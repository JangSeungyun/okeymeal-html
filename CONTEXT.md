---
title: 프로젝트 현황 컨텍스트 (AI 핸드오프 문서)
version: v1.24.0
last_updated: 2026-05-19
author: 숭늉
---

# 🔄 OkeyMeal 프로젝트 현황 컨텍스트

> **AI 에이전트를 새로 소환할 때 이 파일을 먼저 읽히세요.**
> 세션이 끊기거나 AI를 전환(Gemini ↔ Claude Code 등)할 때 전체 맥락을 빠르게 복구하기 위한 원페이지 현황 문서입니다.

---

## 1. 프로젝트 한 줄 요약

> **OkeyMeal(오키밀)** — 외국인 관광객의 식이 제약(알레르기/비건/할랄)과 언어 장벽을 AI로 해결하는 안심 미식 케어 플랫폼. MVP 지역: 제주도.

---

## 2. 핵심 컨텍스트

| 항목 | 내용 |
|---|---|
| **서비스명** | OkeyMeal (오키밀) |
| **공모전 제출 기한** | **2026-05-06 (제안서 제출 완료)** |
| **정식 배포 데드라인** | **2026-09-30** (WBS 기준) |
| **현재 집중 단계** | **Phase 1 분석 완료 (M1 ✅ Go, 2026-05-19) → Phase 2 설계 진입 (2026-05-20, W3)** |
| **프로젝트 인력** | **풀스택 시니어 2인 (15년차)** · 트랙 A(백엔드·AI·인프라) + 트랙 B(프론트·모바일·점주). 분업 RACI: [`02.Planning/RACI.md`](./02.Planning/RACI.md) |
| **브랜드 캐릭터** | 숭늉 정령 "스눙스터 (Snungster)" |
| **MVP 지역** | 제주특별자치도 |
| **공모전** | 2026 한국관광공사 관광데이터 활용 공모전 (웹/앱 개발 부문) |
| **저장소 구조** | Monorepo (`okeymeal/`) — TDR §4.7 |
| **GitHub 레파지토리** | https://github.com/JangSeungyun/okeymeal.git (2026-05-07 초기 푸시 완료) |
| **로컬 작업 위치** | 각 협업자가 클론한 로컬 레포 루트 (경로는 환경별 상이) |
| **문서 저장소** | `./documents/` (레포 루트 하위, 마크다운 기반) |
| **AI 협업 규칙** | `CONTRIBUTING.md` (커밋·PR·AI 푸터 금지), `documents/AI_Docs_Guide.md` (문서 작성), `documents/AI_Agent_Guide.md` (에이전트 운용) |

### 확정된 핵심 기술 스택 (TDR v3.1.0 기준)

| 영역 | 결정 사항 |
|---|---|
| **프론트엔드** | React 19 / Vite 7 / FSD / Zustand / i18next |
| **모바일** | Capacitor (Android 우선, iOS Phase 2) |
| **백엔드 코어** | Spring Boot 4.0 / Java 25 (LTS) / Gradle 멀티모듈(api·core·infra·common) |
| **백엔드 AI** | FastAPI / Python 3.13 |
| **DB** | PostgreSQL 18 + PostGIS + pgvector (HNSW) |
| **캐시·세션** | Valkey 8.x (Redis BSD-3 fork, 라이선스 무료) |
| **인증** | JWT (Access 30분 / Refresh 30일 회전) + 소셜(Google·Apple·Kakao·Naver) |
| **AI/LLM (후보)** | Gemini / Claude / GPT 비교 진행 중. 워크로드별 분리 매핑 (PoC 후 확정) |
| **임베딩** | Gemini `text-embedding-004` 768d (1차 후보), 코사인 유사도 |
| **지도** | Google Maps(Main) + Kakao(주소) + Naver(대중교통) 멀티 프로바이더 |
| **푸시** | FCM 단일(Android·iOS·Web) |
| **인프라** | Single VM (4·8 vCPU 권장) / Docker Compose / Nginx Blue-Green |
| **CI/CD** | GitHub Actions (OIDC, Trivy/CodeQL/gitleaks 보안 스캔) |
| **로깅·모니터링** | Loki + Promtail + Prometheus + Grafana |
| **안정성** | Resilience4j (Timeout / Retry / CB / Bulkhead / Fallback / DLQ) |

---

## 3. 현재 진행 단계

```
[완료] 01.Ideation  →  [완료] 02.Planning  →  [완료] 03.Proposal
→  [완료] 04.Design(TDR/WBS)  →  [✅ M1 통과] Phase 1 분석  →  [★ 진행 중] Phase 2 설계 (W3-W6)  →  [대기] 05.Development  →  [대기] 06.Testing  →  [대기] 07.Final_Submission
```

> **상태 업데이트 (2026-05-19 — M1 게이트 ✅ Go, Phase 1 종료):**
> **WBS Task 1.8 M1 게이트 회고록 v1.0.0 작성 + Phase 1 분석 단계 종료 + Phase 2 설계 진입 결정.** 산출물 `00.Meetings/2026-05-19-m1-retrospective-01.md`. ① **KPT 회고**: Keep 5건(K1 정합성 관리·K2 WBS.md↔html 동기화 정책화·K3 R11·R12 사전 대응·K4 Q9 신속 처리·K5 변경 이력 슬림화), Problem 4건(P1 산출물 집중 부담·P2 식이 특화 리서치 권한 제약·P3 변경 이력 묶음 검토·P4 2인 분업 실제 시작 지연), Try 4건(T1 W3 직전 V1~V4+R16 후속 검증·T2 W2 안에 Base Code 인터페이스 스케치·T3 매주 일요일 회고 시작·T4 두 번째 협업자 합류 체크리스트). ② **M1 게이트 통과 판단**: 산출물 7건 모두 충족, 종합 판단 **✅ Go** (조건부: 두 번째 협업자 합류 M2 게이트(2026-06-16) 전 필수). ③ **결정 사항 4건**: M1 Go / 조건부 협업자 합류 / 후속 검증 일정 5월 20~22일 / WBS 2.12 PoC W3 시작 즉시. ④ **Action Items A1~A7** 등록(트랙 A 소유 4건 / 트랙 B 소유 1건 / 양 트랙 공동 2건). 동기화: WBS.md Task 1.8 ✅, README v1.8.0 → v1.9.0(00.Meetings 회고록 인덱스 추가), §3 현재 집중 단계 "Phase 1 진행 중" → "Phase 1 완료 / Phase 2 진입(2026-05-20)" 갱신.

> **상태 업데이트 (2026-05-18, 후속 — WBS Task 1.6 ✅):**
> **Risk_Register.md v1.0.0 신규 작성.** WBS Task 1.6 완료, M1 게이트 1.5·1.6·1.8 잔여 중 2개 완료. ① §2.1 **핵심 리스크 R1~R12** WBS §6과 SSOT 동기화(소유자·트리거 조건·잔여 위험·마감일 컬럼 신규). ② §2.2 **분석 단계 추가 식별 리스크 R13~R18 6건**: R13 신규 진입자(AI OCR×ISO×다국어 결합)·R14 K-PIPA DPO 미지정 + 14세 미만·국외 이전·R15 점주 콘솔 다국어 입력 부담·R16 공공 데이터(Visit Korea) 라이선스·R17 외국인 결제·OAuth 지역 제약·R18 페르소나 D(60대 점주) 디지털 리터러시. ③ §3 **가정 A1~A8**(데드라인 절대 / 시니어 2인 풀가동 / MVP 제주 / iOS 후순위 / Free private 유지 / LLM PoC 후 결정 / 멀티 맵 SDK 가용 / 공공 API 무료). ④ §4 이슈 — 분석 단계 종료 시점 활성 없음. ⑤ §5 의존성 외부 D1~D7(Google Play·TourAPI·식약처·OCR·Maps·FCM·LLM) + 내부 D8~D11(WBS 사슬). ⑥ §6 모니터링·에스컬레이션·소유자 정책 명문화. **SSOT 정책**: Risk_Register가 정본, WBS §6은 요약 미러(R13·R15·R18은 다음 WBS 버전 업 시 §6 미러링 후보). 동기화: WBS.md Task 1.6 ✅, WBS.html Phase 1 산출물 카드 Risk_Register v1.0.0 표기, README v1.7.0 → v1.8.0. **남은 작업**: 1.8 M1 게이트 회고(2026-05-19).

