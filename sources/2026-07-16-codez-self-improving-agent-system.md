<!-- Provenance (agent-added, 2026-07-16): Thức uploaded this document on
     2026-07-16. The upload was purged when the container restarted; the text
     below is restored verbatim from the agent's context of the original read.
     Content unaltered; only this note was prepended. -->

# Self-Improving Agent System — Nghiên cứu chi tiết

> **Nguồn:** Article trên X của Codez (@0xCodez), đăng 11/06/2026, ~2.9M views.
> Tiêu đề: *"Build self-improving agent system with Fable 5 in 14 steps: loops, dynamic workflows, routines"*.
>
> **Lưu ý về độ tin cậy:** Tác giả là content creator (có Substack cần kéo subscriber). Bài tự nhận "sourced from Anthropic engineering posts, verified against launch documentation" nhưng **chưa được đối chiếu độc lập** với tài liệu chính thức của Anthropic. Các mục đánh dấu ⚠️ cần verify trước khi dựa vào để thiết kế hệ thống.

---

## 0. Luận điểm cốt lõi

**Self-improvement là thuộc tính của HỆ THỐNG, không phải của MODEL.**

- Model (Fable 5) là **stateless** — không tự update weights, không "học" giữa các session.
- Cái compound (tích lũy) là **môi trường xung quanh model**: state files, Skills, eval loops, memory.
- Mỗi run để lại dấu vết → run sau kế thừa → hệ thống sắc bén dần theo thời gian.

Phân biệt quan trọng:

| Khái niệm | Định nghĩa | Trạng thái |
|---|---|---|
| **Self-learning** | Agent tự update weights của chính nó | KHÔNG tồn tại ở production model nào. RSI (recursive self-improvement) là hướng dài hạn Anthropic cảnh báo, không phải capability hiện tại |
| **Self-improving** | Hệ thống quanh agent compound: session ghi lesson vào memory, Skills tích lũy edge cases, state files tích lũy verified facts, eval loops tinh chỉnh prompt/rubric | Xây được NGAY với tooling hiện có |

Trích dẫn định hướng từ Anthropic engineering (theo bài):
> "Rather than directly prompting and steering, it's often better to design loops that let the model self-correct in response to environment feedback and manage its own context (e.g., via memory)."

---

## 1. Bối cảnh: Claude Fable 5 (Mythos-class)

⚠️ *Thông tin theo bài viết, cần verify với docs chính thức:*

- Ra mắt **09/06/2026** — model Mythos-class đầu tiên công khai, tier **trên Opus**.
- Mythos 5 (không có safety classifiers) chỉ dành cho tổ chức được duyệt; Fable 5 là bản public có classifier.
- **Pricing:** $10/M input tokens, $50/M output tokens (giảm 90% input với prompt caching). ~5× giá Opus 4.8.
- Capability chính:
  - **Days-long autonomous sessions** trong agent harness (Claude Code, Claude Managed Agents).
  - **Self-verification built-in**: tự viết test, dùng vision check output, distill lessons thành rules.
  - Large migrations, multi-day coding, multi-stage knowledge work.

### Cost routing matrix (pattern production theo bài)

| Model | Vai trò | Task điển hình |
|---|---|---|
| **Fable 5** | Orchestrator | Plan nhiều ngày, delegate sub-agents, vision check, distill rules từ evidence |
| **Opus 4.8** | Hard-but-bounded subtasks + fallback | Architecture decisions, complex debugging, deep code review; fallback khi Fable 5 bị classifier block |
| **Sonnet 4.6** | Worker volume lớn | Lint, simple refactor, test scaffolding, doc updates |
| **Haiku 4.5** | Grader / classifier | Verifier sub-agent, cheap classification — context window độc lập, chi phí thấp |

**Nguyên tắc:** Route theo độ phức tạp, không mặc định dùng model đắt nhất. "Fable 5 on tasks Sonnet would handle" là một trong 10 sai lầm phổ biến.

---

