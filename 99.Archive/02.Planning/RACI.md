---
title: "[기획] OkeyMeal 분업 RACI 매트릭스 (Team Responsibility Assignment)"
version: v0.1.2
last_updated: 2026-05-08
author: 숭늉
---

# 👥 OkeyMeal 분업 RACI 매트릭스

본 문서는 **풀스택 시니어 2인** 인력 구성에서 [`WBS.md`](./WBS.md) v0.2.0 작업 분해의 책임 분담을 정의합니다. 본 문서는 WBS의 **부속 문서**이며, 작업 단위는 WBS와 1:1 매핑됩니다.

> 📌 **연계 문서**
> - 작업 분해: [`02.Planning/WBS.md`](./WBS.md) v0.2.0
> - 요구사항: [`01.Ideation/Requirements.md`](../01.Ideation/Requirements.md) v0.1.1 (CON-02)
> - 기술 결정: [`04.Design/Technical_Decision_Records.md`](../04.Design/Technical_Decision_Records.md) v3.1.0
> - 협업 규칙: [`CONTRIBUTING.md`](../../CONTRIBUTING.md)

---

## 1. 문서 개요

### 1.1 목적
1인 가정 → 시니어 2인 인력 구성으로 변경(2026-05-08)됨에 따라 **누가 어느 작업의 R/A/C/I인지**를 명확히 하여 다음 리스크를 통제합니다.
*   **R6** (개발 리소스 부족) — 분업으로 완화
*   **R11** (분업 인터페이스 정합 비용) — 본 문서가 1차 완화책
*   **R12** (AI 도메인 전문성 갭) — 트랙 A 책임자가 PoC 조기 진행

### 1.2 RACI 약어

| 약어 | 의미 | 인원 |
|---|---|---|
| **R** | Responsible (실제 작업 수행) | 1~2인 |
| **A** | Accountable (최종 책임·승인) | 작업당 **1인 고정** |
| **C** | Consulted (사전 협의 대상) | 0~2인 |
| **I** | Informed (사후 통보 대상) | 0~2인 |

### 1.3 트랙 정의

| 트랙 | 약어 | 주요 영역 |
|---|---|---|
| **트랙 A** | **A** | 백엔드(Spring Boot 4.0 + FastAPI) · DB(PostgreSQL 18 + PostGIS + pgvector) · AI(LLM/RAG/임베딩) · 인프라(Docker · Nginx · Loki/Prometheus/Grafana) · CI/CD · 외부 API 어댑터(서버측) |
| **트랙 B** | **B** | 프론트(React 19 / Vite 7 / FSD) · 모바일(Capacitor Android) · 점주 콘솔(`apps/owner/`) · UI/UX · 다국어(i18next) · 외부 API(클라이언트측: Maps 3종) · 접근성 |
| **공동** | **A+B** | API 계약(2.3) · DB 마이그레이션(3.1.4) · E2E 시나리오(3.11.1) · 시연 리허설(5.5) · runbooks(5.6) · 보안 게이트(NFR-SEC-05) |

> ℹ️ 본 문서는 트랙 명만 사용하며 실제 담당자 이름·이메일은 별도 비공개 매핑(예: `00.Meetings/Team_Roster.md`)으로 분리합니다. AI 푸터 금지 정책과 동일한 사유로, 본 문서에는 PII를 두지 않습니다.

---

## 2. Phase 1. 분석 (W1-W2, 2026-05-06 ~ 2026-05-19)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 1.1 | 요구사항 명세서 (`Requirements.md`) | A+B | A | — | — |
| 1.2 | 외부 API 인벤토리 (`External_API_Inventory.md`) | A | A | B | — |
| 1.3 | 사용자 페르소나 검증·갱신 | B | B | A | — |
| 1.4 | Core_Features.md 갱신 (MVP 스코프 반영) | A+B | A | — | — |
| 1.5 | 경쟁 서비스 벤치마크 | B | B | A | — |
| 1.6 | 리스크 레지스터 (RAID) | A+B | A | — | — |
| 1.7 | **GitHub Branch Protection + CODEOWNERS 설정** | A | A | B | — |
| 1.8 | M1 게이트 회고 | A+B | A | — | — |

