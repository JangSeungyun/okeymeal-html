---
title: "[설계] 외부 API 인벤토리 (External API Inventory)"
version: v0.1.0
last_updated: 2026-05-08
author: 숭늉
---

# 🔌 외부 API 인벤토리 (External API Inventory)

본 문서는 OkeyMeal 서비스에서 활용하는 외부 OpenAPI 및 서드파티 서비스의 명세, 인증 방식, 쿼터 및 제한 사항을 관리합니다.

> 📌 **참조 문서**
> - WBS: [`02.Planning/WBS.md`](../02.Planning/WBS.md) Task 1.2
> - RACI: [`02.Planning/RACI.md`](../02.Planning/RACI.md) (트랙 A: R/A, 트랙 B: C)
> - 기술 결정: [`04.Design/Technical_Decision_Records.md`](./Technical_Decision_Records.md)

---

## 1. 공공 데이터 (Public Data)

### 1.1 한국관광공사 TourAPI 4.0
*   **용도:** 전국 식당 POI 정보, 다국어 관광 정보, 지역/서비스 코드 조회.
*   **제공처:** [관광데이터 Hub](https://api.visitkorea.or.kr/) / 공공데이터포털
*   **엔드포인트:** `http://apis.data.go.kr/B551011/`
    *   국문: `KorService1`
    *   영문: `EngService1`
    *   일어: `JpnService1`
    *   중문(간): `ChnService1`
*   **인증 방식:** API Key (`serviceKey` 쿼리 파라미터, Encoding/Decoding 주의)
*   **주요 오퍼레이션:**
    *   `areaBasedList1`: 지역기반 관광정보 조회
    *   `searchKeyword1`: 키워드 검색 조회
    *   `detailIntro1`: 소개정보 조회 (영업시간, 휴무일 등)
    *   `detailImage1`: 이미지 정보 조회
*   **쿼터:** 기본 10,000건/일 (공공데이터포털에서 증액 신청 가능)

### 1.2 식품의약품안전처 (식품안전나라)
*   **용도:** 표준 조리식품 레시피 성분 분석 및 가공식품 영양성분 대조.
*   **제공처:** [식품안전나라 데이터활용서비스](https://www.foodsafetykorea.go.kr/api/main.do)
*   **엔드포인트:** `http://openapi.foodsafetykorea.go.kr/api/{key}/{serviceId}/{type}/{start}/{end}/{params}`
*   **인증 방식:** API Key (URL 경로 포함)
*   **주요 서비스 ID:**
    *   `I2790`: 식품영양성분 DB (가공식품 중심)
    *   `COOKRCP01`: 요리(조리식품) 레시피 DB (성분 분석 Ground Truth)
*   **쿼터:** 일일 1,000건 (활용 사례 등록 시 한도 상향 가능)

### 1.3 기상청 단기예보 조회 서비스 2.0
*   **용도:** 실시간 날씨 기반 추천 컨텍스트 재정렬 (Contextual Re-ranking).
*   **제공처:** 공공데이터포털
*   **엔드포인트:** `http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/`
*   **인증 방식:** API Key (`serviceKey` 쿼리 파라미터)
*   **주요 오퍼레이션:**
    *   `getVilageFcst`: 단기예보 조회 (격자 좌표 nx, ny 사용)
*   **비고:** 기상청 전용 격자 좌표 변환 로직 필요.

### 1.4 보건복지부/심평원 병의원·약국 현황
*   **용도:** SOS 메디컬 핫라인 (현 위치 기반 응급실/약국 매핑).
*   **제공처:** 공공데이터포털
*   **엔드포인트:** `http://apis.data.go.kr/B551182/hospInfoServicev2/`
*   **인증 방식:** API Key (`serviceKey`)
*   **필터링:** 외국어 대응 가능 기관 필터링 로직 구현 예정.

---

## 2. 지도 및 위치 서비스 (Maps & Location)

### 2.1 Google Maps Platform
*   **용도:** 사용자 앱 메인 지도 UI, 글로벌 표준 POI 검색.
*   **제공처:** Google Cloud Console
*   **엔드포인트:** `https://maps.googleapis.com/maps/api/`
*   **인증 방식:** API Key (`key` 파라미터) + HTTP Referrer 제한
*   **주요 API:**
    *   Maps JavaScript API: 웹 지도 렌더링
    *   Places API (New): 장소 상세 정보, 자동완성
    *   Geocoding API: 위경도 ↔ 주소 변환
*   **비용:** 월 $200 무료 크레딧 제공, 초과 시 종량제.

### 2.2 Kakao Maps API
*   **용도:** 국내 정밀 주소 검색, 좌표 ↔ 행정구역 변환 (국내 주소 체계 최적화).
*   **제공처:** [Kakao Developers](https://developers.kakao.com/)
*   **엔드포인트:** `https://dapi.kakao.com/v2/local/`
*   **인증 방식:** REST API Key (`Authorization: KakaoAK {key}` 헤더)
*   **주요 API:**
    *   `/search/address.json`: 주소 검색
    *   `/geo/coord2address.json`: 좌표로 주소 변환
*   **쿼터:** 무료 레벨 일일 제한 존재.

### 2.3 Naver Maps API (NCP)
*   **용도:** 대중교통 길찾기 (Directions API), 국내 도보/차량 경로 안내.
*   **제공처:** [Naver Cloud Platform](https://console.ncloud.com/)
*   **엔드포인트:** `https://naveropenapi.apigw.ntruss.com/map-direction/v1/`
*   **인증 방식:** Client ID/Secret (`X-NCP-APIGW-API-KEY-ID`, `X-NCP-APIGW-API-KEY` 헤더)
*   **주요 API:**
    *   Driving / Transit Directions

---

## 3. 푸시 및 인프라 (Push & Infra)

### 3.1 Firebase Cloud Messaging (FCM)
*   **용도:** 사용자 알림, 점주 주문/문의 알림 푸시 발급.
*   **제공처:** Firebase Console
*   **엔드포인트:** `https://fcm.googleapis.com/v1/projects/{projectId}/messages:send`
*   **인증 방식:** OAuth 2.0 Access Token (Google Service Account)
*   **규약:** HTTP v1 API 사용 (Legacy Server Key 사용 금지).

---

## 4. AI 및 LLM (AI & LLM)

### 4.1 Google Gemini API
*   **용도:** 메뉴판 OCR(Vision), 다국어 번역, RAG 기반 추천 설명 생성.
*   **제공처:** Google AI Studio / Vertex AI
*   **엔드포인트:** `https://generativelanguage.googleapis.com/v1beta/`
*   **인증 방식:** API Key 또는 OAuth 2.0
*   **모델 후보:** `gemini-1.5-pro`, `gemini-1.5-flash`
*   **임베딩:** `text-embedding-004` (768d)

---

## 5. 관리 및 주의사항

1.  **시크릿 관리:** 모든 API Key와 Service Account JSON은 Git에 커밋하지 않으며, `.env` 또는 CI/CD Secret 변수로 관리합니다.
2.  **Rate Limiting:** 각 API의 쿼터 초과를 방지하기 위해 서버 측에서 Rate Limiter(Resilience4j 등) 및 캐싱(Valkey)을 적용합니다.
3.  **Circuit Breaker:** 외부 API 장애 시 서비스 전체가 중단되지 않도록 Fallback 로직(예: Stale 데이터 노출 또는 기본 추천 노출)을 반드시 구현합니다.
4.  **추상화 인터페이스:** 특정 벤더 종속성을 줄이기 위해 `MapClient`, `LlmProvider` 등 공통 인터페이스를 통해 접근하도록 설계합니다. (TDR §1.6)

---

## 📝 변경 이력
| 버전 | 날짜 | 변경 내용 | 작성자 |
|---|---|---|---|
| v0.1.0 | 2026-05-08 | 최초 작성 (TourAPI, 식약처, 기상청, Maps 3종, FCM, Gemini 포함) | 숭늉 |
