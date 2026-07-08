---
title: "[회고] M1 게이트 — Phase 1 분석 단계 회고"
version: v1.0.0
last_updated: 2026-05-19
author: 숭늉
---

## 회의 개요

| 항목 | 내용 |
|---|---|
| 일시 | 2026-05-19 (M1 게이트 일자) |
| 마일스톤 | **M1: 분석 완료** (WBS §2) |
| 게이트 판단 | **✅ Go — Phase 2 설계 진입 결정** |
| 참석자 | 숭늉(작성), 트랙 A / 트랙 B 책임자(예정) |
| 회고 대상 기간 | Phase 1 분석 단계 (2026-05-06 ~ 2026-05-19, 2주) |
| 산출물 | 본 회고록 — WBS Task 1.8 |

---

## 1. Phase 1 진행 요약

### 1.1 작업 분해 완료 현황 (WBS §3 Phase 1)

| Task | 작업 | 산출물 | 상태 | 완료일 |
|---|---|---|---|---|
| 1.1 | 기능·비기능 요구사항 정리 | `Requirements.md` v0.1.4 | ✅ 완료 | 2026-05-08 (Q9 해결 갱신: 2026-05-11) |
| 1.2 | 외부 API 인벤토리 | `External_API_Inventory.md` v0.1.0 | ✅ 완료 | 2026-05-08 |
| 1.3 | 사용자 페르소나 검증·갱신 | `Target_Persona.md` v1.2.0 | ✅ 완료 | 2026-05-11 |
| 1.4 | MVP 핵심 기능 명세 | `Core_Features.md` v1.5.0 | ✅ 완료 | 2026-05-11 |
| 1.5 | 경쟁 서비스 벤치마크 | `Competitor_Benchmark.md` v1.0.0 | ✅ 완료 | 2026-05-18 |
| 1.6 | 리스크 식별·등록 (RAID) | `Risk_Register.md` v1.0.0 | ✅ 완료 | 2026-05-18 |
| 1.7 | CODEOWNERS + R11 완화 정책 | `.github/CODEOWNERS` + CONTRIBUTING v1.1.0 + Q9 해결 | ✅ 완료 | 2026-05-08 (Free 환경 다층 완화) |
| 1.8 | 분석 단계 회고 + M1 게이트 점검 | 본 문서 | ✅ 완료 | 2026-05-19 |

> **전체 8개 Task 모두 완료** — Phase 1 100% 진척 달성.

### 1.2 분석 단계 추가 보강 산출물

WBS에 명시되지 않았으나 분석 과정에서 함께 갱신/신규 작성된 산출물:

- **TDR (Technical_Decision_Records.md) v3.1.0** — React 19·Vite 7·PostgreSQL 18·Valkey·AI 알고리즘·MVP 스코프 확정 (2026-05-06)
- **System_Architecture.md v2.0.0** — TDR v3.1.0 기준 전면 재작성 (2026-05-11)
- **RACI.md v0.1.2** — 트랙 A/B 분업 + Free 환경 다층 완화 메커니즘 (2026-05-08)
- **WBS.md v0.4.0 + WBS.html v0.4.0** — Free 환경 제약 반영, MK1 2주 앞당김, R11·R12 신규
- **CONTRIBUTING.md v1.1.0** — AI 푸터 금지, Cross-Review 정책

---

## 2. 회고 (KPT 형식)

### 2.1 잘된 점 (Keep)

- **K1. 분석 산출물의 정밀한 정합성 관리** — TDR ↔ Requirements ↔ Core_Features ↔ Target_Persona ↔ WBS 사이 SSOT 정책을 모든 산출물에서 명문화. v1.4(Core_Features) / v1.3(Target_Persona) 갱신 시 매칭 FR ID 표를 양방향 동기화 의무로 명시한 게 향후 변경 비용을 크게 낮춤.
- **K2. WBS.md ↔ WBS.html 동기화 의무 정책화** — 2026-05-08 후속 5에서 누락 사례를 발견하자마자 §7 본문에 정책으로 명문화하고 영구 메모리에 저장. 이후 모든 갱신(Task 1.3·1.4·1.5·1.6)에서 일관 적용됨.
- **K3. 리스크 R11·R12에 대한 사전 대응 강화** — 인력 2인 변경(2026-05-08) 직후 R11(분업 정합)·R12(AI 전문성)를 신규 등록하고, WBS Task 1.7(CODEOWNERS)·2.12(Base Code 자산화)·3.1.3(CODEOWNER CI Action)으로 구체적 완화책을 즉시 반영.
- **K4. Q9(GitHub Free private) 결정의 신속한 처리** — 미결 사항이 9일간 추적 후 결정 → 4단계 다층 완화로 통제. Requirements §16에 "해결된 결정" 표로 별도 영역 분리한 패턴은 향후 미결 사항 추적에 그대로 재사용 가능.
- **K5. 직전 세션 요약 슬림화 정책(v1.18.0)** — CONTEXT.md가 비대해지는 문제를 한 줄 요약 + git log 참고 정책으로 일관 적용. 토큰 효율과 핸드오프 명료성을 동시 달성.