> 💡 Phase 1은 분량이 많지 않아 양쪽이 서로의 산출물을 리뷰하는 형태로 진행합니다.
> ⚠️ **1.7은 R11 강제 완화의 핵심.** 트랙 A가 인프라 권한으로 설정하되, CODEOWNERS 경로 매핑은 트랙 B가 C(consult) — 본인 영역 누락 방지 차원.

---

## 3. Phase 2. 설계 (W3-W6, 2026-05-20 ~ 2026-06-16)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 2.1 | ERD 작성 | A | A | B | — |
| 2.2 | AI 추천 알고리즘 상세 설계 | A | A | B | — |
| 2.3 | API 명세서 (사용자·점주 분리) | **A+B** | A | — | — |
| 2.4 | 화면 흐름·IA·와이어프레임 | B | B | A | — |
| 2.5 | UI 디자인 시안 (Figma) | B | B | A | — |
| 2.6 | 점주 콘솔 별도 설계 | B | B | A | — |
| 2.7 | DB 마이그레이션 V1 골격 (Flyway) | A | A | B | — |
| 2.8 | 외부 API 어댑터 인터페이스 설계 | A | A | B | — |
| 2.9 | 인프라 토폴로지 | A | A | — | B |
| 2.10 | 보안 위협 모델링 (STRIDE) | A | A | B | — |
| 2.11 | 다국어 콘텐츠 정책 | B | B | A | — |
| 2.12 | **LLM/AI 공통 라이브러리 PoC + Base Code 자산화** | A | A | B | — |
| 2.13 | M2 게이트 회고 | A+B | A | — | — |

> ⚠️ **2.3 (API 계약)은 R11 완화의 핵심.** 양쪽 공동 R, 합의된 OpenAPI 스펙 머지 후에만 3.x 진입 허용.
> ⚠️ **2.12 (AI Base Code)는 R12 완화의 핵심.** 트랙 A 단독 R이지만 인터페이스 설계는 트랙 B가 C로 검토 — 향후 클라이언트 호출(USR-3.1 AI 렌즈, USR-3.3 질문 생성기 등)에서 사용 편의성 확보. PoC 결과(Q1·Q2 결정 데이터) 회의에는 양쪽 모두 참석.

---

## 4. Phase 3. 개발 (W7-W18, 2026-06-17 ~ 2026-09-08)

### 4.1 인프라 셋업 (3.1, W7-W8)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.1.1 | Monorepo 부트스트랩 | A | A | B | — |
| 3.1.2 | Docker Compose | A | A | — | B |
| 3.1.3 | GitHub Actions CI 골격 | A | A | B | — |
| 3.1.4 | Flyway 초기 마이그레이션 V1 | **A+B** | A | — | — |
| 3.1.5 | 모니터링 스택 (Loki+Prom+Grafana) | A | A | — | B |
| 3.1.6 | Nginx Reverse Proxy + 라우팅 | A | A | B | — |

### 4.2 인증 시스템 (3.2, W9-W10)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.2.1 | Guest JWT 발급 (서버) | A | A | B | — |
| 3.2.2 | 소셜 로그인 OAuth2 (4종, 서버측) | A | A | B | — |
| 3.2.3 | Access/Refresh 토큰 회전·재사용 탐지 | A | A | B | — |
| 3.2.4 | Guest → Member 데이터 마이그레이션 | A | A | B | — |
| 3.2.5 | 자동로그인·생체 인증 (모바일 UX) | B | B | A | — |
| 3.2.6 | 회원 탈퇴/재가입 정책 | A | A | B | — |
| 3.2.7 | 점주 별도 인증 도메인 | A | A | B | — |

> 💡 클라이언트측 OAuth 콜백 화면·생체 인증 UX는 트랙 B가 단독 처리. 토큰 발급/검증 모두 트랙 A 담당.

### 4.3 핵심 도메인 (3.3, W11-W12)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.3.1 | User, DietProfile | A | A | B | — |
| 3.3.2 | Restaurant, Menu (다국어 JSONB) | A | A | B | — |
| 3.3.3 | Review (다국어 + 캐시) | A | A | B | — |
| 3.3.4 | 찜 / 좋아요 / 방문 이력 | A | A | B | — |
| 3.3.5 | 식당 상세·메뉴 조회 API | A | A | B | — |
| 3.3.6 | 알레르기 매핑 룰엔진 | A | A | B | — |

