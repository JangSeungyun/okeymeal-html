# 01.Analysis_Strategy (예비심사 준비 단계) 가이드

이 단계는 공모전 지정과제 5번에 맞춰 시장을 분석하고 서비스 전략을 수립하는 단계입니다. 모든 문서는 아래 명시된 템플릿 규칙을 따라 상세하게 작성되어야 합니다.

## 📄 작성 필수 문서 목록

1.  **`Task_Analysis.md` (과제 분석서)**
    *   지정과제 5번(맞춤형 식당 정보 부족으로 인한 만성질환자의 외식 불안감 발생)의 핵심 문제점, 타겟 요구사항, 데이터 활용 방향성 분석.
2.  **`Target_Persona.md` (타겟 페르소나 정의서)**
    *   주요 타겟(식이 제한이 있는 외국인 관광객, 당뇨/고혈압 등 기저질환자)의 Pain Point와 Needs 도출.
3.  **`Service_Direction.md` (서비스 방향성 및 차별화 전략)**
    *   기존 OkeyMeal 기능과 과제 5번을 결합한 핵심 가치 제안 (예: 안심 식당 매칭 + 식후 혈당 관리 산책 코스 연계).

---

## 📐 문서별 맞춤 템플릿 규칙

### 1. `Task_Analysis.md`
```markdown
## 1. 해결 과제 정의 (Problem Definition)
- 현상 및 문제점 명시
- 문제 발생의 근본 원인 분석

## 2. 공공데이터 활용 전략 (Data Strategy)
- [필수] 한국관광공사 OpenAPI 활용 방안 (TourAPI 등)
- 기타 외부 API (식약처 공공데이터 등) 연계 방안

## 3. 기대 효과 (Expected Impact)
- 정량적/정성적 기대 효과
```

### 2. `Target_Persona.md`
```markdown
## 페르소나 프로필: [페르소나 이름]
| 항목 | 내용 |
| --- | --- |
| 인적사항 | 나이, 국적, 직업, 기저질환/식이제한 종류 |
| Pain Point | 여행/외식 시 겪는 주요 어려움 |
| Needs | 서비스에서 바라는 핵심 기능 |

## 고객 여정 지도 (Customer Journey Map)
- [Mermaid Flowchart 형식으로 식당 검색 -> 식사 -> 산책의 여정 시각화]
```

### 3. `Service_Direction.md`
```markdown
## 1. 핵심 가치 제안 (Value Proposition)
- 한 줄 요약
- 경쟁사 대비 차별점 분석 (표 형식)

## 2. 필수 구현 과제
- 과제 5번 해결을 위한 필수 기능 리스트
- 서비스 성공 지표 (KPI)
```

---

## 🎨 시각화 HTML 생성 규칙

`Task_Analysis` 및 `Target_Persona` 등 분석 결과를 HTML로 시각화할 때는 다음 규칙을 따릅니다.

1. **대시보드 레이아웃**: 핵심 지표(타겟 규모, 기대 효과 등)를 상단에 KPI 카드 형태로 배치.
2. **페르소나 카드 뷰**: `Target_Persona.md`의 내용을 명함 또는 프로필 카드 형태로 시각화 (Tailwind Grid 활용).
3. **고객 여정 지도**: Mermaid Flowchart를 가로로 스크롤 가능하도록(`overflow-x-auto`) 렌더링.