> **상태 업데이트 (2026-05-18 — WBS Task 1.5 ✅):**
> **Competitor_Benchmark.md v1.0.0 신규 작성.** WBS Task 1.5 완료. 5개 경쟁 서비스 분석: ① **종합 맛집 3종** — 망고플레이트(국내 영문 콘텐츠 빈약·운영 축소 이슈), Visit Korea Food(공공 다국어 10+종·정적 큐레이션·할랄 분류 별도 가이드), Yelp(한국 사실상 비활성·식당 단위 카테고리 필터). ② **식이 특화 2종** — HappyCow(비건/할랄 라이프스타일 태그·한·일·중 UI 미흡), Fig(50+ 식이 프로필 매칭·식료품 라벨 OCR·영어 단일·메뉴 OCR은 베타). ③ **차별화 5축 가설 1차 검증**: A) AI 메뉴 OCR × ISO 알레르겐 × 다국어 결합 직접 경쟁자 사전 지식 기준 **없음**(시장 공백 가설 유효) / B) 점주 콘솔(다국어 메뉴 입력) B2B 사이드 비어 있음 / C) 동아시아(ko/ja/zh-CN) 관광객 사각지대 / D) End-to-End 시나리오 통합 우위 / E) B2B 수익 모델 가설 단계. ④ **Phase 2/3 인사이트 I1~I7**: Safe/Avoid 신호등 UX(Fig 차용)·Visit Korea Cold-start 시드·할랄 분류 표준 채택·커뮤니티 부트스트랩·점주 광고 회피·점주 콘솔 다국어 보조 UI·V1~V4 W3 재검증. ⑤ **제한사항**: 식이 특화 2종은 사전 지식(2026-01 컷오프) 의존 — 후속 검증 V1~V4(HappyCow UI/가격·Fig 메뉴 OCR·Spoonful 식별·신규 진입자)를 Phase 2 W3 직전 재조사. 동기화: WBS.md Task 1.5 ✅, WBS.html Phase 1 산출물 카드, README v1.6.0 → v1.7.0.

> **상태 업데이트 (2026-05-11, 후속 3 — System_Architecture.md v2.0.0 ✅):**
> **시스템 아키텍처 정의서 v1.1.0 → v2.0.0 — TDR v3.1.0 기준 전면 재작성.** ① §1 구성도 Mermaid 재구성: Java 멀티모듈(`okeymeal-api`·`core`·`infra`·`common`) + Python AI(FastAPI 3.13) 분리, LLM Provider 추상화(Gemini/Claude/GPT 후보, Q1 미결), Valkey 8.x, 멀티 맵(Google Main + Kakao 주소 + Naver 대중교통 + `MapClient` 추상화), FCM 단일 채널, Loki+Promtail+Prometheus+Grafana, GitHub Actions OIDC/Trivy/CodeQL/gitleaks 노드 추가. ② §2 레이어 표 전면 갱신(React 19/Vite 7, PostgreSQL 18 + pgvector HNSW + 임베딩 768d, 점주 콘솔 `owner.okeymeal.kr` 별도 서브도메인, 소셜 4종 Google·Apple·Kakao·Naver, JWT TTL 정책). ③ §3 데이터 흐름 재작성: AI 렌즈 시퀀스에 ISO 룰엔진 우선 + LLM 보조 + 30분 자동 삭제 명시, QR 알림에 nonce 60초 + Quiet Hours 22~08, 추천 RAG 5단계 신규. ④ §4 환경 구성 신규(1단계 논리/2단계 물리, Single VM 4·8 vCPU, Blue-Green 4단계, CI/CD 8항, 모노레포 구조). ⑤ §5 K-PIPA 8항 신규(14세 미만·10일 SLA·DPO·국외 이전·자동화 의사결정 등). ⑥ §6 Resilience4j 6패턴 + 외부 API Stale 데이터 + 관측 임계치. ⑦ §7 미결 결정(Q1·Q2·Q4·Q5) + 점진적 강화 트리거 5종. 동기화: CONTEXT.md 산출물 표 갱신, README v1.5.0 → v1.6.0(System_Architecture v2.0.0 인덱스 갱신).

> **상태 업데이트 (2026-05-11, 후속 2 — WBS Task 1.3 ✅):**
> **Target_Persona.md v1.1.0 → v1.2.0 — 페르소나 검증·갱신.** 검증 결과 페르소나 4명(A 마크 / B 아미나 / C 다나카 / D 고순자)은 MVP 스코프(TDR v3.1.0 §0)·Requirements §3.1과 정합 — 추가·제외·대체 불필요. 보강: ① **SSOT 정책 명문화**: 페르소나 서사 정본은 본 문서, FR 매칭표 정본은 Requirements §3.1, 양방향 동기화 의무. ② **각 페르소나 표에 "매칭 FR ID" 행 신규 추가**(A: USR-3.1~3.4 + INF-04·USR-2.2 / B: USR-1.1·2.1·2.2 + INF-02·03 / C: USR-1.1·2.2·3.4 + INF-01·03 + NFR-A11Y-04 / D: OWN-1.1·2.1~2.4 + INF-05 + NFR-A11Y-04 + CON-08). ③ C·D 페르소나에 접근성·SOS·FCM 연계 명시. 동기화: WBS.md Task 1.3 ✅, WBS.html Phase 1 산출물 카드, README v1.4.0 → v1.5.0.

> **상태 업데이트 (2026-05-11, 후속 — WBS Task 1.4 ✅):**
> **Core_Features.md v1.4.0 → v1.5.0 — TDR v3.1.0·Requirements v0.1.4 정합 전면 갱신.** ① **SSOT 정책 명문화**: 본 문서는 ID·우선순위·1줄 명세 인덱스로 한정, AC·사용자 스토리·의존성·WBS 매핑의 정본은 Requirements §7. ② **기술 명세 갱신** 7건: INF-02 LLM Provider 추상화(EXT-09)·워크로드별 분리(Q1 미결) / INF-03 3계층 + JSONB 사전 번역 / INF-04 OCR 엔진 Q2 미결 표기 / INF-05 FCM 단일 채널(기존 "Web Push/Socket" 부정확) / INF-06 Guest JWT 90일·OAuth 4종·점주 Refresh 7일 / USR-2.1 Google(메인)+Kakao+Naver 멀티 프로바이더+`MapClient` / USR-2.3 Naver Directions. ③ **핵심 AC 보강**: P95 임계값, ISO 코드 룰엔진 우선·LLM 보조, 30분 자동 삭제, 면책 문구, QR nonce 60초, 색맹 대응 등 비고 컬럼 통합. ④ **§4 MVP 의도적 제외 항목 신규**(예약·결제·iOS·자체 추천 모델·USR-1.3 Health Sync). ⑤ **§5 단계별 구현 로드맵 WBS v0.4.0 기준 재작성**(5 Phase × 21주 × 7 마일스톤). 동기화: WBS.md Task 1.4 ✅, WBS.html Phase 1 산출물 카드, README v1.3.0 → v1.4.0.

> **상태 업데이트 (2026-05-11):**
> **Q9 해결 — GitHub Free private 유지 확정.** 사용자 결정으로 Public 전환·Pro 업그레이드 모두 보류, **Free 플랜 private 유지**로 확정. Branch Protection Ruleset 강제 미작동은 (a) CODEOWNERS 자동 리뷰 요청 + (b) CONTRIBUTING.md 정책 명문화 + (c) WBS 3.1.3 `codeowner-approval` CI Action + (d) 시니어 2인 신뢰 4단계 다층 완화로 통제(Requirements NFR-MAINT-06, WBS R11). Requirements v0.1.3 → v0.1.4 갱신: §16 Q9를 본 표에서 분리하여 신규 "✅ 해결된 결정" 표로 이전, §15.2 M1 게이트 행에서 "Q9 추적 사안으로 보류" → "Free 유지 확정, 다층 완화로 통제"로 갱신. 영구 메모리 `project_github_free_private.md` 저장(향후 세션에서 Public/Pro 옵션 재제안 차단).

> **상태 업데이트 (2026-05-08, 후속 5):**
> **WBS.md ↔ WBS.html 동기화 규칙 명문화 + WBS.html v0.4.0 본문 미러링.** v0.3.0 → v0.4.0 갱신 시 WBS.html이 누락된 채 방치되어 있던 사례를 발견하여, **WBS.md 수정 시 WBS.html을 동일 커밋에서 함께 갱신하는 규칙**을 명문화했습니다. ① WBS.md §7 본 문서 갱신 정책에 "🔁 WBS.html 동기화 의무 (필수)" bullet 추가, ② WBS.html §8 진척 관리 규칙에도 동일 bullet 미러링(이중 안전장치), ③ WBS.html 헤더 v0.3.0 → v0.4.0, Phase 1 산출물 카드·병렬화 영역·R11 완화책 cell을 v0.4.0 본문에 맞춰 동기화. ④ 영구 메모리에 `feedback_wbs_md_html_sync.md` 저장(향후 모든 세션 자동 적용).