### 4.4 데이터 융합 파이프라인 (3.4, W12-W13)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.4.1 | TourAPI 수집 어댑터 | A | A | — | B |
| 3.4.2 | 식약처 API 수집 어댑터 | A | A | — | B |
| 3.4.3 | DLQ + 재시도 + Stale 폴백 | A | A | — | B |
| 3.4.4 | Spring Batch 적재 잡 | A | A | — | B |
| 3.4.5 | 임베딩 생성 배치 (768d) | A | A | B | — |

### 4.5 AI 추천 엔진 (3.5, W13-W14)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.5.1 | pgvector HNSW 인덱스 구성 | A | A | — | B |
| 3.5.2 | 추천 API (코사인 유사도) | A | A | B | — |
| 3.5.3 | Cold-start 핸들러 (4단계) | A | A | B | — |
| 3.5.4 | 컨텍스트 재정렬 | A | A | B | — |
| 3.5.5 | RAG 추천 설명문 생성 | A | A | B | — |
| 3.5.6 | Valkey 추천 캐시 + 무효화 | A | A | — | B |
| 3.5.7 | 기상청 단기예보 연동 | A | A | — | B |

> ⚠️ **R12 핵심 영역.** Phase 2 W3~W4 LLM PoC 결과(Q1·Q2)를 본 워크스트림 진입 직전 회고에서 게이트로 점검.

### 4.6 다국어 사전 번역 배치 (3.6, W14)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.6.1 | LLM Batch API 클라이언트 | A | A | B | — |
| 3.6.2 | JSONB 다국어 적재 (4종) | A | A | B | — |
| 3.6.3 | 변경 감지 해시 트리거 | A | A | — | B |
| 3.6.4 | 번역 누락 검증 + 폴백 마킹 | A | A | B | — |

### 4.7 AI 렌즈 OCR (3.7, W15-W16)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.7.1 | 이미지 업로드 API (검증 포함, 서버) | A | A | B | — |
| 3.7.2 | OCR 엔진 통합 | A | A | B | — |
| 3.7.3 | OCR 결과 → 메뉴 텍스트 정제 | A | A | B | — |
| 3.7.4 | 메뉴 → 알레르기 매칭 | A | A | B | — |
| 3.7.5 | 결과 표시 화면 (UI) | B | B | A | — |
| 3.7.6 | 30분 자동 삭제 스케줄러 | A | A | — | B |

> 💡 카메라 캡처·갤러리 업로드 UX는 트랙 B 단독. OCR 파이프라인은 트랙 A.

### 4.8 검색 + 지도 (3.8, W15-W16)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.8.1 | 다국어 검색 API (서버 GIN 인덱스) | A | A | B | — |
| 3.8.2 | Google Maps JS SDK 통합 (클라) | B | B | A | — |
| 3.8.3 | Kakao Geocoding 연동 (클라) | B | B | A | — |
| 3.8.4 | Naver Directions 연동 (클라) | B | B | A | — |
| 3.8.5 | `MapClient` 추상화 + 어댑터 3종 | B | B | A | — |
| 3.8.6 | 위치 기반 식당 탐색 (서버 PostGIS) | A | A | B | — |

### 4.9 점주 콘솔 (3.9, W17)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.9.1 | `apps/owner/` Vite 엔트리 + FSD | B | B | A | — |
| 3.9.2 | 점주 가입 + 사업자 등록증 + 승인 | **A+B** | B | — | — |
| 3.9.3 | 메뉴 등록·수정·삭제 (다국어) | B | B | A | — |
| 3.9.4 | 리뷰 응대 화면 | B | B | A | — |
| 3.9.5 | 푸시 알림 수신 (`owner_*` 토픽) | B | B | A | — |
| 3.9.6 | `owner.okeymeal.kr` Nginx 라우팅 + 배포 | A | A | B | — |

### 4.10 푸시 알림 인프라 (3.10, W17)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.10.1 | FCM SDK 통합 (서버 + Capacitor) | **A+B** | A | — | — |
| 3.10.2 | Device Token 등록·갱신·정리 | A | A | B | — |
| 3.10.3 | Topic 구독·해지 관리 | A | A | B | — |
| 3.10.4 | 다국어 메시지 빌더 | A | A | B | — |
| 3.10.5 | Quiet Hours 적용 | A | A | — | B |
| 3.10.6 | 알림 발송 이력 로그 | A | A | — | B |

