<!-- Provenance (agent-added, 2026-07-16): Thức uploaded this document on
     2026-07-16. The upload was purged when the container restarted; the text
     below is restored verbatim from the agent's context of the original read.
     Content unaltered; only this note was prepended. -->

# Kiến trúc Shepherd — Reversible Execution Traces & Review Gates (kèm code)

> **Nguồn:** [shepherd-agents/shepherd](https://github.com/shepherd-agents/shepherd) (`@b48754a`) — **MIT License**.
> Paper: *Shepherd: Enabling Programmable Meta-Agents via Reversible Agentic Execution Traces* (arXiv 2605.10913).
> Các đoạn code dưới đây trích để minh họa kiến trúc, đã lược phần không cốt lõi (`# ...`). Comment gốc được giữ
> vì chúng nêu *lý do thiết kế* — phần đáng học nhất.

**Vì sao bài này liên quan trực tiếp tới anh:** Shepherd là hiện thân "công nghiệp" của đúng ba câu hỏi trong
**Challenge Phase** của `plan-creator` skill anh đã xây (reversibility, verifiability, blast radius). Nó biến
chúng thành *cơ chế runtime cưỡng chế ở tầng syscall*, không phải checklist trong đầu. Nếu Hermes dạy anh về
*self-improvement loop*, thì Shepherd dạy anh về *review gate + blast-radius containment* — mảnh còn lại của pipeline.

Một câu tóm tắt triết lý (README): *nothing touches your files until you accept it* — công việc của agent quay về
dưới dạng **proposal có thể review**, và **trace ghi lại dù anh giữ hay bỏ**.

---

## 0. Bản đồ kiến trúc

```
   ┌─ TASK (bodyless function) ──────────────────────────────────────────┐
   │  signature + docstring = HỢP ĐỒNG. Quyền nằm ngay trong chữ ký:      │
   │      repo: May[GitRepo, ReadWrite]   docs: May[GitRepo, ReadOnly]    │
   └───────────────────────────┬─────────────────────────────────────────┘
                               │  policy lowering
                               ▼
   ┌─ may= (policy surface) ─────▶ ConfinementSpec (IR) ──▶ JAIL ─────────┐
   │  dialect sở hữu từ vựng      │  vcs-core "may=-blind"  │ Landlock/    │
   │  KHÔNG cho nới quyền         │  cưỡng chế IR           │ Seatbelt     │
   └──────────────────────────────────────────────────────┬──────────────┘
                               ghi ngoài file thật         │ syscall-deny
                                                           ▼
   ┌─ RETAINED OUTPUT (proposal giữ riêng, chưa áp dụng) ────────────────┐
   │  đọc/chạy thử được, CHƯA áp dụng gì.                                 │
   │  settle ĐÚNG MỘT LẦN:  select (giữ) | release (bỏ qua) | discard     │
   │  "any-writable rule": mọi binding ReadOnly ⇒ cấm select cả delta     │
   └───────────────────────────┬─────────────────────────────────────────┘
                               │  mọi bước đều ghi vào
                               ▼
   ┌─ TRACE (reversible, inspectable) ───────────────────────────────────┐
   │  mỗi effect (model call, ghi file...) là sự kiện có kiểu, được ghi.  │
   │  ReversibilityLevel: AUTO | COMPENSABLE | NONE  (weakest-link)       │
   └─────────────────────────────────────────────────────────────────────┘
```

---

## 1. Task = bodyless contract (hợp đồng không thân hàm) — signature chính là permission surface

Task là một **bodyless function/model** (không có phần thân hàm); signature + docstring là contract (hợp đồng) mà agent phải hoàn thành. Write authority (quyền ghi) được
**khai báo ngay trong kiểu tham số**, không phải config rời.

README (Python surface):

```python
from shepherd import task, May, GitRepo, ReadOnly, ReadWrite

@task
def apply_documented_fix(
    docs:    May[GitRepo, ReadOnly],   # chỉ đọc: mọi ghi bị từ chối ở OS
    backend: May[GitRepo, ReadWrite],  # gốc ghi được
    issue:   str,
) -> None: ...
```

Decorator ghi rõ luồng thực thi — và điểm mấu chốt: prompt được sinh **từ docstring + Input fields**, output được
trích ra và validate, artifact được thu thập. Mọi thứ vào/ra đều đi qua boundary có ghi lại.

`shepherd/packages/runtime/src/shepherd_runtime/task/decorator.py` (docstring)

```
Execution Flow:
    1. Resolve Context fields from scope (by name, then by type)
    2. Create ExecutionLifecycle with scope and provider
    3. Generate prompt from docstring + Input fields
    4. Execute via provider
    5. Extract outputs from structured response
    6. Collect artifacts from .artifacts/ directory
    7. Return task instance with all fields populated
```

> **Học được gì:** biến authority (quyền) thành một phần của *function signature* thay vì environment variable. Đọc signature = đọc toàn bộ
> permission surface (bề mặt quyền — toàn bộ những gì task được phép đụng). Với monorepo của anh, đây là cách khai báo "task này chỉ được đụng package X" một cách *khả kiểm*.

---

## 2. Permission surface — per-binding, và KHÔNG BAO GIỜ được nới quyền

Grant là **whole-profile theo từng binding**: mỗi repo bound vào task hoặc ghi được toàn bộ, hoặc chỉ đọc. Quan trọng
nhất: **caller không được nới quyền mà task đã khai báo** — có exception riêng cho việc này.

`shepherd/packages/dialect/src/shepherd_dialect/workspace_control/may.py`

```python
class MayProfileWideningError(MayProfileError):
    """Raised when a caller tries to widen a task's declared authority."""


class HeterogeneousBindingAuthorityError(MayProfileError):
    """Raised when a run-wide scalar authority is read off a decision whose bindings differ.

    Collapsing {docs: readonly, backend: readwrite} to one scalar either amplifies the
    most-restricted binding (... ReadOnly `docs` read as "readwrite") or downgrades the
    granted one. Any consumer that still reads a scalar on the multi-binding path fails
    loudly here instead of silently mis-enforcing.
    """


@dataclass(frozen=True)
class MayProfile:
    """ReadOnly is a strict subset of ReadWrite; Permissive ... lowers to the same
    workspace GitRepo authority as ReadWrite in this slice."""
    name: MayProfileName
    rank: int
    workspace_repo_authority: WorkspaceRepoAuthority
    workspace_selection_can_mutate: bool
```

> **Học được gì:** hai lỗi này là bài học về **fail-loud**. Khi trộn quyền không đồng nhất (chỗ đọc, chỗ ghi),
> đừng bao giờ "gộp" thành một giá trị vô hình — hoặc anh vô tình nới quyền chỗ read-only, hoặc siết nhầm chỗ
> read-write. Bất kỳ ai còn đọc scalar trên đường multi-binding sẽ *nổ ngay*, không âm thầm enforce sai.

---

## 3. Policy lowering — tách *từ vựng chính sách* khỏi *cưỡng chế*

`may=` là **policy surface duy nhất** (bề mặt chính sách — nơi duy nhất khai quyền). Nó được "hạ" (lower) xuống `ConfinementSpec` (IR), rồi vcs-core cưỡng chế
IR đó mà **hoàn toàn mù về `may=`**. Tách bạch này cho phép đổi từ vựng chính sách mà không đụng lớp enforcement.

`shepherd/packages/dialect/src/shepherd_dialect/confinement.py` (docstring)

```
`may=` is the single policy surface; `ConfinementSpec` is its lowered IR.
The dialect owns the vocabulary and the lowering; vcs-core's jail enforces
the spec and stays `may=`-blind. ... anything else refuses fail-closed.

The default is loud: `resolve_may` is the single resolution point for the
`may=None → Permissive` rule, and it returns provenance
(declared/resolved/source) the run payload records — so the defaulted
population is countable ...
```

```python
class UnsupportedMayProfileError(ValueError):
    """The declared `may=` profile has no v0 lowering — refuse, never weaken."""


@dataclass(frozen=True)
class MayResolution:
    """The lowering's provenance: what the author wrote vs what the run got.

    `declared` is exactly the author's declaration (None = omitted);
    `resolved` is the profile the run actually lowers to; `source` is
    "declared" or "defaulted". Recorded into the run payload so a
    defaulted-Permissive run never masquerades as a declared one.
    """
    declared: str | None
    resolved: str
```

> **Học được gì:** hai lớp. *Từ vựng* (dễ đọc cho người viết task) tách khỏi *IR cưỡng chế* (máy thực thi). Và
> **provenance**: phân biệt "tác giả cố tình khai Permissive" với "để trống nên bị default thành Permissive" — số
> lượng bị default là *đếm được*, không lẫn với chủ ý. Đây là kỷ luật anh nên áp cho mọi default nguy hiểm.

---

## 4. Syscall jail — cưỡng chế ở tầng kernel, không phải merge gate

Đây là điểm khiến Shepherd khác các framework "review sau khi merge". Grant được biên dịch thành ruleset Landlock
(Linux) / Seatbelt (macOS) và **ghi trái phép bị từ chối ngay ở syscall — trước điểm undo cuối, không phải bị bắt
muộn ở cổng merge**.

`vcs-core/packages/core/src/vcs_core/_landlock_containment.py`

```python
def landlock_confine(writable_dirs: Sequence[str]) -> None:
    """Restrict this thread (and its children) so writes are allowed only beneath the roots.

    Reads/exec are not governed. An empty `writable_dirs` confines with NO writable root
    (every write denied — the ReadOnly case); each root adds one PATH_BENEATH rule, so a
    proper subset of the workspace yields per-binding grants. Raises OSError on any
    setup failure so the caller can fail closed.
    """
    attr = _RulesetAttr(handled_access_fs=_WRITE_ACCESS)
    fd = _syscall(_NR_CREATE_RULESET, ctypes.byref(attr), ...)
    if fd < 0:
        raise OSError(ctypes.get_errno(), "landlock_create_ruleset")

    for writable_dir in writable_dirs:                 # mỗi root ghi được = 1 rule PATH_BENEATH
        dirfd = os.open(writable_dir, os.O_RDONLY | os.O_DIRECTORY)
        rule = _PathBeneathAttr(allowed_access=_WRITE_ACCESS, parent_fd=dirfd)
        _syscall(_NR_ADD_RULE, fd, _LL_RULE_PATH_BENEATH, ctypes.byref(rule), 0)
        os.close(dirfd)

    _LIBC.prctl(_PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)      # không leo quyền
    _syscall(_NR_RESTRICT_SELF, fd, 0)                 # áp ruleset cho chính thread + con
```

**Fail-closed probe** — chi tiết tinh tế nhất: một jail *hỏng* không bao giờ được tính là "ghi bị từ chối". Trước khi
chạy thân task, probe chứng minh jail vừa *sống* vừa *đúng grant*:

```python
def probe(self, profile, working_root, *, writable_roots) -> None:
    """Fail-closed: prove the jail is BOTH live AND grant-conformant before the body.

    Exit-code-aware: a confine FAILURE (rc==3) is treated as "no jail" rather than
    "write denied", so a broken Landlock can never pass as a working jail.
    """
    def _denied(target: Path) -> bool:
        rc = self._write_result(profile, working_root, target)
        if rc == _CONFINE_FAILED_RC:
            raise JailNotEstablished("fail-closed: Landlock confinement could not be established")
        return rc != 0

    # (1) liveness: ghi NGOÀI workspace phải bị từ chối
    if not _denied(wd.parent / ".jail-probe"):
        raise JailNotEstablished("out-of-WORKDIR write was NOT denied — no jail established")

    # (2) per-root: mỗi root ghi được phải NHẬN được ghi (không siết nhầm)
    for root in roots:
        if _denied(root / ".jail-probe-canary"):
            raise JailNotEstablished(f"writable root {root} DENIES writes (profile too strict)")

    # (3) deny-closed: path trong WORKDIR nhưng ngoài mọi root ghi được phải bị từ chối
    if not wd_is_writable and not _denied(wd / ".jail-probe-denied"):
        raise JailNotEstablished("in-WORKDIR path outside every writable root was PERMITTED — would silently escalate")
```

> **Học được gì:** (1) **containment ở tầng thấp nhất có thể** — với agent sinh code trong monorepo, đây là cách
> chặn "task sửa app mới lỡ tay đụng legacy app". (2) **fail-closed + probe**: đừng *giả định* cơ chế an toàn đang
> chạy — hãy *chứng minh* nó vừa sống vừa đúng trước khi cho agent làm việc. Jail hỏng ≠ jail chặt.

---

## 5. Retained output (kết quả giữ riêng) — proposal chưa áp dụng gì

Kết quả của agent **không ghi vào thư mục của anh**. Nó thành *retained output* (kết quả giữ riêng sang một chỗ): một proposal, đọc/chạy thử được mà
chưa áp dụng. README minh họa: agent viết `donut.py` nhưng nó nằm ngoài directory; anh chạy thử thẳng từ retained
output, thích thì giữ, không thì bỏ — *trace nhớ cả hai đường*.

Ba lệnh settle, đối xứng:

```bash
shepherd run changeset --latest --read donut.py | python3 -   # chạy thử, chưa áp dụng
shepherd run select  <run-ref>    # giữ (áp vào world thật)
shepherd run discard <run-ref>    # bỏ
```

`shepherd/packages/dialect/src/shepherd_dialect/workspace_control/run_outputs.py`

```python
def select(self) -> RetainedOutputSelectionResult:
    """Select this output through the owning workspace."""     # giữ: áp delta vào parent world
    return self._workspace.select(self)

def release(self) -> RetainedOutputSettlementResult:
    """Release this output through the owning workspace."""     # tiêu thụ mà không select
    return self._workspace.release(self)

def discard(self) -> RetainedOutputSettlementResult:
    """Discard this output through the owning workspace."""     # tiêu thụ như đã bỏ
    return self._workspace.discard(self)
```

> **Học được gì:** đây chính là "review gate" của anh, nhưng ở tầng hạ tầng. Agent *đề xuất*, không *áp dụng*.
> Mọi thứ side-effect đều phải qua một lần settle tường minh. Với pipeline Implement của anh, pattern này biến
> mỗi output của agent thành thứ review được *trước khi* nó chạm vào cây source.

---

## 6. Settle đúng một lần + "any-writable rule" — blast radius được cưỡng chế

Điểm mạnh nhất về **blast radius**: nếu một run có nhiều binding mà *tất cả* đều ReadOnly, thì **cấm select cả delta**.
Lý do rất tinh: jail đã đảm bảo delta chỉ chứa ghi được-phép; nhưng nếu chẳng binding nào được phép ghi, thì "cả
delta" về mặt logic không được phép áp.

`shepherd/packages/dialect/src/shepherd_dialect/workspace_control/workspace.py`

```python
def _refuse_readonly_multi_binding_select(self, output: RunOutput) -> None:
    """Enforce the any-writable settlement rule for a heterogeneous run.

    Selecting a per-binding run's whole-delta output is allowed iff at least one binding was
    ReadWrite — the syscall jail guarantees the retained delta contains only authorized writes,
    so selecting the whole delta cannot apply an unauthorized change. `can_mutate` is computed
    explicitly from the recorded per-binding authority (any(a == "readwrite")), never via
    the tripwired run-wide scalar.
    """
    # ...
    can_mutate = any(
        isinstance(entry, Mapping) and entry.get("authority") == "readwrite"
        for entry in per_binding.values()
    )
    if not can_mutate:
        raise WorkspaceControlError(
            "retained-output select refused (any-writable rule): every binding in this run was "
            "ReadOnly, so nothing was authorized to mutate the workspace — selecting the whole "
            "delta is not allowed. Use release/discard instead."
        )
```

> **Học được gì:** quyền *tại thời điểm chạy* quyết định điều được phép *tại thời điểm settle*. Không thể "lách" bằng
> cách chạy read-only rồi áp kết quả. Đây là bất biến blast-radius mà Challenge Phase của anh đang hỏi bằng lời —
> Shepherd trả lời bằng code.

---

## 7. Reversibility là first-class — AUTO / COMPENSABLE / NONE, weakest-link

Đây là mảnh khớp thẳng câu hỏi "reversibility?" trong Challenge Phase của anh. Mỗi context/effect **tự khai mức độ
reversible (đảo ngược được)**, và khi kết hợp thì theo **weakest-link** (mắt xích yếu nhất thắng).

`shepherd/packages/core/src/shepherd_core/types.py`

```python
class ReversibilityLevel(Enum):
    """How reversible are effects from this context?

    Composition follows "weakest link" semantics:
    - AUTO + AUTO = AUTO
    - AUTO + COMPENSABLE = COMPENSABLE
    - anything + NONE = NONE
    """
    AUTO = auto()          # Mechanically reversible (git reset, db rollback)
    COMPENSABLE = auto()   # Requires compensation action (send correction email)
    NONE = auto()          # Cannot be reversed (published tweet, sent SMS)

    def compose(self, other: "ReversibilityLevel") -> "ReversibilityLevel":
        """Compose two levels (weakest wins)."""
        order = [ReversibilityLevel.AUTO, ReversibilityLevel.COMPENSABLE, ReversibilityLevel.NONE]
        return order[max(order.index(self), order.index(other))]
```

Mỗi context khai mức của mình — và mức này *hiện trong prompt* để chính agent biết nó đang đụng thứ không đảo ngược được:

```python
# workspace/ref.py  — thao tác Git
@property
def reversibility(self) -> ReversibilityLevel:
    """Git operations are mechanically reversible."""
    return ReversibilityLevel.AUTO

# database/context.py — truy vấn DB
@property
def reversibility(self) -> ReversibilityLevel:
    """Queries can leak sensitive info - irreversible."""
    return ReversibilityLevel.NONE
```

> **Học được gì:** đây là Challenge Phase của anh, được cơ khí hóa. Thay vì *hỏi* "việc này đảo ngược được không?",
> mỗi tài nguyên *khai* mức của nó, và hệ thống *tự tính* mức của cả kế hoạch bằng weakest-link. Một plan chạm vào
> một effect `NONE` thì cả plan là `NONE` — và đó là tín hiệu để bắt buộc review chặt hơn.

---

## 8. Effect boundary — mọi thứ qua ranh giới đều có kiểu và được ghi

Thân task là hộp đen (không xem được lý luận của model), nhưng **mọi thứ băng qua ranh giới đều là một effect**: giá
trị có tên, có kiểu, trên một kênh tường minh — trả lời được, theo dõi được, từ chối được, ghi lại được.

`docs/shepherd/concepts/effects.md`

Model delivery bản thân nó cũng là một effect: *the model request, the model response, and the validated return
value are all evidence you can inspect when a run does not behave the way you expected.* Handler thì "trả lời" effect
— và đây là cách test chạy **không cần model thật**: môi trường test trả lời effect model delivery bằng response ghi
sẵn, code task không đổi. *Substitution happens at the boundary, not by monkey-patching the task.*

> **Học được gì:** nếu mọi tương tác ngoài (model call, ghi file, network) đều là effect có ghi lại, thì anh có
> đồng thời **auditability** (soi lại vì sao run sai) và **testability** (thay model bằng response ghi sẵn ở
> boundary). Đây là mức "quan sát được" mà agentic pipeline của anh nên hướng tới.

---

## 9. So sánh Hermes vs Shepherd — chúng bù cho nhau

| Trục | Hermes Agent | Shepherd |
|---|---|---|
| Trọng tâm | **Self-improvement** (skill tự sinh, tự cải thiện) | **Supervision** (review gate, containment, reversibility) |
| Đơn vị | Skill file (`.md`) tái sử dụng | Task = bodyless contract + typed effect |
| An toàn tự động | Curator (reversible archive, provenance) | Syscall jail (Landlock/Seatbelt), fail-closed probe |
| Người trong vòng lặp | GEPA gate qua PR (offline) | Retained output + settle-once (mọi run) |
| Điểm mạnh cho anh | *Cách học từ mỗi phiên* | *Cách chặn blast radius + review trước khi áp dụng* |

Ghép lại chính là pipeline hoàn chỉnh của anh: **Hermes** cho tầng "agent học và đề xuất cập nhật skill"; **Shepherd**
cho tầng "mỗi đề xuất chạy trong jail, quay về như proposal, anh review rồi mới settle".

---

## 10. Checklist "chôm" cho pipeline của anh

| Cơ chế Shepherd | Đưa vào pipeline Clarify→Spec→Plan→Tasks→Implement thế nào |
|---|---|
| Quyền nằm trong chữ ký task (`May[GitRepo, ReadWrite]`) | Mỗi task khai rõ package/repo được đụng — khả kiểm, không ẩn trong config |
| Widening refused + fail-loud khi trộn quyền | Không "gộp" quyền không đồng nhất thành một giá trị; sai thì nổ ngay |
| Policy lowering + provenance (declared vs defaulted) | Tách từ vựng chính sách khỏi enforcement; đếm được default nguy hiểm |
| Syscall jail cho agent sinh code | Chạy agent trong Landlock/sandbox, giới hạn writable root theo task |
| Fail-closed probe | *Chứng minh* sandbox sống + đúng grant trước khi chạy, không giả định |
| Retained output (proposal, chưa áp dụng) | Output của Implement thành thứ review được *trước khi* chạm source |
| Settle-once (select/release/discard) + any-writable rule | Mỗi side-effect qua đúng một lần settle; blast radius cưỡng chế theo grant |
| `ReversibilityLevel` weakest-link | Cơ khí hóa Challenge Phase: mỗi effect khai mức, plan tự tính, `NONE` ⇒ gate chặt |
| Effect boundary có kiểu + handler | Auditability + test không cần model thật (thay response ở boundary) |

**Kết luận một dòng:** `plan-creator` của anh *hỏi* đúng câu (reversibility, verifiability, blast radius);
Shepherd cho thấy cách *cưỡng chế* câu trả lời ở tầng runtime — biến review gate từ kỷ luật con người thành bất biến
của hệ thống.
