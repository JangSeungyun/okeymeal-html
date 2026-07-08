---
title: HTML 시각화 공통 가이드 (HTML_Visualization_Guide)
version: v1.1.0
last_updated: 2026-07-08
author: 숭늉
---

# 🎨 HTML 시각화 공통 가이드

이 문서는 `documents/` 내의 마크다운 산출물들을 웹 브라우저에서 직관적으로 확인할 수 있도록 HTML 기반 시각화 페이지를 생성할 때 준수해야 하는 공통 규칙입니다.

## 1. 기본 아키텍처 및 라이브러리 (Common Stack)

모든 시각화 HTML 파일은 별도의 빌드 과정 없이 브라우저에서 바로 열람할 수 있도록 단일 파일(Single HTML File) 구성을 지향하며, 외부 의존성 없이 오프라인에서도 작동하도록 **로컬 에셋(Local Assets)**을 참조합니다.

*   **CSS Framework**: Tailwind CSS (로컬) - `<script src="../../../assets/js/tailwindcss.js"></script>`
*   **다이어그램 렌더링**: Mermaid.js (로컬) - `<script src="../../../assets/js/mermaid.min.js"></script><script>mermaid.initialize({ startOnLoad: true, theme: 'neutral' });</script>`
*   **차트 렌더링 (필요시)**: Chart.js (로컬) - `<script src="../../../assets/js/chart.umd.js"></script>`
*   **폰트**: 프리텐다드(Pretendard) 웹폰트 적용.

## 2. 폴더 구조 최적화 규칙 (Directory Structure)

HTML 파일이 늘어나 마크다운 파일과 섞이는 것을 방지하기 위해, 각 단계별 폴더(`01.Analysis_Strategy` 등) 내부에 **`html/원본_문서명/`** 하위 폴더를 생성하여 결과물을 관리합니다.

*   **예시**: `01.Analysis_Strategy/html/Task_Analysis/dashboard.html`
*   **경고**: 이 깊이(`html/폴더명/파일.html`)를 준수해야 위의 `../../../assets/js/` 상대 경로가 정상 작동합니다.

## 3. 공통 UI/UX 레이아웃 규칙

모든 시각화 문서는 일관성을 위해 아래의 기본 구조를 가집니다.

1.  **Header 영역**: 
    *   좌측 상단: 프로젝트 로고 (OkeyMeal) 및 문서 타이틀
    *   우측 상단: 버전(`vX.Y.Z`) 및 최종 업데이트 날짜
2.  **Contents 영역**:
    *   최대 너비(Max-width)를 주어 가독성 확보 (예: `max-w-5xl mx-auto`).
    *   섹션 구분 시 그림자(`shadow-md`) 및 카드(`bg-white rounded-lg p-6`) 디자인 적용.
3.  **Color Palette**:
    *   OkeyMeal 브랜드 컬러(안심/건강/자연)에 맞춘 녹색(Green/Teal) 또는 차분한 파란색(Slate/Blue) 계열을 포인트 컬러로 사용.

## 4. 폴더/문서별 시각화 전략

각 단계(Stage)별 문서 특성에 따라 시각화 방식이 달라집니다. 상세한 시각화 포맷과 요구사항은 각 폴더 내의 **`_Stage_Guide.md` 하단 `[시각화 HTML 생성 규칙]` 섹션**에 명시되어 있습니다.

*   **01.Analysis_Strategy**: 시각적인 대시보드 형태, 페르소나 카드 뷰.
*   **02.Planning_Design**: 아키텍처 맵, 반응형 ERD 뷰어, 와이어프레임 갤러리.
*   **03.Service_Development**: API 문서(Swagger-like) UI, 코드 스니펫 하이라이팅.
*   **04.Testing_QA**: 테스트 통과율 도넛 차트, 칸반 보드 형태의 버그 리포트.
*   **05.Submission_Review**: PT 발표 자료 형태의 슬라이드쇼 레이아웃.

## 5. 통합 랜딩 페이지 (index.html) 관리 규칙

생성되는 모든 단계별 시각화 HTML 문서들은 `documents/index.html` (통합 문서 허브)에서 좌측(또는 상단) 글로벌 메뉴를 통해 쉽게 열람할 수 있어야 합니다.
*   **문서 생성 봇(AI)의 의무**: 시각화 HTML 작성 완료 직후 반드시 `documents/index.html` 소스 코드 내부의 **`menuConfig` 배열(JavaScript)** 을 찾아, 알맞은 카테고리(`items` 배열)에 `{ name: "문서명", path: "경로" }` 객체를 추가해야 합니다.
*   **Iframe 및 SPA 연동**: 랜딩 페이지는 Iframe과 동적 사이드바 렌더링을 통해 페이지 새로고침 없이 빠른 전환을 지원합니다. 첫 진입 시에는 `home.html`(대시보드)이 렌더링됩니다.

---

## 📝 변경 이력
| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v1.0.0 | 2026-07-08 | 최초 작성 (HTML 시각화 공통 규칙 수립) | 숭늉 |
| v1.1.0 | 2026-07-08 | `html/원본_문서명/` 하위 폴더 관리 규칙 추가 및 에셋 참조 경로 업데이트 | 숭늉 |
| v1.2.0 | 2026-07-08 | 통합 랜딩 페이지(`index.html`) 연동 및 자동화 규칙 추가 | 숭늉 |