> **이전 상태 업데이트 (2026-05-08, 압축):**
> - **초기 — Phase 1 진입 + 인력 2인 변경**: Requirements.md v0.1.0 / WBS.html 신규. 1인 가정 → 풀스택 시니어 2인(15년차) 결정 → WBS v0.2.0·Requirements v0.1.1·RACI v0.1.0 동기화.
> - **후속 1 — Cross-Review 강제 + AI PoC 자산화**: WBS v0.3.0(Task 1.7 Branch Protection·2.12 Base Code 신규), Requirements v0.1.2(NFR-MAINT-06 신규), RACI v0.1.1(§8 강제 메커니즘 컬럼), CONTRIBUTING v1.1.0, README v1.1.0.
> - **후속 2 — 인프라·인벤토리 셋업**: External_API_Inventory v0.1.0(WBS 1.2 ✅), `.github/CODEOWNERS` 신규(WBS 1.7 착수), README v1.2.0.
> - **후속 4 — Free 환경 제약 반영 + Task 1.7 ✅**: Free private에서 Branch Protection Ruleset 강제 미작동 확인 → 옵션 2(다층 완화) 채택. WBS v0.4.0·Requirements v0.1.3·RACI v0.1.2·README v1.3.0 일괄 동기화.
>
> (상세는 git log 또는 §변경 이력 참고)

### 완료 및 진행 중 산출물

| 문서 | 버전 | 위치 | 상태 |
|---|---|---|---|
| 외부 API 인벤토리 | **v0.1.0** | `04.Design/External_API_Inventory.md` | ✅ 완료 (WBS 1.2, 2026-05-08) |
| CODEOWNERS | - | `.github/CODEOWNERS` | ✅ 작성 완료 (WBS 1.7, Free 환경 다층 완화로 마무리, 2026-05-08) |
| 기술 결정 정의서 (TDR) | **v3.1.0** | `04.Design/Technical_Decision_Records.md` | ✅ 완료 (스코프·AI 알고리즘 확정) |
| WBS (작업 분해 구조) | **v0.4.0** | `02.Planning/WBS.md` | ✅ 갱신 (Free 환경 반영, 2026-05-08) |
| 분업 RACI 매트릭스 | **v0.1.2** | `02.Planning/RACI.md` | ✅ 갱신 (§8.2 Free 환경 운영 메커니즘 신설, 2026-05-08) |
| 요구사항 명세서 | **v0.1.4** | `01.Ideation/Requirements.md` | ✅ 갱신 (Q9 해결: Free private 유지 확정, 2026-05-11) |
| 상세 기능 정의서 (Core_Features) | **v1.5.0** | `02.Planning/Core_Features.md` | ✅ 갱신 (WBS 1.4, TDR v3.1.0·Requirements v0.1.4 정합, 2026-05-11) |
| 타겟 페르소나 분석서 | **v1.2.0** | `02.Planning/Target_Persona.md` | ✅ 갱신 (WBS 1.3, SSOT 명문화 + 매칭 FR ID 매핑, 2026-05-11) |
| 경쟁 서비스 벤치마크 | **v1.0.0** | `02.Planning/Competitor_Benchmark.md` | ✅ 신규 (WBS 1.5, 5개 서비스 × 7축 매트릭스 + 차별화 5축 + V1~V4 후속 검증, 2026-05-18) |
| 리스크 레지스터 (RAID) | **v1.0.0** | `02.Planning/Risk_Register.md` | ✅ 신규 (WBS 1.6, R1~R12 SSOT 동기화 + R13~R18 + A1~A8 + D1~D11, 2026-05-18) |
| M1 게이트 회고록 | **v1.0.0** | `00.Meetings/2026-05-19-m1-retrospective-01.md` | ✅ 신규 (WBS 1.8, KPT + Go 결정 + Action Items A1~A7, 2026-05-19) |
| 기여 가이드 (CONTRIBUTING) | **v1.1.0** | `CONTRIBUTING.md` (레포 루트) | ✅ 완료 (2026-05-08) |
| 문서 인덱스 (README) | **v1.9.0** | `documents/README.md` | ✅ 갱신 (Task 1.5·1.6·1.8 동기화, 2026-05-19) |
| 시스템 아키텍처 | **v2.0.0** | `04.Design/System_Architecture.md` | ✅ 갱신 (TDR v3.1.0 기준 전면 재작성, 2026-05-11) |
| DB 스키마 (초안) | v1.0.0 | `04.Design/DB_Schema.md` | 🔄 ERD 작성 후 재정의 예정 |
| 리스크 레지스터 | - | `02.Planning/Risk_Register.md` | ⬜ Phase 1 (WBS 1.6) 작성 예정 |

---

## 4. MVP 스코프 (TDR §0)

### ✅ 포함 범위
*   **사용자 앱 (웹 + Android):** 회원/Guest 인증, 식이 프로필, 식당 탐색·추천, **AI 렌즈(메뉴판 OCR)**, 다국어(ko/en/ja/zh-CN), 리뷰.
*   **점주 콘솔:** **`owner.okeymeal.kr` 별도 서브도메인** (동일 백엔드 API, `apps/owner/` 별도 Vite 엔트리).
*   **데이터 파이프라인:** TourAPI + 식약처 API 융합, 다국어 사전 번역, 임베딩 생성.

---

## 5. 다음 작업 목록 (Next Actions)

### Phase 1 분석 (현재 진행 중)
- [x] **[01.Ideation]** 요구사항 명세서 작성 (`Requirements.md` v0.1.4) — WBS 1.1
- [x] **[04.Design]** 외부 API 인벤토리 작성 (`External_API_Inventory.md` v0.1.0) — WBS 1.2
- [x] **[Infra]** WBS Task **1.7** CODEOWNERS 작성 + R11 완화 정책 명문화 (Free 환경 다층 완화 채택, Q9 추적 — 2026-05-08)
- [x] **[02.Planning]** Core_Features.md MVP 스코프 반영 갱신 (`Core_Features.md` v1.5.0) — WBS 1.4 (2026-05-11)
- [x] **[02.Planning]** 사용자 페르소나 검증·갱신 (`Target_Persona.md` v1.2.0) — WBS 1.3 (2026-05-11)
- [x] **[02.Planning]** 경쟁 서비스 벤치마크 (`Competitor_Benchmark.md` v1.0.0) — WBS 1.5 (2026-05-18)
- [x] **[02.Planning]** 리스크 레지스터 작성 (`Risk_Register.md` v1.0.0) — WBS 1.6 (2026-05-18)
- [x] **[M1 게이트]** 분석 단계 회고 (`00.Meetings/2026-05-19-m1-retrospective-01.md` v1.0.0) — WBS 1.8 (2026-05-19, ✅ Go 결정)

### Phase 2 설계 (M1 게이트 통과 후)
- [ ] ERD / 도메인 모델
- [ ] AI 추천 알고리즘 상세 설계서
- [ ] API 명세서 (사용자/점주 분리)
- [ ] 와이어프레임 + UI 디자인
- [ ] 점주 콘솔 별도 설계
- [ ] DB 마이그레이션 V1 골격
- [ ] 보안 위협 모델링 (STRIDE)

---

## 6. 미결 결정 사항 (Open Questions)

| # | 영역 | 미결 사항 | 결정 시점 |
|---|---|---|---|
| Q1 | **AI/LLM** | Gemini / Claude / GPT 중 워크로드별 Primary 모델 확정 (W1~W4) | Phase 2 PoC 후 |
| Q2 | **AI 렌즈** | OCR 엔진 선택 (Google Cloud Vision vs Gemini Vision 단독) | Phase 2 |
| Q3 | **법무** | 개인정보 제공 동의 문구 법적 적정성 검토 (개발 초기 단계) | Phase 3 초반 |
| Q4 | **인프라** | 단일 VM 클라우드 제공자 결정 (GCP `e2-standard-8` vs AWS `m6i.xlarge` vs NCP) + 비용 검토 | Phase 2 후반 |
| Q5 | **K-PIPA** | DPO(개인정보 보호책임자) 지정 | 운영 시작 전 |
| Q6 | **마켓** | Google Play 개발자 계정 등록 ($25) 시점 | 2026-08-01 (WBS MK1) |