### 4.11 통합·튜닝 (3.11, W18)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 3.11.1 | E2E 시나리오 통합 (Playwright) | **A+B** | A | — | — |
| 3.11.2 | 성능 튜닝 (DB·캐시) | A | A | B | — |
| 3.11.3 | 다국어 4종 화면 검수 | B | B | A | — |
| 3.11.4 | 접근성(axe-core) 위반 해결 | B | B | A | — |
| 3.11.5 | 발견 버그 수정 | A+B | A | — | — |
| 3.11.6 | M5 게이트 점검 (Feature Freeze) | A+B | A | — | — |

---

## 5. Phase 4. 테스트 (W19-W20, 2026-09-09 ~ 2026-09-22)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 4.1 | 단위/통합 테스트 커버리지 게이트 | A+B | A | — | — |
| 4.2 | E2E 테스트 (Playwright) | B | B | A | — |
| 4.3 | 보안 스캔 (Trivy + CodeQL + gitleaks) | A | A | B | — |
| 4.4 | 부하 테스트 (k6 S1~S4) | A | A | B | — |
| 4.5 | 접근성 점검 (axe + 수동) | B | B | A | — |
| 4.6 | 다국어 QA (4개 언어) | B | B | A | — |
| 4.7 | UAT (5인 이상) | A+B | B | — | — |
| 4.8 | DR 리허설 | A | A | — | B |
| 4.9 | 결함 수정 + 회귀 테스트 | A+B | A | — | — |
| 4.10 | M5+ 게이트 회고 | A+B | A | — | — |

---

## 6. Phase 5. 배포 (W21, 2026-09-23 ~ 2026-09-30)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| 5.1 | staging 최종 검증 | A+B | A | — | — |
| 5.2 | 프로덕션 환경 사전 점검 | A | A | — | B |
| 5.3 | 프로덕션 Blue-Green 배포 | A | A | — | B |
| 5.4 | 모니터링·알림 동작 검증 | A | A | — | B |
| 5.5 | 시연 리허설 (3회) | **A+B** | A | — | — |
| 5.6 | runbooks 운영 매뉴얼 | **A+B** | A | — | — |
| 5.7 | 공모전 제출 자료 준비 | B | B | A | — |
| 5.8 | 정식 출시 발표 (D8) | A+B | A | — | — |

---

## 7. 마켓 트랙 (Google Play, MK1~MK6)

| WBS # | Task | R | A | C | I |
|---|---|---|---|---|---|
| MK1 | 개발자 계정 생성 (2026-07-18 / W12, v0.2.0에서 2주 앞당김) | B | B | A | — |
| MK2 | 스토어 자산 준비 (4종 언어 스크린샷·설명) | B | B | A | — |
| MK3 | 내부 테스트 트랙 업로드 (베타) | B | B | A | — |
| MK4 | 비공개 테스트 트랙 업로드 (RC) | B | B | A | — |
| MK5 | 정식 등록 심사 제출 | B | B | A | — |
| MK6 | 정식 등록 완료 | B | B | A | — |

> 💡 마켓 트랙 전체를 트랙 B가 단독 책임. 트랙 A는 빌드 산출물(AAB) 제공 + 스토어 정책 사전 검토 협의 대상.

---

## 8. 공동 영역 (A+B 모두 R) — 정합성 핵심

다음 작업은 **양쪽 모두 작성·리뷰 의무**가 있는 R11 완화 핵심 영역입니다. **목표는 GitHub Branch Protection + CODEOWNERS 기술 강제**(WBS 1.7, NFR-MAINT-06)이지만, **현행 GitHub Free private 환경에서는 강제가 미작동**(Q9 추적)하므로 CODEOWNERS 자동 리뷰 요청 + CONTRIBUTING.md v1.1.0 §3 정책 + WBS 3.1.3 CI 검증 Action(추후) + 시니어 2인 신뢰 기반의 다층 완화로 운영합니다.