### 2.2 개선할 점 (Problem)

- **P1. M1 게이트 임박 시점의 산출물 집중 부담** — Task 1.3·1.4·1.5·1.6이 2026-05-11 ~ 05-18 7일 안에 집중 처리됨. 1.1·1.2·1.7은 2026-05-08에 일찍 끝났으나 그 사이 5월 6일~7일 휴면. 향후 Phase는 작업 간격을 더 평탄화 필요.
- **P2. 식이 특화 경쟁 서비스 리서치의 권한 제약** — WBS 1.5 진행 중 일반 목적 에이전트가 WebSearch/WebFetch 권한 거부로 사전 지식(2026-01 컷오프) 기반 작성. **후속 검증 V1~V4가 Phase 2 W3 직전(2026-05-22)에 반드시 진행되어야 함.** 권한 정책을 사전에 점검하지 못한 점이 비용.
- **P3. CONTEXT.md 변경 이력 압축의 인지적 부담** — v1.16.0 → v1.23.0까지 7번 minor up이 발생하면서 매번 변경 이력 행을 추가. 한 세션 안에서 후속 작업이 발생할 때 묶어 처리할지(예: 1.5·1.6·1.8을 v1.24.0 단일 row)는 다음 회고에서 결정 권장.
- **P4. 2인 분업 합의의 실제 시작 미루기** — 인력 변경이 2026-05-08에 결정됐으나, 두 번째 협업자의 실제 합류·CODEOWNERS placeholder 교체·일일 동기화 시작은 Phase 2 진입 시점까지 미뤄짐. M2 전까지 합류 완료 필수.

### 2.3 다음 단계 시도할 점 (Try)

- **T1. Phase 2 W3 직전 후속 검증 일괄 진행 (2026-05-20 ~ 05-22)**:
  - Competitor_Benchmark V1~V4 (HappyCow 한·일·중 UI / Fig 메뉴 OCR / Spoonful 식별 / 신규 진입자)
  - Risk_Register R16 한국관광공사 Visit Korea Food 큐레이션 데이터 라이선스 (KOGL 표시)
  - 이 두 작업을 W3 시작(2026-05-20) 직전 1일 작업으로 묶어 처리.
- **T2. AI/LLM PoC를 W3 시작과 동시에 개시 (WBS 2.12)** — Q1·Q2 결정 게이트로 활용. PoC 결과를 Base Code(`backend-python/app/ai/`)로 자산화하는 인터페이스를 W2 안에 미리 스케치하여 W3 첫 날부터 작업 가능하게 준비.
- **T3. 매주 일요일 회고 + Risk_Register 일관 점검** — Risk_Register §6 모니터링 정책을 첫 운영 회고(2026-05-24, 일)부터 실 적용. 🟡 주의 상태 진입 시 즉시 액션 플랜.
- **T4. 두 번째 협업자 합류 시 즉시 처리할 체크리스트 운영** — ① CODEOWNERS `@track-a-user`·`@track-b-user` placeholder 실제 GitHub 핸들 교체, ② RACI §9 일 15분 동기화 미팅 시작, ③ Risk_Register §6.3 트랙 B 소유 리스크(R1·R7·R15·R17·R18) 인수인계.

---

## 3. M1 게이트 통과 판단

### 3.1 게이트 산출물 체크리스트 (WBS §2)