### ✅ 해결된 결정 (이전 Open → 확정)
*   ~~Kakao/Google Maps 듀얼 엔진 전환 로직~~ → **Google Maps Main + Kakao(주소) + Naver(대중교통) 멀티 프로바이더 + `MapClient` 추상화** (TDR §1.6)
*   ~~Q7: GitHub Free private에서 Branch Protection 강제 미작동 — Public/Pro/Free 중 결정~~ → **GitHub Free private 유지** 확정 (2026-05-11). 강제 미작동은 CODEOWNERS + CONTRIBUTING + WBS 3.1.3 CI Action + 시니어 신뢰 4단계 다층 완화로 통제. Requirements §16 Q9도 동일 결정으로 해결. 향후 Public 전환·Pro 업그레이드 재검토는 사용자 명시 요청 시에만.

---

## 7. 핵심 설계 원칙 (Design Principles)

1. **신뢰 우선 (Trust First):** 식약처 DB → 점주 직접 입력 → LLM AI 추론 순으로 데이터 신뢰도 우선순위 적용. AI 렌즈에서도 알레르기 정보는 ISO 코드 룰엔진 결과를 우선 표시.
2. **제로 배리어 (Zero Barrier):** 외국인이 회원가입 없이도 핵심 기능(AI 렌즈) 즉시 사용 가능 (Guest JWT 90일).
3. **글로벌 스탠다드 (Global Ready):** 4개 언어(ko/en/ja/zh-CN) 3계층 i18n + Google/Apple/Kakao/Naver 소셜 인증 + 다국어 에러 응답.
4. **운영 안정성 (OpEx):** Blue-Green 무중단 배포 + Resilience4j 다층 회복 + Loki/Prometheus 통합 관제 + WAL 1분 RPO.
5. **점진적 강화 (Progressive Hardening):** 1단계 논리 분리(환경/저장소/CDN) → 2단계 물리 분리, mTLS 전환 트리거 명시.

---

## 8. AI 핸드오프 메모 (Next Session 시작 시 읽기)

### 🆕 작업 환경 변경 안내 (2026-05-07 적용)
*   **이전 (Deprecated):** Google Drive 단독 관리 `documents/` 폴더 — 더 이상 작업 대상 아님(향후 archive 처리 검토).
*   **현재 (Active):** GitHub 레포 `JangSeungyun/okeymeal` (브랜치 `main`)을 클론한 **로컬 작업 디렉토리**. 협업자별로 경로가 다를 수 있으므로 본 문서에는 절대 경로를 명시하지 않습니다.
*   **GitHub Origin:** `https://github.com/JangSeungyun/okeymeal.git`
*   **레포 구조:** TDR §4.7 모노레포 구조. **현재 존재**: `./README.md`, `./CONTRIBUTING.md`, `./documents/`, `./.github/PULL_REQUEST_TEMPLATE.md`. 향후 `./backend-java/`, `./backend-python/`, `./frontend/`, `./infra/`, `./runbooks/`, `./.github/workflows/` 순차 추가 예정.
*   **새 세션 시작 시 체크:** Google Drive 경로가 아닌 **Git 클론된 로컬 레포 루트**에서 작업 중인지 반드시 확인. 두 위치에 동일 파일이 존재할 수 있어 잘못된 경로에서 작업하면 변경분이 origin에 반영되지 않습니다.

### 직전 세션 작업 요약 (2026-05-19 — M1 게이트 회고 + Phase 1 종료 결정)
1. **회고록 작성**: `00.Meetings/2026-05-19-m1-retrospective-01.md` v1.0.0. 8개 Task(1.1~1.8) 전체 ✅ 확인 + 보강 산출물 5종(TDR / System_Architecture / RACI / WBS / CONTRIBUTING).
2. **KPT 회고 — Keep 5건**: K1 정합성 관리(SSOT 정책 일관 적용) / K2 WBS.md↔html 동기화 정책화 / K3 인력 2인 변경 직후 R11·R12 사전 등록 + 완화책(1.7·2.12·3.1.3) 즉시 반영 / K4 Q9 결정 9일 만에 처리 + "해결된 결정" 표 분리 패턴 / K5 CONTEXT.md 변경 이력 슬림화(v1.18.0).
3. **KPT 회고 — Problem 4건**: P1 산출물 집중 부담(1.3·1.4·1.5·1.6이 7일 안에 처리) / P2 식이 특화 리서치 WebSearch/WebFetch 권한 거부로 사전 지식 의존 → V1~V4 W3 직전 재검증 필수 / P3 변경 이력 행 누적(v1.16 → v1.23 7회) — 다음 회고에서 묶음 정책 결정 / P4 두 번째 협업자 실제 합류·CODEOWNERS 핸들 교체 지연.
4. **KPT 회고 — Try 4건**: T1 5월 20~22일 안에 Competitor V1~V4 + Risk_Register R16(Visit Korea 라이선스) 일괄 / T2 WBS 2.12 Base Code 인터페이스 W2 마지막 영업일 안에 스케치 → W3 첫날 PoC 즉시 가동 / T3 매주 일요일 회고 시작(첫 회고 2026-05-24) / T4 두 번째 협업자 합류 시 체크리스트(CODEOWNERS 핸들 교체·RACI 미팅·Risk_Register 트랙 B 리스크 인수인계).
5. **M1 게이트 판단**: 산출물 7건 모두 충족, 종합 판단 **✅ Go**. 조건부: 두 번째 협업자 합류는 M2(2026-06-16) 전 필수.
6. **Action Items A1~A7 등록**: A1 V1~V4 후속 검증(5/22) / A2 Visit Korea 라이선스 확인(5/22) / A3 Base Code 인터페이스 스케치(5/22) / A4 두 번째 협업자 합류·CODEOWNERS 교체(M2 전) / A5 매주 회고 시작(5/24) / A6 트랙 A Phase 2 W3 시작(5/20: 2.1·2.2·2.12) / A7 트랙 B Phase 2 W3 시작(5/20: 2.4·2.5·2.6).
7. **동기화**: WBS.md Task 1.8 ✅, README v1.8.0 → v1.9.0(00.Meetings 회고록 인덱스), CONTEXT §2 표 현재 집중 단계 "Phase 1 진행 중" → "Phase 1 완료 / Phase 2 진입(2026-05-20)" + §3 진행 단계 다이어그램 갱신 + 산출물 표 M1 회고록 추가 + §5 다음 작업 1.8 ✅.

### 직전 세션 작업 요약 (2026-05-18, 후속 — WBS Task 1.6 완료: Risk_Register.md v1.0.0)
1. **§2.1 핵심 리스크 R1~R12 WBS §6 동기화 + 확장 컬럼 신규**: 기존 #/리스크/영향/확률/완화책/버퍼 6컬럼 → **소유자·트리거 조건·잔여 위험·검토일** 4컬럼 추가하여 10컬럼. R11(분업 정합)의 Free 환경 4단계 다층 완화 명시 + Q9 해결 반영.
2. **§2.2 분석 단계 추가 발견 리스크 R13~R18 6건**:
   - **R13 (MARKET, 중/낮)** — 신규 진입자 출현. Competitor_Benchmark V4 W3 재조사가 트리거. 차별화 5축 중 B(점주 콘솔)·C(동아시아 UI)·D(End-to-End)가 모방 어려운 해자.
   - **R14 (LEGAL, 높/낮)** — K-PIPA DPO 미지정 + 14세 미만 + 국외 이전. Q5 결정 게이트.
   - **R15 (PARTNER, 중/중)** — 점주 콘솔 다국어 입력 부담. Competitor_Benchmark I6 직결. 한국어 입력 → LLM 자동 번역 + 점주 검수 패턴.
   - **R16 (LEGAL, 중/낮)** — 공공 데이터(Visit Korea Cold-start 시드) 라이선스. KOGL 표시 의무. **2026-05-22까지 한국관광공사 라이선스 확인 필요** (Phase 2 시작 전).
   - **R17 (TECH, 중/낮)** — 외국인 신용카드·소셜 로그인 지역 제약. 4종 OAuth + Guest JWT 90일로 우회. 결제는 MVP 제외.
   - **R18 (OPS, 중/중)** — 페르소나 D(60대 점주) 디지털 리터러시. NFR-A11Y-04 + 1:1 온보딩 + 동영상 매뉴얼.
