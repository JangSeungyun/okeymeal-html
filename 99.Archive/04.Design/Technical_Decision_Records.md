---
title: "[설계] OkeyMeal 기술 결정 정의서 (Technical Decision Records)"
version: v3.1.0
last_updated: 2026-05-06
author: 숭늉
---

# 🛠️ 기술 결정 정의서 (Technical Decision Records)

이 문서는 OkeyMeal 프로젝트의 핵심 기술 스택, 버전, 인프라 구성에 대한 의사결정 사항을 기록합니다. **본 문서는 2026년 5월 기준 최신 안정화 및 LTS 버전을 기준으로 작성되었으며, 설계 및 구현의 단일 진실 공급원(SSOT) 역할을 합니다.**

---

## 📌 0. 본 공모전 MVP 스코프 및 향후 확장 메모

본 공모전(2026)에서 구현할 범위와, 의도적으로 **제외**하되 향후 재검토할 항목을 명시합니다. 모든 기술 결정은 이 스코프를 전제로 합니다.

### 0.1 MVP 포함 범위
*   **사용자 앱 (웹 + Android):** 회원/Guest 인증, 식이 프로필, 식당 탐색·추천, AI 렌즈(메뉴판 OCR), 다국어(ko/en/ja/zh-CN), 리뷰 조회·작성.
*   **점주 콘솔 (별도 서브도메인):** `owner.okeymeal.kr`로 분리된 별도 SPA 서비스. 점주 가입, 메뉴 등록·수정, 리뷰 응대, 푸시 알림 수신.
*   **데이터 파이프라인:** 한국관광공사 TourAPI + 식약처 API 융합, 다국어 사전 번역, 임베딩 생성.

### 0.2 의도적 제외 항목 (Out of Scope)

| 항목 | 제외 사유 | 향후 재검토 |
|---|---|---|
| **자체 예약 시스템** | 공모전 기간(~2026-09-30) 내 안정성 확보 어려움. 자체 예약 시 결제·취소·노쇼·환불 로직 등 부가 복잡도 높음. PG 연동·법적 책임도 동반 | **Phase 2 (정식 출시 단계)** 검토. 1차 우회: 외부 예약 플랫폼 딥링크(Naver 예약/카카오 예약) 또는 식당 전화 연결 버튼 제공 가능 |
| **결제 시스템** | 자체 예약과 동시 검토 항목. 단독 결제 기능은 무의미하므로 예약 도입 시점에 함께 검토 | **Phase 2** — 예약 도입과 동시 |
| **AI 렌즈 - 음식 사진 식별** | 메뉴판 OCR(텍스트 인식 기반 알레르기 매칭)이 1차 핵심 기능. 음식 이미지 → 종류 식별은 멀티모달 정확도·도메인 학습 부담 큼 | **Phase 1.5** — MVP 안정화 후 시간 여유 시. Gemini Vision 기반 PoC 가능 |

### 0.3 점주 콘솔 분리 전략
*   **배포:** `owner.okeymeal.kr` 서브도메인. 단일 VM 내 별도 컨테이너로 동일 백엔드 API 사용.
*   **인증:** 일반 사용자와 별도 계정 도메인(`owner_account` 테이블), Refresh Token TTL 7일(일반 30일 대비 짧게).
*   **빌드:** 동일 `frontend/` 모노레포 내 별도 Vite 엔트리(`apps/owner/`)로 구성하여 90% 이상 컴포넌트 재사용.

---

## 1. 언어 및 프레임워크 (Languages & Frameworks)

### 1.1 백엔드 (Backend) - 하이브리드 전략 및 패키지 구조
코어 비즈니스 로직의 안정성과 AI/데이터 처리의 유연성을 위해 Java와 Python을 혼합한 하이브리드 아키텍처를 채택합니다.

| 항목 | 결정 사항 | 기술적 근거 |
|---|---|---|
| **코어 언어** | **Java 25 (LTS)** | 2025년 9월 출시된 최신 LTS 버전. **Structured Concurrency** 및 **Scoped Values**가 정식화되어 가상 스레드 기반 고성능 비동기 처리 최적화. |
| **코어 프레임워크** | **Spring Boot 4.0.x** | 2025년 11월 출시. Java 25 및 **Jakarta EE 11**을 기반으로 하며, 네이티브 AI 벡터 검색 지원 및 향상된 가상 스레드 최적화 제공. |
| **AI/데이터 언어** | **Python 3.13** | 2024년 10월 출시 안정 버전. 실험적 JIT 컴파일러 및 free-threaded 모드(GIL 제거 옵션)로 AI 워크로드 병렬 처리 효율 향상. LangChain, PyTorch 등 AI 생태계 최신 호환. |
| **데이터 API** | **FastAPI** | Python 기반 AI 모듈을 Spring Boot와 통신시키기 위한 경량 고성능 프레임워크. |

#### ■ Java (Spring Boot 4.0) - 멀티 모듈(Multi-module) 구조
비즈니스 로직의 재사용성과 모듈 간 결합도 제어를 위해 Gradle 멀티 모듈 구조를 적용합니다.

| 모듈명 | 역할 | 의존성 |
|---|---|---|
| **okeymeal-api** | 외부 노출 REST API 엔드포인트 및 컨트롤러 | core, infra, common |
| **okeymeal-core** | 핵심 비즈니스 로직, Service, Entity, Repository | common |
| **okeymeal-infra** | 외부 API 연동(LLM, Maps, FCM, Tour API) 어댑터 | common |
| **okeymeal-common** | 공통 Util, Exception, DTO, 전역 설정 | - |

```text
okeymeal-backend-java (Root)
├── okeymeal-api        # Controller, Security Config, Swagger
├── okeymeal-core       # Domain(User, Restaurant, etc.), Service, JpaRepository
├── okeymeal-infra      # External Clients (LLM, Maps, FCM, Tour)
└── okeymeal-common     # Shared Utils, Global Error Handler
```

#### ■ Python (FastAPI) - 서비스 중심 폴더 구조
```text
app/
├── main.py             # 애플리케이션 진입점 및 Middleware 설정
├── core/               # 핵심 설정 (Config, Security, Logging)
├── api/                # API 라우팅 (v1)
│   └── v1/             # 도메인별 엔드포인트 분리
├── services/           # 핵심 비즈니스 로직 (AI 추천 모델, 데이터 융합 파이프라인)
├── models/             # Pydantic Schemas & DB Models (SQLAlchemy 2.0+)
├── db/                 # Database Connection (PostgreSQL 연동)
└── scripts/            # 데이터 크롤링 및 배치 처리 스크립트
```

### 1.2 프론트엔드 (Frontend) - FSD 아키텍처
기능 단위 분리와 계층 간 의존성 규칙을 강제하는 **Feature-Sliced Design(FSD)**를 적용합니다.

| 항목 | 결정 사항 | 기술적 근거 |
|---|---|---|
| **런타임** | **Node.js 24 (Active LTS)** | 2026년 5월 기준 Active LTS. 최신 V8 엔진 및 내장 테스트 러너/`fetch` 안정화로 빌드·런타임 성능 확보. |
| **프레임워크** | **React 19.x** | Server Actions, `use` API, Document Metadata 등 정식화. Concurrent Rendering의 안정 단계. |
| **빌드 툴** | **Vite 7.x** | Rolldown 백엔드 및 ESM-only 안정화. 이전 6.x 대비 콜드 스타트·HMR 성능 개선. |
| **상태 관리** | **Zustand** | 가벼운 라이브러리로 FSD의 `entities` 레이어와 정합성이 높음. React 19의 Server Actions와 클라이언트 상태 분리에 적합. |
| **다국어** | **i18next + react-i18next** | 지원 언어 `ko`/`en`/`ja`/`zh-CN` 4종. 정적 UI 텍스트 + 백엔드 응답 코드(섹션 4.9 L2) 매핑 키 체계 통합. |

### 1.3 모바일 애플리케이션 (Mobile Application) - 하이브리드 전략 및 Capacitor 통합
웹 기술 기반으로 안드로이드/iOS 동시 지원이 **기술적으로 가능**하되, **본 공모전 범위는 안드로이드(Google Play) 정식 등록으로 한정**합니다. iOS 빌드는 후속 단계 옵션으로 둡니다. 모바일 앱은 별도 저장소를 생성하지 않고, 기존 **`frontend` 프로젝트 내에 Capacitor를 통합**하여 관리합니다.

#### ■ 모바일 구현 방식 비교 분석

| 비교 항목 | **PWA (TWA)** | **Capacitor (추천)** | **React Native / Flutter** |
| :--- | :--- | :--- | :--- |
| **방식** | 웹 사이트를 앱처럼 패키징 | **웹 결과물을 네이티브 쉘로 감쌈** | 네이티브 컴포넌트로 재작성 |
| **코드 재사용** | 100% (웹 소스 그대로) | **95% (일부 네이티브 플러그인)** | 50~70% (비즈니스 로직 위주) |
| **마켓 등록** | 가능 (TWA 이용 시) | **우수 (네이티브 앱과 동일)** | 우수 |
| **카메라/푸시 연동** | 웹 표준 범위 내 제한적 | **플러그인을 통한 완벽 지원** | 기본 지원 (성능 높음) |
| **공모전 적합성** | 매우 높음 (빠른 개발) | **매우 높음 (확장성/안정성)** | 낮음 (학습 곡선 및 시간 부족) |

#### ■ 기존 스택 영향도 분석 및 대응
*   **프로젝트 구조:** 별도 프로젝트 생성 없이 `frontend/` 폴더 루트에서 `npx cap init`을 수행합니다. 이는 웹 빌드 결과물(`dist/`)을 Android/iOS 네이티브 프로젝트로 변환하는 '래퍼(Wrapper)' 역할을 합니다.
*   **백엔드 영향:** 모바일 앱은 기존 웹과 동일한 REST API를 사용하므로 백엔드 코드 수정은 없습니다. 다만, 모바일 환경에서의 CORS 설정 및 인증 토큰 만료 정책(Refresh Token)을 더 견고히 관리합니다.
*   **프론트엔드 영향:** 95% 이상의 코드가 공유됩니다. 단, 네이티브 기능(카메라, 푸시)과 **보안 저장소** 접근 시 `shared/api` / `shared/storage` 레이어에서 '웹 환경'과 'Capacitor 환경'을 조건부 분기하여 처리합니다.

