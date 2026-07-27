<!-- Provenance (agent-added, 2026-07-16): Thức uploaded this document on
     2026-07-16. The upload was purged when the container restarted; the text
     below is restored verbatim from the agent's context of the original read.
     Content unaltered; only this note was prepended. -->

# Cơ chế Self-Improvement của Hermes Agent — Kiến trúc & Code

> **Nguồn:** [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (`@05cbddc`) và
> [NousResearch/hermes-agent-self-evolution](https://github.com/NousResearch/hermes-agent-self-evolution) (`@0a929e3`).
> Cả hai đều **MIT License** — các đoạn code dưới đây được trích để minh họa kiến trúc, đã lược bỏ phần không cốt lõi.
> Comment gốc trong code được giữ lại vì chúng giải thích *lý do thiết kế* — đó mới là thứ đáng học.

Tài liệu này tách thành 2 tầng:

- **Tầng runtime (in-agent):** vòng lặp tự học chạy dưới mỗi phiên — hoàn toàn tự động.
- **Tầng offline (GEPA):** tối ưu skill có người gate qua PR review — bù cho điểm yếu "tự khen" của tầng runtime.

---

## 0. Bản đồ kiến trúc

```
                    ┌─────────────────── MỘT PHIÊN (session) ───────────────────┐
                    │                                                            │
  user message ──▶  │  agent loop  ──▶  tool calls  ──▶  final text             │
                    │       │                                                    │
                    │       ├── mỗi N turn: memory nudge  ──▶ ghi MEMORY.md      │
                    │       └── mỗi N turn: skill  nudge  ──▶ fork review agent  │
                    │                                            │               │
                    └────────────────────────────────────────────┼──────────────┘
                                                                  ▼
                              skill_manage(create | patch | edit | ...) ──▶ ~/.hermes/skills/
                                                                  │
                    ┌─────────────── nền (khi agent rảnh) ────────┼──────────────┐
                    │  CURATOR: active ─30d▶ stale ─90d▶ archived │  (reversible) │
                    │  chỉ đụng skill do agent tạo (provenance)   │               │
                    └────────────────────────────────────────────┴──────────────┘

  ────────────── TẦNG OFFLINE (thủ công, gate qua PR) ──────────────
  GEPA: đọc execution trace ──▶ mutate skill ──▶ eval holdout ──▶ constraint gate ──▶ PR
```

Bốn thành phần runtime (memory nudge, skill creation, skill self-improvement, session search)
đều là **đầu ra của cùng một vòng lặp**, không phải các cơ chế rời rạc bị "gắn thêm".

---

## 1. Trigger — khi nào tự tạo/sửa skill

Đây là điểm đầu tiên đáng học: **điều kiện kích hoạt định lượng**, không mơ hồ. Không phải "sau mỗi task thì cân nhắc",
mà là các ngưỡng cụ thể (≥5 tool call, sửa lỗi khó, workflow không hiển nhiên).

`agent/prompt_builder.py`

```python
SKILLS_GUIDANCE = (
    "After completing a complex task (5+ tool calls), fixing a tricky error, "
    "or discovering a non-trivial workflow, save the approach as a "
    "skill with skill_manage so you can reuse it next time.\n"
    "When using a skill and finding it outdated, incomplete, or wrong, "
    "patch it immediately with skill_manage(action='patch') — don't wait to be asked. "
    "Skills that aren't maintained become liabilities."
)
```

Trigger được đếm theo **số turn** và bắn định kỳ, không phải mỗi turn (tránh nhiễu + tiết kiệm chi phí):

`agent/agent_init.py`

```python
agent._memory_nudge_interval = 10
# ...
agent._memory_nudge_interval = int(mem_config.get("nudge_interval", 10))
# ...
agent._skill_nudge_interval = 10
# ...
agent._skill_nudge_interval = int(skills_config.get("creation_nudge_interval", 10))
```

Điểm bắn trigger nằm trong chính agent loop, kiểm tra *sau khi* đã tăng bộ đếm turn:

`agent/codex_runtime.py`

```python
# Now check the skill nudge AFTER iters were incremented
should_review_skills = False
if (
    agent._skill_nudge_interval > 0
    and agent._iters_since_skill >= agent._skill_nudge_interval
    and "skill_manage" in agent.valid_tool_names
):
    should_review_skills = True
    agent._iters_since_skill = 0
```

> **Học được gì:** thay cho "hỏi Claude sau mỗi task có nên cập nhật skill không", hãy đặt
> điều kiện định lượng (số bước, có lỗi được sửa, có user correction). Trigger dựa trên *số turn*
> cho phép tách nhịp reflection ra khỏi nhịp làm việc.

---

## 2. Reflection prompt — tự học dựa trên tín hiệu, không phải tự chấm điểm

Khi trigger bắn, Hermes **fork một agent phụ** và đưa cho nó một prompt review. Prompt này liệt kê
**tín hiệu cụ thể cần tìm** (user sửa style, sửa workflow, kỹ thuật mới, skill cũ sai) — chứ không hỏi
chung chung "bạn làm tốt không". Đây là cách né bẫy self-congratulation ngay ở tầng prompt.

`agent/background_review.py`

```python
_SKILL_REVIEW_PROMPT = (
    "Review the conversation above and update the skill library. Be "
    "ACTIVE — most sessions produce at least one skill update, even if "
    "small. A pass that does nothing is a missed learning opportunity, "
    "not a neutral outcome.\n\n"
    "Target shape of the library: CLASS-LEVEL skills, each with a rich "
    "SKILL.md and a `references/` directory for session-specific detail. "
    "Not a long flat list of narrow one-session-one-skill entries.\n\n"
    "Signals to look for (any one of these warrants action):\n"
    "  • User corrected your style, tone, format, legibility, or "
    "verbosity. Frustration signals like 'stop doing X', 'this is too "
    "verbose', 'just give me the answer' ... are FIRST-CLASS skill "
    "signals. Update the relevant skill(s) to embed the preference so "
    "the next session starts already knowing.\n"
    "  • User corrected your workflow, approach, or sequence of steps. "
    "Encode the correction as a pitfall or explicit step in the skill.\n"
    "  • Non-trivial technique, fix, workaround, debugging path ... that "
    "a future session would benefit from. Capture it.\n"
    "  • A skill that got loaded this session turned out to be wrong, "
    "missing a step, or outdated. Patch it NOW.\n\n"
    "Preference order — prefer the earliest action that fits:\n"
    "  1. UPDATE A CURRENTLY-LOADED SKILL ... PATCH that one first.\n"
    "  2. UPDATE AN EXISTING UMBRELLA ... patch it.\n"
    "  3. ADD A SUPPORT FILE under an existing umbrella.\n"
    "  4. CREATE A NEW CLASS-LEVEL UMBRELLA SKILL when no existing "
    "skill covers the class.\n"
    # ...
)
```

Prompt cho memory tách riêng, tập trung vào *thông tin bền vững về người dùng*:

```python
_MEMORY_REVIEW_PROMPT = (
    "Review the conversation above and consider saving to memory if appropriate.\n\n"
    "Focus on:\n"
    "1. Has the user revealed things about themselves — their persona, desires, "
    "preferences, or personal details worth remembering?\n"
    "2. Has the user expressed expectations about how you should behave, their work "
    "style, or ways they want you to operate?\n\n"
    "If something stands out, save it using the memory tool. "
    "If nothing is worth saving, just say 'Nothing to save.' and stop."
)
```

Fork chạy trên **model phụ** để không phá prompt cache của phiên chính:

`agent/background_review.py`

```python
# The review fork runs on the MAIN model by default ("auto"), replaying the
# conversation snapshot in a forked AIAgent. A different model cannot reuse
# the parent's cache (different key), so the fork is cold ...
def spawn_background_review_thread(
    agent, messages_snapshot, review_memory=False, review_skills=False,
):
    if review_memory and review_skills:
        prompt = getattr(agent, "_COMBINED_REVIEW_PROMPT", _COMBINED_REVIEW_PROMPT)
    elif review_memory:
        prompt = getattr(agent, "_MEMORY_REVIEW_PROMPT", _MEMORY_REVIEW_PROMPT)
    else:
        prompt = getattr(agent, "_SKILL_REVIEW_PROMPT", _SKILL_REVIEW_PROMPT)

    def _target():
        _run_review_in_thread(agent, messages_snapshot, prompt)

    return _target, prompt
```

> **Học được gì:** reflection nên (1) chạy như một *pass riêng* trên bản snapshot hội thoại,
> (2) được dẫn dắt bởi danh sách tín hiệu cụ thể + thứ tự ưu tiên hành động (patch > tạo mới),
> (3) mặc định ưu tiên **sửa skill đang dùng** thay vì đẻ skill mới → tránh library phình thành list phẳng.

---

## 3. `patch` thay vì `edit` — quyết định về cả tính đúng lẫn token

Hành động mặc định là `patch` (find-and-replace có mục tiêu), không phải rewrite. Lý do kép:
rewrite có nguy cơ làm hỏng phần đang chạy tốt, và patch rẻ token hơn. Đáng chú ý là patch có
**fuzzy matching** (bỏ qua sai khác whitespace/indent) và **rollback nếu security scan chặn**.

`tools/skill_manager_tool.py`

```python
def _patch_skill(name, old_string, new_string, file_path=None, replace_all=False):
    """Targeted find-and-replace within a skill file.
    Requires a unique match unless replace_all is True.
    """
    if not old_string:
        return {"success": False, "error": "old_string is required for 'patch'."}
    if new_string is None:
        return {"success": False,
                "error": "new_string is required. Use an empty string to delete matched text."}

    existing = _find_skill(name)
    if not existing:
        return {"success": False, "error": _skill_not_found_error(name)}

    skill_dir = existing["path"]
    guard = _background_review_write_guard(name, skill_dir, "patch")  # provenance/pin guard
    if guard:
        return guard

    target = skill_dir / "SKILL.md" if not file_path else _resolve_skill_target(skill_dir, file_path)[0]
    content = target.read_text(encoding="utf-8")

    # Fuzzy matching: handles whitespace normalization, indentation differences,
    # escape sequences, and block-anchor matching — saving the agent from
    # exact-match failures on minor formatting mismatches.
    from tools.fuzzy_match import fuzzy_find_and_replace
    new_content, match_count, _strategy, match_error = fuzzy_find_and_replace(
        content, old_string, new_string, replace_all
    )
    if match_error:
        preview = content[:500] + ("..." if len(content) > 500 else "")
        return {"success": False, "error": match_error, "file_preview": preview}

    # Validate frontmatter is still intact after the patch
    if not file_path:
        err = _validate_frontmatter(new_content)
        if err:
            return {"success": False, "error": f"Patch would break SKILL.md structure: {err}"}

    original_content = content  # for rollback
    _atomic_write_text(target, new_content)

    # Security scan — roll back on block
    scan_error = _security_scan_skill(skill_dir)
    if scan_error:
        _atomic_write_text(target, original_content)
        return {"success": False, "error": scan_error}

    return {"success": True,
            "message": f"Patched SKILL.md in skill '{name}' ({match_count} replacement(s))."}
```

> **Học được gì:** khi để LLM tự sửa skill file, dùng **diff-based patch + validate cấu trúc + rollback**,
> đừng cho rewrite cả file. Với `clean-clear-code` skill của anh, đây là pattern an toàn: mỗi cập nhật
> là một patch nhỏ, có kiểm tra frontmatter và có đường lùi.

---

## 4. Provenance — ranh giới không thể vượt giữa skill của agent và skill viết tay

Đây là mảnh ghép mà một review-gate cần. Curator (và cả optimization loop) **chỉ được đụng skill do agent tạo**.
Skill bundled, skill cài từ hub, skill external, và skill "protected" đều bất khả xâm phạm — kể cả khi bật cờ prune.

`tools/skill_usage.py`

```python
def is_agent_created(skill_name: str) -> bool:
    """Whether *skill_name* is neither bundled nor hub-installed."""
    off_limits = _read_bundled_manifest_names() | _read_hub_installed_names()
    if skill_name in off_limits:
        return False
    return not (
        _find_skill_dir(skill_name) is None
        and _find_external_skill_dir(skill_name) is not None
    )


def is_curation_eligible(skill_name, skill_path=None) -> bool:
    """Agent-created skills are always eligible. Bundled built-ins become
    eligible only when curator.prune_builtins is enabled. Hub-installed and
    external skills are NEVER eligible — they have an external upstream owner.
    Protected built-ins are NEVER eligible regardless of any flag.
    """
    if skill_path is not None and is_external_skill_path(skill_path):
        return False
    if is_protected_builtin(skill_name):
        return False
    if is_hub_installed(skill_name):
        return False
    if is_bundled(skill_name):
        return _prune_builtins_enabled()
    local_dir = _find_skill_dir(skill_name)
    if local_dir is not None:
        return not is_external_skill_path(local_dir)
    if _find_external_skill_dir(skill_name) is not None:
        return False
    return True
```

> **Học được gì:** trong loop tự cải thiện của anh, hãy đánh dấu **provenance** cho từng skill file.
> Skill anh viết tay = "human-authored" = loop chỉ được *đề xuất* thay đổi qua review, không được tự ghi đè.
> Đây chính là thứ Hermes phải làm để loop tự động không phá customization thủ công.

---

## 5. Curator — vòng đời skill: active → stale → archived (reversible)

Skill tự sinh nếu để mặc sẽ chất đống và mục. Curator là một pass nền, **kích hoạt bởi trạng thái rảnh
(không phải cron daemon)**, đưa skill qua các trạng thái theo thời gian không dùng — và **không bao giờ xóa**.

`agent/curator.py` (docstring — chính là bản tuyên bố bất biến của hệ thống)

```python
"""Curator — background skill maintenance orchestrator.

Strict invariants:
  - Only touches agent-created skills (see tools/skill_usage.is_agent_created)
  - Never auto-deletes — only archives. Archive is recoverable.
  - Pinned skills bypass all auto-transitions
  - Uses the auxiliary client; never touches the main session's prompt cache
"""

DEFAULT_STALE_AFTER_DAYS = 30
DEFAULT_ARCHIVE_AFTER_DAYS = 90
```

Logic chuyển trạng thái — chú ý các *quy tắc an toàn* (pin, skill được cron tham chiếu, grace floor cho skill chưa dùng):

```python
def apply_automatic_transitions(now=None):
    """Walk every curator-managed skill and move active/stale/archived based on
    the latest real activity timestamp. Pinned skills are never touched."""
    from tools import skill_usage as _u

    now = now or datetime.now(timezone.utc)
    stale_cutoff = now - timedelta(days=get_stale_after_days())
    archive_cutoff = now - timedelta(days=get_archive_after_days())
    cron_referenced = _cron_referenced_skills()
    counts = {"marked_stale": 0, "archived": 0, "reactivated": 0, "checked": 0, "seeded": 0}

    for row in _u.agent_created_report():          # <-- provenance filter: chỉ skill của agent
        counts["checked"] += 1
        name = row["name"]

        if row.get("pinned"):
            continue                                # pin = miễn nhiễm

        # Skill được bất kỳ cron job nào tham chiếu => đang dùng theo định nghĩa.
        if name in cron_referenced:
            continue

        last_activity = _parse_iso(row.get("last_activity_at"))
        anchor = last_activity or _parse_iso(row.get("created_at")) or now

        # Grace floor: skill chưa từng dùng (use_count == 0) không bị archive
        # cho tới khi ít nhất cũ hơn stale_after_days. "Chưa dùng" là thiếu
        # bằng chứng, không phải bằng chứng lỗi thời — trigger có thể chưa xảy ra.
        never_used = int(row.get("use_count", 0) or 0) == 0
        if never_used and anchor > stale_cutoff:
            continue

        current = row.get("state", _u.STATE_ACTIVE)
        if anchor <= archive_cutoff and current != _u.STATE_ARCHIVED:
            _u.archive_skill(name);        counts["archived"] += 1
        elif anchor <= stale_cutoff and current == _u.STATE_ACTIVE:
            _u.set_state(name, _u.STATE_STALE);   counts["marked_stale"] += 1
        elif anchor > stale_cutoff and current == _u.STATE_STALE:
            _u.set_state(name, _u.STATE_ACTIVE);  counts["reactivated"] += 1   # dùng lại -> hồi sinh

    return counts
```

> **Học được gì:** dọn dẹp phải **reversible** (archive, không delete), có **pin** để bảo vệ skill quan trọng,
> và có **grace floor** để không giết skill mới chỉ vì trigger chưa xảy ra. Chạy lúc rảnh, dùng model phụ.

---

## 6. Progressive disclosure — token phẳng bất kể số lượng skill

Mặc định system prompt chỉ nạp `(tên, mô tả)` của mỗi skill, gom theo category. Nội dung đầy đủ chỉ vào
context khi agent chủ động đọc. Nhờ đó 200 skill tốn context gần bằng 40 skill.

`agent/prompt_builder.py`

```python
# Cold path: full filesystem scan + write snapshot for next time
skill_entries = []
for skill_file in iter_skill_index_files(skills_dir, "SKILL.md"):
    is_compatible, frontmatter, desc = _parse_skill_file(skill_file)
    entry = _build_snapshot_entry(skill_file, skills_dir, frontmatter, desc)
    skill_entries.append(entry)
    if not is_compatible:
        continue
    skill_name = entry["skill_name"]
    if entry["frontmatter_name"] in disabled or skill_name in disabled:
        continue
    if not _skill_should_show(
        extract_skill_conditions(frontmatter), available_tools, available_toolsets,
    ):
        continue
    # CHỈ lưu (tên, mô tả) vào index — không nạp body:
    skills_by_category.setdefault(entry["category"], []).append(
        (entry["frontmatter_name"], entry["description"])
    )
```

> **Học được gì:** đây là câu trả lời trực tiếp cho vấn đề token của anh với Claude Code.
> Giữ một **index gọn (tên + 1 dòng mô tả)** trong context; body skill nạp theo yêu cầu.
> Kết hợp thêm `references/`, `templates/`, `scripts/` bên trong mỗi skill để tách chi tiết nặng ra khỏi index.

---

## 7. Tách episodic vs procedural memory

Hai loại "nhớ" nằm ở hai kho khác nhau, trả lời hai câu hỏi khác nhau:

| Loại | Kho | Câu hỏi | Nạp khi nào |
|------|-----|---------|-------------|
| Episodic | SQLite + FTS5 (session archive) | "chuyện gì đã xảy ra, khi nào" | agent chủ động `session_search` |
| Procedural | `~/.hermes/skills/*.md` | "làm việc này thế nào" | index luôn có; body theo yêu cầu |
| Prompt memory | `MEMORY.md` / `USER.md` | "điều luôn đúng về người dùng" | luôn nạp đầu mỗi phiên |

`agent/prompt_builder.py`

```python
SESSION_SEARCH_GUIDANCE = (
    "When the user references something from a past conversation or you suspect "
    "relevant cross-session context exists, use session_search to recall it before "
    "asking them to repeat themselves."
)
```

> **Học được gì:** đừng trộn "log những gì đã xảy ra" với "cách làm". Trộn một chỗ là lý do phần lớn
> hệ memory của agent xuống cấp theo thời gian.

---

## 8. TẦNG OFFLINE — GEPA: điểm yếu "tự khen" và cách vá bằng human gate

Điểm yếu đã được ghi nhận của tầng runtime: agent gần như luôn nghĩ mình làm tốt. GEPA (repo riêng, chạy offline)
giải quyết bằng cách **đọc execution trace để hiểu *tại sao* thất bại**, rồi tối ưu qua tìm kiếm tiến hóa,
và chốt bằng **constraint gate + so sánh holdout + PR review**.

README (self-evolution): *GEPA reads execution traces to understand why things fail (not just that they failed), then proposes targeted improvements.*

### 8.1 Vòng evolve — có gate ở mọi bước

`evolution/skills/evolve_skill.py`

```python
def evolve(skill_name, iterations=10, eval_source="synthetic",
           optimizer_model="openai/gpt-4.1", eval_model="openai/gpt-4.1-mini", ...):
    """Main evolution function — orchestrates the full optimization loop."""

    # 1. Load skill + tách frontmatter/body
    skill = load_skill(find_skill(skill_name, config.hermes_agent_path))

    # 2. Dựng dataset đánh giá: synthetic | golden | 'sessiondb' (đào từ session thật)
    #    -> chia train / val / holdout
    dataset = ...   # to_dspy_examples("train" | "val" | "holdout")

    # 3. Validate constraint trên baseline (để có mốc so sánh)
    baseline_constraints = validator.validate_all(skill["body"], "skill")

    # 4-5. GEPA optimize qua DSPy (fallback MIPROv2 nếu môi trường thiếu GEPA)
    dspy.configure(lm=dspy.LM(eval_model))
    baseline_module = SkillModule(skill["body"])
    optimizer = dspy.GEPA(metric=skill_fitness_metric, max_steps=iterations)
    optimized_module = optimizer.compile(
        baseline_module,
        trainset=dataset.to_dspy_examples("train"),
        valset=dataset.to_dspy_examples("val"),
    )

    # 6-7. Trích skill đã tiến hóa + validate constraint LẦN NỮA
    evolved_body = optimized_module.skill_text
    evolved_constraints = validator.validate_all(
        evolved_body, "skill", baseline_text=skill["body"]   # so với baseline -> chặn phình
    )
    if not all(c.passed for c in evolved_constraints):
        # FAIL constraint -> KHÔNG deploy, chỉ lưu để soi
        return

    # 8. So điểm baseline vs evolved trên HOLDOUT (dữ liệu chưa từng thấy)
    #    -> chỉ khoe cải thiện nếu improvement > 0, và bảo người dùng review diff
```

### 8.2 Constraint gate — chặn hồi quy trước khi tới tay người

`evolution/core/constraints.py`

```python
def validate_all(self, artifact_text, artifact_type, baseline_text=None):
    results = []
    results.append(self._check_size(artifact_text, artifact_type))         # trần kích thước
    if baseline_text:
        results.append(self._check_growth(artifact_text, baseline_text,    # trần % phình so baseline
                                          artifact_type))
    results.append(self._check_non_empty(artifact_text))
    if artifact_type == "skill":
        results.append(self._check_skill_structure(artifact_text))         # frontmatter còn hợp lệ?
    return results


def _check_growth(self, text, baseline, artifact_type):
    growth = (len(text) - len(baseline)) / max(1, len(baseline))
    max_growth = self.config.max_prompt_growth
    passed = growth <= max_growth
    return ConstraintResult(
        passed=passed, constraint_name="growth_limit",
        message=f"Growth {'OK' if passed else 'exceeded'}: {growth:+.1%} (max {max_growth:+.1%})",
    )


def run_test_suite(self, hermes_repo):
    """Run the full hermes-agent test suite. Must pass 100%."""
    result = subprocess.run(["python", "-m", "pytest", "tests/", "-q", "--tb=no"],
                            capture_output=True, text=True, timeout=300, cwd=str(hermes_repo))
    passed = result.returncode == 0
    return ConstraintResult(passed=passed, constraint_name="test_suite",
                            message="All tests passed" if passed else "Test suite failed")
```

> **Học được gì (quan trọng nhất):** cấu trúc "review gate" của anh (Clarify→Spec→Plan→Tasks→Implement)
> chính là thứ Hermes runtime **thiếu** và phải bù bằng GEPA. Ba mảnh nên bê vào loop của anh:
>
> 1. **Reflection dựa trên trace, không dựa trên tự đánh giá** — cho Claude đọc lại log thực thi
>    (lỗi, số lần thử, chỗ user sửa) rồi mới đề xuất. Đừng để nó tự chấm "task tốt".
> 2. **Constraint gate tự động trước review của người** — chặn phình (`growth_limit`), giữ frontmatter,
>    chạy test suite 100%. Đề xuất nào không qua gate thì không tới tay anh.
> 3. **So sánh trên holdout** — chỉ chấp nhận thay đổi nếu điểm trên tập chưa từng thấy *tăng thật*,
>    tránh overfit vào chính phiên vừa rồi.

---

## 9. Tổng kết — checklist "chôm" cho pipeline của anh

| Cơ chế Hermes | Đưa vào loop của anh thế nào |
|---|---|
| Trigger định lượng (≥5 tool call, có lỗi được sửa, có user correction) | Thay "hỏi mỗi task" bằng ngưỡng cụ thể; đếm theo turn |
| Reflection = pass riêng trên snapshot, có danh sách tín hiệu + thứ tự ưu tiên hành động | Prompt review liệt kê tín hiệu; ưu tiên **patch skill đang dùng** > tạo mới |
| `patch` (diff) + validate frontmatter + rollback | Cập nhật skill bằng diff nhỏ, không rewrite; có đường lùi |
| Provenance: human-authored = bất khả xâm phạm | Đánh dấu skill viết tay; loop chỉ *đề xuất*, không ghi đè |
| Vòng đời reversible (active→stale→archived), pin, grace floor | Dọn skill mục nhưng không xóa; pin skill lõi |
| Progressive disclosure (index tên+mô tả, body theo yêu cầu) | Giải bài toán token Claude Code; tách chi tiết vào `references/` |
| Tách episodic (session) vs procedural (skill) vs prompt memory | Ba kho, ba câu hỏi khác nhau |
| **GEPA: trace-based reflection + constraint gate + holdout + PR** | Ba mảnh ở mục 8 — đây là nơi review-gate của anh đã đúng sẵn |

**Kết luận một dòng:** bản năng gate-by-review của anh đúng. Thứ Hermes dạy thêm là *cách làm reflection
trung thực* (đọc trace thay vì tự khen) và *cách dựng constraint gate tự động* đứng trước review của người —
để anh không phải review những đề xuất rác ngay từ đầu.