| 영역 | 작업 | 정합성 게이트 | **강제 메커니즘** (Branch Protection) |
|---|---|---|---|
| **API 계약** | 2.3, 3.x API 추가 시 | OpenAPI 스펙 PR을 양쪽 모두 승인 후에만 머지 | CODEOWNERS: `openapi/**` → `@<track-A> @<track-B>` (2 approvals) |
| **DB 마이그레이션** | 3.1.4 + 3.x 신규 마이그레이션 | Flyway 파일은 양쪽 PR 리뷰 의무 (Expand-Contract 검증) | CODEOWNERS: `db/migration/**`, `**/V*__*.sql` → 양쪽 (2 approvals) |
| **E2E 시나리오** | 3.11.1, 4.2 | 시나리오 정의를 공동 작성, 실행은 트랙 B | CODEOWNERS: `e2e/**`, `**/*.e2e.spec.ts` → 양쪽 |
| **시연 리허설** | 5.5 | 3회 모두 양쪽 동시 참여 | (오프라인 합의) |
| **runbooks** | 5.6 | 트랙 A는 인프라·DR, 트랙 B는 클라이언트·마켓 절차 | CODEOWNERS: `runbooks/**` → 양쪽 |
| **보안 게이트** | NFR-SEC-05 | Trivy/CodeQL/gitleaks 위반은 양쪽 모두 알림 + 머지 차단 합의 | Status Check 필수: `security-scan` 통과 없이 머지 불가 + CODEOWNERS: `.github/workflows/*security*` → 양쪽 |
| **AI Base Code** | 2.12, 3.4.5, 3.5.x | Provider 추상화 인터페이스 변경 시 양쪽 검토 (트랙 B는 클라이언트 사용성 검증) | CODEOWNERS: `backend-python/app/ai/**` → 양쪽 |
| **핵심 문서** | TDR / WBS / Requirements / RACI / CONTEXT | 단일 진실 공급원 일관성 유지 | CODEOWNERS: `documents/04.Design/Technical_Decision_Records.md`, `documents/02.Planning/WBS.md`, `documents/01.Ideation/Requirements.md`, `documents/02.Planning/RACI.md`, `documents/CONTEXT.md` → 양쪽 |

### 8.1 Branch Protection 목표 설정 (WBS 1.7 산출물)

> ⚠️ **현행 환경(GitHub Free private)에서는 Branch Protection/Rulesets 강제가 미작동**합니다(GitHub 정책: Free 플랜은 public 레포에서만 강제). 본 절은 **목표 정책의 단일 진실 공급원**이며, 향후 (a) Public 전환, (b) Pro/Team 업그레이드, (c) 무료 유지 중 결정(Q9, M3 전)에 따라 활성화 시점이 정해집니다. 그 사이에는 §8 본문의 다층 완화로 운영합니다.

`main` 브랜치에 다음 규칙을 적용합니다(활성화 시):

1. **Require pull request reviews before merging**: ON
   - **공동 영역(CODEOWNERS 매칭)**: `Required approving reviews = 2`
   - **단독 영역**: `Required approving reviews = 1` (시니어 2인 환경에서 R6+R11 추가 완화)
   - `Dismiss stale pull request approvals when new commits are pushed`: ON
   - `Require review from Code Owners`: ON
2. **Require status checks to pass before merging**: ON
   - 필수 체크: `lint`, `test-backend`, `test-frontend`, `build`, `trivy`, `codeql`, `gitleaks`, **`codeowner-approval`**(WBS 3.1.3에서 추가하는 CODEOWNER 승인 검증 Action — Free 환경에서도 동작)
   - `Require branches to be up to date before merging`: ON
3. **Require linear history**: ON — main 브랜치 머지 커밋 난립 방지
4. **Require signed commits**: 권장 (정책 확정 후 ON)
5. **Include administrators**: ON — 관리자도 우회 불가
6. **Allow force pushes / deletions**: OFF

### 8.2 Free 환경에서의 현행 운영 메커니즘