## 2. Compound Stack — kiến trúc 4 tầng

Đọc từ dưới lên = thứ tự build = thứ tự leverage compound.

```
┌──────────────────────────────────────────────────────┐
│ Layer 4 · SELF-IMPROVEMENT                           │
│ Vision self-checks · Eval loops · Rule distillation  │
│ → Agent tự chấm output, refine Skill, ghi lesson lại │
├──────────────────────────────────────────────────────┤
│ Layer 3 · MEMORY                                     │
│ State files · Skills · Knowledge Bases · Lessons     │
│ → Session ngày mai RESUME thay vì RESTART            │
├──────────────────────────────────────────────────────┤
│ Layer 2 · ORCHESTRATION                              │
│ /goal & Outcomes (self-correcting loops)             │
│ Dynamic Workflows (multi-step) · Routines (cloud)    │
├──────────────────────────────────────────────────────┤
│ Layer 1 · PRIMITIVES                                 │
│ Model · Sub-agents · Worktrees · Tools               │
│ → Đa số người dùng dừng ở đây                        │
└──────────────────────────────────────────────────────┘
```

**Feedback loop:** Output từ Layer 1 chảy lên Layer 4 → được grade, distill → ghi ngược về Layer 3 → run ngày mai ở Layer 1 kế thừa memory + Skills đã sharpened.

---

## 3. Ba Primitives của Orchestration

### 3.1. /goal vs Outcomes — hai implementation của cùng một ý tưởng

Cấu trúc chung: **grader độc lập chấm bài → verdict "not-met" khởi động iteration tiếp → loop exit khi grader pass.**

| | **/goal (Claude Code, local)** | **Outcomes (CMA, cloud)** |
|---|---|---|
| Khi dùng | Work tại máy, loop nhanh in-session | Run nhiều giờ/ngày trên hạ tầng Anthropic (sandbox, GPU) |
| Use case | Hands-on coding, debug flaky tests, refine 1 file | ML training, migration dài, multi-day research |
| Goal format | Plain text | File-based rubric với gradable criteria |
| Grader | Model grader, feedback in-terminal | Sub-agent grader, có hard `max_iterations` bound |

Điểm chung quyết định: **agent viết code KHÔNG PHẢI là agent chấm code** (xem 3.2).

### 3.2. Verifier sub-agent > Self-critique (cơ chế then chốt)

Theo bài, Anthropic engineering (Prithvi Rajasekaran) chỉ ra models rất kém khi tự critique output của mình, và Claude Code team xác nhận empirically:

> "We've found that a verifier sub-agent tends to outperform self-critique."

**Cơ chế là structural, không phải "cố gắng hơn":**
- Model tự đánh giá output của mình → nhìn thấy reasoning trail của chính nó → thiên vị kết luận nhất quán với những gì đã viết.
- Verifier riêng biệt → chỉ thấy **artifact + rubric**, không thấy quá trình suy luận → "no skin in the maker's game".

**Bằng chứng (thí nghiệm "Parameter Golf" ⚠️):**
- Fable 5 + verifier độc lập: dám làm thay đổi **architecture-level** (TRAIN_SEQ_LEN=2048, overlapped sliding-window eval, int6 QAT), **vượt qua regression** thay vì revert sau failed experiment → tiếp tục investigate đến win lớn nhất.
- Opus 4.7: sau win đầu tiên, mọi experiment sau đều cùng template "adjust scalar, measure, keep if positive" — an toàn hơn nhưng không tốt hơn (~6× ít improvement).
- **Takeaway:** Không có verifier độc lập, model dừng ở "good enough" đầu tiên. Verifier là thứ ép nó explore hypothesis space lớn hơn.

### 3.3. Dynamic Workflows (ship 28/05/2026 ⚠️)

Claude tự viết **JavaScript harness on-the-fly**: file với primitives `agent()`, `parallel()`, `pipeline()` + JS thường để xử lý data giữa các bước. Harness custom cho từng task, không generic.