#### ■ 최종 결정: Capacitor (Ionic Ecosystem)
*   **결정 이유:** 현재 결정된 **React 19 / Vite 7** 웹 결과물을 그대로 활용하면서, 카메라(AI 렌즈)와 푸시 알림(점주 알림) 기능을 네이티브 수준으로 연동할 수 있는 가장 효율적인 대안입니다. 추후 iOS 대응 시 소스 수정 없이 빌드 타겟만 변경하면 됩니다.
*   **마켓 등록 전략 (Android):**
    1.  Capacitor Android 플랫폼 추가 (`npx cap add android`).
    2.  Android Studio를 통한 App Bundle(`aab`) 생성.
    3.  Google Play Console을 통한 안드로이드 앱 정식 등록.

### 1.4 서비스 간 통신 규약 (Inter-service Communication)
Java(Core)와 Python(AI) 서버 간의 데이터 교환 방식입니다.

| 비교 항목 | **REST API (HTTP/1.1)** | **gRPC (HTTP/2)** |
| :--- | :--- | :--- |
| **개발 속도** | 매우 빠름 (익숙함) | 중간 (IDL 정의 필요) |
| **성능** | 보통 (JSON 오버헤드) | 매우 높음 (Binary 기반) |
| **타입 안전성** | 낮음 (별도 검증 필요) | 매우 높음 (Protobuf) |
| **추천 여부** | **MVP 단계 추천 (FastAPI 궁합)** | 대규모 트래픽/복잡한 스키마 시 |

*   **최종 결정: REST API (JSON)**
    *   **결정 이유:** 초기 개발 속도와 FastAPI의 자동 문서화 기능을 활용하기 위해 REST 방식을 채택합니다.
    *   **보안 전략 (계층적 적용):**
        1. **L1 - 네트워크 격리:** 단일 VM 내 Docker 내부 네트워크(`okeymeal-internal`)로만 통신, 외부 포트 비노출.
        2. **L2 - 인증:** 모든 내부 호출에 `X-Internal-Api-Key` 헤더 강제. Key는 `git-crypt` 및 GitHub Actions Secrets로 관리.
        3. **L3 - 무결성:** 요청 본문에 HMAC-SHA256 서명 부착(`X-Signature`).
    *   **mTLS 전환 트리거:** 다음 중 하나라도 충족 시 mTLS로 격상.
        - VM 분리(Java/Python 노드 분할) 또는 Kubernetes 멀티 노드 전환 시
        - 외부 협력사(예: 식당 POS)와의 직접 연동 시점
        - 의료/결제 등 추가 민감 정보 처리 시작 시점

#### ■ 안정성 정책 (Resilience4j 적용)
Python 모듈 장애가 Java 전체로 전파되지 않도록 다층 회복 패턴을 적용합니다.

| 패턴 | 정책 | 사유 |
| :--- | :--- | :--- |
| **Timeout** | Connect 1s / Read 3s (실시간 추천), Read 30s (Batch 번역) | 워크로드별 분리, 사용자 체감 지연 방지 |
| **Retry** | 지수 백오프 (200ms → 400ms → 800ms, 최대 3회), 5xx·`IOException`만 재시도 | 4xx·요청 오류는 재시도 무의미 |
| **Circuit Breaker** | 슬라이딩 윈도우 50건 중 50% 실패 시 OPEN, 30s HALF_OPEN | 폭주 방지, 자동 회복 |
| **Bulkhead** | 추천 호출 동시 50건, 사전 번역 5건 분리 풀 | 한 워크로드 폭주가 다른 워크로드 영향 차단 |
| **Fallback** | OPEN 시 Valkey 캐시된 인기 메뉴 추천 반환 + "추천 시스템 일시 점검 중" 안내 | 완전 다운보다 부분 기능 제공 |
| **DLQ** | 비동기 작업(번역·임베딩) 최종 실패 시 Valkey Streams `stream:llm:dlq` 적재, 30분 간격 워커가 재처리 | 데이터 손실 방지 |

### 1.5 AI 모델(LLM) 전략 - 후보 비교 (의사결정 진행 중)
OkeyMeal의 AI 기능별 워크로드 특성이 상이하므로 단일 모델이 아닌 **워크로드별 최적 모델 매칭** 전략을 검토 중입니다. 본 절은 결정 전 비교표이며, PoC 결과에 따라 후속 버전에서 확정합니다.

#### ■ AI 워크로드 분류

| 워크로드 | 특성 | 요구 능력 |
| :--- | :--- | :--- |
| **W1. 메뉴 추천 설명문 생성** | 사용자별 동적, 짧은 출력 | 다국어 자연성, 빠른 응답, 비용 효율 |
| **W2. 데이터 사전 번역(Batch)** | 대량(수만 건), 비실시간 | 비용 최우선, 번역 일관성 |
| **W3. AI 렌즈 메뉴 인식(Vision)** | 이미지 + OCR + 식별 | 멀티모달 정확도, 한식 도메인 이해 |
| **W4. 리뷰 요약·감정 분석** | 중간 분량, 비실시간 | 추론 능력, 비용 효율 |

#### ■ 후보 서비스 비교 (2026년 5월 기준 공개 정보)

| 비교 항목 | **Google Gemini** | **Anthropic Claude** | **OpenAI GPT** |
| :--- | :--- | :--- | :--- |
| **대표 모델군** | Gemini 2.5 Pro / Flash / Flash-Lite | Claude Opus 4.x / Sonnet 4.x / Haiku 4.x | GPT-5 / GPT-5 mini / GPT-5 nano |
| **멀티모달(Vision)** | ✅ 네이티브, 강력 | ✅ 우수 | ✅ 우수 |
| **한국어 품질** | 매우 높음 | 매우 높음 | 매우 높음 |
| **컨텍스트 윈도우** | 1M~2M | 200K~1M | 400K |
| **응답 속도(경량 모델)** | 매우 빠름 (Flash-Lite) | 빠름 (Haiku) | 빠름 (mini/nano) |
| **상대 비용 (경량)** | ⭐ 매우 낮음 | 낮음 | 낮음 |
| **상대 비용 (최상위)** | 중간 | 높음 | 중간 |
| **무료/할인 티어** | AI Studio 무료 + GCP 학생/공익 크레딧 | Console 신규 크레딧 | 제한적 (API 크레딧) |
| **국내 데이터 잔존성** | GCP 한국 리전 가능 | AWS Bedrock 통한 한국 리전 | Azure OpenAI 통한 한국 리전 |
| **Batch API** | ✅ (50% 할인) | ✅ (50% 할인) | ✅ (50% 할인) |
| **공모전 적합도** | ⭐⭐⭐⭐⭐ (무료 티어 관대) | ⭐⭐⭐⭐ (품질 최우선) | ⭐⭐⭐⭐ (생태계) |

#### ■ 워크로드별 1차 후보 매핑 (예비, PoC 후 확정)

| 워크로드 | 1차 후보 | 폴백 후보 | 선정 가설 |
| :--- | :--- | :--- | :--- |
| **W1 추천 설명** | Gemini 2.5 Flash | Claude Haiku 4.x | 빠른 응답, 비용 효율, 다국어 동시 출력 |
| **W2 사전 번역(Batch)** | Gemini 2.5 Flash-Lite | GPT-5 mini | Batch API + 경량 모델 단가 우위 |
| **W3 AI 렌즈** | Gemini 2.5 Pro | Claude Sonnet 4.x | Vision 정확도, 한식 메뉴 인식 |
| **W4 리뷰 요약** | Claude Haiku 4.x | Gemini 2.5 Flash | 자연스러운 톤, 감정 분석 강점 |

#### ■ 비용·운영 통제 정책 (공통)
| 정책 | 내용 |
| :--- | :--- |
| **월간 토큰 상한** | 환경변수 `LLM_MONTHLY_TOKEN_BUDGET` 기반 하드 캡. 80% 도달 시 Discord 알림, 100% 도달 시 자동 차단 |
| **요청별 max_tokens** | 추천 설명 512, 번역 입력 길이×1.5, 리뷰 요약 256 |
| **결과 캐시** | 동일 입력 해시 → Valkey 7일 캐시 (`cache:llm:{model}:{hash}`) |
| **자동 폴백** | Primary 모델 5xx/Timeout 3회 연속 → Fallback 모델 자동 전환 (Resilience4j) |
| **PII 차단** | LLM 입력 직전 이메일·전화번호·주소 마스킹 인터셉터 강제 적용 |

#### ■ 결정 마일스톤
*   **PoC 단계:** 워크로드별 100건 샘플 비교 (응답 품질·지연·비용 3축).
*   **결정 시점:** 본 문서 후속 마이너 버전에서 Primary 모델군 확정 예정.

#### ■ AI 추천 알고리즘 아키텍처

##### ▸ 임베딩 전략 (Embedding)

| 임베딩 주체 | 입력 데이터 | 차원 | 갱신 주기 |
| :--- | :--- | :--- | :--- |
| **User Embedding** | 식이 프로필(알레르기·종교·선호) + 좋아요·방문 이력 + 검색 히스토리 | 768 | 프로필 변경 즉시 + 일 1회 배치 |
| **Restaurant Embedding** | 카테고리 + 대표 메뉴 + 위치 + 알레르기 친화 점수 + 평점 | 768 | 식당 정보 변경 시 + 주 1회 배치 |
| **Menu Embedding** | 메뉴명 + 식재료 + 알레르기 ISO 태그 + 조리법 + 가격대 | 768 | 메뉴 변경 시 + 일 1회 배치 |

