# 02.Planning_Design (기획 및 설계 단계) 가이드

분석된 전략을 바탕으로 실제 구현할 서비스의 상세 기능과 기술 구조를 설계하는 단계입니다. 심사위원이 시스템의 완결성을 파악할 수 있도록 상세히 작성합니다.

## 📄 작성 필수 문서 지정

1.  **`Core_Features.md` (상세 기능 정의서)**
    *   식이 프로필 기반 필터링, AI 렌즈(OCR) 성분 분석 경고, 식후 산책 코스 추천 등 기능 명세.
2.  **`System_Architecture.md` (시스템 아키텍처 설계서)**
    *   프론트엔드-백엔드-AI 모델 간의 데이터 흐름도 및 인프라 구조.
3.  **`DB_Schema.md` (데이터베이스 설계서)**
    *   사용자 건강/식이 프로필, 식당 정보, 산책로 정보의 ERD.
4.  **`UI_UX_Flow.md` (화면 설계 및 유저 플로우)**
    *   주요 화면 흐름도 및 각 화면별 컴포넌트 요구사항.

---

## 📐 문서별 맞춤 템플릿 규칙

### 1. `Core_Features.md`
```markdown
## [기능명] (예: AI 렌즈 성분 경고)
- **User Story**: "기저질환자로서, 메뉴판을 스캔하여 위험 성분이 있는지 알고 싶다."
- **기능 설명**: 상세 동작 로직 및 예외 처리
- **연관 데이터**: 활용되는 OpenAPI 또는 자체 DB 명시
```

### 2. `System_Architecture.md`
```markdown
## 시스템 구성도
- [Mermaid Architecture Diagram 필수 삽입]

## 주요 컴포넌트 명세
- Frontend: 기술 스택 및 역할
- Backend: 기술 스택 및 역할
- AI/Data: OCR 연동 및 추론 로직 역할
```

### 3. `DB_Schema.md`
```markdown
## ERD 시각화
- [Mermaid ERD Diagram 필수 삽입]

## 테이블 정의서
| Table Name | Column | Type | Description |
| --- | --- | --- | --- |
| User_Profile | dietary_restrictions | JSON | 알러지, 당뇨 등 제약 조건 |
```

### 4. `UI_UX_Flow.md`
```markdown
## 전체 화면 흐름도
- [Mermaid State Diagram 필수 삽입]

## 화면별 상세 요구사항
- [화면명]: 주요 UI 요소 및 사용자 액션 (API 호출 트리거 명시)
```

---

## 🎨 시각화 HTML 생성 규칙

설계 문서를 HTML로 시각화할 때는 구조의 명확한 파악을 위해 다음 규칙을 따릅니다.

1. **다이어그램 풀스크린 지원**: 아키텍처나 ERD 등 넓은 Mermaid 다이어그램은 더블클릭 시 모달(풀스크린)로 확대되거나, 가로 스크롤을 필수로 제공.
2. **사이드바 네비게이션**: `System_Architecture`, `DB_Schema`, `UI_UX_Flow` 등 여러 설계 파트를 탭(Tab) 또는 좌측 사이드바로 이동할 수 있게 레이아웃 구성.
3. **테이블 스타일링**: 스키마 테이블은 Tailwind의 `table-auto`, `border-collapse`, `hover:bg-gray-50` 등을 적용하여 가독성을 극대화.