**3/6 patterns đáng dùng cho self-improving system:**

1. **Fan-out-and-synthesize** — Chia work thành N phần độc lập, chạy agent song song, tổng hợp. Dùng khi mỗi bước cần context window sạch riêng (VD: eval từng rule trong Skill against historical examples).
2. **Adversarial verification** — Mỗi maker agent có một verifier độc lập KHÔNG được xem reasoning của maker. Fix structural cho self-preferential bias, áp dụng per-task.
3. **Loop-until-done** — Spawn agent lặp đến khi đạt stop condition (không còn finding mới, log sạch lỗi, theory verified). Pair với /goal để có hard completion requirement.

*2 patterns còn lại:* classify-and-act (routing model theo classifier — hữu ích cho cost routing ở mục 1), tournament (pairwise comparison cho taste-based ranking — design/naming).

### 3.4. Git Worktrees — parallel safety

Khi spawn >1 agent, file collision là tất yếu. Worktree = working directory riêng trên branch riêng, chung repo history → edits của agent này **không thể** đụng checkout của agent kia.

**3 pattern bắt buộc:**
- **Maker/Verifier isolation:** Maker viết ở worktree A, verifier đọc ở worktree B (hoặc read-only filesystem trên checkout A).
- **Parallel structural experiments:** Mỗi experiment một worktree, orchestrator thu kết quả, merge cái tốt nhất.
- **Checkpoints cho run dài:** Mỗi phase lớn một worktree — phase fail không poison phần còn lại.

*Trong Claude Code (theo bài):* `git worktree` trực tiếp, flag `--worktree`, hoặc setting `isolation: worktree` trên subagents (tự cleanup sau session).

### 3.5. Routines (research preview 14/04/2026 ⚠️) — laptop tắt, agent vẫn chạy

Saved Claude Code configurations (prompt + repos + connectors + permissions) chạy trên **Anthropic-managed cloud** theo trigger.

| Trigger | Pattern | Ví dụ |
|---|---|---|
| **Schedule** | Morning briefing | 7am hàng ngày: re-run eval suite hôm qua, distill failure modes mới vào Skills, post digest lên Slack |
| **API event** | Fire on event | CI fail → Routine investigate; Sentry alert → Routine triage |
| **GitHub event** | Learn from real work | PR open → eval against latest Skills; merge → ghi pattern mới của PR ngược vào Skill |

Ví dụ prompt trong bài:
```
/schedule daily at 7am, use Fable 5 in CMA
Goal: Re-run yesterday's eval suite against the latest skills.
Any test that newly passes → distill the pattern into the skill.
Any test that newly fails → investigate, document in STATE.md.
Post the digest to #engineering.
/goal don't stop until digest is posted and STATE.md is updated.
```

---

## 4. Tầng Self-Improvement (trái tim của hệ thống)

### 4.1. Memory progression 5 giai đoạn

Framing từ "Continual Learning Bench 1.0" ⚠️ — memory hiệu quả đòi hỏi hoàn thành đủ 5 stage, mỗi stage là một structural move:

```
1. FAIL        → ghi lại failure với đủ chi tiết để hữu ích về sau
2. INVESTIGATE → tìm hiểu TẠI SAO fail, trước khi move on
3. VERIFY      → biến chẩn đoán thành FACT đã kiểm chứng, không phải guess
4. DISTILL     → biến verification thành GENERAL RULE áp dụng ngoài case cụ thể
5. CONSULT     → task tiếp theo ĐỌC RULE thay vì re-derive từ đầu
```

Kết quả đo trên SQL exploration task (theo bài):

| Model | Exit tại stage | Verification coverage |
|---|---|---|
| Sonnet 4.6 | Stage 1 — memory là list failure notes + open guesses, hiếm khi consult lại | — |
| Opus 4.7 | Stage 3 — schema reference có flag uncertainty | 7–33% (median ~17%) |
| Fable 5 | Hoàn thành cả 5 | Đến 73% (22/30), distill được general rules |

