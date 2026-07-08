---
title: 기능 목록 명세서 (Feature List)
version: v1.0.0
last_updated: 2026-07-08
author: 숭늉
status: Draft
---

# 📋 기능 목록 명세서 (Feature List)

본 문서는 요구사항 정의서(Requirements.md)를 바탕으로, WBS(Work Breakdown Structure) 작성을 위한 구체적인 구현 단위의 기능 목록을 명세합니다.

## 1. 모듈 분류 체계 (Module Architecture)
기능은 시스템 구성도(Architecture.md)의 마이크로서비스 구분에 맞추어 4개의 핵심 모듈로 최적화하여 그룹화하였습니다.

*   **[AUTH] 인증/프로필 모듈**: 건강 프로필 설정, 기기 로컬 암호화, 회원 관리 (AuthSvc 대응)
*   **[TOUR] 위치/관광 모듈**: 안심 식당 맵핑, 리뷰 커뮤니티, 식후 산책로, SOS 응급 (TourSvc 대응)
*   **[AI] 스마트 스캐너 모듈**: 실시간 카메라 스캔, OCR, 번역, 성분 위험 분석 (AISvc 대응)
*   **[ORDER] 스마트 오더 모듈**: 보안 QR 발급, 점주용 웹 뷰어, 다국어 퀵 리플라이 (OrderSvc 대응)

---

## 2. 모듈별 기능 상세 명세

### 2.1. [AUTH] 인증/프로필 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-AUTH-01` / **건강 프로필 온보딩 및 로컬 캐싱** |
| **요구사항 연동** | FR-C01, FR-C06, NFR-S02 |
| **선결 작업** | [없음] 앱 구동 시 최초 진입 기능 |
| **UI/UX 요건** | 21종 알레르기/질환 체크리스트, 언어 설정 스피너, 오프라인용 SOS 헬프카드 화면 |
| **상세 구현 계획** | 1. 클라이언트(React 19): 온보딩 데이터 수집 후 통신 단절 대비 기기 내 안전 저장소(Secure Storage) 및 Zustand 전역 상태 캐싱.<br>2. 백엔드(Spring Boot): 수신된 민감 건강 정보(PHI)를 AES-256 양방향 암호화 모듈을 통해 변환 후 JPA를 통해 DB 적재. |
| **DB 스키마** | `users` (id, email, password)<br>`user_profiles` (user_id, encrypted_health_data, language_code) |
| **API 연동** | `POST /api/v1/auth/profile` (내부 API) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 3.0 |

### 2.2. [TOUR] 위치/관광 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-TOUR-01` / **맞춤형 안심 식당 및 리뷰 탐색** |
| **요구사항 연동** | FR-C02, FR-C07 |
| **선결 작업** | `FEAT-AUTH-01` (사용자 프로필 정보가 있어야 위험도 필터링 가능) |
| **UI/UX 요건** | 위치 기반 지도 뷰, 식당 위험도 색상 라벨(적/황/녹), 동일 식성 리뷰 필터 스위치 |
| **상세 구현 계획** | 1. TourAPI '무장애 여행' 데이터 맵핑 후 PostGIS 공간 연산을 활용하여 사용자 반경 5km 식당 고속 검색.<br>2. 식당 메뉴 데이터를 사용자 알레르기 정보와 대조하여 위험도 시각화(React Query 상태 활용).<br>3. 리뷰 조회 시 JPA 연관관계 매핑(`user_profiles`)을 조인하여 동일 식성 사용자 리뷰 상단 노출. |
| **DB 스키마** | `restaurants` (id, name, lat, lng, menu_json)<br>`reviews` (id, restaurant_id, user_id, rating, content) |
| **API 연동** | 한국관광공사 TourAPI (외부), `GET /api/v1/tour/restaurants` (내부) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 4.5 |

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-TOUR-02` / **식후 산책로 추천 및 SOS 연계** |
| **요구사항 연동** | FR-C04, FR-C05 |
| **선결 작업** | [없음] 독립 실행 가능 (단, 결제 모듈 완료 시 식후 자동 팝업 연동) |
| **UI/UX 요건** | 걷기 코스 리스트(소요 시간 표기), 응급실 내비게이션 연결 버튼, 전체화면 헬프카드 |
| **상세 구현 계획** | 1. 걷기 코스: TourAPI 걷기 코스 호출 후 도보 길찾기 앱(구글맵 URL Scheme) 딥링크 생성.<br>2. SOS: 구글 Places API 'hospital' 키워드로 최단 거리 의료기관 맵핑. |
| **DB 스키마** | 별도 DB 저장 불필요 (Stateless 처리) |
| **API 연동** | Google Maps API, Google Places API, TourAPI |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 3.0 |

### 2.3. [AI] 스마트 스캐너 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-AI-01` / **AI 렌즈 (메뉴 스캔 및 성분 분석)** |
| **요구사항 연동** | FR-C03, NFR-P01 |
| **선결 작업** | `FEAT-AUTH-01` (알레르기 판별을 위한 사용자 프로필 필요) |
| **UI/UX 요건** | 카메라 뷰, 분석 중 로딩 스켈레톤, AR 텍스트 오버레이(위험 성분 적색 강조), 수동 검색 Fallback 창 |
| **상세 구현 계획** | 1. 프론트(Vite/React): 이미지 캡처/압축 전송. 3초 경과 시 타임아웃 및 Fallback UI 오픈.<br>2. 백엔드(Java 25): Virtual Threads를 적용하여 외부 API 통신 시 스레드 블로킹 방지.<br>3. Spring AI 연동: Naver Clova OCR 추출 텍스트를 HyperCLOVA X로 전송하여 성분 추론 및 다국어 번역 반환. |
| **DB 스키마** | `scan_logs` (id, user_id, image_url, ocr_result, warning_flag) |
| **API 연동** | Naver Clova OCR, Naver HyperCLOVA X, `POST /api/v1/ai/scan` |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 7.0 (최고 난이도) |

