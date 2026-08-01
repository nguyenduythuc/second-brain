# Nguồn: Thức tách mục tiêu A/B và đưa filter cho transcript mining (2026-07-27)

Raw input, immutable.

## Nguyên văn Thức

> Cần đánh giá lại, phương pháp tiếp cận này có đúng ko, mục tiêu của việc đọc
> các conversation/agent của tôi bên monorepo là để làm gì? Nếu cần để tạo một
> wiki cho lĩnh vực code của tôi trong brain, vậy tôi nghĩ nên viết một tool để
> lấy tư tưởng và kéo về từ bộ nhớ máy tính

Và sau khi agent phân tách A/B rồi phản biện về thứ tự (thủ công trước, tool
sau):

> Tôi thấy khi bạn nhận ra vấn đề, ví dụ "Chỗ bạn đúng, và đúng hơn kế hoạch
> của mình…" tôi thấy bạn lập luận rất tốt, nhìn ra vấn đề rất tốt, nhưng lại
> có một thiếu sót cực lớn, là bạn không tìm root cause và ghi nhớ để lần sau
> tránh, hoặc ít nhất thì cũng hỏi tôi xem có nên đánh giá và lưu lại không.
>
> A,B đều hợp lý, riêng cái bạn phản biện, chúng ta có thể thảo luận. Hãy xem
> các conversation có planing, sau khi acccept plan thường sẽ có các vấn đề
> cần sửa, chỗ đó có thể đáng học mà ko phải đọc toàn bộ nội dung

## Kết quả vòng này

1. **Thức bắt được meta-failure của agent:** nhận ra lỗi tốt trong hội thoại
   nhưng không truy root cause, không lưu lại, cũng không hỏi có nên lưu không.
   Agent chạy 5 Whys → root cause: áp luật "artifact ngoài model mới tích luỹ"
   cho tri thức của user nhưng không áp cho lỗi của chính mình; trong session,
   context *cảm giác* như trí nhớ nên không thấy mất mát. Dừng ở FAIL →
   INVESTIGATE, không tới DISTILL → CONSULT.
   → Sửa cấu trúc: CLAUDE.md "track thinking moves" nay nói rõ áp cho cả lỗi
   lập luận của agent, bắt buộc ghi vào STATE.md hoặc hỏi user.

2. **Agent thừa nhận đã trộn hai mục tiêu** (A: skill file ở monorepo, không
   cần transfer; B: wiki quyết định ở brain, cần transfer) — ghi thành agent
   failure mode: nêu mục tiêu trước khi thiết kế cơ chế.

3. **Filter của Thức được chấp nhận, thay thế đề xuất "thủ công trước" của
   agent:** neo vào mốc *plan được accept*, đọc đoạn sau đó — nơi có delta
   giữa kế hoạch và thực tế. Giải quyết cả phản biện volume lẫn phản biện
   "chưa biết signal là gì".

4. **Agent bổ sung:** phân loại 4 kiểu sửa sau plan (hiểu sai yêu cầu / đúng
   yêu cầu sai cách / đụng chỗ cấm / user đổi ý). Chỉ loại 2 là tri thức nghề;
   loại 4 là bẫy — đóng khung ý thích nhất thời thành luật.
