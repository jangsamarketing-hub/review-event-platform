# 리뷰이벤트 플랫폼 → ERP 연동 핸드오프

작성일: 2026-07-11  
목적: 별도 Claude Code 세션에서 ERP 업체관리 기능에 리뷰이벤트 데이터를 연동할 때 사용

---

## 1. 맥락 요약

"리뷰이벤트 플랫폼"은 요식업 매장용 게임형 리뷰 이벤트 웹앱입니다.  
지금까지 단독 앱으로 개발했고, 이제 **별도의 ERP(업체관리 시스템)** 에 이 앱의 데이터를 **위젯/기능으로 붙이는** 작업을 시작합니다.

### ERP에 붙이려는 기능
- **리뷰게임 참여도** — 매장별 일/주/월 게임 참여 건수, 쿠폰 발급/사용률
- **고객 CRM** — 고객 목록, 방문 이력, 쿠폰 발송, N일 미방문 필터
- **설문 통계** — 방문경로 비율, 항목별 별점 평균 (막대 그래프)
- **포인트/스탬프 적립** — 고객별 스탬프 카운트, 보상 현황

---

## 2. 리뷰이벤트 앱 파일 위치

```
C:\Users\PC\Desktop\00_개발 폴더\클로드 코드\리뷰 웹앱\files\
├── index.html          ← 전체 앱 (단일 파일, ~3,700줄)
├── CLAUDE.md           ← 리뷰이벤트 앱 인수인계 문서 (전체 구조 설명)
├── ERP-HANDOFF.md      ← 이 문서
├── package.json
└── vercel.json
```

**GitHub**: https://github.com/jangsamarketing-hub/review-event-platform  
**라이브 URL**: https://review-event-do.vercel.app

---

## 3. 리뷰이벤트 앱의 데이터 구조 (ERP 연동 핵심)

현재는 `localStorage`에 저장됩니다. Supabase 이전 후에는 API로 동일한 구조를 반환합니다.

### 3-1. 전체 매장 목록
```javascript
storesDB = {
  "demo": { ...STORE },        // 기본 데모 매장
  "1000000001": { ...STORE },  // 매장 ID별 데이터
}
```

### 3-2. 매장 하나(STORE)의 ERP 연동 핵심 데이터

```javascript
STORE = {
  profile: {
    name: "맛있는집",
    address: "서울시 ...",
    phone: "02-1234-5678",
    emoji: "🍽️"
  },

  // ① 고객 목록 (CRM)
  users: [
    {
      id: "u_xxxxxxxx",
      name: "김고객",
      phone: "010-1234-5678",
      marketing: true,          // 마케팅 동의 여부
      joined: "2026-07-01",    // 최초 가입일
      visits: 12               // 누적 방문 횟수
    }
  ],

  // ② 쿠폰 발급/사용 이력
  coupons: [
    {
      id: "c_xxxx",
      uid: "u_xxxxxxxx",       // 고객 ID
      name: "음료수 1개",
      benefit: "음료수 1개 무료",
      status: "available",     // available | used | expired
      issued: "2026-07-01",    // 발급일
      usedAt: null,            // 사용일
      sentAt: null             // CRM 발송일
    }
  ],

  // ③ 게임 참여 로그 (참여도)
  spins: [
    { userId: "u_xxxx", date: "2026-07-01", gameType: "roulette" }
  ],
  spinLog: [...],              // 동일 데이터 (중복 저장)
  visits: 47,                 // 매장 총 방문 수

  // ④ 설문 응답
  surveys: [
    {
      userId: "u_xxxx",
      name: "김고객",
      phone: "010-1234-5678",
      date: "2026-07-01",
      datetime: "2026-07-01 14:30",
      answers: {
        q1: ["네이버 검색", "지인 추천"],     // 방문경로 (복수선택)
        q2: {                                  // 항목별 별점 (0.5단위)
          "가격대비 맛": 4.5,
          "가격대비 양": 3.5,
          "조리 시간": 4,
          "직원 친절도": 5,
          "매장 청결도": 4.5
        },
        q3: "다음에 또 올게요"               // 주관식
      }
    }
  ],

  // ⑤ 스탬프 카드 (포인트 적립)
  stampSettings: {
    goal: 10,
    reward: "무료 메뉴 1개",
    grantStamp: "survey"       // 스탬프 적립 조건
  },
  stampCards: {
    "u_xxxx": {
      count: 7,                // 현재 누적 스탬프 수
      history: [
        { date: "2026-07-01", reason: "survey_2026-07-01" }
      ]
    }
  },

  // ⑥ 추가이벤트 참여 로그
  extraEventLog: [
    { platform: "kakao", date: "2026-07-01", userId: "u_xxxx", prize: "음료수 1개" }
  ]
}
```

---

## 4. ERP에서 뽑아 쓸 수 있는 데이터 계산 예시