**Insight thiết kế:** Đây là RUBRIC để đánh giá memory system của chính mình. Nếu STATE.md chỉ toàn failure notes chưa investigate → hệ thống đang hoạt động ở "Sonnet-mode" bất kể model nào đang chạy.

### 4.2. STATE.md — nơi memory thực sự sống

Cấu trúc file khớp 5 stage:

```markdown
# Project memory · <tên project>

## Verified facts            ← stage 3: ngừng đoán về những điều này
- prc tính bằng dollars, không phải cents. Verified via SELECT MIN(prc), MAX(prc).
- user_id join với auth_users.uid, KHÔNG PHẢI auth_users.id. Confirmed 2026-06-09.

## General rules             ← stage 4: consult trước khi re-derive
- Query time-bucketed metrics: luôn kèm timezone (default UTC mismatch).
- Thứ tự auth middleware: rate_limit → jwt → rbac. Đảo ngược gây 401.
- Migration: không ALTER table >1M rows nếu không batch.

## Open failures             ← stage 1→2: investigate session sau
- 2026-06-09: e2e/checkout flake ~1/50 runs. Hypothesis: webhook race.
  Reproduction steps trong debug/checkout-flake.md.

## Lessons learned           ← stage 4 distillations
- PowerShell dính TLS 1.2 issue trên Windows CI runners. Luôn shell ra bash.

## Last session              ← stage 5: resume pointer
2026-06-10 03:30 UTC · 7 failures classified, 3 fixes drafted, 4 escalated.
Next: verify auth middleware fix against production load.
```

**Hai quy tắc vận hành quyết định file compound hay chỉ phình to:**

1. **Write before walking away** — Mọi session KẾT THÚC bằng update STATE.md (đã thử gì, pass gì, fail gì, rule mới nào survive). Không write = session sau restart từ zero.
2. **Read at session start** — Mọi session mới BẮT ĐẦU bằng đọc STATE.md + Skills liên quan nhất. Không read = "Sonnet-class memory behavior" xuất hiện kể cả với model mạnh nhất.

*Vị trí:* CMA = mounted filesystem persist giữa sessions; Claude Code local = markdown file hoặc Linear board.

### 4.3. Skills that compound — procedural memory

**Phân tách phạm vi:**
- **STATE.md** = project memory — chết cùng project.
- **Skills** (`~/.claude/skills/`) = procedural memory — "cách làm loại việc này" — sống xuyên project, đi theo người dùng.

**Compounding contract:** Sau mọi failure non-trivial, **ghi lesson vào chính Skill**, không chỉ vào chat/STATE.md. Skill sau 2 tuần compound sẽ có thêm sections: known failure modes, rules từ post-mortems, anti-patterns từ production — không còn là static instructions mà là **accumulating record** của những gì đã học được.

Ví dụ Skill `ci-triage` sau 14 ngày compound:

```markdown
---
name: ci-triage
description: Classify CI failures, draft fixes for easy ones, escalate the rest.
---
# CI triage skill

## Classification rules
- env: missing secret, wrong env var        # escalate, never auto-fix
- flake: passes on retry without change     # retry once, then file
- bug: deterministic, tied to recent commit # draft fix
- dependency: tied to version bump          # draft rollback
- infra: timeout, OOM, runner issue         # escalate

## Known failure modes        ← added by the loop over 14 days
- webhook-race: e2e checkout flake khi Stripe webhook đến giữa test.
  Fix: 2s settle delay trong tests/utils/webhook.ts.
- tls-handshake: Windows runners fail TLS 1.2 trong PowerShell. Dùng bash.
- db-migration: ALTER trades >1M rows timeout 30s. Batch 10k chunks.

## Anti-patterns (do NOT do)  ← added after real incidents
- Không bao giờ disable failing test để CI xanh. File nó.
- Không sửa .github/workflows/ nếu chưa có human approval.
- Không đụng src/payments/ hoặc src/billing/ nếu chưa qua security review.

## State
Update STATE.md sau mỗi run: classifications, fixes drafted, escalations.

## Eval suite                 ← loop verify chính cái skill
Chạy against eval/ci-triage-cases.jsonl hàng tuần.
Case mới fail → add vào known failure modes SAU KHI Outcomes verifier confirm.
```

