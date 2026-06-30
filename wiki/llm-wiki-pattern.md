---
title: LLM Wiki Pattern
type: concept
created: 2026-06-12
updated: 2026-06-29
sources: [sources/2026-06-12-karpathy-llm-wiki.md, sources/2026-06-29-karpathy-llm-wiki-field-notes.md]
---

# LLM Wiki Pattern

Một pattern quản trị tri thức do [[wiki/andrej-karpathy]] đề xuất: một agent AI
dần dần xây và bảo trì một wiki markdown thuần bền vững, thay vì đọc lại tài
liệu thô mỗi lần có câu hỏi. Second brain này là một bản triển khai trực tiếp
của nó (xem [[wiki/about-this-brain]]).

## Insight cốt lõi

Wiki của con người chết vì công sức bảo trì tăng nhanh hơn giá trị. Một agent
LLM thì không chán, không bao giờ quên một cross-reference, và chạm được nhiều
file trong một lượt — nhờ vậy wiki compound thay vì mục rữa.

> *"Most personal knowledge systems die of maintenance, not of bad ideas."*

## Chín quy tắc (field notes v040426)

Karpathy về sau hệ thống hoá pattern thành chín quy tắc. Đường xuyên suốt:
**con người sở hữu phán đoán và bản ghi thô, model sở hữu bookkeeping, wiki là
một artifact được compile và biết compound.**

1. **Sources bất biến.** Mọi thứ rơi vào sources thô và không bao giờ bị sửa.
   Nếu một nguồn sai, thêm một nguồn *sửa lỗi* — đừng viết lại lịch sử, nếu
   không bạn có hai bản ghi và không biết cái nào là thật.
2. **Tách các lớp.** Ba lớp, ba chủ sở hữu: raw (bạn), wiki (model), file schema
   (cả hai). Làm nhoè ranh giới — model ghi vào raw, hay người hand-tune wiki để
   thắng một lập luận — là phá luôn cái boundary làm hệ thống đáng tin.
3. **Model sở hữu wiki.** Bạn hiếm khi tự viết một trang wiki; bạn chọn cái gì
   vào raw, đặt câu hỏi, và nghĩ. Nếu *bạn* phải làm bookkeeping, là schema chưa
   đủ chi tiết, không phải lỗi của model.
4. **Compile, đừng retrieve.** Đây *không* phải RAG. RAG tái suy ra câu trả lời
   từ các chunk thô mỗi query và chẳng tích luỹ gì. Ở đây sources được compile
   một lần thành các trang đã link. (raw = source code, model = compiler, wiki =
   executable, query = runtime.) **Tri thức được compile thì compound; tri thức
   đi retrieve thì bị tái-khám-phá mỗi lần.**
5. **Ingest từng nguồn một.** Một ingest tốt không phải một trang mới — đó là
   model truy vết hệ quả của một nguồn *xuyên suốt đồ thị*, chạm tới mọi trang mà
   sự kiện mới làm thay đổi. Nhập cả đời số hoá trong một cuối tuần tạo ra một
   đống đổ (dump), không phải wiki.
6. **Link mọi thứ.** Mỗi wikilink là một cạnh nhìn thấy được. Một entity xuất
   hiện trong năm trang mà không link tới đâu nghĩa là ingest lười. *Giá trị nằm
   ở các cạnh, không ở các nút.* (Đây là lý do Obsidian làm front-end tốt: graph
   view phơi ra cluster, hub, và orphan — xem [[wiki/obsidian-vs-llm-wiki]].)
7. **Điều hướng bằng index.** Đi tới câu trả lời qua `index.md` → vài trang liên
   quan → tổng hợp, chứ không nạp cả vault vào context. Nếu model brute-force cả
   corpus mỗi câu hỏi, index đã ngừng phản ánh lãnh thổ.
8. **Lint tri thức.** Đối xử với wiki như code. Một mâu thuẫn là *thông tin*,
   không phải lỗi cần che — nó nghĩa là hai nguồn bất đồng và giờ bạn biết chỗ để
   nhìn. Bỏ lint là cách wiki mục rữa âm thầm trong khi graph vẫn trông hoành tráng.
9. **Bắt đầu nhỏ.** Mười nguồn, không phải mười nghìn. Làm cho ingest/query/lint
   thành tự nhiên trước khi thêm search engine hay một schema hai mươi quy tắc.
   Trang đầu sẽ lộn xộn và quy ước đặt tên sẽ đổi — đó là bình thường. *Một wiki
   nhỏ bạn thật sự nuôi thắng một kiến trúc đẹp bạn bỏ vào tuần thứ ba.*

## Kiến trúc (ba lớp)

1. **Sources thô** — đầu vào bất biến; agent đọc, không bao giờ sửa. (Brain này
   đặt tên thư mục là `sources/` thay vì `raw/` của Karpathy.)
2. **Wiki** — markdown do agent sở hữu: summary, trang entity/concept, synthesis,
   tất cả cross-link. Con người *không* hand-edit các trang này.
3. **Schema** — một file config (`CLAUDE.md`; `AGENTS.md` cũng được) định nghĩa
   quy ước và các workflow ingest/query/lint.

Hai file điều khiển giữ brain luôn soi được: `index.md` (catalog một dòng mỗi
trang, là lớp điều hướng) và `log.md` (lịch sử append-only, grep được).

## Các thao tác

- **Ingest** — đọc → thảo luận takeaways với người dùng → filing + cross-link,
  từng nguồn một, truy vết hệ quả xuyên đồ thị.
- **Query** — định tuyến qua `index.md`, đọc vài trang liên quan, tổng hợp;
  câu trả lời hay trở thành trang mới, nên dùng brain làm brain lớn lên.
- **Lint** — health check định kỳ: mâu thuẫn, claim cũ, orphan, thiếu
  trang/link, entity bị hai cách viết.

## Lập trường thiết kế

Không vector DB, không RAG, không embeddings — context window hiện đại chứa được
một knowledge base cá nhân dưới dạng text thuần. Bằng chứng nó scale: wiki một
chủ đề của Karpathy đạt ~100 bài / ~400k chữ với zero nội dung viết tay.

## Liên quan

- [[wiki/andrej-karpathy]] — tác giả của pattern.
- [[wiki/about-this-brain]] — cách repo này triển khai nó.
- [[wiki/obsidian-vs-llm-wiki]] — Obsidian như một viewer trên cùng vault, so với
  như một công cụ bảo trì thủ công.