*   **임베딩 모델 (1차 후보):** Gemini `text-embedding-004` (768d, 다국어 지원, 무료 티어 풍부). 폴백: OpenAI `text-embedding-3-small` (1536d → 768d 차원 축소 옵션).
*   **저장:** PostgreSQL pgvector 컬럼(`vector(768)`). HNSW 인덱스로 ANN 검색 가속.
*   **다국어 처리:** 동일 의미의 한·영·일·중 입력은 모두 동일 임베딩 공간에 매핑 (Gemini 다국어 임베딩 특성). 별도 언어별 인덱스 불필요.

##### ▸ 유사도 측정: 코사인 유사도(Cosine Similarity)
*   **선정 이유:** 임베딩 벡터의 방향성이 의미를 담음(L2 norm 영향 배제). 텍스트 임베딩 표준이며 pgvector 네이티브 지원.
*   **연산:** `1 - (vec_a <=> vec_b)` (pgvector `<=>` 연산자는 cosine distance 반환).
*   **L2 / Inner Product 미채택:** L2는 벡터 크기 영향을 받아 정규화가 별도 필요, Inner Product는 임베딩 정규화 가정이 깨지면 불안정. 운영 단순화 위해 코사인 일원화.

##### ▸ Cold-start 처리 (가입 직후 추천)

| 단계 | 전략 |
| :--- | :--- |
| **0순위 (게이트)** | 식이 프로필 미입력 시 **온보딩 강제**: 알레르기·식이 제한·종교 입력 (1분 이내 완료, ISO 코드 기반 체크박스) |
| **1순위 (개인화)** | 식이 프로필 임베딩 ↔ Restaurant Embedding 코사인 유사도 Top-N |
| **2순위 (지역 인기)** | 위치 기반 인기 메뉴 (해당 시군구 방문수·찜수 상위) |
| **3순위 (다양성)** | MMR(Maximal Marginal Relevance) 적용, λ=0.7로 유사도와 다양성 균형 |
| **폴백** | 위 모두 실패 시 카테고리별 베스트 셀러 (정적 큐레이션) |

##### ▸ 컨텍스트 재정렬 (Re-ranking)
1차 임베딩 검색 결과(Top-K, K=50)에 다음 가중치를 곱하여 최종 순위(Top-N, N=10) 결정:

| 컨텍스트 | 가중치 적용 방식 |
| :--- | :--- |
| **거리** | 500m 이내 1.0배, 1km 0.85배, 3km 0.6배 (지수 감쇠) — 도보 접근성 반영 |
| **시간대** | 아침(06~10): 죽·해장 가산 / 점심(11~14): 일반식 / 저녁(17~21): 디너 / 야간(22~02): 야식 |
| **날씨** | 추운 날(< 5℃): 따뜻한 국·찌개 가산 / 더운 날(> 28℃): 냉면·시원한 음식 / 우천: 실내·배달 가능 가산 |
| **운영 상태** | 영업 중 1.0 / 브레이크 타임 0.5 / 영업 종료 0.0 |
| **개인 이력** | 최근 7일 방문 식당 ×0.7 (다양성 유도) / 좋아요 카테고리 ×1.2 |

*   **최종 점수:** `final = cosine_sim × dist_w × time_w × weather_w × open_w × personal_w`
*   **재정렬 위치:** Python `services/recommendation/reranker.py`에서 1차 검색(pgvector) 후 적용.
*   **날씨 데이터:** 기상청 단기예보 API 연동, 30분 캐시.

##### ▸ RAG (Retrieval-Augmented Generation) - 추천 설명문 생성

| 단계 | 내용 |
| :--- | :--- |
| **1. Retrieval** | pgvector로 사용자 프로필 임베딩과 식당 Top-K(K=50) 검색 |
| **2. Re-rank** | 컨텍스트 재정렬 적용 후 Top-3 선별 |
| **3. Augmentation** | Top-3 식당 정보(메뉴·알레르기·운영시간·평점) + 사용자 식이 프로필을 LLM 프롬프트 컨텍스트로 주입 |
| **4. Generation** | LLM(W1: Gemini Flash)이 사용자 locale로 추천 설명문 생성. 예: "이 식당은 채식 옵션이 풍부하며, 비빔밥은 견과류를 사용하지 않아 안심하고 드실 수 있습니다." |
| **5. Cache** | `cache:reco:{userId}:v{profileVersion}:{locale}` Valkey 캐시 6시간 (4.6절 무효화 정책 적용) |

*   **Hallucination 방지:**
    *   프롬프트 시스템 메시지에 "주어진 컨텍스트 외 정보 추론 금지" 명시.
    *   응답 후 식당명·메뉴명을 원본 데이터와 대조 검증 (불일치 시 응답 폐기 후 재생성 1회).
    *   알레르기 정보는 LLM 생성문에 의존하지 않고 ISO 코드 기반 룰엔진 결과를 우선 표시.
*   **Fine-tuning 미채택 사유:** 학습 데이터셋 부족, 비용·운영 부담 高. RAG로 도메인 적합성 충분히 확보 가능.

##### ▸ 평가 지표 (Recommendation Quality KPI)
*   **Precision@10:** 사용자가 클릭/방문한 비율 (목표: ≥ 0.30)
*   **Diversity@10:** Top-10 결과의 카테고리 다양성 점수 (목표: ≥ 0.60)
*   **Cold-start 만족도:** 신규 가입자 첫 7일 추천 클릭률 (목표: ≥ 0.20)
*   **Latency p95:** 추천 API p95 응답 (목표: ≤ 800ms)
*   **A/B 테스트 인프라:** 4.12절 분석 도구로 추천 알고리즘 변경 시 효과 측정.

### 1.6 지도 API 전략 - 멀티 프로바이더
'내 주변 안심 식당 지도 탐색'은 OkeyMeal의 핵심 기능이며, 인바운드 관광객 대상 특성상 지역·언어별 지도 서비스 강점이 달라 **멀티 프로바이더** 전략을 채택합니다.

#### ■ 프로바이더별 비교

| 항목 | **Google Maps (Main)** | **Naver Map** | **Kakao Map** |
| :--- | :--- | :--- | :--- |
| **글로벌 인지도** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| **한국 POI 정확도** | 보통 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **다국어 라벨** | ⭐⭐⭐⭐⭐ (자동) | ⭐⭐⭐ (영문 일부) | ⭐⭐⭐ (영문 일부) |
| **길찾기(대중교통)** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ (국내) | ⭐⭐⭐⭐⭐ (국내) |
| **무료 한도** | 월 $200 크레딧 | 일 25만 회 | 일 30만 회 |
| **주요 사용층** | 인바운드 관광객 | 국내 거주 외국인 | 국내 사용자 |

#### ■ 역할 분담 (Main: Google Maps)

| 기능 | 사용 프로바이더 | 사유 |
| :--- | :--- | :--- |
| **메인 지도·POI 표시** | **Google Maps** | 인바운드 관광객 친숙도, 다국어 라벨 자동화 |
| **국내 주소 검색·자동완성** | **Kakao Map (Geocoding API)** | 한국 주소 정확도 우수, 무료 한도 큼 |
| **대중교통 길찾기 (한국 내)** | **Naver Directions API** | 지하철/버스 데이터 정밀도 |
| **좌표 보정·역지오코딩 폴백** | Kakao → Naver → Google | 국내 우선, 외국 API 폴백 |

#### ■ 추상화 및 운영
*   **`okeymeal-infra` 모듈에 `MapClient` 인터페이스 정의.** 프로바이더별 어댑터(`GoogleMapAdapter`, `KakaoMapAdapter`, `NaverMapAdapter`) 구현. 사용 측 코드는 인터페이스만 의존.
*   **API Key 관리:** 각 프로바이더 키는 `git-crypt`. 프론트 노출 키(Google Maps JS API)는 도메인·Referer 화이트리스트 필수. 서버측 키는 백엔드에서만 호출.
*   **할당량 모니터링:** 사용량을 Prometheus 메트릭(`map_api_call_total{provider}`)으로 수집, 일 한도 80% 도달 시 Discord 알림. Google Maps는 GCP Budget Alert로 월 $150 도달 시 통지.

### 1.7 푸시 알림 인프라 (Push Notification)
점주 알림(예약·문의·리뷰) 및 사용자 알림(추천·이벤트)을 다국어로 송출합니다.

#### ■ 게이트웨이 비교

| 비교 항목 | **FCM 단일 (추천)** | **FCM + APNs 직접** | **OneSignal/AWS SNS** |
| :--- | :--- | :--- | :--- |
| **Android** | ✅ 네이티브 | ✅ | ✅ (FCM 경유) |
| **iOS** | ✅ APNs 자동 중계 | ✅ 직접 제어 | ✅ |
| **웹 푸시** | ✅ Service Worker | ❌ | ✅ |
| **무료 한도** | 무제한 | 무제한 | 제한적 |
| **운영 복잡도** | 낮음 | 높음 (인증서 별도) | 중간 |

*   **결정:** **FCM Cloud Messaging API(v1)**. iOS는 FCM이 APNs로 자동 라우팅하므로 인증서 관리 1회로 Android·iOS·Web 단일 SDK 운영.

#### ■ 구독 모델 (Topic + Token)

| 채널 | 구독 방식 | 예시 |
| :--- | :--- | :--- |
| **개인 알림** | Device Token 직접 송신 | 예약 확정, 1:1 회신 |
| **점주 그룹** | Topic 구독 (`owner_{restaurantId}`) | 신규 리뷰, 입점 공지 |
| **지역 이벤트** | Topic 구독 (`region_{sigunguCode}_{locale}`) | 지역별 다국어 이벤트 |
| **마케팅 동의자** | Topic 구독 (`marketing_{locale}`) | 동의자 한정 다국어 푸시 |

#### ■ 다국어 메시지 송출
*   **저장 형식:** 알림 템플릿은 4.9절 i18next `notification` 네임스페이스를 백엔드도 공유. Backend는 i18n 키 + 변수만 가지고 사용자 `preferredLocale` 기반으로 메시지 빌드.
*   **송신 방식:** Topic은 locale별로 분리된 토픽으로 송신, 1:1 알림은 사용자 locale에 맞춰 즉시 빌드.

