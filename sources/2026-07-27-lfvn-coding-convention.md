# Nguồn: Coding Convention — LFVN Monorepo (Confluence, đọc 2026-07-27)

Raw input, immutable.

**Provenance:** Confluence page "Coding Convention - LFVN Monorepo", space
"Nguyen Duy Thuc", author Nguyễn Duy Thức, last modified 2026-07-22.
URL: https://thuclife.atlassian.net/wiki/x/BYAlAQ
Fetched via Atlassian MCP on 2026-07-27; text below is the page body as
returned by the API (markdown conversion).

**Epistemic note:** unlike sources/2026-07-27-craft-philosophy-self-report.md,
this is a **maintained artifact**, not a memory. It is direct evidence of what
Thức actually enforces — his conventions, his gates, and (in the second half)
his stated reasons. The second section "Lý thuyết & Nguyên lý thiết kế" is the
rarer half: most convention docs list rules without reasons.

---

Checklist convention được tổng hợp theo các đầu mục quan trọng trong `wiki của dự án LOTTE Digital`: [docs/README.md · uat · Lotte Finance Digital / SourceCode / lfd-portal-public-fe · GitLab](https://gitlab.lottefn.vn/lotte-finance-digital/sourcecode/lfd-portal-public-fe/-/blob/uat/docs/README.md?ref_type=heads).

| **#** | **Task** |
| --- | --- |
| **1.0 Coding Standards — Quy chuẩn đặt tên** | **Biến / hàm**: camelCase — VD: getUserProfile, isLoading. |
| **Class / Component / Type / Interface**: PascalCase — VD: UserProfileCard, AuthState. |
| **Hằng số (module-level, immutable)**: UPPER_CASE — VD: MAX_RETRY_COUNT, SSL_PINNING_DOMAINS. |
| **Hook**: camelCase, prefix use — VD: useCaptureCccdManual, useCountdown. |
| **File Redux slice**: camelCase + suffix Slices/Slice — VD: inputCccdManualSlices/. |
| **File Screen component**: PascalCase khớp tên folder — VD: screens/CaptureCccdManual/CaptureCccdManual.tsx. |
| **File Test**: co-located, suffix .test.ts(x) — VD: cccdManualCapture.test.ts. |
| **File Platform-specific**: suffix .web.ts(x) / .native.ts(x) — VD: FastImage.web.tsx. |
| **File Doc (root docs/)**: UPPER_CASE.md — VD: SSL_PINNING.md, GIT_FLOW.md. |
| **1.1 Coding Standards — Cấu trúc & Quy tắc Project** | **Platform-agnostic**: Logic dùng chung mobile+web đặt trong packages/shared, KHÔNG import trực tiếp API platform-specific (@react-navigation/native, \__DEV_\_) — dùng abstraction (useConfigRouting, process.env.NODE_ENV). |
| **Util thuần (pure)**: utils/ phải pure — không gọi API, không side effect; logic có side effect thuộc hooks/ hoặc api/. |
| **Test co-located**: Mỗi util/hook/slice mới → có test cùng thư mục (\*.test.ts). |
| **File platform-specific**: Dùng suffix chuẩn RN/Next (.web.ts(x), .native.ts(x)) thay vì check Platform.OS khi tách file được. |
| **API endpoint**: Định nghĩa qua RTK Query trong redux/slices/apiSlices/<domain>API.ts, type theo types/services/<domain>Types.ts. |
| **Xử lý lỗi API**: Convert qua utils/ErrorMessageService.ts — không tự viết tay extract message trong screen/hook. |
| **Route web**: Folder app/\[locale\]/ dạng kebab-case, map 1-1 với 1 shared screen. |
| **Import path**: Cross-folder trong shared dùng alias @lfvn-customer/shared/<path>; không chain ../../.. |
| **TypeScript:** Ưu tiên dùng enum hơn dùng type trong các trường hợp limited value Ưu tiên dùng lại các type đã được define rồi để đảm bảo consistent về mặt logic và dữ liệu hoặc sử dụng tính kế thừa của typescript Toàn bộ biến và object phải được khai báo kiểu dữ liệu |
| **2. UI Conventions** | **Styling engine**: Dùng twrnc (tw.style(...)) — không dùng styled-components/emotion/StyleSheet.create cho code mới. |
| **Design tokens**: Màu/size lấy từ themes/ (colors.ts, size.ts, style.ts), ưu tiên token/class hơn hex cứng. |
| **Style động**: Class động/điều kiện dùng template string trong tw.style(...). |
| **Cấu trúc components**: components/common/ = UI tái sử dụng chung, không chứa business logic; components/<Feature>/ = composite theo tính năng. |
| **Form**: Dùng react-hook-form cho form nhiều field, không tự quản lý state tay. |
| **i18n — key**: Namespace.camelCase (VD Common.confirm), namespace PascalCase; interpolation dùng {placeholder}. |
| **i18n — usage**: Trong React dùng useTranslations(); ngoài React dùng getTranslation() từ i18n/translationStore.ts. |
| **i18n — đồng bộ locale**: vi.json và en.json phải cùng bộ key (enforce bởi check-i18n-sync.mjs). |
| **Comment code**: Business logic/BRD dùng tiếng Việt, cite BRD code + bước; identifier luôn tiếng Anh. |
| **Format**: Prettier — singleQuote, trailingComma all, bracketSpacing false, arrowParens avoid; yarn format, lint-staged tự chạy pre-commit. |
| **3. State Management** | **Cấu trúc redux**: store.ts (mobile, persist qua MMKV) và storeWeb.ts (web, persist qua localStorage) DÙNG CHUNG 1 rootReducer. |
| **Quy tắc persist 2-store**: Slice mới phải quyết định persist rõ ràng, update blacklist ở CẢ HAI store hoặc note lý do khác biệt — thiếu 1 bên = persist ngoài ý muốn. |
| **Middleware**: serializableCheck/immutableCheck tắt cố ý (perf) — không có gì chặn non-serializable value/mutation ngoài review. |
| **Checklist slice mới**: Tạo dưới redux/slices/ → đăng ký rootReducer.ts → quyết định blacklist ở cả 2 store → co-located test. |
| **Đọc state**: Dùng useAppSelector (typed) từ redux/store, không dùng useSelector thô. |
| **RTK Query**: 1 file/domain trong slices/apiSlices/<domain>API.ts; 2 apiSlice riêng (apiSlice + apiOnlineProcessSlice), reducerPath luôn blacklist khỏi persist. |
| **Mock-first**: Hook có thể ship với hằng số MOCK\_\* trong lúc chờ backend, phải greppable rõ ràng — bắt buộc gỡ trước khi lên uat/main (check-no-mock-flags.mjs enforce). |
| **4. Adding a Screen** | **Vị trí logic**: Pure logic → utils/, side effect/orchestration → hooks/use<Feature>, UI → screens/<Feature>/ (compose hook+component, ít logic). |
| **Shared screen**: Tạo shared/screens/<Feature>/ + biến thể .web.tsx (nếu có) + barrel index.ts; platform chưa làm → placeholder null có JSDoc giải thích. |
| **Route name**: Thêm entry ScreenParamEnum (value kebab-case = URL web) trong types/paramtypes.ts. |
| **Navigate**: CHỈ dùng useConfigRouting().appNavigate(...) trong shared code — không import @react-navigation/native trực tiếp. |
| **Mobile wiring**: Thêm Stack.Screen trong RootNavigator.tsx, name = đúng enum value. |
| **Web wiring**: Tạo app/\[locale\]/<enum-value>/page.tsx, wrapper mỏng (layout + shared screen); CSS web-only (dvh...) nằm ở đây, không nằm trong shared screen. |
| **Checklist đủ bước**: shared screen + hook + enum + mobile navigator + web route + slice persist (nếu có state) + i18n vi/en + test co-located. |
| **5. Env & Tooling** | **Env theo package**: mobile dùng .env/.env.sit/.env.uat/.env.production qua react-native-config; web dùng .env qua Next.js/dotenv (biến public phải NEXT_PUBLIC\_\*). |
| **Đọc env trong shared**: KHÔNG import react-native-config hay process.env.NEXT_PUBLIC\_\* trực tiếp — chỉ qua utils/handleEnvByPlatform.ts (thêm case khi thêm biến mới). |
| **Runtime env check**: Dùng getCurrentEnvironment() thay vì \__DEV_\_ (RN-only) hay tự đoán host. |
| **Debug override**: Build non-production cho phép override API base URL runtime qua debug tool (utils/apiDomain.ts), tự tắt khi production. |
| **patch-package**: Fix vá node_modules lưu ở patches/\*.patch, tự áp dụng lúc postinstall; PR phải ghi rõ LÝ DO patch. |
| **Git hook**: postinstall cài githooks/pre-commit — chạy CẢ lint-staged VÀ yarn web:build (build full Next.js) — 2 gate, đừng bypass --no-verify trừ khi chỉ sửa doc. |
| **Workspace**: Yarn 3, alias @lfvn-customer/shared chính là tên package (workspace resolution, không cần babel/tsconfig alias riêng). |
| **6.0 Code Review Tier 1 — ESLint** | **Rule platform-agnostic**: no-restricted-imports chặn @react-navigation/native, @react-navigation/native-stack, react-native-config trong packages/shared. |
| **Rule \__DEV_\_**: no-restricted-globals chặn \__DEV_\_ (RN-only, undefined trên web) — dùng getCurrentEnvironment(). |
| **Exemption cấu trúc**: hooks/routing/index.ts và utils/handleEnvByPlatform.ts được phép dùng trực tiếp — chính là lớp abstraction. |
| **Nợ cũ (grandfathered)**: 14 file vi phạm trước khi có rule, liệt kê tên file rõ ràng trong eslint.config.js — không thêm file mới vào danh sách này. |
| **6.1 Code Review Tier 2 — CI scripts** | **check-i18n-sync.mjs**: vi.json và en.json phải khai báo cùng bộ key. |
| **check-persist-sync.mjs**: Mọi entry trong persistConfig.blacklist (store.ts/storeWeb.ts) phải khớp key thật của rootReducer. |
| **check-screen-routes.mjs**: Mỗi route folder web (app/\[locale\]/) phải có ScreenParamEnum tương ứng. |
| **check-no-mock-flags.mjs**: Không còn hằng số MOCK\_\* trong packages/shared — chỉ chạy ở release gate (uat/main), không chạy ở develop. |
| **Ratchet baseline**: Nợ cũ liệt kê trong scripts/checks/baselines/\*.json, không chặn build — chỉ chặn drift MỚI phát sinh. |
| **Debt tracker**: report-debt.mjs in tổng nợ vào mọi CI run (job summary) + workflow debt-tracker.yml cập nhật 1 GitHub issue theo tuần. |
| **6.2 Code Review Tier 3 — AI review** | **Bản Active (free)**: ai-review-free.yml dùng GitHub Models, GITHUB_TOKEN mặc định (permission models: read) — không cần secret. |
| **Bản Paused (trả phí, chất lượng cao hơn)**: claude-review.yml dùng Claude, cần secret ANTHROPIC_API_KEY hoặc CLAUDE_CODE_OAUTH_TOKEN — hiện đang tắt trigger tự động (workflow_dispatch only). |
| **Phạm vi review AI**: Đúng tầng kiến trúc (utils/hooks/screen)? Util có pure không? Lỗi API có qua ErrorMessageService không? Thiếu test co-located không? |
| **6.3 Code Review Tier 4 — Human review** | **Phạm vi còn lại**: Chỉ review đúng nghiệp vụ/BRD — phần cơ chế (naming, wiring, convention) đã được Tier 1–3 xử lý trước đó. |
| **7. Git Flow** | **Mô hình nhánh**: feature/\* merge trực tiếp vào develop (build SIT) VÀ uat (chỉ feature đã pass SIT, build UAT) VÀ main (chỉ từ uat/hotfix, build PROD). |
| **Nguồn sự thật**: Feature branch = source of truth — sửa lỗi luôn commit trên feature branch, KHÔNG bao giờ sửa trực tiếp develop/uat. |
| **Cắt nhánh**: feature/\* PHẢI cắt từ main (base sạch), không cắt từ develop — tránh kéo theo feature khác chưa duyệt khi merge vào uat. |
| **Release gate**: Feature không được duyệt/chưa cần thì đơn giản KHÔNG merge vào uat — đó chính là gate. |
| **Back-merge bắt buộc**: Sau khi merge lên main/hotfix phải merge ngược lại uat và develop, tránh drift. |
| **Reset develop**: Sau mỗi milestone reset develop = main (reset --hard + force-with-lease) rồi merge lại feature còn dở — tránh SIT test tổ hợp không tồn tại thật. |
| **Naming**: feature/<BRD-code>-<ten> (kebab-case, cắt từ main); hotfix/<mo-ta-ngan>; commit theo Conventional Commits (feat/fix/refactor/...). |
| **Tag**: uat-x.y.z cho uat, prod-x.y.z cho main — luôn có prefix môi trường. |
| **8. CI/CD** | **Test job**: push/PR vào develop → test coverage và automation review code. |
| **Diff-coverage job**: Chỉ chạy trên PR — scripts/diff-coverage.mjs yêu cầu ≥90% coverage trên dòng code MỚI/THAY ĐỔI (không bắt buộc code cũ). |
| **Mobile CI-CD**: Chưa có job. Tuy nhiên sẽ bổ sung github action để auto build cho các PR và deliver qua firebase app distribution. Dev ko phải build trực tiếp app cho tester nữa |
| **UAT-DEVOPS**: Build → deploy UAT/PROD, release store, secret management KHÔNG nằm trong repo — liên hệ DevOps; chỉ mapping nhánh↔môi trường ghi ở Git Flow. |
| **9. Definition of Done** | **Chuẩn Coding Convention**: Code tuân theo Coding Standards (naming, cấu trúc project). |
| **Lint**: yarn lint pass — hiện chỉ chạy ở pre-commit hook (githooks/pre-commit), CHƯA gate ở CI. |
| **Chuẩn Commit**: Commit theo Conventional Commits (xem Git Flow — commit & branch naming). |
| **Unit Test**: Có test cho logic mới trong packages/shared (utils/hooks/redux) — co-located \*.test.ts. |
| **Coverage**: Không giảm dưới floor hiện tại + diff-coverage ≥90% trên code mới (CI tự động check). |
| **Giám sát lỗi (Sentry)**: Không phát sinh lỗi Sentry mới sau khi deploy DEV. |
| **Deploy**: Deploy DEV thành công. |
| **Code Review**: Đảm bảo đúng yêu cầu nghiệp vụ, tái sử dụng code, clean code, số dòng code của file < 400 (không chứa các khoảng trắng/xuống dòng)  |
| **10. Monitoring & Logging (Sentry)** | **SDK**: @sentry/react-native (mobile) · @sentry/nextjs (web); platform resolve tự động qua file suffix (sentry.ts / sentry.web.ts), KHÔNG conditional import tay. |
| **Env DSN**: SENTRY_DSN (mobile, per .env.\*) · NEXT_PUBLIC_SENTRY_DSN (web) · SENTRY_AUTH_TOKEN chỉ dùng CI để upload sourcemap, KHÔNG commit. |
| **Quy tắc tunnelRoute (CRITICAL)**: src/middleware.ts phải loại trừ path sentry-tunnel khỏi locale routing — nếu không next-intl redirect 307, event không tới Sentry. |
| **Sampling**: Dùng tracesSampler (không fixed rate) — flow quan trọng (login/eKYC/loan/esign) luôn 100%, còn lại 100% dev/20% prod. |
| **Tắt Sentry**: Không set DSN tương ứng (SENTRY_DSN/NEXT_PUBLIC_SENTRY_DSN) → SDK tự vô hiệu hoá, không cần đổi code. |
| **Hook bắt buộc**: setSentryUser gọi ở useAuth (login/logout); sentryLogger gọi ở luồng eKYC quan trọng (useHandleStartEkyc, useVerifyCustomerEKYC). |
| **11.0 Security — SSL Pinning** | **Config format**: SSL_PINNING_DOMAINS liệt kê domain, mỗi domain có biến SSL_PINNING\_<DOMAIN_UPPER_SNAKE> chứa list pin (fallback theo thứ tự). |
| **Cơ chế fallback**: Bất kỳ pin nào khớp là connection pass — cho phép nhiều pin backup, tránh lockout khi renew cert. |
| **Thứ tự pin khuyến nghị**: Cert 1 không hợp lệ sẽ được bỏ qua và check cert tiếp theo. |
| **Injection**: scripts/inject-ssl-pins.sh sinh network_security_config.xml (Android) và Info.plist TrustKit config (iOS) từ .env — tích hợp sẵn vào build script android:\*/ios:\*. |
| **Thêm domain mới**: sslpin.sh sinh pin → thêm vào .env (domain list + biến pin) → chạy lại inject script → rebuild. |
| **Best practice**: KHÔNG BAO GIỜ tắt pinning ở production; luôn có ≥2 pin backup/domain; test lại MITM proxy sau mỗi thay đổi. |
| **11.1 Security — Tạm tắt (⚠️ phải restore trước prod)** | **Trạng thái**: Runtime security checks (jailbreak/root/hook/debugger/ADB/emulator) + SSL pinning (iOS TrustKit + Android network_security_config) đang TẮT TẠM để tích hợp BShield (RASP thương mại) — từ 2026-06-10. |
| **Không đụng**: Anti-reverse build (ProGuard/R8, iOS symbol strip) và ATS/cleartext KHÔNG nằm trong phạm vi tắt này. |
| **Checklist restore bắt buộc**: SecuritiesChecking.tsx if(true)→if(\__DEV_\_); AppDelegate.swift bỏ comment TrustKit init; Info.plist 2× TSKEnforcePinning→true; network_security_config.xml khôi phục 2 pin-set block; package.json khôi phục prefix yarn ssl:\* cho 6 script; xoá hết comment marker "SECURITY DISABLED (temp)"; build sit + test MITM phải bị chặn lại. |
| **Gate**: KHÔNG build production khi chưa hoàn tất checklist restore HOẶC chưa xác nhận BShield đã cover đầy đủ các check bị tắt. |
| **11.2 Security — Assessment Response** | **High severity**: 5 vấn đề — 2 đã fix (ATS local networking iOS, Android minSdkVersion 24→29), 3 chấp nhận rủi ro vì nằm trong SDK bên thứ 3 không sửa được (TrueID SDK OpenSSL, CBC padding oracle, thiếu stack canary thư viện precompiled). |
| **Warning severity**: 6 vấn đề — 1 đã fix (strip debug symbol iOS release build), 5 chấp nhận (false positive hoặc standard practice: rpath, binary không mã hoá, C API/random/malloc trong SDK bên thứ 3). |
| **Medium severity (Android, 24 vấn đề)**: Phần lớn chấp nhận vì thuộc thư viện bên thứ 3 bắt buộc (OneSignal/Firebase/TrueID exported component) hoặc false positive (không dùng SQL — dùng MMKV; secret không hard-code, nằm trong .env gitignored). |
| **Nguyên tắc chấp nhận rủi ro**: CHỈ accept khi (a) code bên thứ 3 không sửa được, (b) có phân tích risk=impact×likelihood rõ ràng, (c) có ghi mitigation — không accept tuỳ tiện. |
| **Review định kỳ**: Theo dõi advisory của TrueID/React Native/OneSignal cho các rủi ro đã accept — không phải "đóng" vĩnh viễn. |
| **12. Push Notification (OneSignal)** | **Đã có**: Subscribe device khi mở app, link identity sau login, click handling có navigate, In-App Message trigger, phân biệt user mới/cũ. |
| **Chưa làm (theo priority)**: (1) Loan status updates qua OneSignal REST API; (2) Abandoned application recovery qua trigger step; (3) User segmentation qua tag; (4) Personalized offer; (5) Smart scheduling; (6) Rich notification; (7) Notification preference. |
| **Yêu cầu backend**: Tích hợp OneSignal REST API, lưu external_user_id (identityNumber), trigger theo loan status, schedule reminder qua cron, track delivery. |
| **Test checklist trước khi ship**: iOS/Android (foreground/background/killed), deep link từ notification, In-App Message trigger, có/không mạng, sound/vibration/badge. |

## Lý thuyết & Nguyên lý thiết kế

Phần dưới giải thích **tại sao** convention ở trên được thiết kế như vậy — lý thuyết engineering đứng sau, và cách nó cụ thể hoá trong repo này.

| **#** | **Khái niệm** | **Lý thuyết / Nguyên lý** | **Áp dụng trong repo này** |
| --- | --- | --- | --- |
| **A. Kiến trúc & Design Pattern** | **Layered architecture (utils/hooks/screens)** | Mục tiêu: tách phần logic thuần — dễ test, dễ suy luận — khỏi phần có side effect — khó test, dễ lỗi. Từ đó code dễ đọc và dễ tái sử dụng | utils/ = functional core (pure), hooks/ = imperative shell (API call, redux dispatch, navigation), screens/ chỉ compose. Vì vậy utils luôn test dễ; bug thường chỉ nằm ở lớp hooks/screens. |
| **Adapter / Strategy pattern** | Định nghĩa 1 interface chung, nhiều implementation khác nhau phía sau — code gọi không cần biết implementation nào đang chạy. | useConfigRouting (native dùng @react-navigation, web dùng next/navigation) và handleEnvByPlatform (native đọc react-native-config, web đọc process.env) — business logic gọi cùng 1 API, không quan tâm platform. |
| **Atomic Design (bản rút gọn)** | Chia UI thành 5 cấp (atoms → molecules → organisms → templates → pages) để tái sử dụng có hệ thống. | Repo dùng bản rút gọn 2 cấp: components/common = atom/molecule dùng chung, components/<Feature> = organism theo tính năng, screens/ = page. Đủ cho team nhỏ, tránh over-engineer 5 tầng khi chưa cần. |
| **Server-state vs Client-state** | State đến từ server (có latency, có thể stale, cần cache/invalidate) khác bản chất với state UI thuần (đồng bộ, không cần cache) — đây là insight cốt lõi của RTK Query/React Query. | RTK Query (apiSlice) quản lý toàn bộ data từ backend; slice thường chỉ chứa UI/app state — tránh nhét logic cache tay vào reducer thường. |
| **B. Tại sao Redux persist tách 2 store + có blacklist** | **Explicit state ownership** | Persisted state là một "hợp đồng ngầm" với version app tương lai — trường nào tồn tại lâu dài phải có chủ đích, không phải mặc định. | Mặc định KHÔNG persist gì đặc biệt — blacklist chỉ loại trừ những gì rõ ràng không cần sống qua session. Muốn 1 state sống lâu phải là quyết định có ý thức, không phải tình cờ. |
| **Vì sao 2 store riêng thay vì share persistConfig** | Mobile và web có cơ chế lưu trữ vật lý khác nhau (MMKV vs localStorage) và mô hình vòng đời khác nhau (app kill vs tab close/SSR) — dùng chung storage engine là sai kỹ thuật. | rootReducer share logic, nhưng persistConfig (và blacklist) tách riêng để mỗi platform tự quyết định cái gì cần sống theo đúng vòng đời của nó — 2 store hiện tại có blacklist khác nhau có chủ đích. |
| **C. Tại sao Code Review chia 4 tier** | **Shift-left testing / Defense in depth** | Lỗi bắt càng sớm trong pipeline thì chi phí sửa càng thấp ("cost of a bug" tăng theo cấp số nhân càng xa điểm phát sinh); nhiều lớp phòng thủ độc lập tốt hơn 1 lớp duy nhất (an ninh mạng gọi là "defense in depth"). | ESLint (giây) chặn trước commit → CI script (giây) chặn trước merge → AI review (phút) bắt lỗi ngữ nghĩa → người chỉ xử lý phần không cơ giới hoá được. Mỗi tầng rẻ hơn tầng sau nên luôn đặt trước. |
| **Ratchet** | Nợ kỹ thuật trong codebase brownfield không thể fix hết ngay (không đủ nguồn lực, rủi ro side-effect) — nhưng để nó tự do lan cũng sai. Ratchet (chặn tăng, cho phép giảm) là compromise thực dụng giữa "kệ nợ" và "big-bang rewrite". | Coverage floor, i18n-sync-baseline.json, screen-routes-baseline.json, ESLint grandfathered list — nợ cũ hiển thị rõ + không tăng thêm, không chặn build vì nợ nằm ngoài phạm vi PR hiện tại. |
| **Automation trước, người sau** | Con người giỏi phán đoán ngữ cảnh/ý đồ nghiệp vụ, kém việc lặp lại chính xác hàng trăm lần (mỏi, bỏ sót) — máy thì ngược lại. Phân việc theo đúng thế mạnh mỗi bên. | Nếu người bắt cùng 1 loại lỗi 2 lần trong review → viết rule/script cho nó, không review tay mãi mãi. |
| **D. Tại sao Git Flow hiện tại "cắt từ main, không từ develop"** | **Tránh integration hell / silent coupling** | Nếu feature branch cắt từ 1 nhánh tích hợp (develop) đang chứa nhiều feature khác chưa release, merge riêng feature đó lên môi trường release (uat) sẽ vô tình kéo theo code feature khác — một dạng coupling ẩn giữa các thay đổi lẽ ra độc lập. | Cắt từ main (base sạch, chỉ chứa code đã lên PROD) đảm bảo mỗi feature branch độc lập tuyệt đối — muốn merge lên uat lúc nào cũng được mà không kéo rác. |
| **Release gate bằng chọn lọc merge, không phải feature-flag** | Cách rẻ nhất để "bật/tắt" 1 tính năng ở 1 môi trường, khi chưa có hệ thống feature-flag, là kiểm soát ngay ở tầng merge — nhánh nào không merge thì môi trường đó không có code đó. | uat chỉ nhận feature đã pass SIT — quyết định merge = quyết định gate. Trade-off: phải test lại tổ hợp khác nhau giữa develop và uat (ghi rõ trong docs là "accepted trade-off"). |
| **Reset develop mỗi milestone** | Nhánh tích hợp chứa MỌI thay đổi (kể cả bị từ chối) qua thời gian sẽ "trôi" khỏi trạng thái build thật — SIT test ra một tổ hợp code không giống bất kỳ bản PROD nào từng có, làm giảm giá trị của việc test. | Sau mỗi lần lên PROD, reset develop = main rồi merge lại đúng feature còn đang làm dở — đưa integration branch về lại trạng thái "sạch" định kỳ. |

---

## Bổ sung — Thức phản hồi sau khi agent đọc trang (2026-07-27)

> Bạn không cần quan tâm tới vụ security, nó không nằm trong scope này, tuy
> nhiên bạn có thể hiểu được cách tôi tư duy và cách làm, khi gặp một sự thay
> đổi, tôi luôn document lại, làm sao để sau này dễ recover, truy vết lịch sử.
> Ngoài ra tôi đồng ý nên theo rule of three

Hai điều được chốt:

1. **Nguyên tắc rút ra (không phải nội dung security):** mọi thay đổi đều được
   document lại để sau này *recover* và *truy vết lịch sử*. Mục 11.1 là ví dụ:
   nó chứa what/why/when + checklist restore 7 bước + một gate.
2. **Ngưỡng Rule of Three:** Thức chọn **3, thống nhất**. Giả thuyết của agent
   về "ngưỡng điều chỉnh theo chi phí" (2 cho automation rẻ, 3 cho tool đắt)
   **bị bác** — anh ưu tiên một ngưỡng nhất quán. Dòng "2 lần" trong mục
   "Automation trước, người sau" của trang là điểm cần chỉnh về 3.

---

## Bổ sung 2 — Phần bôi vàng (đọc lại 2026-09-01)

**Ghi chú provenance:** lần capture đầu chuyển trang sang markdown và **mất
phần highlight** (`#ffc400`) — highlight là markup, không phải nội dung, nên
nó rơi mất trong quá trình convert. Thức yêu cầu đọc lại đúng phần này. Dưới
đây là **toàn bộ** các ô được bôi vàng, chép nguyên văn, trừ hai ô trong mục
security (11.1) vì security nằm ngoài scope theo yêu cầu của anh.

**1.1 Cấu trúc & quy tắc project**

- **Platform-agnostic**: Logic dùng chung mobile+web đặt trong packages/shared,
  KHÔNG import trực tiếp API platform-specific (@react-navigation/native,
  __DEV__) — dùng abstraction (useConfigRouting, process.env.NODE_ENV).
- **Util thuần (pure)**: utils/ phải pure — không gọi API, không side effect;
  logic có side effect thuộc hooks/ hoặc api/.
- **TypeScript**:
  - Ưu tiên dùng enum hơn dùng type trong các trường hợp limited value
  - Ưu tiên dùng lại các type đã được define rồi để đảm bảo consistent về mặt
    logic và dữ liệu hoặc sử dụng tính kế thừa của typescript
  - Toàn bộ biến và object phải được khai báo kiểu dữ liệu

**2. UI Conventions**

- **Cấu trúc components**: components/common/ = UI tái sử dụng chung, không
  chứa business logic; components/<Feature>/ = composite theo tính năng.

**6.1 Code Review Tier 2 — CI scripts** (cả 4 script đều được bôi vàng)

- **check-i18n-sync.mjs**: vi.json và en.json phải khai báo cùng bộ key.
- **check-persist-sync.mjs**: Mọi entry trong persistConfig.blacklist
  (store.ts/storeWeb.ts) phải khớp key thật của rootReducer.
- **check-screen-routes.mjs**: Mỗi route folder web (app/[locale]/) phải có
  ScreenParamEnum tương ứng.
- **check-no-mock-flags.mjs**: Không còn hằng số MOCK_* trong packages/shared —
  chỉ chạy ở release gate (uat/main), không chạy ở develop.

**6.2 / 6.3 — phạm vi review**

- **Phạm vi review AI**: Đúng tầng kiến trúc (utils/hooks/screen)? Util có pure
  không? Lỗi API có qua ErrorMessageService không? Thiếu test co-located không?
- **Phạm vi còn lại (Tier 4 — người)**: Chỉ review đúng nghiệp vụ/BRD — phần cơ
  chế (naming, wiring, convention) đã được Tier 1–3 xử lý trước đó.

**8. CI/CD**

- **Mobile CI-CD**: Chưa có job. Tuy nhiên sẽ bổ sung github action để auto
  build cho các PR và deliver qua firebase app distribution. Dev ko phải build
  trực tiếp app cho tester nữa.

**Bảng lý thuyết** (mục A và C)

- **Layered architecture** (utils/hooks/screens)
- **Adapter / Strategy pattern**
- **Atomic Design** (bản rút gọn)
- **Automation trước, người sau**

---

## Bổ sung 3 — Thức phản hồi về phần bôi vàng (2026-09-01)

> Vẫn là những gì tôi từng nói thôi, đây chỉ là mô tả chi tiết hơn về tư tưởng
> code của tôi

Chốt: **không phải kiến thức mới, mà là cùng một triết lý ở mức chi tiết hơn.**
Agent đề xuất tách một concept page mới ("extend the type system with scripts")
— **rút lại**. Giá trị thật của phần bôi vàng là *bằng chứng*: nó nâng trạng
thái nhận thức của [[wiki/craft-philosophy]] từ self-report sang có artifact
chống lưng, và cho thấy các giá trị đó được **thực thi bằng cơ chế gì**.
