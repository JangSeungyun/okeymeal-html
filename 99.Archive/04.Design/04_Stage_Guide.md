---
title: 04.Design 단계 가이드
version: v1.1.1
last_updated: 2026-04-30
author: 숭늉
---

# 04.Design 단계 가이드

이 단계에서는 서비스의 기술적 구조와 사용자 인터페이스를 설계합니다.

---

## 📊 단계 현황

| 항목 | 내용 |
|---|---|
| **상태** | 🚀 진행 중 |
| **시작일** | 2026-05-06 |

---

---

## 🔗 선행 조건

- [x] `03.Proposal` 완료 — 핵심 기능 정의 및 기술 스택 확정 (2026-05-05 제출 완료)
- [x] `CONTEXT.md` Open Questions 중 설계에 영향을 미치는 사항 우선 결정

---

## ✅ 완료 기준 (Definition of Done)

- [x] 전체 시스템 구성도 및 레이어별 기술 스택 정의
- [x] 핵심 테이블 ERD 및 컬럼 정의 완료
- [ ] 주요 API 엔드포인트 명세 완료 (최소 P1 기능 전체)
- [ ] 핵심 사용자 여정(User Journey) 플로우 차트 완료
- [ ] 05.Development 시작 전 팀 내 설계 검토(Review) 완료

---

## 📋 산출물 체크리스트

| 파일 | 버전 | 상태 |
|---|---|---|
| `System_Architecture.md` | v1.0.0 | ✅ 완료 |
| `DB_Schema.md` | v1.0.0 | ✅ 완료 |
| `Technical_Decision_Records.md` | v1.0.0 | ✅ 완료 |
| `API_Specification.md` | - | ⬜ 미작성 |
| `UI_UX_Flow.md` | - | ⬜ 미작성 |

---

## 📝 주요 문서 구성 기준

- **시스템 아키텍처**: 전체 구성도(Mermaid), 레이어별 기술 스택, 주요 데이터 흐름(Sequence Diagram), 환경 구성, 보안 설계 포함.
- **DB 스키마**: ERD(Mermaid erDiagram), 테이블별 컬럼 정의(타입/PK/FK/Nullable), 인덱스 전략, 시딩 계획 포함.
- **API 명세서**: Method, Path, Description, Request(Header/Body/Params), Response Body, Error Codes 포함.
- **UI/UX 흐름도**: 사용자 여정별(온보딩, 지도 탐색, AI 렌즈, QR 알림, SOS) 화면 플로우 포함.

---

## 🤖 AI 요청 프롬프트

> `AI_Agent_Guide.md`, `04.Design/System_Architecture.md`, `04.Design/DB_Schema.md`를 먼저 읽어 설계 맥락을 파악하세요.

**API 명세서 작성 요청:**
> `04.Design/System_Architecture.md`와 `02.Planning/Core_Features.md`를 읽고, P1 기능(INF-01~07, USR-1.1, USR-2.1~2.3, USR-3.1~3.4, OWN-1.1~1.3, OWN-2.1~2.4)에 해당하는 RESTful API 엔드포인트 명세서를 `04.Design/API_Specification.md`로 작성해줘. URL prefix는 `/api/v1/`이고, 각 엔드포인트에 Method/Path/설명/Request/Response/ErrorCodes를 포함해줘.

**UI/UX 흐름도 작성 요청:**
> `02.Planning/Target_Persona.md`와 `02.Planning/Core_Features.md`를 읽고, 페르소나 A(Mark, 알레르기)가 OkeyMeal을 처음 사용하는 전체 여정을 Mermaid flowchart로 시각화한 `04.Design/UI_UX_Flow.md`를 작성해줘. 온보딩 → 지도 탐색 → AI 렌즈 → QR 알림 → SOS 각 흐름을 포함해줘.

---

## 📝 변경 이력
| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.0.0 | 2026-04-18 | 설계 단계 가이드 생성 | 숭늉 |
| v1.1.0 | 2026-04-23 | 진행 중 상태 반영, 완료/미완료 체크리스트 추가, 설계 문서별 전용 프롬프트로 교체 | 숭늉 |