#### ■ 권한·정책·운영
| 항목 | 정책 |
| :--- | :--- |
| **마케팅 동의 관리** | `UserPushPreference` 테이블로 토픽 구독 상태 관리, 동의 철회 시 즉시 unsubscribe |
| **조용 시간(Quiet Hours)** | 22:00~08:00 KST 기본 적용. 긴급 알림(예약 취소 등)은 예외 |
| **무효 토큰 정리** | FCM 응답 `NOT_REGISTERED`/`INVALID_REGISTRATION` 즉시 DB 삭제 |
| **점주/일반 격리** | 점주는 `owner_*` 토픽으로 분리, Refresh Token TTL도 일반 사용자(30일)보다 짧게(7일) 적용 |
| **송신 속도 제한** | FCM 자체 제한(분당 1M 메시지) 내 운영, 대량 송신은 Spring Batch 사용 |

---

## 2. 데이터베이스 (DBMS) 비교 분석 및 결정

### 2.1 DBMS 비교 분석

| 비교 항목 | **PostgreSQL (PostGIS + pgvector)** | **MariaDB (Native Vector)** |
| :--- | :--- | :--- |
| **GIS 성능** | ⭐⭐⭐⭐⭐ (600+ 공간 함수, 3D 지원) | ⭐⭐ (기본 위경도 반경 검색 수준) |
| **JSON 처리** | ⭐⭐⭐⭐⭐ (이진 `JSONB`, 강력한 인덱싱) | ⭐⭐⭐ (텍스트 기반 `JSON` Alias 처리) |
| **AI 벡터 검색** | ⭐⭐⭐⭐ (pgvectorscale 등 에코시스템 방대) | ⭐⭐⭐⭐⭐ (2026년 기준 높은 QPS 성능) |
| **종합 평가** | **데이터 융합 및 정밀 위치 추천에 최적** | 단순 로그성 및 빠른 벡터 검색 위주 적합 |

### 2.2 최종 결정: PostgreSQL 18
*   **결정 이유:** 2025년 9월 출시된 최신 안정 버전. 비동기 I/O 개선, B-Tree skip scan, OAuth2 인증 지원 등 운영 효율 향상. PostGIS 3.5+, pgvector 0.8+ 호환.
*   **확장 라이브러리:** `PostGIS` (공간), `pgvector` / `pgvectorscale` (AI 추천 엔진용).
*   **'내 주변 안심 식당 지도 탐색'을 위한 PostGIS의 공간 연산 능력**과 관광공사/식약처 API의 복잡한 JSON 데이터를 성능 저하 없이 처리하기 위한 **JSONB**가 필수.

### 2.3 DB 스키마 형상 관리 (Migration Tool)
멀티 모듈 및 하이브리드 백엔드 환경에서의 DB 정합성을 위해 **Flyway**를 도입합니다.
*   **관리 주체:** **`okeymeal-core` 모듈 단독 관리**. JPA Entity와 마이그레이션 스크립트의 위치를 일치시켜 SSOT를 보장합니다. Python 측은 동일 스키마를 SQLAlchemy 리플렉션으로 참조하며 마이그레이션 작성 권한을 갖지 않습니다.
*   **명명 규칙:** `V{YYYYMMDD}{NN}__{snake_case_description}.sql` (예: `V2026050601__init_user_table.sql`).
    *   날짜 기반 prefix로 멀티 개발자 환경에서 PR 머지 순서 의존 충돌 회피.
    *   동일 일자 다중 마이그레이션은 `NN` 시퀀스(01~99)로 구분.
*   **운영 정책:** `flyway.outOfOrder=false` 강제. 누락된 마이그레이션 발견 시 배포 중단.
*   **롤백 전략:** Flyway는 자동 롤백 미지원 → **수동 보상 마이그레이션(`U{버전}__rollback_*.sql`)**을 별도 폴더에 작성, 운영 적용 시 DBA 승인 필수.
*   **수리(repair):** Checksum 불일치 또는 중단 발생 시 `flyway repair` 후 재시도. 절차서: `runbooks/flyway-recovery.md`.

### 2.4 캐시 및 세션 스토어 (Cache & Session Store)
JWT Refresh Token 회전, AI 추천 결과 캐싱, 실시간 알림 큐 등 다용도 인메모리 저장소가 필요합니다.

#### ■ Redis 라이선스 검토 및 대안 비교

| 항목 | **Redis 7.4+** | **Valkey 8.x (추천)** | **KeyDB** |
| :--- | :--- | :--- | :--- |
| **라이선스** | RSALv2/SSPL (상용 제약 있음) | **BSD-3 (완전 자유, 무료)** | BSD-3 |
| **Redis 호환** | 100% | 100% (Redis 7.2 fork) | 99% |
| **운영 주체** | Redis Inc. | Linux Foundation | Snapcraft (활동 둔화) |
| **클라이언트 SDK** | 풍부 | Redis 호환 SDK 그대로 사용 | 호환 |
| **공모전 적합** | 라이선스 검토 필요 | **완전 무료, 권장** | 운영 리스크 |

*   **최종 결정: Valkey 8.x**
    *   **이유:** Linux Foundation 관리, BSD-3 라이선스로 상용 사용 제약 없음(완전 무료). Redis 7.2 fork 기반으로 기존 SDK·키 네임스페이스·운영 명령 100% 호환.
    *   **호환성 표기:** 본 문서에서 일부 'Redis' 용어가 등장해도 Valkey와 동의어로 취급(API 호환성 확보).
    *   **용도별 키 네임스페이스:** `auth:refresh:{userId}`, `cache:reco:{userId}:v{profileVersion}:{ctx}`, `cache:llm:{model}:{hash}`, `queue:notify:owner`, `i18n:review:{reviewId}:{locale}` (TTL 7일), `stream:llm:dlq`, `stream:ingest:dlq` 등.
    *   **운영 정책:** AOF `everysec`, maxmemory `allkeys-lru`. Docker 볼륨으로 영속성 확보.
    *   **확장 트리거:** QPS 5k 초과 또는 데이터 1GB 초과 시 Valkey Cluster 도입 검토.

### 2.5 백업 및 복구 전략 (Backup & DR)
*   **일일 백업:** `pg_basebackup` 기반 풀 백업, 매일 03:00 KST 실행.
*   **PITR(Point-in-Time Recovery):** WAL 아카이빙(`archive_mode=on`, `archive_timeout=60s`)으로 최대 7일 복구 지원. **트래픽 적은 시간대에도 RPO 1분 보장** (16MB WAL이 차지 않아도 60초마다 강제 아카이브).
*   **백업 보관:** 1단계는 별도 파티션(`/data/okeymeal/backup`), 2단계는 GCS Coldline 30일 보관.
*   **K-PIPA 정합성:** 회원 탈퇴 시 백업본에서도 5일 내 개인 식별 데이터 삭제(논리 삭제 마커 기반 자동 스크립트).
*   **복구 훈련:** 분기 1회 스테이징 환경에서 복구 리허설 및 RTO/RPO 측정(목표: RTO 30분, RPO 1분).

---

## 3. 서버 인프라 및 보안 (Infrastructure & Security)

### 3.1 서버 설정 (Single VM 전략)
초기 개발 및 소규모 운영의 효율성을 위해 단일 가상 머신(VM) 기반의 컨테이너 환경을 구축합니다.

*   **OS:** Ubuntu 24.04 LTS
*   **계정 및 보안:**
    *   `root` 로그인 차단 및 `deploy` 전용 계정 사용.
    *   SSH Key 기반 인증 강제 (비밀번호 로그인 금지).
    *   UFW 방화벽: 22(SSH), 80(HTTP), 443(HTTPS)만 개방.
    *   `fail2ban`으로 SSH 무차별 대입 차단.
*   **권장 사양 (실제 결정은 추후, 참고용):**
    *   **최소:** 4 vCPU / 16 GB RAM / 200 GB SSD — PostgreSQL+Valkey+Java+Python+Loki+Prometheus+Nginx 동시 가동 가능 최소선.
    *   **권장:** 8 vCPU / 32 GB RAM / 500 GB SSD — 시연 트래픽 + 부하 테스트 여유.
    *   **클라우드 후보 (사양 참고):** GCP `e2-standard-8`, AWS `m6i.xlarge`/`m7i.2xlarge`, NCP `g2-server-h64s`.
    *   **확장 트리거:** CPU 70% 5분 지속, 메모리 80% 도달, 또는 디스크 80% 도달 시 수직 확장 우선 검토.
*   **파일시스템 및 파티션:**
    *   `/` (Root): OS 및 시스템 (20GB+, ext4)
    *   `/var/lib/docker`: Docker 이미지 및 런타임 (별도 파티션 추천)
    *   `/data/okeymeal`: DB 볼륨, 로그, 업로드 데이터 (ext4, 데이터 보존용)
    *   `/data/okeymeal/backup`: 일일 백업 보관 (ext4)

### 3.2 환경 분리 전략 (Environment Separation)
초기 인프라 제약을 감안해 **1단계 논리적 분리**, **2단계 물리적 분리**의 점진적 전략을 채택합니다.

#### ■ 1단계 (초기·공모전): 논리적 분리

| 환경 | 용도 | 분리 방식 | 시크릿 출처 |
| :--- | :--- | :--- | :--- |
| **dev (local)** | 개발자 PC | Docker Compose | `.env.dev` (git-crypt) |
| **staging** | QA·시연 리허설 | 동일 VM 내 별도 Docker network + 별도 포트(`8090`) + 별도 서브도메인(`stg.okeymeal.kr`) + 별도 DB schema | GitHub Actions Secrets |
| **prod** | 운영·심사 시연 | 동일 VM Blue/Green 슬롯 + 메인 도메인(`okeymeal.kr`) | GitHub Actions Secrets |