| # | 요구 산출물 | 상태 | 비고 |
|---|---|---|---|
| ✅ | 요구사항 명세서 | 충족 | Requirements.md v0.1.4 (FR/NFR/EXT/추적성 매트릭스, Q9 해결) |
| ✅ | 외부 API 인벤토리 | 충족 | External_API_Inventory.md v0.1.0 (7개 API) |
| ✅ | 리스크 레지스터 | 충족 | Risk_Register.md v1.0.0 (R1~R18, A1~A8, D1~D11, 모니터링 정책) |
| ✅ (보강) | 사용자 페르소나 | 충족 | Target_Persona.md v1.2.0 (4명, SSOT 정책 + 매칭 FR ID) |
| ✅ (보강) | MVP 핵심 기능 명세 | 충족 | Core_Features.md v1.5.0 (TDR/Requirements 정합) |
| ✅ (보강) | 경쟁 서비스 벤치마크 | 충족 | Competitor_Benchmark.md v1.0.0 (5개 서비스, 차별화 5축) |
| ✅ (보강) | CODEOWNERS + R11 완화 | 충족 | `.github/CODEOWNERS` + CONTRIBUTING v1.1.0 + Q9 해결 |

### 3.2 Phase 2 진입 가능 여부 판단 (Go/No-Go)

| 판단 기준 | 판단 결과 | 근거 |
|---|---|---|
| 분석 단계 모든 Task 완료 | ✅ Go | WBS Task 1.1~1.8 전체 ✅ (§1.1) |
| 산출물 정합성 유지 | ✅ Go | SSOT 정책 5개 산출물에 명문화, WBS ↔ HTML 동기화 의무 적용 |
| 시장 포지셔닝 검증 | ✅ Go | Competitor_Benchmark 차별화 5축 가설 1차 검증, 후속 V1~V4는 W3 직전 |
| 리스크 통제 체계 정립 | ✅ Go | Risk_Register 18건 + 가정 8건 + 의존성 11건 + 모니터링 정책 |
| 인력 분업 합의 | ⚠️ 조건부 Go | 시니어 2인 결정·RACI 문서화는 완료. 두 번째 협업자 실제 합류·CODEOWNERS 핸들 교체는 **M2 게이트 전 필수** (T4) |
| 미결 사항 영향 | ✅ Go | Q1·Q2·Q4·Q5는 결정 시점이 Phase 2 이후. Q3(법무)는 Phase 3 초반. Q6(Play 계정)는 2026-08-01 |

> **종합 판단: ✅ Go — Phase 2 설계 진입 결정.**
> 조건: T4(두 번째 협업자 합류) 완료를 M2 게이트(2026-06-16) 전 필수 처리.

---

## 4. Phase 2 진입 준비 사항

### 4.1 Phase 2 일정 (WBS §3)

- **기간**: 2026-05-20 ~ 2026-06-16 (4주, W3~W6)
- **목표**: ERD / API 명세 / AI 알고리즘 설계서 / 와이어프레임 완성
- **마일스톤**: M2 설계 완료 (2026-06-16) — 개발 진입 가능 여부 판단

### 4.2 W3 직전(2026-05-20) 처리 항목

1. **Competitor_Benchmark V1~V4 후속 검증** (5월 20~22일)
2. **Risk_Register R16 한국관광공사 Visit Korea Food 라이선스 확인** (5월 20~22일)
3. **두 번째 협업자 합류 작업 (T4)** — CODEOWNERS placeholder 실제 핸들 교체, RACI §9 동기화 시작
4. **WBS 2.12 Base Code 인터페이스 스케치** — Phase 2 W3 첫날 PoC 즉시 가동
5. **Phase 2 산출물 작성 순서 합의** — 트랙 A(2.1 ERD → 2.2 AI 알고리즘 → 2.3 API 명세) vs 트랙 B(2.4 와이어프레임 → 2.5 UI 시안 → 2.6 점주 콘솔 설계) 병렬화

### 4.3 미결 결정 사항 추적 (CONTEXT.md §6)

| Q# | 미결 사항 | Phase 2 처리 계획 |
|---|---|---|
| Q1 | LLM 워크로드별 Primary 모델 (Gemini/Claude/GPT) | W3~W4 PoC + Base Code 자산화 (WBS 2.12) |
| Q2 | OCR 엔진 (Google Cloud Vision vs Gemini Vision) | W3~W4 PoC, AI 렌즈 정확도 검증과 함께 |
| Q4 | 단일 VM 클라우드 제공자 (GCP/AWS/NCP) | Phase 2 후반(W5~W6), 비용 검토 |
| Q5 | DPO(개인정보 보호책임자) 지정 | 운영 시작 전 (Phase 5 또는 그 이전) |

---

## 5. 결정 사항

