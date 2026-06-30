# Plant-it 발표 PPT 가이드

> 2026 GBSW 캡스톤 발표용 — 슬라이드 구성 + AI 이미지 프롬프트 포함

---

## 슬라이드 구성 (총 12장 기준)

---

### Slide 1 — 표지

**제목:** Plant-it  
**부제:** 식물과 함께 성장하는 AI 케어 앱  
**구성:** 앱 로고 + 팀원 이름 + 날짜

**AI 이미지 프롬프트:**
```
A clean, modern mobile app icon design featuring a small green sprout
growing from dark rich soil, minimalist flat design style, soft green and
white color palette, centered on a white background, professional and
approachable aesthetic, high resolution
```

---

### Slide 2 — 문제 정의 (Why?)

**메시지:** "식물을 키우고 싶지만 어떻게 해야 할지 모르겠다"

**내용:**
- 국내 반려식물 인구 급증 (2020년 이후 +40%)
- 식물 관리 정보의 파편화 — 검색해도 제각각
- 물주기, 햇빛, 비료 시기를 기억하기 어렵다
- 전문가에게 식물 상태를 물어보기 어렵다

**AI 이미지 프롬프트:**
```
A sad wilting potted plant on a windowsill, soft natural light, slightly
desaturated warm tones, the plant drooping and dry, realistic photography
style, shallow depth of field, evoking the feeling of a neglected but
beloved plant, clean minimal background
```

---

### Slide 3 — 솔루션 (What?)

**메시지:** Plant-it이 식물 관리의 모든 것을 해결합니다

**내용:**
- AI 기반 식물 진단 및 케어 가이드
- 물주기·비료·햇빛 알림 자동 설정
- 성장 일기 & 사진 기록
- 실시간 AI 챗봇 (GPT-4o-mini)

**AI 이미지 프롬프트:**
```
A modern smartphone displaying a beautiful plant care app interface,
surrounded by lush green tropical houseplants, bright natural studio
lighting, flat lay perspective from slightly above, clean white surface,
professional product photography aesthetic
```

---

### Slide 4 — 주요 기능 소개 (1/2)

**내용:**
- 식물 등록 및 프로필 관리 (사진, 이름, 종류)
- AI 식물 분석 — 사진 한 장으로 식물 상태 진단
- 케어 히스토리 타임라인

**AI 이미지 프롬프트:**
```
A phone screen mockup showing a clean plant profile page with a
beautiful monstera deliciosa photo, health status indicators in green,
and a care history timeline, modern UI design with rounded cards,
soft green gradient background, isometric style illustration
```

---

### Slide 5 — 주요 기능 소개 (2/2)

**내용:**
- 개인화 알림 — 종별 케어 주기 자동 계산
- 성장 다이어리 — 사진 & 텍스트 기록
- AI 채팅 — "잎이 노래졌어요" 같은 자연어 질문 가능

**AI 이미지 프롬프트:**
```
A notification on a smartphone saying "🌱 오늘은 몬스테라에 물 줄 날이에요!",
surrounded by app chat bubbles showing a conversation about plant care,
soft white and green UI, playful but clean mobile design illustration,
flat vector art style
```

---

### Slide 6 — 기술 스택

**내용:**

| 영역 | 기술 |
|------|------|
| 모바일 프론트엔드 | Flutter (Android / iOS) |
| 웹 법적 문서 | Flutter Web |
| 백엔드 API | Spring Boot 3, Java 17 |
| 데이터베이스 | MySQL + JPA/Hibernate |
| 인증 | JWT (자체 구현) + Google OAuth (Firebase) |
| AI | OpenAI GPT-4o-mini API |
| 스토리지 | Firebase Storage |
| 푸시 알림 | Firebase Cloud Messaging |
| 이메일 | JavaMail (iCloud SMTP) |
| 배포 | (서버 / 클라우드) |

**AI 이미지 프롬프트:**
```
A tech stack diagram illustration in a clean modern infographic style,
icons for Flutter, Spring Boot leaf logo, MySQL dolphin, Firebase logo,
OpenAI logo, connected by subtle lines in a flow chart, white and green
color scheme, minimal flat design, professional presentation quality
```

---

### Slide 7 — 시스템 아키텍처

**내용:**
```
[Flutter App]
     │
     ├─ REST API ──→ [Spring Boot BE]
     │                    │
     │                    ├─ MySQL DB
     │                    ├─ Firebase Auth (Google 로그인)
     │                    ├─ Firebase Storage (이미지)
     │                    ├─ FCM (푸시 알림)
     │                    └─ OpenAI API (AI 분석·채팅)
     │
     └─ Firebase SDK (직접) ──→ Google 로그인 토큰 발급
```

