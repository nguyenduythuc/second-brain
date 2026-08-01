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