Chú ý: Skill có **eval suite của riêng nó** — loop không chỉ verify code, mà verify chính Skill. Lesson mới chỉ được add sau khi verifier confirm (chống ghi rác vào memory).

### 4.4. Vision self-verification

Thay thế bước "người nhìn screenshot để confirm UI đúng":

```
1. Maker sub-agent viết UI code
2. Render kết quả ra screenshot
3. Verifier sub-agent đọc screenshot bằng VISION:
   - So với goal description
   - So với design tokens trong project Skill
   - So với screenshot trước đó từ STATE.md
4. Verdict về loop:
   - Match     → mark complete
   - Mismatch  → mô tả gap, trả về maker kèm structured diff
```

Áp dụng cho: UI, dashboards, design fidelity, charts (Parameter Golf: verifier đọc training chart và quyết định curve có match criterion không — không có người trong loop).

### 4.5. Safety boundary như một design constraint

⚠️ Theo bài: Fable 5 có classifier từ chối các domain rủi ro cao (cyber vulnerability research, bio, chem, model distillation), tự fallback về Opus 4.8.

**Hệ quả thiết kế cho hệ thống autonomous:**
- Hệ thống đụng security tooling (SAST, pentest logic, một số code review — kể cả review crypto primitives) → **expect classifier blocks**. Architect fallback tường minh: route sang Opus 4.8 hoặc surface cho human reviewer.
- **Skill phải document expected behavior khi bị block** — loop fail âm thầm vì classifier trông GIỐNG HỆT loop fail vì lỗi thật, cho đến khi phải debug.
- Nguyên tắc chung: **treat safety boundary như known fallback, không phải failure mode**. Hệ thống có handling tường minh sẽ robust khi classifier evolve; hệ thống ignore sẽ silent regression khi policy update.
- Review retention policy (bài nhắc terms 30-day / 2-year ⚠️) trước khi cho sensitive data chạy qua Routine.

---

## 5. Mười sai lầm giữ hệ thống ở 10% tiềm năng

1. **Dùng Fable 5 như Sonnet với context to hơn** — session 5 phút prompt-and-close đốt tiền Mythos-tier mà không có compound effect.
2. **Self-critique thay vì verifier độc lập** — maker tự chấm bài mình.
3. **Không có STATE.md** — mọi session restart từ zero; đây là nơi 70%+ memory advantage biến mất.
4. **Skills không bao giờ được ghi thêm** — static Skill là scaffolding lãng phí.
5. **Model đắt cho task rẻ** — route theo complexity.
6. **Chạy session dài trên laptop** — days-long capability cần cloud (CMA/Routines).
7. **Ignore safety boundary** — classifier block tạo silent regression.
8. **Không vision-verify cho visual tasks** — text-only verifier miss đúng failure mode quan trọng.
9. **Bỏ qua /goal hoặc Outcomes** — không có objective stop condition + grader độc lập, loop dừng ở "handled enough" thay vì done.
10. **Không review retention policy** — compliance issue âm thầm với sensitive data.

---

## 6. Đối chiếu với pipeline hiện tại của chúng ta

Pipeline hiện có: **Clarify → Spec → Plan → Tasks → Implement**, review gates + artifact files mỗi phase, `plan-creator` skill (Challenge Phase + Advisory Pass), `clean-clear-code` skill. Mảnh còn thiếu đã xác định trước đây: **post-task feedback loop** — Claude propose update cho skill files, gated bởi review của Thức.

Mapping trực tiếp:

| Khái niệm trong bài | Tương ứng pipeline hiện tại | Trạng thái |
|---|---|---|
| Layer 2 Orchestration (review gates) | Review gates giữa các phase | ✅ Đã có |
| Artifact files mỗi phase | STATE.md tương đương (nhưng phân tán theo phase) | 🔶 Có, chưa hợp nhất thành project memory |
| Skills (`plan-creator`, `clean-clear-code`) | Procedural memory | ✅ Đã có, nhưng **static** — chưa có cơ chế compound |
| 5-stage progression (Fail→Consult) | Chưa formalize | ❌ Thiếu — đây chính là post-task feedback loop |
| Verifier sub-agent độc lập | Challenge Phase là self-review trong plan; chưa có verifier tách biệt cho implement | ❌ Thiếu |
| Skill eval suite | Chưa có | ❌ Thiếu |
| "Karpathy: be the bottleneck" | Review gates + gated skill updates | ✅ Triết lý khớp — human review là gate ở stage 4→ghi |

### Thứ tự build đề xuất (ưu tiên theo leverage, khớp lời khuyên cuối bài)

**Bước 1 — STATE.md hợp nhất** (chi phí thấp nhất, unlock ngay)
- Tạo template STATE.md với 5 sections khớp 5 stages.
- Thêm 2 quy tắc vào skill files: *write before walking away* (cuối mỗi Implement phase) và *read at session start* (đầu Clarify).

**Bước 2 — Post-task feedback loop** (mảnh thiếu đã xác định)
- Cuối mỗi task: Claude phân loại lessons theo stage (fact verified? rule distill được?).
- Lessons đạt stage 4 → **propose diff vào skill file tương ứng**, Thức review & approve (giữ nguyên nguyên tắc "be the bottleneck").
- Format proposal: `## Known failure modes` / `## Anti-patterns` sections trong skill — như ví dụ ci-triage.

**Bước 3 — Verifier tách biệt cho Implement phase**
- Verifier không thấy reasoning của maker, chỉ thấy: artifact + spec + acceptance criteria từ Plan.
- Với UI work (React Native/Next.js): thêm vision-verify — render → screenshot → verifier so với Figma design tokens.

**Bước 4 — Skill eval suite**
- Mỗi skill có `eval/` với test cases (jsonl).
- Chạy định kỳ; case mới fail → investigate → chỉ ghi vào skill sau khi verify.

**Bước 5 — (Sau, khi tooling sẵn sàng ⚠️) Routines/schedule**
- Nightly: re-run eval suite, distill, digest. Cần verify tính năng Routines/CMA có thật và available trên plan hiện tại trước.

---

## 7. Checklist verify trước khi thiết kế chi tiết

Những claim trong bài cần đối chiếu với nguồn chính thức (docs.claude.com, anthropic.com/engineering) trước khi commit architecture:

- [ ] `/goal` command trong Claude Code — tồn tại? cú pháp?
- [ ] Outcomes + Claude Managed Agents (CMA) — có thật? availability?
- [ ] Dynamic Workflows (`agent()`, `parallel()`, `pipeline()`) — ship chưa? docs?
- [ ] Routines — research preview? trigger types? pricing?
- [ ] `isolation: worktree` setting trên subagents — có trong Claude Code config?
- [ ] Số liệu Parameter Golf & Continual Learning Bench — có engineering post gốc?
- [ ] Fable 5 classifier domains + auto-fallback sang Opus 4.8 — mô tả chính thức?
- [ ] Retention terms (30-day / 2-year) cho Routines.

**Nguyên tắc:** Phần KIẾN TRÚC (verifier độc lập, 5-stage memory, STATE.md, Skills compound, worktree isolation) đứng vững độc lập với tooling cụ thể — có thể build bằng Claude Code + git + markdown ngay hôm nay. Phần TOOLING (Routines, CMA, Dynamic Workflows) cần verify trước khi dựa vào.

---

## 8. Tóm tắt một dòng

> Chọn một layer chưa làm — verifier sub-agent, state file, hoặc vision-verify — thêm vào ngày mai. Rồi layer tiếp theo. **Build the system, not the prompt.**
