# 03.Service_Development (서비스 구현 단계) 가이드

이 단계는 설계된 시스템을 바탕으로 실제 프론트엔드, 백엔드, AI 모듈 코드를 작성하고 상호 연동하는 과정의 문서화를 담당합니다.

## 📄 작성 필수 문서 지정

1.  **`API_Specs.md` (API 명세서)**
    *   내부 시스템 간 연동을 위한 REST API 스펙 정의.
2.  **`Frontend_Component_Guide.md` (프론트엔드 컴포넌트 가이드)**
    *   재사용 가능한 UI 컴포넌트 목록 및 상태 관리(Zustand) 명세.
3.  **`AI_Module_Integration.md` (AI 모듈 통합 명세서)**
    *   메뉴판 OCR 결과 분석 로직 및 Gemini 프롬프트 설계 명세.
4.  **`Troubleshooting_Log.md` (이슈 및 트러블슈팅 로그)**
    *   개발 중 발생한 주요 버그, 의존성 충돌 및 해결 과정 기록.

---

## 📐 문서별 맞춤 템플릿 규칙

### 1. `API_Specs.md`
```markdown
## [API 엔드포인트 명] (예: POST /api/v1/restaurants/recommend)
- **Description**: 기능 요약
- **Request Parameters**
  - Parameter (Type): 설명 및 필수 여부
- **Response Format**
  - [JSON 응답 예시 코드 블록]
- **Error Codes**: 주요 에러 및 원인
```

### 2. `Frontend_Component_Guide.md`
```markdown
## [컴포넌트명] (예: RestaurantCard)
- **Props**: 전달받는 인자 명세
- **상태(State)**: 로컬 상태 및 글로벌(Zustand) 연동 여부
- **동작**: 클릭 이벤트 등 주요 동작
```

### 3. `AI_Module_Integration.md`
```markdown
## OCR 파이프라인
- [Mermaid Sequence Diagram으로 이미지 입력부터 위험 성분 판단까지 시각화]

## 프롬프트 설계 (Prompt Engineering)
- System Prompt: [프롬프트 내용]
- User Prompt: [프롬프트 내용]
- Expected Output: [기대되는 JSON 포맷]
```

### 4. `Troubleshooting_Log.md`
```markdown
## [이슈명/에러메시지]
- **발생일시**: YYYY-MM-DD
- **원인**: 문제의 근본 원인 분석
- **해결방법**: 구체적인 코드 변경 사항 또는 설정 변경 내용
```

---

## 🎨 시각화 HTML 생성 규칙

구현 단계의 문서(API 명세 등)를 HTML로 시각화할 때는 개발자 친화적인 형태를 띠어야 합니다.

1. **Swagger UI 스타일**: API 명세서는 Endpoint(HTTP Method 별 색상 다르게 - GET은 파란색, POST는 녹색 등)를 아코디언(Accordion) 컴포넌트로 접고 펼칠 수 있게 구현.
2. **코드 하이라이팅**: 코드 스니펫 영역은 어두운 테마(예: `bg-gray-800 text-white`)를 적용하고 고정폭 폰트(Monospace)를 사용.
3. **트러블슈팅 타임라인**: `Troubleshooting_Log`는 이슈 발생-해결의 과정을 타임라인 UI로 배치.
