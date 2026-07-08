---
title: 05.Development 단계 가이드
version: v1.1.0
last_updated: 2026-04-23
author: 숭늉
---

# 05.Development 단계 가이드

이 단계에서는 실제 코드를 구현하고 개발 과정을 기록(DevLogs)합니다.
바이브 코딩(Vibe Coding) 방식으로 AI 에이전트와 협업하여 개발을 진행합니다.

---

## 📊 단계 현황

| 항목 | 내용 |
|---|---|
| **상태** | ⏳ 대기 (04.Design 완료 후 시작) |
| **예정 시작** | 2026-06-01 (Phase 2) |

---

## 🔗 선행 조건

- [ ] `04.Design` 완료 — System_Architecture, DB_Schema, API_Specification, UI_UX_Flow 모두 작성
- [ ] `CONTEXT.md` Open Questions 중 개발 진행에 필요한 사항 결정 (OQ-01~OQ-05)
- [ ] 개발 환경 설정 완료 (`Environment_Setup.md`)

---

## ✅ 완료 기준 (Definition of Done)

- [ ] 로컬 환경에서 Docker Compose로 전체 스택 실행 가능
- [ ] P1 기능 전체 구현 및 자체 테스트 통과
- [ ] `06.Testing` 단계로 넘길 수 있는 Beta 버전 빌드 가능
- [ ] 주요 기능별 개발 일지(`DEVLOG.md`) 작성 완료

---

## 📋 산출물 체크리스트

| 파일 | 상태 | 비고 |
|---|---|---|
| `Environment_Setup.md` | ⬜ 미작성 | 개발 시작 전 작성 필수 |
| `DEVLOG.md` | ⬜ 미작성 | 날짜별 개발 일지 누적 |
| `TROUBLESHOOT.md` | ⬜ 미작성 | 문제-원인-해결 누적 |

---

## 🛠 기술 스택 (개발 시 참조)

| 영역 | 기술 | 버전 |
|---|---|---|
| **Frontend** | React + Vite + FSD Architecture | 18 / 6 |
| **상태관리** | Zustand | latest |
| **스타일링** | Tailwind CSS + 스눙스터 디자인 토큰 | v3 |
| **Backend** | Spring Boot (Java) | 3.4.x / 21 |
| **DB** | PostgreSQL | 16.x |
| **인증** | JWT (Access 15분 / Refresh 7일) | - |
| **AI** | Google Gemini API | latest |
| **OCR** | Google Cloud Vision API | latest |
| **지도** | Kakao Maps JS SDK + Google Maps | latest |
| **알림** | FCM (Firebase Cloud Messaging) | latest |
| **인프라** | Docker Compose | - |
| **CI/CD** | GitHub Actions | - |

---

## 📝 문서 템플릿

### DEVLOG.md (날짜별 누적)

```markdown
## YYYY-MM-DD

### 진행 내용
- 구현한 기능/작업 요약

### 주요 코드 변경
- `파일경로`: 변경 사항 설명

### 이슈 & 해결
- 문제: 에러/이슈 내용
  - 원인: 분석
  - 해결: 방법

### 내일 계획
- [ ] 할 일
```

### TROUBLESHOOT.md (문제별 누적)

```markdown
## [TS-001] 문제 제목

| 항목 | 내용 |
|---|---|
| **발생일** | YYYY-MM-DD |
| **심각도** | High / Medium / Low |
| **상태** | Resolved / Open |

### 문제 상황
재현 방법 및 에러 메시지

### 원인 분석

### 해결 방법

### 배운 점
```

---

## 🤖 AI 요청 프롬프트 (바이브 코딩)

> `AI_Agent_Guide.md`, `04.Design/System_Architecture.md`, `04.Design/DB_Schema.md`, `04.Design/API_Specification.md`를 먼저 읽어 기술 스택과 설계 맥락을 파악하세요.

**환경 설정 가이드 작성 요청:**
> 위 기술 스택을 기반으로 로컬 개발 환경 설정 가이드(`Environment_Setup.md`)를 작성해줘. Docker Compose로 PostgreSQL + Spring Boot + React Dev Server를 한 번에 실행할 수 있는 구성을 포함하고, 각 서비스의 환경변수 목록(실제 값 제외)도 명시해줘.

**기능 구현 요청:**
> `02.Planning/Core_Features.md`의 [기능 ID]([기능명])를 구현해줘.
> - 백엔드: Spring Boot 3.4, `/api/v1/` prefix, `04.Design/API_Specification.md`의 명세를 따를 것.
> - 프론트엔드: React 18 + FSD 아키텍처 + Zustand + Tailwind CSS, 스눙스터 디자인 토큰 적용.
> - 구현 완료 후 `05.Development/DEVLOG.md`에 오늘 날짜로 개발 일지를 추가해줘.

**트러블슈팅 기록 요청:**
> 아래 에러를 분석하고 해결 방법을 제안해줘. 해결 후 `05.Development/TROUBLESHOOT.md`에 TS 항목으로 추가해줘.
>
> [에러 내용 입력]

---

## 📝 변경 이력
| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.0.0 | 2026-04-18 | 개발 단계 가이드 생성 | 숭늉 |
| v1.1.0 | 2026-04-23 | 단계 현황·선행 조건·완료 기준 추가, 파일명 통일(DEVLOG/TROUBLESHOOT), 기술 스택 표 추가, 바이브 코딩 특화 프롬프트로 교체 | 숭늉 |