*   **분리 보장:**
    *   **네트워크:** `okeymeal-stg-net` / `okeymeal-prod-net` Docker network 분리, inter-network 통신 차단.
    *   **DB:** 동일 PostgreSQL 인스턴스 내 `okeymeal_stg` / `okeymeal_prod` 데이터베이스 분리, 각 데이터베이스 전용 계정.
    *   **파일:** 호스트 마운트 경로 분리 (`/data/okeymeal/{env}/`).
    *   **모니터링:** 메트릭에 `env` 라벨 강제 부착, Loki 스트림 분리.

#### ■ 2단계 (인프라 확충 후): 물리적 분리
*   별도 VM 또는 Kubernetes 네임스페이스로 staging/prod 전환.
*   **전환 트리거:** 동시 사용자 1k 도달, 외부 협력사 연동 시작, 또는 결제·의료 등 추가 민감 정보 처리 시작.

*   **설정 분리:** Spring Profile(`application-{env}.yml`), FastAPI(`Settings` Pydantic + `ENV`), Vite(`.env.{mode}`).
*   **데이터 격리:** prod 데이터는 staging으로 절대 직접 복제 불가. 마스킹 스크립트를 거친 합성 데이터만 사용.

### 3.3 파일 저장소 전략 (Object Storage Strategy)
*   **1단계 (초기):** 서버 내 별도 파티션(`/data/okeymeal/uploads`)을 할당하여 로컬 파일 시스템에서 직접 관리. Docker 볼륨 마운트를 통해 컨테이너 간 공유.
*   **2단계 (확장):** 트래픽 증가 및 서비스 안정화 단계에서 **Google Cloud Storage (GCS)** 혹은 AWS S3로 이전. 추후 마이그레이션이 용이하도록 파일 업로드 로직은 인터페이스(`StorageClient`)로 추상화하여 구현.
*   **CDN 전략:**
    *   **1단계:** Nginx 정적 자원 캐시(`expires 30d`) + Brotli 압축.
    *   **2단계:** GCS 전환과 동시에 Cloud CDN(또는 CloudFront) 결합. 이미지 변환은 GCS + `imgproxy` 사이드카로 처리.

#### ■ 업로드 파일 검증 정책 (AI 렌즈 입력 포함)

| 항목 | 정책 |
| :--- | :--- |
| **허용 MIME 타입** | `image/jpeg`, `image/png`, `image/webp`, `image/heic` (그 외 거부) |
| **매직 넘버 검증** | Apache Tika(Java) / `python-magic` (Python)으로 파일 헤더 바이트 검증 — 확장자·MIME 위변조 차단 |
| **최대 크기** | 단일 파일 10MB, 총 요청 50MB |
| **이미지 제약** | 가로·세로 ≤ 8000px, EXIF 메타데이터 자동 제거 (위치·기기 정보 유출 방지) |
| **악성코드 스캔** | ClamAV 사이드카 컨테이너 + `clamd` TCP 인터페이스로 비동기 스캔, 감염 시 즉시 격리·알림 |
| **저장 경로** | 사용자 입력 파일명 사용 금지, **UUID v7 + 확장자**로 재명명 (시간순 정렬 + 충돌 방지) |
| **AI 렌즈 입력** | 동일 검증 통과 후 Python 서버로 전달, 처리 후 30분 내 자동 삭제 (개인정보 최소 보관) |
| **Rate Limit** | 사용자당 업로드 분당 10회, 일 100회 (3.5절 L3와 정합) |

### 3.4 시크릿 관리 및 보안 정책 (Secret Management & Compliance)
`.env` 파일 유출 방지 및 개인정보보호법(K-PIPA) 준수를 위한 전략입니다.

#### ■ 데이터 보안 및 컴플라이언스
| 항목 | 적용 내용 | 비고 |
|---|---|---|
| **암호화 (저장)** | 알레르기/식이 프로필 등 민감 정보 DB 컬럼 암호화 | AES-256-GCM (Spring Security Crypto) |
| **암호화 (전송)** | 외부 트래픽 TLS 1.3 강제, 내부 통신 HMAC 서명 | Nginx + Let's Encrypt |
| **데이터 파기** | 탈퇴 시 즉시 파기, 백업 데이터 5일 내 삭제 | 로그 내 개인 식별 정보 포함 금지 |
| **법적 동의** | 서비스 이용약관, 개인정보 수집/이용 동의, 위치정보 이용 동의 | 회원가입/Guest 진입 시 필수 |
| **시크릿 관리** | **`git-crypt`** + **GitHub Actions Secrets** | 로컬 커밋 시 자동 암호화 |
| **로그 마스킹** | 이메일·전화번호·주소·토큰 자동 마스킹 필터 | Java/Python 공통 로깅 인터셉터 |

#### ■ 개인정보 제공 동의 필수 항목
*   [필수] 서비스 이용약관 및 개인정보 처리방침
*   [필수] 식이 제한 사항(알레르기, 종교적 신념 등) 수집 및 이용 동의
*   [필수] 만 14세 미만의 경우 법정대리인 동의
*   [선택] 맞춤형 식당 추천을 위한 위치정보 이용 동의
*   [선택] 이벤트 및 혜택 알림 수신 동의 (Push)
*   [선택] 개인정보 국외 이전 동의 (LLM API 제공자 소재국, CDN)

#### ■ K-PIPA 추가 준수 사항
| 항목 | 정책 |
| :--- | :--- |
| **만 14세 미만** | 가입 시 생년월일 입력 → 14세 미만은 법정대리인 동의 절차로 분기. 미동의 시 가입 차단. 14세 미만 식별 정보는 별도 분리 보관 |
| **정보주체 권리 응답 SLA** | 열람·정정·삭제·처리정지 요청 시 **10일 이내** 처리 (개인정보보호법 시행령 제46조). 처리 결과는 동일 채널로 회신, 처리 이력은 1년 보관 |
| **개인정보 처리방침** | `/privacy` 경로에 상시 게시, 변경 시 **최소 7일 사전 고지** + 푸시·이메일 통지. 변경 이력 영구 보관 |
| **개인정보 보호책임자(DPO)** | 운영 시작 전 지정 및 처리방침에 연락처(이메일·전화) 명시 |
| **국외 이전 고지** | LLM API(미국)·CDN 사용 시 이전 국가·항목·기간을 명시하고 별도 동의 받음 |
| **자동화 의사결정** | AI 추천이 사용자 의사결정에 영향을 미치는 경우 의의 제기 채널 제공 (`/contact/ai-decision`) |
| **접근권한 통제** | 운영자 콘솔 접근 시 IP 화이트리스트 + 2FA 강제, 접근 로그 1년 보관 (4.1절 감사 로그 정합) |
| **개인정보 안전성 확보 조치** | 분기 1회 자체 점검, 연 1회 외부 보안 점검(예산 확보 시) |

### 3.5 Rate Limiting 및 남용 방지 (Abuse Protection)
공모전 시연 중 부하 사고 및 자동화 공격을 방지하기 위한 다층 방어 전략입니다.

| 계층 | 적용 위치 | 정책 |
| :--- | :--- | :--- |
| **L1 - Edge** | Nginx `limit_req_zone` | IP당 60req/min, burst 30 |
| **L2 - 인증 API** | Spring Cloud Gateway / 인터셉터 | 로그인 시도 IP·계정당 5req/min, 5회 실패 시 15분 잠금 |
| **L3 - 비용 API** | AI 추천(LLM 호출) | 사용자당 30req/hour, Valkey 토큰 버킷 |
| **L4 - 업로드** | 업로드 엔드포인트 | 사용자당 분당 10회, 일 100회 |
| **L5 - WAF (2단계)** | Cloudflare 또는 GCP Armor | OWASP Core Rule Set |

*   **차단 응답:** `429 Too Many Requests` + `Retry-After` 헤더, 다국어 에러 코드(`ERR_RATE_LIMIT`).
*   **CAPTCHA 폴백:** 정상 사용자가 차단된 경우 hCaptcha 통과 시 재허용.

---

## 4. 운영 및 품질 관리 전략 (Operational Strategy)

### 4.1 통합 로깅 전략 (Logging Strategy)
단일 서버 내 여러 스택(Java, Python, Nginx)의 로그를 통합 관리합니다.

| 항목 | **Local File (Tail)** | **Grafana Loki (추천)** | **ELK Stack** |
| :--- | :--- | :--- | :--- |
| **리소스 사용** | 매우 낮음 | **낮음 (인덱싱 최소화)** | 높음 (JVM 기반) |
| **검색 능력** | Grep 의존 (불편) | **LogQL 기반 강력한 검색** | Lucene 기반 고성능 검색 |
| **시각화** | 없음 | **Grafana 연동 우수** | Kibana 전용 UI |
*   **결정:** **Grafana Loki + Promtail**. 단일 VM에서 리소스 부담 없이 통합 대시보드 구성을 위해 최적.
*   **로그 보존 정책:**
    *   **애플리케이션 로그:** 30일 보존, 이후 자동 삭제.
    *   **접근 로그(Nginx):** 90일 보존(K-PIPA 권고 기준).
    *   **감사 로그(인증·결제·민감 동작):** 1년 보존, WORM 모드(append-only) 적용.
    *   **개인 식별 정보:** 적재 단계에서 마스킹 후 저장(원본 미저장).

### 4.2 모니터링 및 알림 (Metrics & Alerting)
서버 가용성 및 성능 지표 관리를 위한 방안입니다.

| 항목 | **Uptime Kuma (경량)** | **Prometheus + Grafana (추천)** | **Cloud Monitoring (Managed)** |
| :--- | :--- | :--- | :--- |
| **복잡도** | 매우 낮음 | 중간 | 낮음 |
| **기능** | 단순 생존 확인 | **리소스/메트릭 상세 분석** | 인프라 밀착형 통합 모니터링 |
| **적합성** | 사이드 프로젝트 | **Loki와 연동된 통합 모니터링** | 높은 운영 비용 감수 시 |
*   **결정:** **Prometheus + Grafana**. 이미 결정된 Loki와 스택이 일치하며, 시스템 메트릭과 로그를 하나의 대시보드에서 통합 관제 가능.
*   **알림 연동:** 특정 임계치(CPU 90%, 5xx 비율 1%, p95 응답 1s 등) 도달 시 Discord Webhook을 통한 실시간 알림 발송.

