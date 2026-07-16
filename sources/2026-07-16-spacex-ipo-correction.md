# Nguồn sửa lỗi: SpaceX đã IPO — fact-check ngày 14/07 của agent sai một lớp (2026-07-16)

Correcting source, immutable. Sửa cho một phần nội dung trong
sources/2026-07-14-metacognition-q1.md (bản gốc giữ nguyên theo luật).

## Sự việc

Trong bài tập fact-vs-opinion mở Q2, Thức thả claim: "SpaceX đã list sàn từ
tháng trước." Agent search và xác nhận: **đúng**.

## Fact đã verify (2026-07-16)

- SpaceX IPO ngày **2026-06-12**, ticker **SPCX** trên Nasdaq. IPO lớn nhất
  lịch sử: giá chốt IPO $135 (11/06), định giá ~$1.77T; phiên đầu tăng 19%,
  đóng $160.95, vốn hoá ~$2.1T. (NPR, CNN Business, CNBC, Wikipedia
  "Initial public offering of SpaceX", 06/2026)
- Zhuque-3 (re-check cùng ngày): chuyến bay 2 CHƯA diễn ra — static fire 9
  động cơ ngày 29/06/2026, dự kiến phóng ~tháng 8/2026; nếu thành công mới là
  lần đầu Trung Quốc hạ cánh đất liền một booster quỹ đạo. (NASASpaceflight
  China update 15/07/2026; china-in-space.com)

## Hệ quả cho các bản ghi trước

1. Trong thảo luận 14/07 (source metacognition-q1), agent khẳng định "SpaceX
   là công ty tư nhân — không có cổ phiếu niêm yết" như một fact chết trong
   5 giây check. **Sai tại thời điểm nói**: SpaceX đã niêm yết từ 12/06,
   hơn một tháng trước đó. Lớp fact-check thứ 2 của vụ mổ xẻ incident SpaceX
   bị rút lại; lớp 1 (video Trung Quốc chưa phải fact "đã làm được như
   SpaceX") vẫn đứng.
2. Chế độ failure của agent được ghi nhận làm person variable của TOOL:
   cùng một lượt, agent search claim "lạ" (tên lửa TQ) nhưng trả lời từ bộ
   nhớ claim "quen" (SpaceX private) — kiến thức training là cache không có
   TTL; fact càng quen càng ít bị nghi. Đây là bằng chứng sống cho hạng mục
   lint "stale claims" và cho yêu cầu Q2: fact phải có timestamp.
3. Người bắt lỗi: **Thức** — lần đầu user bắt được agent khẳng định fact hết
   hạn. Đúng thế "trao đổi" mà Thức yêu cầu: cả hai phía đều bị soi.