| 메커니즘 | 작동 여부 (Free private) | 효과 |
|---|---|---|
| **CODEOWNERS 리뷰 자동 요청** | ✅ 작동 | PR 생성 시 매칭 owner에게 자동 review request 발송 — 누락 방지의 1차 안전망 |
| **CONTRIBUTING.md v1.1.0 §3 정책** | ✅ (정책 의무) | 2 approvals 공동 / 1 approval 단독 / self-merge 금지를 정책으로 명문화. 위반 시 사후 회고에서 점검 |
| **CI 기반 CODEOWNER 승인 검증 Action** | ✅ (WBS 3.1.3 이후) | PR이 CODEOWNERS 매칭 리뷰어 승인 없이 머지되지 않도록 GitHub Actions에서 검증, 실패 시 머지 차단 알림 |
| **시니어 2인 신뢰 기반 운영** | ✅ | 데일리 15분 동기화 + 주간 회고로 위반 조기 감지 |
| Branch Protection 강제 (Required reviews/Status check 머지 차단) | ❌ 미작동 (Free 정책) | Q9 결정 이후 활성화 |

---

## 9. 동기화 리듬

| 주기 | 형식 | 시간 | 참석 |
|---|---|---|---|
| **매일** | 데일리 동기화 | 15분 | A+B |
| **매주 일요일** | 주간 회고 (WBS 진척·블로커·다음주 계획) | 60분 | A+B |
| **마일스톤 도달 시** | 게이트 회고 (M1~M7) | 90분 | A+B |
| **PR 리뷰** | 비동기 | 24h SLA | **공동 영역은 양쪽 (2 approvals, 강제) / 단독 영역도 상호 1 approval 필수** (시니어 2인 환경에서 self-merge 금지) |
| **PoC 결정 회의** | LLM(Q1)·OCR(Q2) | 60분 × 2회 | A+B (W3~W4 중) |

> 💡 R11 완화 차원에서 **API 계약 변경은 비동기 PR이 아닌 30분 동기 합의 후 PR 작성** 원칙.

---

## 10. 갱신 정책

*   **Minor 갱신:** 트랙 책임 영역 미세 조정, 작업 추가/삭제 시 패치 버전(v0.1.x).
*   **Major 갱신:** 분업 모델 자체 변경(예: 인력 추가, 트랙 통합)·마일스톤 도달 시 마이너 버전(v0.2.0+).
*   **연동 문서:** WBS / Requirements 변경 시 본 문서 영향 검토 후 동시 갱신.
*   **첫 1주 후 재검토:** 2026-05-15 (W1 종료) 시점 트랙 분담 실효성 점검 회의에서 미세 조정.

---

## 📝 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v0.1.0 | 2026-05-08 | 최초 작성. 풀스택 시니어 2인(트랙 A 백엔드·AI·인프라 / 트랙 B 프론트·모바일·점주) 분업 모델 정의, WBS v0.2.0의 모든 Task에 RACI 매핑, 공동 영역 6항목 명시(R11 완화), 동기화 리듬(데일리 15분 / 주간 60분 / PoC 게이트 회의) 정의. | 숭늉 |
| v0.1.1 | 2026-05-08 | WBS v0.3.0 동기화 + 강제 메커니즘 보강. §2 Phase 1 신규 1.7(Branch Protection) RACI 추가 + 1.8 회고 ID 이동, §3 Phase 2 신규 2.12(AI Base Code) RACI 추가 + 2.13 회고 ID 이동, §8 공동 영역 표에 **"강제 메커니즘" 컬럼 추가**(CODEOWNERS 경로 매핑 명시) + AI Base Code·핵심 문서 영역 신규 추가, **§8.1 Branch Protection 필수 설정 6항목**(2 approvals/1 approval/Status Check/linear history/admin 포함/force push 차단) 신설, §9 PR SLA에 단독 영역 상호 1 approval 의무 명시. | 숭늉 |
| v0.1.2 | 2026-05-08 | **GitHub Free private 환경 제약 반영**. §8 머리말 갱신: "기술 강제" → "목표는 기술 강제이나 Free 환경 미작동, 다층 완화로 운영". §8.1 머리말에 Free 환경 제약 경고 박스 추가, Status Check 필수 항목에 `codeowner-approval`(WBS 3.1.3) 추가. **§8.2 신설**: Free 환경 현행 운영 메커니즘 4종(CODEOWNERS 리뷰 요청 / CONTRIBUTING 정책 / CI 검증 Action / 시니어 2인 신뢰)과 작동 여부 매트릭스. WBS v0.4.0·Requirements v0.1.3과 동기화. | 숭늉 |