### 4.3 통합 API 문서화 (Integrated API Docs)

| 항목 | **Separate Swaggers** | **Nginx Proxy Routing (추천)** | **Swagger UI Aggregator** |
| :--- | :--- | :--- | :--- |
| **사용자 편의** | 낮음 (포트별 이동) | **중간 (URL 경로 분기)** | 높음 (단일 페이지 통합) |
| **관리 난이도** | 매우 낮음 | **낮음 (Nginx 설정만)** | 높음 (별도 통합 서버 필요) |
*   **결정:** **Nginx Proxy Routing**. `/docs/java`, `/docs/python` 경로로 분기하여 점진적 통합 유도.

### 4.4 자동화된 테스트 전략 (CI Testing)

| 계층 | **Unit Test** | **Integration Test** | **E2E Test** | **Load Test** |
| :--- | :--- | :--- | :--- | :--- |
| **대상** | 로직/함수 단위 | DB/외부 연동 (Testcontainers) | 사용자 시나리오 전체 | 트래픽 시나리오 |
| **도구** | JUnit 5.11+ / Pytest 8.x / Vitest 2.x | Testcontainers (PostgreSQL + Valkey) | Playwright | **k6** |

*   **전략:** **Unit + Integration 중심**. 데이터 정합성이 중요한 OkeyMeal 특성상 Testcontainers를 활용한 연동 테스트를 강제함.
*   **커버리지 목표(라인 기준):**
    *   `okeymeal-core` (도메인/서비스): **80%**
    *   `okeymeal-api` (컨트롤러): **70%**
    *   `okeymeal-infra` (외부 어댑터): **60%** (외부 API는 계약 테스트 우선)
    *   Python `services/` (AI 파이프라인): **70%**
    *   Frontend `entities`/`features`: **60%**
*   **CI 게이트:** PR 머지 시 커버리지 미달 또는 신규 코드 커버리지 50% 미만이면 자동 차단.

#### ■ 부하 테스트 (k6) 시나리오
| 시나리오 | 가상 사용자 | 지속 시간 | 시나리오 |
| :--- | :--- | :--- | :--- |
| **S1 - 평시** | 50명 동시 | 5분 | 지도 탐색·식당 조회·추천 요청 |
| **S2 - 피크** | 200명 동시 | 10분 | S1 + AI 렌즈 호출 + 리뷰 작성 |
| **S3 - 의존성 다운** | 100명 동시 | 5분 | Tour API 모킹 다운, 회복(Stale 데이터 제공) 검증 |
| **S4 - 인증 폭주** | 500 RPS | 2분 | 로그인 엔드포인트 Rate Limit·Circuit Breaker 동작 검증 |

*   **합격 기준:** p95 응답 1s 이하, 에러율 1% 이하, OOM·5xx 폭증 없음.
*   **CI 연동:** `staging` 배포 직후 자동 실행, 결과를 Grafana 대시보드 + PR 코멘트로 게시.
*   **공모전 시연 전 필수:** 시연 D-3에 S2 시나리오를 prod 환경 시뮬레이션으로 실시.

### 4.5 비회원(Guest) 인증 및 소셜 로그인 (Guest & Social Auth)
'제로 베리어' 실현 및 글로벌 사용자 대응을 위한 인증 전략입니다.

#### ■ 소셜 로그인 확장성 고려
*   **Google OAuth2:** 글로벌 관광객 대상 표준 인증.
*   **Apple ID:** iOS 사용자 필수 대응 및 프라이버시 중심 인증.
*   **Kakao/Naver:** 국내 거주 외국인 및 테스트 접근성 향상.

#### ■ 토큰 저장 전략 (XSS/CSRF 동시 방어)
| 환경 | Access Token | Refresh Token |
| :--- | :--- | :--- |
| **웹 (Browser)** | 메모리 (변수) | **`httpOnly` + `Secure` + `SameSite=Strict` 쿠키** |
| **모바일 (Capacitor)** | 메모리 (Zustand) | **Capacitor `Preferences` + Keychain/Keystore** |

*   `shared/storage` 추상화 레이어에서 환경별 분기.
*   `localStorage`/`sessionStorage`에는 토큰을 절대 저장하지 않음 (XSS 노출 차단).
*   Refresh Token은 Valkey(`auth:refresh:{userId}`)에서 회전(Rotation) 및 재사용 탐지.

#### ■ JWT 만료 및 세션 정책

| 항목 | 정책 | 사유 |
| :--- | :--- | :--- |
| **Access Token TTL** | **30분** | 짧게 유지하되 빈번한 갱신 부하 회피 |
| **Refresh Token TTL** | **30일 (자동로그인 ON, 기본값) / 24시간 (자동로그인 OFF)** | 사용자 선택 가능, 인바운드 관광객 편의 위해 자동로그인 기본 활성 |
| **Refresh Token 회전** | 사용 시마다 새 토큰 발급, 이전 토큰 즉시 폐기 | 탈취 탐지 및 완화 |
| **재사용 탐지** | 폐기된 Refresh Token 재사용 시 해당 사용자 모든 세션 강제 종료 + 보안 알림 | 토큰 탈취 의심 시 자동 차단 |
| **동시 세션** | 사용자당 최대 5 디바이스 | 6번째 로그인 시 가장 오래된 세션 자동 만료 |
| **강제 로그아웃** | 비밀번호 변경·계정 정지·이상 행위 탐지 시 모든 Refresh Token 즉시 무효화 (Valkey `auth:refresh:{userId}` 삭제) | 보안 사고 대응 |
| **Idle Timeout** | Refresh 7일 미사용 시 자동 만료 (TTL과 별개) | 휴면 계정 자동 정리 |
| **Guest Token** | TTL 90일, 회전 없음, 단일 디바이스 | 가벼운 익명 식별 목적 |
| **점주 계정** | Refresh TTL 7일 (일반 사용자보다 짧게), 자동로그인 미지원 | 점주 콘솔 보안 강화 |

#### ■ 자동로그인 및 생체 인증 UX
*   **기본값:** 자동로그인 ON (체크박스 사전 선택). 첫 진입 시 안내 모달로 보안 권고 표시.
*   **OFF 선택 시:** Refresh Token 24시간 유지 + Access 만료 시 매번 재로그인.
*   **모바일(Capacitor):** OS 생체 인증(Face ID / 지문)을 활성화한 경우 Refresh Token 사용 시 생체 검증 요구.
*   **민감 작업 재인증:** 비밀번호 변경·결제·개인정보 변경 시 Access Token 재발급 직후라도 별도 재인증 요구.

#### ■ Guest → Member 전환 정책
*   **UUID 기반 Guest JWT:** 최초 접속 시 발급. 위 저장 전략에 따라 환경별 보호 영역에 저장.
*   **데이터 마이그레이션:** 소셜 로그인 시, 해당 UUID에 연결된 '식이 프로필' 및 '찜 목록' 데이터를 정식 회원 계정으로 자동 이관(Merge). 충돌 시 회원 측 데이터 우선.

#### ■ 회원 탈퇴 및 재가입 정책

| 단계 | 처리 |
| :--- | :--- |
| **즉시 (T+0)** | 모든 Refresh Token 무효화, 개인 식별 정보 익명화(`user_anon_{hash}`), 식이 프로필·찜 목록 30일간 복구 가능 형태로 보존 |
| **유예 (T+0 ~ T+30일)** | 사용자 본인 직접 복구 가능 (소셜 로그인 시 복구 의사 확인 모달) |
| **완전 파기 (T+30일 ~ T+35일)** | 모든 데이터 영구 삭제, 백업본 5일 내 동기 삭제 (K-PIPA 준수) |
| **재가입 정책 (정상 탈퇴)** | 동일 소셜 ID로 30일 이내 재가입 시 보존 데이터 복구 옵션 제시. 30일 경과 후에는 신규 사용자로 처리 |
| **재가입 차단 (악의적 탈퇴)** | 정지 사유로 탈퇴된 계정은 동일 소셜 ID로 재가입 불가 (`block_list` 테이블 영구 보존, K-PIPA 합법 근거 사전 고지) |

### 4.6 데이터 융합 파이프라인 동기화 기술 비교
관광공사 및 식약처 데이터 수집/가공을 위한 도구 선택입니다.

| 비교 항목 | **Spring Batch (Java)** | **Python Schedulers (Celery/APS)** |
| :--- | :--- | :--- |
| **강점** | **대용량 처리 안정성, 트랜잭션 관리** | **AI 라이브러리 연동, 빠른 스크립팅** |
| **복잡도** | 높음 (설정 및 러닝커브) | 낮음 (빠른 구현) |
| **데이터 결합** | RDBMS 중심 결합에 유리 | **Open API/Crawling 연동에 최적** |
*   **전략:** **하이브리드 운영**.
    *   **Python (FastAPI/APScheduler):** 외부 Open API 연동 및 데이터 전처리, **다국어 사전 번역(L3 동적 데이터)**, AI 임베딩 생성 (스크립트 위주).
    *   **Spring Batch:** 전처리된 데이터를 최종 운영 DB에 정합성을 맞춰 적재하거나, 대규모 알림 발송 등 시스템 안정성이 중요한 작업에 사용.

#### ■ 다국어 사전 번역 단계 (Pre-translation Step)
관광공사 API는 한국어 데이터를 반환하므로, 적재 직전 4개국 언어로 일괄 번역합니다.