3. **§3 가정 A1~A8 + §5 의존성 D1~D11**: 외부 D1~D7(Play·TourAPI·식약처·OCR·Maps·FCM·LLM Provider), 내부 D8~D11(WBS 사슬). Q1·Q2·Q4·Q5 미결이 R2·R5·R8·R14 활성화 트리거.
4. **§6 모니터링·소유자 정책**: 매주 일요일 회고 + 마일스톤 게이트 회고. 트랙 A 소유 10건 / 트랙 B 소유 5건 / 양 트랙 공동 3건(R6·R10·R11). 🟡 3주 지속 → 🔴 활성 에스컬레이션. 데드라인 영향 시 사용자 즉시 보고 + 비핵심 기능 Phase 2 이전 옵션.
5. **SSOT 정책**: Risk_Register가 정본, WBS §6은 요약 미러. R13·R15·R18은 영향·확률 "중/중" 이상이라 다음 WBS 버전 업 시 §6 미러링 후보로 명시.
6. **동기화**: WBS.md Task 1.6 ✅ + Risk_Register v1.0.0 명시, WBS.html Phase 1 산출물 카드(Risk_Register v1.0.0 버전 추가), README v1.7.0 → v1.8.0. **잔여 작업**: 1.8 M1 게이트 회고(2026-05-19).

### 직전 세션 작업 요약 (2026-05-18 — WBS Task 1.5 완료: Competitor_Benchmark.md v1.0.0)
1. **리서치 수행**: 일반 목적 에이전트 2개 병렬 — ① 종합 맛집 3종(망고플레이트·Visit Korea Food·Yelp) WebFetch/WebSearch 활용, ② 식이 특화 2종(HappyCow·Fig) WebFetch/WebSearch 권한 거부로 사전 지식(2026-01 컷오프) 기반. 사용자 결정으로 ②는 결과 활용 + 후속 검증 항목 명시.
2. **Competitor_Benchmark.md v1.0.0 신규**: ① §1 비교 대상 5개 + 페르소나(A·B·C·D) 매핑 / ② §2 **7축 매트릭스**(다국어·식이 필터·메뉴·추천·지도·외국인 진입 장벽·BM) / ③ §3 서비스별 상세 4-6 bullet / ④ §4 **차별화 5축 가설 검증 표**: A) AI OCR×ISO×다국어 결합 직접 경쟁자 사전 지식 기준 없음(공백 가설 유효) / B) 점주 콘솔 B2B 사이드 비어 있음 / C) 동아시아 ko/ja/zh-CN 사각지대 / D) End-to-End 시나리오 통합 / E) B2B 수익 가설 / ⑤ §5 Phase 2/3 인사이트 I1~I7 / ⑥ §6 제한사항 + 후속 검증 V1~V4.
3. **Phase 2 직접 반영 인사이트**: I1 Safe/Avoid 신호등 UX(Fig 차용, USR-3.1) · I2 Visit Korea 큐레이션 Cold-start 시드(2.2/2.8) · I3 한국관광공사 할랄 분류 표준 채택(2.1) · I6 점주 콘솔 한국어→4개국어 자동 번역 + 검수(2.6, 3.9.3) · I7 V1~V4 W3 직전 재검증.
4. **후속 검증 V1~V4**(Phase 2 W3 시작 전, 2026-05-20 ~ 05-22): V1 HappyCow 한·일·중 UI / V2 Fig 메뉴 OCR 실재 / V3 Spoonful 명칭 정확성 / V4 신규 진입자(2024~2026) 모니터링 — 시장 공백 가설 최종 검증.
5. **동기화**: WBS.md Task 1.5 ✅ + Competitor_Benchmark v1.0.0 명시, WBS.html Phase 1 산출물 카드(WBS.md ↔ html 동기화 규칙 준수), README v1.6.0 → v1.7.0(02.Planning 인덱스 Competitor_Benchmark 추가).

### 직전 세션 작업 요약 (2026-05-11, 후속 3 — System_Architecture.md v2.0.0 전면 재작성)
1. **갭 분석**: v1.1.0(React 18/Vite 6, Spring Boot 4.0 단일 백엔드, PostgreSQL 17, Gemini 단독, Kakao/Google 듀얼, 점주 웹 푸시만) ↔ TDR v3.1.0(React 19/Vite 7, Java 멀티모듈 + Python AI 분리, PostgreSQL 18 + pgvector HNSW, LLM Provider 추상화, 멀티 맵 + `MapClient`, FCM 단일, Valkey, Resilience4j, 점주 별도 서브도메인) 사이 15개 영역 차이 식별.
2. **§1 Mermaid 구성도 재구성**: Client(사용자 앱 + 점주 콘솔) → Edge(Nginx Blue-Green) → BackendJava(api·core·infra·common) ↔ BackendPython(FastAPI: Reco·RAG·Batch) → LLM(Gemini/Claude/GPT 후보) + External(OCR·Google/Kakao/Naver Maps·기상청·TourAPI·식약처·보건복지부·FCM) + Data(PG18·Valkey·FileStorage) + Ops(Loki·Prometheus·GitHub Actions).
3. **§2 레이어 표 전면 갱신** (3개 표): 프론트(사용자 앱/점주 콘솔 분리), 백엔드(Java 멀티모듈 + Python 하이브리드 + Java↔Python 통신 보안 3단계), 데이터 레이어(PG18·임베딩 768d·JSONB·Flyway·Valkey 8.x·백업 RPO 1분/RTO 30분), 외부 서비스(Q1·Q2 미결 명시).
4. **§3 데이터 흐름 재작성**: AI 렌즈 시퀀스에 파일 검증·HMAC 내부 호출·ISO 룰엔진 1차 판정·LLM 보조·30분 자동 삭제 명시. QR 점주 알림에 nonce 60초·Quiet Hours·Topic `owner_{restaurantId}`. 추천 RAG 5단계(Retrieval→Re-rank→Augmentation→Generation→Cache) 신규.
5. **§4 환경 구성 / §5 보안 / §6 Resilience / §7 미결 신규**: 1단계 논리/2단계 물리 분리(트리거 동시 1k·외부 협력사·결제·의료), Single VM 4·8 vCPU 사양표, Blue-Green 4단계, CI/CD 8항(OIDC·Trivy·CodeQL·gitleaks·release-please·Reviewer 1인 승인), K-PIPA 8항, Resilience4j 6패턴 + 외부 API Stale 데이터(`X-Data-Stale: true`) + LLM 자동 폴백, 점진적 강화 트리거 5종(mTLS·환경 분리·CDN·검색 엔진·Valkey 클러스터).
6. **동기화**: CONTEXT.md §3 산출물 표 System_Architecture 행 갱신(v1.1.0 ⚠️ → v2.0.0 ✅), README v1.5.0 → v1.6.0(인덱스 v1.0.0 ⚠️ 오기 보정 + v2.0.0 갱신).

### 직전 세션 작업 요약 (2026-05-11, 후속 2 — WBS Task 1.3 완료: Target_Persona.md v1.2.0)
1. **검증 결과**: 페르소나 4명(A 마크 / B 아미나 / C 다나카 / D 고순자) 본문은 MVP 스코프(TDR v3.1.0 §0)·Requirements §3.1과 정합 — 추가·제외·대체 불필요. 페르소나 자체는 그대로 유효.
2. **SSOT 정책 명문화**: 본 문서는 페르소나 **서사·통증·솔루션 시나리오**의 정본, FR 매칭표의 정본은 Requirements §3.1. 페르소나 추가/제거/조건 변경 시 양방향 동기화 의무 명시.
3. **각 페르소나 표에 "매칭 FR ID" 행 신규 추가** (4건): A → USR-3.1~3.4 + INF-04·USR-2.2 / B → USR-1.1·2.1·2.2 + INF-02·03 / C → USR-1.1·2.2·3.4 + INF-01·03 + NFR-A11Y-04 / D → OWN-1.1·2.1~2.4 + INF-05 + NFR-A11Y-04 + CON-08.
4. **추가 연계 명시**: A 페르소나에 OCR(INF-04)·신호등 핀(USR-2.2), C·D 페르소나에 NFR-A11Y-04(폰트 14px / 터치 44dp — 68세·61세 시인성), C에 SOS(USR-3.4 — 고혈압·당뇨 응급), D에 INF-05(FCM 단일 채널 — 카카오톡 유사 웹 푸시) 및 CON-08(점주 콘솔 서브도메인).
5. **동기화**: WBS.md Task 1.3 ✅ + Target_Persona v1.2.0 명시, WBS.html Phase 1 산출물 카드(WBS↔html sync 규칙 준수), README v1.4.0 → v1.5.0(Target_Persona v1.2.0 인덱스 갱신).