- [x] **M1 게이트 ✅ Go** — Phase 2 설계 진입 결정
- [x] **조건부 사항**: 두 번째 협업자 합류는 M2 게이트(2026-06-16) 전 필수 처리
- [x] **후속 검증 일정 확정**: 2026-05-20~22 안에 Competitor_Benchmark V1~V4 + Risk_Register R16 (Visit Korea 라이선스) 일괄 처리
- [x] **WBS 2.12 PoC 가동 시점**: Phase 2 W3 시작과 동시(2026-05-20) — Base Code 인터페이스 스케치를 W2 마지막 영업일 안에 준비

---

## 6. Action Items

| # | 담당자 | 할 일 | 기한 | 상태 |
|---|---|---|---|---|
| A1 | 트랙 A | Competitor_Benchmark V1~V4 후속 검증 (HappyCow UI/가격·Fig 메뉴 OCR·Spoonful 명칭·신규 진입자) | 2026-05-22 | ⬜ 대기 |
| A2 | 트랙 A | Risk_Register R16 — 한국관광공사 Visit Korea Food 큐레이션 데이터 라이선스(KOGL 표시 의무 확인) | 2026-05-22 | ⬜ 대기 |
| A3 | 트랙 A | WBS 2.12 Base Code 인터페이스 스케치 (`backend-python/app/ai/` 골격: Provider 추상화·임베딩 클라이언트·RAG 빌더·프롬프트 템플릿·토큰 캡 미들웨어) | 2026-05-22 | ⬜ 대기 |
| A4 | 트랙 A·B | 두 번째 협업자 합류 + CODEOWNERS placeholder 실제 GitHub 핸들 교체 + RACI §9 일 15분 동기화 시작 | 2026-06-16 (M2 전) | ⬜ 대기 |
| A5 | 트랙 A·B | Risk_Register §6 매주 일요일 회고 시작 (첫 회고 2026-05-24) | 2026-05-24 | ⬜ 대기 |
| A6 | 트랙 A | Phase 2 W3 시작(2026-05-20) — 2.1 ERD + 2.2 AI 알고리즘 설계 + 2.12 PoC 가동 | 2026-05-20 ~ | ⬜ 대기 |
| A7 | 트랙 B | Phase 2 W3 시작 — 2.4 와이어프레임 + 2.5 UI 시안 + 2.6 점주 콘솔 설계 병렬 진행 | 2026-05-20 ~ | ⬜ 대기 |

---

## 7. Phase 2 산출물 예상 일정 (참고)

| Task | 산출물 | 주차 | 비고 |
|---|---|---|---|
| 2.1 | ERD | W3 | 트랙 A |
| 2.2 | AI 추천 알고리즘 설계 | W3 | 트랙 A, Q1 영향 |
| 2.3 | API 명세서 | W4 | 트랙 A (2.1 의존) |
| 2.4 | 와이어프레임 | W4 | 트랙 B |
| 2.5 | UI 시안 (Figma) | W5 | 트랙 B (2.4 의존) |
| 2.6 | 점주 콘솔 설계 | W5 | 트랙 B (2.3 의존) |
| 2.7 | DB 마이그레이션 V1 골격 | W6 | 트랙 A |
| 2.8 | 외부 API 어댑터 인터페이스 | W6 | 트랙 A |
| 2.9 | 인프라 토폴로지 | W6 | 트랙 A |
| 2.10 | 보안 위협 모델링 (STRIDE) | W6 | 양 트랙 |
| 2.11 | 다국어 콘텐츠 정책 | W6 | 트랙 B |
| 2.12 | LLM/AI Base Code PoC | W3-W4 | 트랙 A, Q1·Q2 결정 게이트 |
| 2.13 | M2 게이트 회고 | W6 D7 | 양 트랙 |

---

## 📝 변경 이력

| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.0.0 | 2026-05-19 | **WBS Task 1.8 — M1 게이트 회고록 최초 작성**. ① §1 Phase 1 진행 요약: 8개 Task 전체 ✅ + 보강 산출물 5종(TDR / System_Architecture / RACI / WBS / CONTRIBUTING). ② §2 KPT 회고: Keep 5건(K1~K5) / Problem 4건(P1~P4) / Try 4건(T1~T4). ③ §3 M1 게이트 통과 판단 — 산출물 7건 모두 충족, 종합 판단 **✅ Go** (조건: 두 번째 협업자 합류 M2 전 필수). ④ §4 Phase 2 진입 준비: W3 직전 처리 항목 5건. ⑤ §5 결정 사항 4건 + §6 Action Items 7건(A1~A7). | 숭늉 |
