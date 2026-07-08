---
title: OkeyMeal 세션 인수인계 상태 요약 (Handover State)
last_updated: 2026-07-08
status: Approved
---

# 🔄 세션 인수인계 문서 (Handover Document)

이 문서는 이전 AI 세션에서 진행된 작업의 문맥(Context)과 주요 결정 사항을 기록하여, 새로운 세션의 AI 에이전트가 단절 없이 업무를 이어가기 위해 작성되었습니다.

## 1. 현재 프로젝트 상태 요약
*   **프로젝트**: OkeyMeal (오키밀) - AI 기반 초개인화 안심 미식 케어 플랫폼
*   **공모전**: 2026 관광데이터 활용 공모전 (②-2 웹·앱 구현 부문 - 지정과제 5번)
*   **타겟**: 식이 제한(알레르기, 비건) 및 기저질환(당뇨 등)이 있는 관광객
*   **현재 완료 단계**: 0단계 (기반 아키텍처 및 마스터 가이드라인 셋업 완료)

## 2. 주요 아키텍처 및 룰 결정 사항 (핵심 컨텍스트)
1.  **5단계 라이프사이클 분리**: 기존 문서는 `99.Archive`로 분리하고, 공모전 진행 흐름에 맞춰 `01.Analysis` ~ `05.Submission` 까지 5단계 폴더를 신설.
2.  **문서 작성 룰 (AI_Docs_Guide.md)**:
    *   YAML 메타데이터에 반드시 `status: [Draft | Review | Approved]` 기재할 것.
    *   문서 작성 전 반드시 해당 폴더의 `_Stage_Guide.md`를 읽고 템플릿을 차용할 것.
3.  **다국어 UI 룰 (AI_Agent_Guide.md)**: 
    *   문서 자체는 한국어 작성. 단, UI/시나리오/프롬프트 텍스트 등은 글로벌 다국어(EN/CN/JA 등)를 염두에 두고 설계할 것.
4.  **시각화 구조 최적화 (HTML_Visualization_Guide.md)**:
    *   오프라인 구동을 위해 `documents/assets/`의 로컬 에셋(Tailwind, Mermaid, Chart.js)을 참조(`../../../assets/js/`).
    *   마크다운과 HTML이 섞이지 않도록, HTML 변환 시 반드시 `html/원본_문서명/` 하위 폴더를 생성하여 저장.

## 3. 🎯 새 세션에서 바로 이어갈 Next Task (할 일 목록)
새로운 세션이 열리면 가장 먼저 **[01. 분석 및 전략 단계]** 작업을 시작해야 합니다.

*   `[ ]` 1. `01.Analysis_Strategy/_Stage_Guide.md` 내용 숙지.
*   `[ ]` 2. 기존 분석 및 공모전 스펙을 바탕으로 **과제 분석서(`Task_Analysis.md`)** 초안 작성 및 검토.
*   `[ ]` 3. **타겟 페르소나 정의서(`Target_Persona.md`)** 수립.

---
**💡 다음 세션 시작 명령어 추천:**
> " `documents/handover_state.md` 와 `documents/AI_Agent_Guide.md`를 읽어줘. 그리고 Next Task의 1번, 2번 항목인 과제 분석서 작성을 시작하자."