```javascript
// 매장의 오늘 참여 건수
const todaySpins = STORE.spins.filter(s => s.date === today()).length;

// 쿠폰 사용률
const total = STORE.coupons.length;
const used = STORE.coupons.filter(c => c.status === 'used').length;
const rate = total ? Math.round(used / total * 100) : 0;

// N일 이상 미방문 고객 (ERP 재방문 유도 CRM용)
const daysAgo = (n) => {
  const d = new Date(); d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};
const notVisited30 = STORE.users.filter(u => {
  const lastVisit = STORE.spins
    .filter(s => s.userId === u.id)
    .map(s => s.date)
    .sort().pop();
  return !lastVisit || lastVisit < daysAgo(30);
});

// 방문경로 집계 (설문 q1)
const routeCounts = {};
STORE.surveys.forEach(sv => {
  (sv.answers.q1 || []).forEach(r => {
    routeCounts[r] = (routeCounts[r] || 0) + 1;
  });
});

// 설문 항목별 평균 별점
const matrixAvg = {};
const q2items = ['가격대비 맛', '가격대비 양', '조리 시간', '직원 친절도', '매장 청결도'];
q2items.forEach(item => {
  const scores = STORE.surveys.map(s => s.answers.q2?.[item]).filter(v => v > 0);
  matrixAvg[item] = scores.length ? scores.reduce((a,b) => a+b, 0) / scores.length : 0;
});
```

---

## 5. ERP 연동 방식 (2가지 선택지)

### 선택지 A — iframe 임베드 (빠른 방법)
ERP의 업체 상세 페이지 안에 리뷰이벤트 관리자 화면을 iframe으로 넣는 방식.

```html
<!-- ERP 업체 상세 페이지 내 -->
<iframe
  src="https://review-event-do.vercel.app/?store=1000000001"
  style="width:100%; height:700px; border:none; border-radius:12px"
></iframe>
```

- **장점**: 코드 변경 없이 즉시 적용
- **단점**: ERP 디자인과 이질감, 데이터 공유 불가

### 선택지 B — API/데이터 연동 (권장, Supabase 이전 후)
Supabase에 데이터를 올리면, ERP에서 API 호출로 데이터를 가져와 위젯으로 표시.

```
리뷰이벤트 앱 → Supabase DB → ERP API 호출 → ERP 대시보드 위젯
```

ERP에서 보여줄 위젯 예시:
- 이번 달 리뷰게임 참여 건수 카드
- 최근 7일 미방문 고객 수 (CRM 타겟)
- 설문 평균 별점 막대그래프
- 스탬프 달성률 현황

### 선택지 C — 컴포넌트 분리 후 ERP에 직접 통합
`index.html`에서 각 기능을 별도 JS 모듈로 분리한 뒤 ERP 프레임워크에 통합.  
작업량 가장 크지만 완전 통합 가능. Supabase 이전과 동시에 진행 추천.

---

## 6. 다른 Claude Code 세션에서 시작하는 방법

### 방법 1: 이 폴더를 새 Claude Code에서 열기
```
새 Claude Code 세션 → 
폴더 열기: C:\Users\PC\Desktop\00_개발 폴더\클로드 코드\리뷰 웹앱\files
```
그러면 `CLAUDE.md`가 자동으로 읽혀서 컨텍스트가 로드됩니다.

### 방법 2: 새 세션 시작 메시지 (복붙용)
```
이 폴더는 요식업 매장용 "리뷰이벤트 웹앱"이야.
CLAUDE.md와 ERP-HANDOFF.md를 먼저 읽어줘.

지금 할 작업:
- 우리 ERP(업체관리 시스템)에 리뷰이벤트 데이터를 붙이려고 해
- ERP 폴더는 [ERP 프로젝트 경로]야
- 리뷰이벤트 앱의 고객 CRM, 설문 통계, 스탬프 적립, 게임 참여도 데이터를
  ERP 업체 상세 페이지의 위젯으로 넣고 싶어
- ERP 기술스택: [React/Vue/Laravel 등 여기에 작성]
- 연동 방식은 ERP-HANDOFF.md의 5번 선택지 중 [A/B/C]로 할 예정이야
```

---

## 7. 파일 전달 방법

### 현재 파일 위치
```
C:\Users\PC\Desktop\00_개발 폴더\클로드 코드\리뷰 웹앱\files\
```

### GitHub에서 받기 (최신 코드)
```bash
git clone https://github.com/jangsamarketing-hub/review-event-platform.git
```

### 라이브 사이트
https://review-event-do.vercel.app

---

## 8. 개발 이력 타임라인

| 버전 | 날짜 | 주요 내용 |
|------|------|-----------|
| V1 | 2026-07 초 | 기본 기능 (룰렛/카드/복권, VIP, 스탬프, 설문, QR) |
| V2 | 2026-07-10 | 보안강화, 고객로그인 복원, 개인정보동의, 기본값 개선 |
| V2-2 | 2026-07-11 | 로그인 힌트, 매장초기화, 반별점(0.5단위), 홈 추가이벤트 |
| V2-3 | 2026-07-11 | 설문 그래프화, 총괄관리자 진입, 고객화면 미리보기, accordion |
| 예정 | - | Supabase 백엔드 이전, ERP 연동 |