1. **수집:** 관광공사/식약처 API → 원본(`ko`) 적재.
2. **정규화:** 알레르기/식이 키워드를 ISO 코드로 표준화 (예: `vegetarian`, `halal`, `gluten_free`).
3. **번역 (LLM Batch API):** 식당명·메뉴명·설명·태그를 `en`/`ja`/`zh-CN`으로 일괄 번역. 비용 절감을 위해 Batch API(50% 할인) 우선 사용.
4. **검증:** 길이·금칙어·번역 누락 검사. 실패 시 원본(`ko`) 폴백 마킹.
5. **저장:** JSONB 컬럼(`name`, `description` 등)에 `{ "ko": "...", "en": "...", ... }` 형태 적재.
6. **재번역 트리거:** 원본 변경 시점에만 재실행(해시 비교). 신규 데이터는 일 1회 배치.

#### ■ 외부 API 실패 처리 정책 (Tour API / 식약처 API)

| 계층 | 정책 |
| :--- | :--- |
| **타임아웃** | Connect 2s / Read 10s |
| **재시도** | 지수 백오프 (1s → 2s → 4s, 최대 3회), 5xx·`429`만 재시도 |
| **Circuit Breaker** | 50건 중 60% 실패 시 OPEN, 5분 HALF_OPEN |
| **Rate 준수** | 토큰 버킷으로 외부 API rate 80% 이내 유지 |
| **DLQ** | 최종 실패 시 Valkey Streams `stream:ingest:dlq`에 작업 적재, 별도 워커가 30분 간격으로 재처리 (최대 24시간) |
| **Stale 허용** | DB에 마지막 성공 데이터 + `fetched_at` 보존, 외부 API 다운 시 stale 데이터 제공 + 응답에 `X-Data-Stale: true` 헤더 |
| **알림** | 연속 실패 30분 도달 시 Discord 알림, 2시간 도달 시 운영자 호출 |

#### ■ AI 추천 캐시 무효화 정책
*   **이벤트 기반 무효화:** 다음 이벤트 발생 시 `cache:reco:{userId}:*` 일괄 삭제
    *   사용자 식이 프로필 변경 (알레르기·종교·선호 등)
    *   사용자 위치 컨텍스트 변경 (도시 단위 변경)
    *   해당 추천에 포함된 식당 정보 업데이트 (메뉴·운영 상태)
*   **TTL 폴백:** 이벤트 누락 대비 캐시 TTL 6시간.
*   **버전 키 패턴:** `cache:reco:{userId}:v{profileVersion}:{ctx}` — 프로필 변경 시 자동으로 새 캐시 키 생성, 구 캐시는 TTL 자연 만료 (TOCTOU 회피).

---

### 4.7 GitHub 레파지토리 및 CI/CD (Git & CI/CD)

| 항목 | **Multi-Repo** | **Monorepo (추천)** | **Hybrid (Submodule)** |
| :--- | :--- | :--- | :--- |
| **구조** | 서비스별 개별 저장소 | **단일 저장소 내 폴더 구분** | 메인-서브 저장소 연결 |
| **장점** | 서비스 간 독립성 완벽 | **의존성 공유 및 CI 일원화** | 독립성/연결성 병행 |
| **결정** | - | **초기 개발 및 설계 문서 공유에 최적** | - |

#### ■ [샘플 구조] Monorepo (최종 결정) - Java 멀티모듈 반영
```text
okeymeal-workspace/ (Repo)
├── .github/workflows/    # 통합 CI/CD (GitHub Actions)
├── documents/            # 기획 및 설계 문서
├── runbooks/             # 장애 대응 매뉴얼 (Flyway, 배포, 보안 사고)
├── backend-java/         # Java Multi-module Root
│   ├── okeymeal-api      # API Module
│   ├── okeymeal-core     # Core Business Module (Flyway 관리 주체)
│   ├── okeymeal-infra    # External Link Module
│   └── okeymeal-common   # Shared Common Module
├── backend-python/       # FastAPI Project
├── frontend/             # React Project (Capacitor 통합 루트)
│   ├── src/              # React Source (FSD)
│   ├── android/          # Capacitor Android Native Project
│   ├── ios/              # (Phase 2) Capacitor iOS Native Project
│   └── capacitor.config.ts
├── infra/                # docker-compose, nginx, prometheus, loki 설정 + deploy.sh
└── docker-compose.yml
```

#### ■ CI/CD: GitHub Actions

| 항목 | 정책 |
| :--- | :--- |
| **트리거** | PR 생성·업데이트 시 lint+test, `main` push 시 staging 배포, `release/v*` 태그 시 prod 배포 |
| **매트릭스 빌드** | Java 25 / Node.js 24 / Python 3.13 (단일 LTS 라인) |
| **캐싱** | Gradle (`actions/cache` + `gradle/gradle-build-action`), npm/pnpm (lockfile 기반), pip (`requirements.lock` 기반) |
| **병렬화** | backend-java / backend-python / frontend 잡 병렬 실행, 변경 경로 기반 조건부 실행 (`paths-filter`) |
| **시크릿** | GitHub Actions Secrets + OIDC 연동(GCP·AWS) — 장기 키 비저장 |
| **배포** | SSH 기반 `docker compose pull && up -d`, Blue/Green 스왑은 `infra/deploy.sh` 스크립트 |
| **릴리스 노트** | `release-please` 액션으로 Conventional Commits 기반 자동 생성 |
| **보안 스캔** | Trivy(이미지), CodeQL(코드), gitleaks(시크릿 누출) PR 차단 |
| **승인 게이트** | prod 배포는 GitHub Environments에 Reviewer 1인 승인 필수 |

### 4.8 로컬 개발 및 IDE 최적화 전략 (Local Dev Strategy)
*   **IDE 설정:** 인덱싱 제외 패턴 설정 및 모듈 단위 로딩을 통해 로컬 PC 부하 최소화.
*   **로컬 부트스트랩:** `make up` 또는 `docker compose --profile dev up`으로 PostgreSQL/Valkey/MinIO(S3 에뮬) 일괄 기동.

### 4.9 국제화(I18n) 및 공통 에러 핸들링 (I18n & Error Handling)
관광 인바운드 사용자 대응을 위한 다국어 서비스 설계입니다. 텍스트의 성격에 따라 **3계층 구조**로 분리합니다.

#### ■ 지원 언어 (Phase 1)
`ko` (Default) / `en` / `ja` / `zh-CN` — 관광공사 인바운드 상위 4개국 기준.

#### ■ 3계층 i18n 구조

| 계층 | 대상 | 처리 위치 | 도구·방식 |
| :--- | :--- | :--- | :--- |
| **L1 정적 UI** | 버튼, 메뉴, 라벨, 안내 문구 | **Frontend** | `i18next` + `react-i18next`. 네임스페이스 분리(`common`, `auth`, `restaurant`, `error`, `notification`) |
| **L2 시스템 메시지** | 에러, 알림(Push), 메일 | **Backend는 `code`만 반환 → Frontend가 i18next로 매핑** | 공통 응답 포맷(아래) + i18next `error`/`notification` 네임스페이스 |
| **L3 동적 데이터** | 식당명, 메뉴, 설명, 태그, AI 추천문 | **DB(JSONB) 사전 번역 + Valkey 캐시** | 4.6절 사전 번역 파이프라인 + `i18n:review:{id}:{locale}` 캐시 |

#### ■ 언어 결정 우선순위
1. **사용자 명시 설정** (`User.preferredLocale`) — 최우선.
2. **Accept-Language 헤더** — 미로그인/Guest 기본.
3. **Capacitor OS Locale** — 모바일 초기 진입 시 자동 적용 후 ②/①과 동기화.
4. **기본값 `ko`** — 위 모두 부재 시 폴백.

* 변경 시 서버에 동기화하여 푸시 알림 언어도 일치시킵니다.

#### ■ 동적 데이터 번역 정책 (L3 상세)

| 데이터 종류 | 번역 시점 | 저장 위치 | 사유 |
| :--- | :--- | :--- | :--- |
| **식당·메뉴·태그** | **사전(Batch)** | DB JSONB 컬럼 | 조회 빈도 압도적, 응답 지연 0ms 필요 |
| **AI 추천 설명문** | **요청 시 + 결과 캐시** | Valkey `cache:reco:{userId}:v{ver}:{locale}` | 사용자별 동적 생성, LLM 호출 직후 다국어 변환 |
| **사용자 리뷰** | **요청 시 + 7일 캐시** | Valkey `i18n:review:{id}:{locale}` | 작성 빈도 < 조회 빈도, 원문 보존 필요 |

*   **JSONB 스키마 패턴:**
    ```json
    {
      "name": {"ko": "전주 비빔밥집", "en": "Jeonju Bibimbap House", "ja": "全州ビビンバ", "zh-CN": "全州拌饭店"},
      "description": {"ko": "...", "en": "...", "ja": "...", "zh-CN": "..."}
    }
    ```
*   **인덱싱:** PostgreSQL GIN 인덱스(`jsonb_path_ops`)로 다국어 검색 성능 확보.
*   **다국어 검색 매칭:** 사용자 입력 언어와 무관하게 4개 언어 인덱스 동시 조회 후 점수 합산. (예: 일본어로 "비빔밥" 입력 → `ko`/`ja` 인덱스 모두 매칭)

#### ■ 검색 엔진 확장 트리거
*   **현재:** PostgreSQL GIN 인덱스(`jsonb_path_ops`).
*   **전환 트리거 (Meilisearch 또는 OpenSearch):**
    *   식당 데이터 50만 건 초과 또는 검색 p95 500ms 초과
    *   오타 허용·동의어·유사어 매칭 요구 발생
    *   다국어 형태소 분석 정확도 부족 (특히 일본어·중국어)
*   **선택 가이드:** 운영 부담 낮은 **Meilisearch** 우선 검토 (단일 노드, 한국어 형태소 한계는 토큰 사전으로 보완).

#### ■ 알레르기·식이 제한 키워드 표준화
국가별 표현 차이로 직역이 부정확하므로(예: 비건 ↔ 素食 ↔ ヴィーガン), **DB는 ISO 코드로만 저장**하고 표시 단계에서 i18next로 라벨링합니다.
*   표준 코드: `vegan`, `vegetarian`, `pescatarian`, `halal`, `kosher`, `gluten_free`, `lactose_free`, `peanut_free`, `shellfish_free` 등.
*   확장 시 `okeymeal-core` 모듈에 enum으로 관리.