### 2.4. [ORDER] 스마트 오더 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-ORDER-01` / **B2B 점주용 보안 QR 오더링** |
| **요구사항 연동** | FR-B01, FR-B02, NFR-S01 |
| **선결 작업** | `FEAT-AI-01` (메뉴 스캔 후 해당 메뉴를 주문하는 흐름에서 파생) |
| **UI/UX 요건** | (App) 타이머가 돌아가는 동적 QR 화면<br>(Web) 점주용 주문 내역서 뷰어(24px 이상 고대비), 퀵 리플라이 터치 버튼 |
| **상세 구현 계획** | 1. 관광객 주문 확정 시 임시 토큰(JWT) 생성 후 `https://owner.okeymeal.kr/order/{token}` 구조의 QR 생성.<br>2. 점주 카메라 스캔 시 백엔드에서 토큰 검증(만료/위조 체크).<br>3. 점주용 Web 렌더링 시 웹소켓(또는 SSE) 연결로 퀵 리플라이 터치 시 관광객 App으로 FCM 푸시 발송. |
| **DB 스키마** | `orders` (id, user_id, restaurant_id, menu_details, status)<br>`qr_tokens` (Redis 캐시 저장) |
| **API 연동** | Firebase Cloud Messaging(FCM), `GET /api/v1/order/view/{token}` |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 5.5 |

### 2.5. [CS] 고객지원 및 커뮤니티 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-CS-01` / **게시판 및 커뮤니티** |
| **요구사항 연동** | FR-C08 |
| **선결 작업** | `FEAT-AUTH-01` |
| **상세 구현 계획** | 1. 관광 꿀팁 및 지역별 맛집 리스트업 커뮤니티 UI 개발.<br>2. JPA 다대일 매핑 및 페이징 성능 최적화(React Query 무한 스크롤 연동). |
| **DB 스키마** | `posts` (id, user_id, title, content, likes)<br>`comments` (id, post_id, content) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 4.0 |

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-CS-02` / **고객센터 (FAQ 및 1:1 문의)** |
| **요구사항 연동** | FR-C09, FR-C10 |
| **선결 작업** | [없음] |
| **상세 구현 계획** | 1. 아코디언 UI 형태의 FAQ 제공.<br>2. 사진 첨부가 가능한 1:1 문의 게시판 구현 (S3 객체 스토리지 연동). |
| **DB 스키마** | `inquiries` (id, user_id, type, content, image_url, status) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 3.5 |

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-CS-03` / **개인정보 동의 이력 관리** |
| **요구사항 연동** | FR-C11, NFR-S02 |
| **선결 작업** | `FEAT-AUTH-01` |
| **상세 구현 계획** | 가입 시 약관 버전별 동의 여부 저장. 마이페이지에서 선택(마케팅) 동의 철회 시 DB 및 FCM 구독 정보 업데이트. |
| **DB 스키마** | `user_consents` (id, user_id, terms_id, agreed, updated_at) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 2.0 |

### 2.6. [ADMIN] 데이터/통계 관리자 모듈

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-ADMIN-01` / **종합 모니터링 대시보드** |
| **요구사항 연동** | FR-A01 |
| **선결 작업** | 전체 기능 오픈 |
| **상세 구현 계획** | 1. Chart.js 기반 일간/주간 스캔량, QR 발급량, 에러율 모니터링 뷰어 개발.<br>2. 성능을 위해 Redis에 일간 통계 캐싱 처리. |
| **DB 스키마** | `admin_stats` (일자별 통계 집계 테이블) |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 5.0 |

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-ADMIN-02` / **AI 트렌드 및 주문 통계 분석** |
| **요구사항 연동** | FR-A02, FR-A03 |
| **선결 작업** | `FEAT-AI-01`, `FEAT-ORDER-01` |
| **상세 구현 계획** | 스캔 실패 이력 및 기피 식재료 통계 추출. CSV 다운로드 기능. 대용량 조회를 위한 QueryDSL 활용 및 읽기 전용(Read Replica) 트랜잭션 분리. |
| **DB 스키마** | `scan_logs`, `orders`, `user_profiles` 조인 쿼리 |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 4.5 |

| 항목 | 내용 |
| :--- | :--- |
| **기능 ID / 기능명** | `FEAT-ADMIN-03` / **회원 및 1:1 문의 관리** |
| **요구사항 연동** | FR-A04 |
| **선결 작업** | `FEAT-CS-02` |
| **상세 구현 계획** | 1:1 문의 답변 등록 시 FCM 푸시 알림 연동 발송. 회원 정지/탈퇴 처리 및 개인정보 동의 이력 강제 열람 권한. |
| **DB 스키마** | `inquiries`, `users`, `user_consents` |
| **관리 정보** | 담당자: [미정] \| 상태: Todo \| 예상 공수(M/D): 3.0 |
