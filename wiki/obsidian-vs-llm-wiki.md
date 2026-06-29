---
title: Obsidian vs. LLM Wiki (chọn công cụ cho second brain)
type: concept
created: 2026-06-29
updated: 2026-06-29
sources: [sources/2026-06-29-karpathy-llm-wiki-field-notes.md]
---

# Obsidian vs. LLM Wiki

Vì sao brain này dùng **git markdown + agent bảo trì** thay vì Obsidian/Notion —
và vì sao đó *không* phải hai lựa chọn loại trừ nhau.

## Obsidian là gì

App ghi chú **local-first**: note là file markdown thuần trong một thư mục
("vault") trên máy bạn. Điểm mạnh: liên kết hai chiều `[[wikilink]]`, **graph
view** vẽ ra mạng lưới note, backlinks, và hệ sinh thái plugin lớn (Dataview,
spaced repetition…). Miễn phí cho cá nhân, đa nền tảng, có mobile.

## Khác biệt cốt lõi: ai bảo trì?

| | Obsidian (PKM thủ công) | LLM Wiki (brain này) |
|---|---|---|
| Người làm vườn | **Con người** tự link, sắp xếp, dọn | **Agent** link/cross-ref/tái cấu trúc |
| Việc của con người | Vừa nghĩ vừa bảo trì | Chỉ *nghĩ* (thảo luận lúc ingest) |
| Failure mode | Bỏ wiki vì bảo trì > giá trị | (tránh được — agent không chán) |
| Giao diện | GUI giàu, graph view, mobile | Không GUI; grep + đọc file |
| Chi phí | Miễn phí, không cần LLM | Tốn token API |

Failure mode của Obsidian là đúng cái [[wiki/about-this-brain]] và
[[wiki/llm-wiki-pattern]] cảnh báo: *con người bỏ wiki vì công sức bảo trì tăng
nhanh hơn giá trị*. Graph view đẹp nhưng dễ thành "búi tóc" rối; nhiều người sa
vào chỉnh plugin hơn là nghĩ.

Nói công bằng: Obsidian xuất sắc cho ai muốn **kiểm soát thủ công hoàn toàn,
không muốn LLM trong vòng lặp, không tốn phí API, cần GUI/mobile tức thì.** Phần
lớn lời khuyên PKM có trước khi agent đủ giỏi. Hai bên tối ưu khác nhau: Obsidian
đổi lấy *kiểm soát + giao diện*; brain này đổi lấy *zero-maintenance + chiều sâu
hội thoại*.

## Điểm không hiển nhiên: dùng cả hai

Vì cả hai đều là markdown + `[[wikilink]]`, bạn **trỏ Obsidian vào chính thư
mục `second-brain` này như một vault** → có graph view, backlinks, đọc mobile,
trong khi Claude Code vẫn là người bảo trì. Đây không phải mẹo bên lề: Karpathy
**đích danh gọi Obsidian là "front-end of choice"** (quy tắc VI của
[[wiki/llm-wiki-pattern]]) để soi cluster, hub, và orphan trên graph.

*(Lưu ý kỹ thuật cần kiểm chứng: agent viết link kiểu `[[wiki/page]]` theo
đường dẫn; Obsidian mặc định hay dùng `[[tên-note]]`. Mở thử để xác nhận phân
giải đúng trước khi tin.)*

## Khuyến nghị

- **Đừng chuyển sang** Obsidian làm công cụ bảo trì — nó kéo lại đúng gánh thủ
  công mà thiết kế này cố thoát.
- **Thêm Obsidian như viewer** lên cùng repo nếu thèm graph view / đọc mobile —
  gần như miễn phí thử.

## Related

- [[wiki/llm-wiki-pattern]] — pattern brain này chạy; quy tắc VI về Obsidian.
- [[wiki/about-this-brain]] — vì sao agent-maintained tránh được rot.