#### ■ 폴백(Fallback) 정책
번역 누락 시 표시 우선순위는 **`사용자 언어` → `en` → `ko`(원본)** 순으로 폴백합니다.
*   폴백된 항목은 응답에 `_fallback: true` 플래그를 포함시켜 클라이언트가 "원문 표시 중" UI를 노출할 수 있게 합니다.
*   사용자 리뷰는 폴백 발생 시 **`🌐 원문 보기(JA)` 토글**을 함께 제공합니다.

#### ■ 공통 에러 응답 포맷
Java와 Python 백엔드 모두 아래 규격을 준수합니다. 프론트는 `code`만으로 i18next 키와 매핑하여 표출하며, `message`/`message_en`은 디버깅·로깅·서버 측 백업 표기용입니다.
```json
{
  "code": "ERR_RESTAURANT_NOT_FOUND",
  "message": "식당을 찾을 수 없습니다.",
  "message_en": "Restaurant not found.",
  "detail": "Requested ID: 12345",
  "traceId": "01HXYZ..."
}
```

### 4.10 무중단 배포 전략 (Deployment Strategy)
단일 VM 환경에서의 가용성 확보를 위한 배포 방식입니다.

*   **방식: Blue-Green 컨테이너 스왑**
    *   **도구:** Docker Compose + Nginx (Reverse Proxy)
    *   **절차:**
        1. 신규 버전 컨테이너를 다른 포트로 실행 (Green).
        2. Green 컨테이너의 Health Check(`/actuator/health`, `/health`) 완료 확인.
        3. Nginx 설정 파일(`upstream`)을 업데이트하여 트래픽을 Green으로 전환 (`nginx -s reload`).
        4. 5분 관찰 후 기존 버전 컨테이너(Blue) 제거.
    *   **롤백:** Nginx upstream을 Blue로 되돌리고 reload (1분 내 복구).

#### ■ DB 마이그레이션 안전성 (Flyway)
| 항목 | 정책 |
| :--- | :--- |
| **Expand-Contract 패턴** | Blue/Green 동시 가동 호환을 위해 컬럼 즉시 삭제 금지, 두 단계 배포로 분리(Expand → Migrate Data → Contract) |
| **사전 검증** | staging에서 실제 데이터 사본(마스킹)으로 마이그레이션 1회 수행 후 prod 적용 |
| **타임아웃 가드** | 단일 마이그레이션 30분 초과 시 자동 중단(`statement_timeout=1800s`), 운영자 개입 |
| **실패 시 행위** | Flyway 실패 시 신규 컨테이너 부팅 차단, Blue 유지. 알림 즉시 발송 |
| **수리 절차** | (1) 실패 SQL 진단 → (2) 보상 SQL 작성 → (3) `flyway repair` → (4) 수정된 마이그레이션 재실행. 절차서: `runbooks/flyway-recovery.md` |
| **수동 개입 권한** | 운영 DB 마이그레이션 강제 진행은 DBA 1인 + 백엔드 리드 1인 2명 승인 필수 |
| **사전 스냅샷** | prod 마이그레이션 직전 `pg_basebackup` 스냅샷 자동 생성, 7일 보존 |

### 4.11 API 명세서 작성 전략 (API Documentation)
설계와 구현의 정합성을 유지하기 위한 전략입니다.

| 비교 항목 | **Manual Markdown (직접 작성)** | **SpringDoc / Swagger (자동)** |
| :--- | :--- | :--- |
| **장점** | **구현 전 설계 합의에 최적** | 코드와 문서의 100% 일치 |
| **단점** | 관리 리소스 발생, 동기화 누락 위험 | **구현이 완료되어야 문서가 나옴** |
| **추천** | **설계 단계 (API_Specification.md)** | **개발/검증 단계 (Swagger UI)** |

*   **최종 전략:** **설계 우선 (Design-First)**. `API_Specification.md`를 통해 엔드포인트와 데이터 구조를 먼저 합의한 후, 구현 단계에서 SpringDoc을 통해 자동화된 문서를 제공합니다.

### 4.12 사용자 행동 분석 및 지표 (Analytics)
공모전 결과 보고 및 운영 의사결정용 지표 수집 전략입니다.

| 도구 | 용도 | 사유 |
| :--- | :--- | :--- |
| **Google Analytics 4** | 페이지뷰·이탈률·획득 채널 등 일반 웹 분석 | 무료, 표준 도구, 공모전 보고서 호환 |
| **Plausible (Self-host)** | 쿠키리스 트래픽 분석 (PIPA 친화) | 개인정보 비저장, 보조 지표 |
| **Mixpanel 무료 플랜** | 핵심 퍼널·이벤트 추적 (추천 클릭→방문 전환) | 월 100k 이벤트 무료 |
| **PostHog (옵션, 2단계)** | 세션 리플레이·기능 플래그 | OSS, 셀프 호스트 가능 |

#### ■ 핵심 KPI (공모전 보고용)
*   DAU/MAU, 회원 전환율(Guest→Member), 추천 클릭율(CTR), AI 렌즈 사용률, 다국어 사용자 비율, 알레르기 필터 적용 비율, p95 응답 시간, 에러율.

#### ■ 개인정보 보호
*   GA4 IP 익명화 활성, User-ID는 해시 처리. 마케팅 동의자만 광고 ID 수집. 모든 분석 도구 사용 사실은 개인정보 처리방침에 명시.

### 4.13 접근성 (Accessibility, a11y)
다국어·고령 인바운드 관광객·시각·청각 장애인을 포함한 보편적 접근성 보장.

| 항목 | 기준 |
| :--- | :--- |
| **준수 표준** | WCAG 2.1 Level AA |
| **컬러 대비** | 본문 텍스트 4.5:1, 큰 텍스트 3:1 이상 — 색약 대응 |
| **키보드 네비게이션** | 모든 기능 키보드만으로 접근 가능, 포커스 인디케이터 명시 |
| **스크린 리더** | 시맨틱 HTML, ARIA 라벨, 이미지 `alt` 텍스트 다국어 제공 |
| **모션 민감성** | `prefers-reduced-motion` 미디어 쿼리 대응 |
| **폰트 크기** | 사용자 OS 폰트 크기 설정 존중 (rem 단위) |
| **자동 검증** | CI에 `axe-core` 연동, Critical 위반 시 PR 차단 |
| **수동 점검** | 릴리스 전 키보드만으로 핵심 플로우 점검 (체크리스트: 가입·로그인·검색·추천·예약·리뷰) |

---

## 📝 변경 이력
| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.0.0 | 2026-05-06 | 최초 기술 결정 정의서 작성 | 숭늉 |
| v1.5.0 | 2026-05-06 | 2026년 표준 반영, 하이브리드 아키텍처, 패키지 구조, 서버 및 로깅/보안 전략 통합 | 숭늉 |
| v1.6.0 | 2026-05-06 | 하이브리드 모바일 전략(Capacitor) 및 안드로이드 마켓 등록 방안 추가 | 숭늉 |
| v1.7.0 | 2026-05-06 | Java 멀티 모듈 구조 적용 및 모바일 앱 통합 영향도 분석 반영 | 숭늉 |
| v1.8.0 | 2026-05-06 | DB 마이그레이션(Flyway), 파일 저장소, 모니터링, 비회원 인증, 동기화 전략 상세화 | 숭늉 |
| v1.9.0 | 2026-05-06 | 서비스 간 통신(REST), PIPA 준수 보안, 게스트 전환, I18n 에러 규격, 무중단 배포(Blue-Green), API 문서화 전략 추가 | 숭늉 |
| v2.0.0 | 2026-05-06 | 검토 권장안 일괄 반영: React 19/Vite 7 갱신, 표 오타 수정, 토큰 저장(httpOnly+Capacitor) 정책, 내부 통신 mTLS 트리거, Rate Limiting, Redis 캐시(2.4), DB 백업/PITR(2.5), 환경 분리(3.2), CDN 전략, 로그 보존 기간, 테스트 커버리지 목표, Flyway 관리 주체 확정, Expand-Contract 마이그레이션 | 숭늉 |
| v2.1.0 | 2026-05-06 | 다국어 전략 구체화: 4.9절 3계층 구조, 지원 언어 4종, JSONB 사전 번역 패턴, 알레르기 ISO 코드, 폴백 정책, 다국어 검색 인덱스, 4.6절 사전 번역 파이프라인, 리뷰 번역 캐시 | 숭늉 |
| v3.0.0 | 2026-05-06 | 23개 검토 항목 일괄 반영: AI 모델(LLM) 후보 비교(1.5), 지도 멀티 프로바이더(1.6), FCM 푸시(1.7), Resilience4j 안정성, Valkey 채택(2.4), PostgreSQL 18 확정, Flyway 명명·실패 처리, WAL archive_timeout, VM 권장 사양, 환경 논리/물리 2단계 분리, 업로드 파일 검증, K-PIPA 추가 항목, JWT 상세 정책 + 자동로그인 + 탈퇴/재가입, 외부 API DLQ, AI 캐시 무효화, 부하 테스트(k6), GitHub Actions 상세, Python 3.13, 분석/지표(4.12), 접근성(4.13), 검색 엔진 트리거, Redis→Valkey 라이선스 이슈 해결 | 숭늉 |
| v3.1.0 | 2026-05-06 | 본 공모전 MVP 스코프 정의(0장 신설): 예약·결제 제외 + 향후 확장 메모, 점주 콘솔 서브도메인 분리, AI 렌즈 OCR 우선 / 음식 사진 식별 보류. AI 추천 알고리즘 아키텍처 상세화: User/Restaurant/Menu 임베딩 768d 전략, 코사인 유사도 채택 사유, Cold-start 4단계, 컨텍스트 재정렬(거리·시간·날씨·운영·이력), RAG 5단계, Hallucination 방지, 추천 품질 KPI | 숭늉 |
