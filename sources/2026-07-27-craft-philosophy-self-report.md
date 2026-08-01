# Nguồn: Thức tự thuật triết lý nghề (2026-07-27)

Raw input, immutable. Thức chủ động kể lại kinh nghiệm nghề "những gì có thể
nhớ được" — self-report, chưa đối chiếu với code/PR thật.

## Nguyên văn

> Trước hết tôi sẽ nói kinh nghiệm nghề của tôi, những gì tôi có thể nhớ đc.
> Tôi đề cao tư duy hơn việc biết nhiều ngôn ngữ hay công cụ, từ thời chưa có
> AI tôi đã nghĩ vậy rồi. Khi có AI, suy nghĩ đó càng đúng đắn. Tôi luôn muốn
> code của tôi phải clean-clear, tức là người ko biết code như BA hay tesếtr
> có thể đọc hiểu, vì như vậy tức là code logic, tường minh, tuyến tính. Code
> clear là code có cấu trúc, chẳng hạn import ở đầu file, use state và các
> const ở đầu component, sau đó tới efect và các hooks/hàm còn lại, cuối cùng
> là giao diện. Tôi ví dụ thế, còn rất nhiều thứ giúp code clean-clear. Tiếp
> theo là tính tái sử dụng, code tái sử dụng ko chỉ giúp code mình bạch, logic
> rõ ràng, mà còn giúp giảm lượng công việc phát sinh. Ngoài ra tôi đề cao
> việc áp dụng các công nghệ mới, chẳng hạn như thay vì dùng async storage tôi
> tìm hiểu và dùng mmkv, hay là tôi dùng new arch thay vì old arch của react
> native, hay là react 19 không cần tới các memorized hooks nữa,… hồi chưa có
> AI, tôi phải research rất nhiều, từ trang chủ của các framework mà tôi đang
> dùng, tới medium, X, github,… vì tôi nghĩ rằng, những công nghệ mới sinh ra
> là để giải quyết các khó khăn ở thời điểm hiện tại. Performance và debug là
> 2 thứ tôi luôn trú trọng trong quá trình code, nếu lúc làm không vận dụng
> các best practices về performance, nó sẽ là tech debt và về sau rất khó trả
> nợ, còn debug giúp tôi nhanh chóng khoanh vùng vấn đề và fix lỗi. Đặc biệt ở
> thời đại AI, tôi phải làm sao đó để AI có đc nhiều context từ các debuggers.
> Tiếp theo là document hoá các quy trình, convention, khó khăn,… Trong việc
> quản lý task và planning , tôi rất thích tư tưởng agile scrum. Mọi việc đc
> break nhỏ, linh hoạt và hoạt động tôi thích nhất là retro, giúp tôi hoàn
> thiện/giỏi hơn sau mỗi sprint. Tạm thế đã, bạn có thể lưu vào source nếu cần.

## Ghi chú về trạng thái nhận thức của nguồn này

Đây là **self-report từ trí nhớ**, không phải quan sát hành vi. Theo khung
[[wiki/fact-vs-opinion]]: phần lớn là claim chuẩn tắc ("code nên clean-clear"),
một phần là claim mô tả về chính mình ("tôi luôn chú trọng performance") —
loại thứ hai kiểm chứng được bằng code/PR thật, và đó chính là việc mà
/mine-history + transcript mining sẽ làm. Nguồn này là **giả thuyết về nghề
của Thức**; monorepo là **bằng chứng**.

---

## Bổ sung (cùng ngày) — cách gỡ xung đột "công nghệ mới vs. dễ đọc"

Agent hỏi: nguyên tắc thì ai cũng phát biểu được, cách xử lý *xung đột giữa
các nguyên tắc* mới là thứ 10 năm mua được. Thức trả lời:

> Đúng vậy, nhìn nhận rất sắc, thường thì sẽ có một vài case.
> - Dùng đc luôn, chẳng hạn như mmkv, nó viết các function/api tương đồng với
>   async storage, do đó việc thay đổi nhanh và dễ
> - Migrate dần, chẳng hạn như react 19 có cơ chế ko cần khai báo memorized
>   hooks, tôi sẽ thí điểm vào các file mới và chỗ update của các feature. Ví
>   dụ thứ 2 là test script, tôi chỉ bắt đầu với unit teét trước
> - Chờ. Có những thứ ko sẵn sàng ngay, hồi mới ra new arch, tôi upgrade lên
>   luôn để dùng thử, nhưng vì libs chưa support, tôi tắt ngay new arch chứ ko
>   cố sửa, vì mất công nhiều
>
> Ngoài ra tôi còn nhớ thêm 1 ý. Cái gì lặp lại 3 lần, cần có tool thay thế.
> Hoặc tự viết