**AI 이미지 프롬프트:**
```
A clean system architecture diagram illustration for a mobile app,
showing a Flutter phone icon on the left connecting via arrows to a
Spring Boot server in the center, which connects to MySQL database,
Firebase cloud, and OpenAI brain icon on the right, white background,
soft green and gray color palette, professional infographic style
```

---

### Slide 8 — 회원가입 / 로그인 흐름

**내용:**
- 이메일 회원가입: 이메일 인증 코드 → 닉네임 설정 → 완료
- 구글 로그인: Firebase 토큰 → 백엔드 검증 → JWT 발급
- JWT Access/Refresh Token (180일 유효)
- 비밀번호 찾기: 이메일 인증 코드 → 재설정

**AI 이미지 프롬프트:**
```
A flowchart illustration showing user authentication journey: phone
showing login screen → email verification code screen → success screen,
connected by curved arrows, soft mint green and white, friendly mobile
app illustration style, simple icons for each step
```

---

### Slide 9 — 데모 (핵심 화면 스크린샷)

**내용:** 실제 앱 스크린샷 배치 (아래 목록 중 선택)
- 홈 화면 (내 식물 목록)
- 식물 상세 + AI 분석 결과
- 다이어리 작성 화면
- AI 채팅 화면
- 알림 설정 화면

> 스크린샷은 실제 앱 캡처본 사용 권장

**AI 이미지 프롬프트 (보완용 목업):**
```
Three smartphone mockups side by side showing: (1) a home screen with
a list of green houseplants in rounded cards, (2) a plant detail screen
with health score and care tips, (3) a chat interface with an AI assistant
answering questions about plant care, modern flat design, soft green and
white UI, professional app store screenshot style
```

---

### Slide 10 — 개발 과정 & 어려웠던 점

**내용:**
- Firebase 인증 연동 (Google 로그인 토큰 검증)
- 이메일 인증 + 비밀번호 재설정 플로우 설계
- OpenAI 응답을 식물 케어 컨텍스트에 맞게 프롬프트 튜닝
- Flutter + Spring Boot 간 JWT 처리 통일
- iOS 푸시 알림 APNS 설정

**AI 이미지 프롬프트:**
```
A developer at a desk with multiple monitors showing code and app
screens, warm focused lighting, plants on the desk, a whiteboard with
diagrams in the background, realistic digital illustration style, cozy
productive atmosphere, green accent colors
```

---

### Slide 11 — 성과 및 향후 계획

**내용:**

**성과:**
- REST API 엔드포인트 30+ 구현
- 이메일 인증 / Google OAuth 완성
- AI 식물 분석 및 채팅 기능 완성
- 앱스토어 출시 준비 완료

**향후 계획:**
- 식물 커뮤니티 기능 (다른 사용자와 식물 공유)
- 식물 종 DB 확장
- 위젯 지원 (홈 화면 물주기 D-day)
- 다국어 지원 (영어)

**AI 이미지 프롬프트:**
```
A roadmap illustration with a winding green path through a garden,
milestones marked with small plant growth icons from seedling to full
tree, soft watercolor style, optimistic and forward-looking mood,
clean white background with green and earth tone accents
```

---

### Slide 12 — 마무리 / Q&A

**내용:**
- "Plant-it과 함께 당신의 식물을 건강하게 키워보세요"
- GitHub / 앱스토어 QR코드
- 팀원 역할 소개

**AI 이미지 프롬프트:**
```
A thriving collection of beautiful healthy houseplants in various pots,
monstera, pothos, succulent, fiddle leaf fig, soft warm natural window
light, peaceful and lush atmosphere, realistic photography style,
clean minimal background, celebratory and accomplished mood
```

---

## 발표 팁

1. **데모는 짧게** — 앱 직접 시연 시 홈 → 식물 추가 → AI 분석 → 채팅 순서로 60초 내 흐름 보여주기
2. **기술 설명은 청중 레벨에 맞게** — 심사위원이 개발자가 아니라면 "AI가 사진을 보고 식물 상태를 알려줍니다" 정도로 단순화
3. **어려웠던 점 슬라이드** — 문제를 어떻게 해결했는지 한 줄씩 추가하면 신뢰감 상승
4. **숫자로 말하기** — "API 30개", "인증 4단계 구현" 등 구체적인 수치 사용

---

## AI 이미지 생성 추천 툴

| 툴 | 특징 | 접근 |
|----|------|------|
| **Midjourney** | 퀄리티 최고, 사실적 | Discord 봇 |
| **DALL-E 3** | ChatGPT Plus에서 바로 사용 가능 | ChatGPT |
| **Ideogram** | 텍스트 포함 이미지에 강함 | ideogram.ai |
| **Adobe Firefly** | 저작권 안전, 상업용 OK | adobe.com/firefly |

> 슬라이드 배경이나 장식용으로는 **Unsplash**에서 `houseplant`, `minimal plant` 키워드로 무료 사진도 사용 가능