### 직전 세션 작업 요약 (2026-05-11, 후속 — WBS Task 1.4 완료: Core_Features.md v1.5.0)
1. **Core_Features.md v1.4.0 → v1.5.0 전면 갱신** (WBS Task 1.4 ✅): TDR v3.1.0·Requirements v0.1.4와의 갭 5개 그룹(기술 명세 / MVP 스코프 / 수용 기준 / 로드맵 / 메타) 일괄 정합.
2. **SSOT 정책 명문화**: 본 문서는 ID·우선순위·1줄 명세 인덱스로 한정, AC·사용자 스토리·의존성·WBS 매핑의 정본은 Requirements §7. 변경 시 Requirements §7·§14 추적성 매트릭스 동시 갱신 의무 명시.
3. **기술 명세 7건 갱신**: INF-02(LLM Provider 추상화·EXT-09), INF-03(3계층·JSONB 사전 번역), INF-04(OCR Q2 미결 표기), INF-05(FCM 단일), INF-06(Guest 90일·OAuth 4종·점주 7일), USR-2.1(Google+Kakao+Naver 멀티 + `MapClient`), USR-2.3(Naver Directions).
4. **§4 MVP 의도적 제외 항목 신규**: 예약·결제·iOS 정식·자체 추천 모델·USR-1.3 Health Sync (Requirements §5.2 정합).
5. **§5 단계별 구현 로드맵 재작성**: 기존 Schedule_Plan 5단계 월 단위 → WBS v0.4.0의 5 Phase × 21주 × 7 마일스톤 기준 통일.
6. **동기화**: WBS.md Task 1.4 행 ✅ 마킹 + Core_Features v1.5.0 명시, WBS.html Phase 1 산출물 카드에 "MVP 핵심 기능 명세" 추가(WBS.md↔html 동기화 의무 준수), README.md v1.3.0 → v1.4.0(Requirements v0.1.4·Core_Features v1.5.0 인덱스 갱신).

### 직전 세션 작업 요약 (2026-05-11 — Q9 해결: GitHub Free private 유지 확정)
1. **사용자 결정 확정**: "GitHub는 free 티어로 private 레파지토리로 유지". Public 전환(시크릿 감사·코드 노출 수용)과 Pro 업그레이드($4/월) 옵션 모두 보류, **무료 유지** 결정.
2. **Requirements.md v0.1.3 → v0.1.4**: §16 Q9를 "미결" 표에서 분리하여 신규 **"✅ 해결된 결정" 표**로 이전(결정일 2026-05-11 명시, 4단계 다층 완화 정책 본문 기술). §15.2 M1 게이트 행 갱신: "Q9 추적 사안으로 보류" → "Free private 유지 확정, 다층 완화로 통제". NFR-MAINT-06 본문은 v0.1.3에서 이미 다층 완화 형태로 재구성되어 추가 변경 없음.
3. **CONTEXT.md v1.16.0 → v1.17.0**: §3 "상태 업데이트(2026-05-11)" 추가 + 산출물 표 Requirements v0.1.4 갱신. §6 Q7 행을 표에서 제거, "해결된 결정" 영역에 결정 내용·완화 정책·재검토 조건 명시. §8 후속 6 작업 요약 추가, "다음 세션 즉시 처리할 일" Q7/Q9 추적 항목을 "결정 완료" 상태로 갱신.
4. **영구 메모리 `project_github_free_private.md` 저장**: 향후 세션에서 Public 전환·Pro 업그레이드를 다시 옵션으로 제안하지 않도록 정책 고정(사용자 명시 재검토 요청 시에만 재논의). MEMORY.md 인덱스 갱신.

### 직전 세션 작업 요약 (2026-05-08, 후속 5 — WBS sync 규칙 + WBS.html v0.4.0 미러링)
1. **WBS.md ↔ WBS.html 동기화 규칙 명문화**: WBS.md §7 본 문서 갱신 정책에 "🔁 WBS.html 동기화 의무 (필수)" bullet 추가. 한쪽만 변경된 채 머지·푸시 금지. 동기화 영역 9종(헤더 버전 / Phase 산출물 / 마일스톤 / Phase 3 서브 / 크리티컬 패스 / 병렬화 / 마켓 트랙 / 리스크 / 갱신 정책) 명시. CSS·레이아웃 단독 수정만 예외.
2. **WBS.html §8에 동일 규칙 미러링** (이중 안전장치).
3. **WBS.html v0.3.0 → v0.4.0 본문 동기화**: 헤더 subtitle 버전 갱신, Phase 1 산출물 카드("Branch Protection + CODEOWNERS" → "CODEOWNERS + R11 완화 정책 (Free 환경 다층 완화)"), 병렬화 영역 박스("1.7 Branch Protection" → "1.7 CODEOWNERS+정책"), R11 행 완화책("Branch Protection 강제" → "Free 환경 다층 완화 4단계 + Q9 추적").
4. **영구 메모리 저장**: `~/.claude/projects/.../memory/feedback_wbs_md_html_sync.md` 신규 + MEMORY.md 인덱스 업데이트. 향후 모든 세션에서 WBS.md 편집 시 자동으로 본 규칙 적용.

### 이전 세션 요약 (압축 — 2026-05-06 ~ 2026-05-08)

> 최근 2개 세션(2026-05-11, 2026-05-08 후속 5)만 상세 유지. 그 이전은 한 줄 요약. 상세는 `git log` 참고.

- **2026-05-08, 후속 4 — Free 환경 제약 + Task 1.7 ✅**: Free private에서 Branch Protection Ruleset 강제 미작동 확인 → 옵션 2(다층 완화) 채택. WBS v0.4.0(Task 1.7 재정의 + 3.1.3 CODEOWNER 검증 Action), Requirements v0.1.3(NFR-MAINT-06 재구성, §16 Q9 신규), RACI v0.1.2(§8.2 Free 운영 매트릭스), README v1.3.0 일괄 동기화.
- **2026-05-08, 후속 3 — WBS.html 동기화**: WBS.html v0.3.0 본문을 WBS.md와 정합 일치(MK1 W14→W12, AI 사슬 2.12 노드, 병렬화 W2·W3-W4, 리스크 12건).
- **2026-05-08, 후속 2 — 인프라·인벤토리 셋업**: External_API_Inventory v0.1.0 작성(TourAPI/식약처/기상청/Maps/FCM/Gemini, WBS 1.2 ✅), `.github/CODEOWNERS` 신규(WBS 1.7 착수), README v1.2.0.
- **2026-05-08, 후속 1 — Cross-Review 강제 + AI PoC 자산화**: WBS v0.3.0(Task 1.7 Branch Protection·2.12 Base Code 신규), Requirements v0.1.2(NFR-MAINT-06 신규·EXT-09 추상화), RACI v0.1.1(§8 강제 메커니즘 컬럼), CONTRIBUTING v1.1.0(§3 게이트 4절 재구성), README v1.1.0.
- **2026-05-08, 초기 — Phase 1 진입 + 인력 2인 변경**: Requirements.md v0.1.0(FR INF/USR/OWN + NFR 10도메인 + EXT-01~11 + Q1~Q8) + WBS.html 신규. 1인 → 풀스택 시니어 2인(15년차) 결정 → WBS v0.2.0(MK1 W14→W12, R11·R12 신규), Requirements v0.1.1, RACI v0.1.0 신규.
- **2026-05-07, 후속 — CONTRIBUTING 정립**: CONTRIBUTING.md v1.0.0 신규(브랜치/Conventional Commits 11타입/AI 푸터 금지 정책), `.github/PULL_REQUEST_TEMPLATE.md` 신규, README v1.1.0, WBS v0.1.1(한자→한글 통일).
- **2026-05-07, 초기 — GitHub 레포 초기화**: `JangSeungyun/okeymeal` 레포 생성·main 푸시, 공통 README.md v1.0.0 작성, Google Drive `documents/` 신규 레포로 이관.
- **2026-05-06 — TDR v1.9.0 → v3.1.0 종합 갱신**: React 19/Vite 7·Valkey 채택·PostgreSQL 18·JWT·k6·Resilience4j·접근성 등 23개 항목 검토(v2.0.0), 다국어 3계층 정립(v2.1.0), AI 모델·지도 멀티 프로바이더·FCM 추가(v3.0.0), MVP 스코프 §0 + AI 알고리즘 §1.5(임베딩 768d/코사인/Cold-start)(v3.1.0). WBS v0.1.0 신규(21주·7 마일스톤·R1~R10).

