---
title: About This Brain
type: meta
created: 2026-06-12
updated: 2026-06-29
sources: []
---

# Về Brain Này

Đây là một **LLM Wiki** cá nhân — một second brain được một agent AI (Claude
Code) bảo trì, thay vì làm tay. Pattern là [[wiki/llm-wiki-pattern]] của
[[wiki/andrej-karpathy]]: giữ mọi thứ dưới dạng markdown thuần, để agent đọc
vào context, và để agent sở hữu lớp wiki có cấu trúc — nhờ vậy gánh nặng bảo
trì không bao giờ rơi xuống mình.

## Vì sao nó hiệu quả

Con người bỏ wiki vì công sức bảo trì tăng nhanh hơn giá trị nó tạo ra. Agent
thì không chán, không quên một cross-reference nào, và chạm được nhiều file
trong một lượt. Nhờ vậy wiki **compound** thay vì mục rữa.

## Cách mình dùng

- **Capture** bất cứ thứ gì đáng giữ — một cuộc chat AI vừa "click", một ý
  tưởng, một bài viết — rồi chạy `/ingest`.
- **Thảo luận** takeaways với agent; cuộc nói chuyện đó mới là phần nghĩ thật
  sự. File chỉ là cặn lắng lại của nó.
- **Hỏi** brain bằng `/query` khi cần nhớ lại hoặc nối các thứ với nhau.
- **Lint** định kỳ để bắt mâu thuẫn, claim cũ, và trang mồ côi.

## Quy tắc giữ brain đáng tin

`sources/` là đầu vào thô, bất biến. `wiki/` là phần tổng hợp sống của agent.
Mọi thứ link tới mọi thứ liên quan — **giá trị nằm ở đồ thị, không ở từng
trang lẻ**. Con người sở hữu `sources/` và phán đoán; agent sở hữu `wiki/` và
toàn bộ bookkeeping. Con người không hand-edit `wiki/`: muốn đổi một kết luận
thì thêm một nguồn sửa lỗi hoặc bàn lại để agent viết.

## Ngôn ngữ

Nội dung wiki viết bằng **tiếng Việt** (ngôn ngữ tư duy của người sở hữu).
Thuật ngữ kỹ thuật và quote gốc giữ tiếng Anh inline. `sources/` giữ nguyên
ngữ của nguồn. `CLAUDE.md` và `.claude/commands/` ở tiếng Anh — lớp "code"
hướng tới agent.

Xem `CLAUDE.md` ở gốc repo để biết schema vận hành đầy đủ.