### 다음 세션이 즉시 처리할 일

> **Phase 1 종료(M1 ✅ Go, 2026-05-19) → Phase 2 설계 진입(W3, 2026-05-20).** 회고록 §6 Action Items A1~A7이 다음 세션 핵심 작업.

1. **(작업 환경 점검)** 작업 디렉토리가 Git 클론된 로컬 레포 루트인지 `git status` / `git remote -v`로 확인 (origin이 `JangSeungyun/okeymeal`인지).
2. **(A4 — 인력 분업 합의 + 협업자 합류)** 트랙 A/B 책임자 매핑(실명·이메일은 비공개로 별도 관리), 첫 데일리 동기화(15분) 시작 — RACI §9 동기화 리듬 적용. **두 번째 협업자 합류 시 CODEOWNERS의 `@track-a-user`·`@track-b-user` placeholder를 실제 GitHub 핸들로 교체 필수.** M2 게이트(2026-06-16) 전 완료 조건.
3. **(A1·A2 — Phase 2 W3 직전 후속 검증, 5/20~22)** Competitor_Benchmark V1~V4(HappyCow 한·일·중 UI / Fig 메뉴 OCR / Spoonful 식별 / 신규 진입자) + Risk_Register R16(한국관광공사 Visit Korea Food 데이터 라이선스 KOGL 표시) 일괄 검증.
4. **(A3·A6 — WBS 2.12 Base Code + PoC)** R12 완화 — `backend-python/app/ai/` 인터페이스 스케치(Provider 추상화·임베딩·RAG 빌더·프롬프트·토큰 캡)를 W2 마지막 영업일 안에 준비. W3 시작과 동시에 LLM/OCR PoC 가동 (Q1·Q2 결정 게이트).
5. **(A6·A7 — Phase 2 W3 본격 작업, 5/20~)** 트랙 A: 2.1 ERD → 2.2 AI 추천 알고리즘 → 2.3 API 명세. 트랙 B: 2.4 와이어프레임 → 2.5 UI 시안 → 2.6 점주 콘솔 설계. 병렬화.
6. **(A5 — 매주 회고 시작, 5/24~)** Risk_Register §6 모니터링 정책 적용 — 매주 일요일 회고에서 R1~R18 상태 점검.
7. **(Q7/Q9 → 결정 완료)** ✅ GitHub Free private 유지 확정(2026-05-11). **WBS 3.1.3 `codeowner-approval` CI Action 구현 우선순위**를 유지하고, 정책 위반 빈도를 데이터로 누적(재검토는 사용자 명시 요청 시에만).
8. 모든 문서 변경 시 **Conventional Commits** 규약(`docs: ...`)으로 커밋. **AI 푸터 금지·사전 승인 후 커밋·푸시** 원칙 준수.

### 주의사항
*   본 문서(CONTEXT.md)와 TDR/WBS는 **버전 동기화 유지** 필수. 결정 변경 시 TDR → CONTEXT 순서로 갱신.
*   WBS 작업 완료 시 해당 항목에 `✅ 완료 (날짜)` 마킹, 지연 시 `⚠️ 지연 (사유)` 마킹.
*   미결 사항 Q1~Q6은 결정 시점이 도래할 때까지 본 문서 §6에 유지, 결정 후 §6의 "해결된 결정"으로 이전.
*   **2026-09-30 데드라인은 절대 기준**. 일정 압축 필요 시 비핵심 기능을 Phase 2로 이전 (TDR §0 패턴 활용).
*   **Google Drive의 `documents/` 폴더는 더 이상 작업 대상이 아님.** 모든 신규 작업·커밋은 GitHub 레포(`JangSeungyun/okeymeal`)를 클론한 로컬 디렉토리에서만 진행하며, 본 문서에는 협업자별로 다를 수 있는 절대 경로를 기재하지 않습니다.
*   **커밋 메시지 AI 푸터 금지**: AI(Claude·Gemini·GPT 등)가 커밋 메시지를 작성·제안할 때 `Co-Authored-By: Claude`, `🤖 Generated with Claude Code`, `Generated-by: GPT-4` 등 **AI 작성자/생성 표기 푸터를 포함하지 않습니다.** 본 레포에서 AI는 도구이지 공저자가 아닙니다. 상세 정책: [`CONTRIBUTING.md`](../CONTRIBUTING.md) §"AI 협업 시 커밋 메시지 규칙".
*   **인력 분업(RACI) 준수**: 트랙 A(백엔드·AI·인프라) ↔ 트랙 B(프론트·모바일·점주) 책임 영역 외 작업 시 사전 동기화. **공동 영역 6항목**(API 계약·DB 마이그레이션·E2E·시연·runbooks·보안 게이트)은 양쪽 PR 리뷰 의무. 상세는 [`02.Planning/RACI.md`](./02.Planning/RACI.md) §8.

---

## 📝 변경 이력

> 최근 3개 버전(v1.16.0 이후)만 상세 유지. 그 이전 변경은 한 줄 요약. 상세는 `git log -- documents/CONTEXT.md` 참고.

| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.6.0~v1.8.0 | 2026-05-06 | TDR v1.9.0→v3.1.0 종합 갱신 반영(React 19/Vite 7·Valkey·PostgreSQL 18·AI 알고리즘), WBS v0.1.0 신규, MVP 스코프 §4·Q1~Q6·§8 AI 핸드오프·9/30 데드라인 신설. | 숭늉 |
| v1.9.0~v1.11.0 | 2026-05-07 | GitHub 모노레포 초기화(`JangSeungyun/okeymeal`) + Google Drive `documents/` 이관 + CONTRIBUTING.md v1.0.0 신규(AI 푸터 금지 정책 명문화). §2·§3·§8 동기화, WBS v0.1.0→v0.1.1. | 숭늉 |
| v1.12.0~v1.13.0 | 2026-05-08 | Phase 1 분석 진입 + 인력 1인→풀스택 시니어 2인(15년차) 변경 + Cross-Review 강제 + AI PoC 자산화. WBS v0.3.0(Task 1.7·2.12 신규), Requirements v0.1.2(NFR-MAINT-06), RACI v0.1.1(§8 강제 메커니즘), CONTRIBUTING v1.1.0. | 숭늉 |
| v1.14.0~v1.15.0 | 2026-05-08 | WBS Task 1.2(External_API_Inventory v0.1.0) ✅ + Task 1.7(CODEOWNERS) ✅ + GitHub Free private 환경 제약 반영. WBS v0.4.0(Task 1.7 재정의·3.1.3 CODEOWNER Action·R11 4단계 다층 완화), Requirements v0.1.3(NFR-MAINT-06 재구성·Q9 신규), RACI v0.1.2(§8.2 Free 운영 매트릭스), README v1.3.0. §6 Q7 신규. | 숭늉 |
| v1.16.0 | 2026-05-08 | **WBS.md ↔ WBS.html 동기화 규칙 명문화 + WBS.html v0.4.0 본문 미러링**. v0.3.0 → v0.4.0 갱신 시 WBS.html이 방치된 사례 발견을 계기로 동기화 의무를 정책화. ① WBS.md §7에 "🔁 WBS.html 동기화 의무" bullet 추가(동기화 영역 9종 명시), ② WBS.html §8에 동일 규칙 미러링, ③ WBS.html 헤더 v0.3.0→v0.4.0, Phase 1 산출물 카드·병렬화 영역·R11 완화책 cell 동기화, ④ 영구 메모리 `feedback_wbs_md_html_sync.md` + MEMORY.md 인덱스 업데이트. §3 후속 5 상태 업데이트 + §8 후속 5 직전 세션 요약 추가. | 숭늉 |
| v1.17.0 | 2026-05-11 | **Q9 해결 — GitHub Free private 유지 확정**. §3 "상태 업데이트(2026-05-11)" 추가 + 산출물 표 Requirements v0.1.4 갱신. §6 Q7 행을 미결 표에서 제거, "해결된 결정" 영역에 결정 내용·4단계 다층 완화·재검토 조건 명시. §8 직전 세션 작업 요약(2026-05-11) 신규 + "다음 세션 즉시 처리할 일" 6번을 "Q7/Q9 추적" → "결정 완료, WBS 3.1.3 우선순위 유지"로 갱신. Requirements.md v0.1.4·영구 메모리 `project_github_free_private.md`와 동기화. | 숭늉 |
| v1.18.0 | 2026-05-11 | **이력 정리(문서 슬림화)**. §3 상태 업데이트의 2026-05-08 후속 1·2·4·초기 4개를 "이전 상태 업데이트(2026-05-08, 압축)" 한 블록으로 통합. §8 직전 세션 작업 요약 8개(2026-05-08 후속 4·3·2·1·초기 + 2026-05-07 후속·초기 + 2026-05-06)를 "이전 세션 요약(압축)" 한 줄씩으로 변환, 최근 2개(2026-05-11, 2026-05-08 후속 5)만 상세 유지. 변경 이력 v1.6.0~v1.15.0(10개 항목)을 4개 묶음으로 통합(상세는 git log 참고). 누락 동기화 보정: §5 Task 1.1을 v0.1.3 → v0.1.4, §6 빈 줄 추가. | 숭늉 |
| v1.19.0 | 2026-05-11 | **WBS Task 1.4 완료 — Core_Features.md v1.5.0 전면 갱신**. TDR v3.1.0·Requirements v0.1.4와의 5개 갭 그룹 일괄 정합(SSOT 정책 / 기술 명세 7건 / 수용 기준 보강 / MVP 의도적 제외 §4 신규 / 로드맵 WBS 기준 재작성). §3 상태 업데이트(2026-05-11, 후속) 추가 + 산출물 표에 Core_Features 행 신규, §5 Phase 1 1.4 ✅ 마킹, §8 직전 세션 요약 추가. WBS.md Task 1.4 행·WBS.html Phase 1 산출물 카드·README v1.4.0 동기화. | 숭늉 |
| v1.20.0 | 2026-05-11 | **WBS Task 1.3 완료 — Target_Persona.md v1.2.0 검증·갱신** + **세션 종료 전 정리·동기화 보정**. ① 페르소나 4명 본문 정합 검증 완료(MVP 스코프와 일치, 추가·제외 불필요) + SSOT 정책 명문화(서사 정본은 본 문서, FR 매칭표 정본은 Requirements §3.1, 양방향 동기화 의무) + 각 페르소나 표에 "매칭 FR ID" 행 신규(A·B·C·D 4건) + C·D에 NFR-A11Y-04 접근성·SOS·FCM·CON-08 연계 명시. ② §3 상태 업데이트(후속 2) + 산출물 표 Target_Persona 행 신규 + §5 Phase 1 1.3 ✅ 마킹 + §8 직전 세션 요약(후속 2) 추가. ③ WBS.md Task 1.3 · WBS.html Phase 1 산출물 카드 · README v1.5.0 동기화. ④ **세션 종료 전 보정**: 산출물 표 README "v1.3.0" → "v1.5.0" 누락 보정(이전 1.4 동기화 누락분) + §8 다음 세션 즉시 처리할 일에서 완료된 1.3·1.4 제거하고 1.5(경쟁 벤치마크)·1.6(Risk Register)·1.8(M1 회고) 잔여 작업으로 재구성 + 변경 이력 v1.17.0 → v1.20.0 구→신 순서로 재정렬. | 숭늉 |
| v1.21.0 | 2026-05-11 | **System_Architecture.md v1.1.0 → v2.0.0 전면 재작성 (TDR v3.1.0 기준)**. ① §1 구성도 Java 멀티모듈 + Python AI 분리, LLM Provider 추상화, Valkey, 멀티 맵, FCM 단일, Loki+Prometheus, GitHub Actions OIDC 노드 추가. ② §2 레이어 표 전면 갱신(React 19/Vite 7, PostgreSQL 18 + pgvector HNSW 768d, 점주 콘솔 `owner.okeymeal.kr` 별도 서브도메인). ③ §3 데이터 흐름 재작성(AI 렌즈 ISO 룰엔진 우선 + 30분 자동 삭제, QR 알림 nonce·Quiet Hours, 추천 RAG 5단계 신규). ④ §4 환경 구성(논리/물리 2단계, Single VM 사양, Blue-Green, CI/CD 8항, 모노레포 구조) / §5 K-PIPA 8항 / §6 Resilience4j 6패턴 + 관측 / §7 미결 결정(Q1·Q2·Q4·Q5) + 점진적 강화 트리거 5종 신규. ⑤ 동기화: §3 산출물 표 System_Architecture 행 갱신, README v1.5.0 → v1.6.0(인덱스 v1.0.0 오기 보정 + v2.0.0 갱신). §3 상태 업데이트(후속 3) + §8 직전 세션 요약(후속 3) 추가. | 숭늉 |
| v1.22.0 | 2026-05-18 | **WBS Task 1.5 완료 — Competitor_Benchmark.md v1.0.0 신규 작성**. 5개 서비스(망고플레이트·Visit Korea Food·Yelp·HappyCow·Fig) × 7축 비교 매트릭스 + 차별화 5축 가설 1차 검증(AI OCR×ISO×다국어 결합 직접 경쟁자 사전 지식 기준 없음·점주 콘솔 B2B 공백·동아시아 사각지대·End-to-End 시나리오 통합·B2B 수익 가설) + Phase 2/3 인사이트 I1~I7 + 후속 검증 V1~V4(W3 직전 재조사). 식이 특화 2종은 WebSearch/WebFetch 거부로 사전 지식(2026-01 컷오프) 의존 명시. ① §3 상태 업데이트(2026-05-18) + 산출물 표 Competitor_Benchmark 행 신규 + README v1.7.0 갱신 / ② §5 Phase 1 Task 1.5 ✅ 마킹 / ③ §8 직전 세션 요약(2026-05-18) 신규, 잔여 작업 안내(Task 1.6 → 1.8) / ④ WBS.md Task 1.5 ✅ + WBS.html Phase 1 산출물 카드 동기화. | 숭늉 |
| v1.23.0 | 2026-05-18 | **WBS Task 1.6 완료 — Risk_Register.md v1.0.0 신규 작성**. ① §2.1 핵심 리스크 R1~R12 WBS §6 SSOT 동기화(소유자·트리거·잔여 위험·검토일 4컬럼 신규 추가) / ② §2.2 분석 단계 추가 발견 R13~R18 6건(신규 진입자·K-PIPA DPO·점주 다국어 입력 부담·Visit Korea 라이선스·외국인 결제·점주 디지털 리터러시) / ③ §3 가정 A1~A8 + §5 외부 의존성 D1~D7 + 내부 D8~D11 / ④ §6 모니터링·에스컬레이션·소유자 정책. **SSOT 정책**: Risk_Register가 정본, WBS §6은 요약 미러. ① §3 상태 업데이트(2026-05-18, 후속) + 산출물 표 Risk_Register 행 신규 + README v1.8.0 갱신 / ② §5 Phase 1 Task 1.6 ✅ 마킹 / ③ §8 직전 세션 요약(2026-05-18, 후속) 신규, 잔여 작업 1.8 M1 회고만 안내 / ④ WBS.md Task 1.6 ✅ + WBS.html Phase 1 산출물 카드 Risk_Register v1.0.0 표기 동기화. | 숭늉 |
| v1.24.0 | 2026-05-19 | **WBS Task 1.8 완료 — M1 게이트 회고록 v1.0.0 + Phase 1 종료 + Phase 2 진입 결정**. ① 산출물 `00.Meetings/2026-05-19-m1-retrospective-01.md` 신규: KPT(Keep K1~K5 / Problem P1~P4 / Try T1~T4) + M1 통과 판단 산출물 7건 모두 충족 → 종합 **✅ Go**(조건부: 두 번째 협업자 합류 M2 전 필수) + Phase 2 진입 준비 + Action Items A1~A7. ② §2 현재 집중 단계 "Phase 1 진행 중" → "Phase 1 완료 / Phase 2 진입(2026-05-20, W3)" + §3 진행 단계 다이어그램 [✅ M1] / [★ Phase 2] 갱신. ③ 산출물 표 M1 회고록 행 신규 + README 인덱스 v1.8.0 → v1.9.0(00.Meetings 회고록 추가). ④ §5 Phase 1 Task 1.8 ✅ 마킹(분석 단계 100% 완료). ⑤ §8 직전 세션 요약(2026-05-19) 신규 + 다음 세션 즉시 처리할 일을 회고록 Action Items A1~A7 기준으로 전면 재구성(작업 환경 / A4 협업자 합류 / A1·A2 W3 직전 후속 검증 / A3·A6 Base Code + PoC / A6·A7 Phase 2 W3 본격 / A5 매주 회고). ⑥ WBS.md Task 1.8 ✅ 동기화. | 숭늉 |
