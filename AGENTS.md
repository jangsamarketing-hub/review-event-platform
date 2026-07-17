# 리뷰이벤트 플랫폼 — Codex 인수인계

## 프로젝트 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트 이름 | 리뷰이벤트 플랫폼 (요식업 매장용) |
| 메인 파일 | `index.html` (단일 파일, 약 250KB, 3,700줄) |
| 기술 스택 | Vanilla JS + HTML5 Canvas, localStorage |
| GitHub | https://github.com/jangsamarketing-hub/review-event-platform |
| 라이브 URL | https://review-event-do.vercel.app |
| 배포 방식 | GitHub push → Vercel 자동 배포 |
| 최종 커밋 | V2-3 (2026-07-11) |

---

## 개발 규칙 (반드시 지켜야 함)

1. **수정 후 항상 브라우저에서 직접 확인** — 콘솔 에러(F12) 없는지 체크
2. **비개발자 사용자** — 전문용어 최소화, 뭘 왜 하는지 한 줄씩 설명하며 진행
3. **큰 구조 변경(파일 분리 등)은 사용자 승인 후에만** 진행
4. **단일 HTML 파일 유지** — 별도 JS/CSS 파일 분리하지 말 것 (Supabase 이전 시점에 같이 논의)
5. 로컬 개발: `python -m http.server 8420` → http://localhost:8420

### 토큰 절약 전략 (search-first · tdd-workflow · strategic-compact)

6. **search-first** — 코드를 읽기 전에 Grep/Glob으로 먼저 위치를 찾는다. 파일 전체를 Read하기 전에 검색으로 범위를 좁혀라.
7. **tdd-workflow** — 기능 추가 시 변경할 함수/섹션만 파악 후 최소 범위만 Edit. 전체 파일 재작성 금지.
8. **strategic-compact** — 컨텍스트가 길어지면 이전 탐색 결과·중간 출력은 참조하지 말고 버려라. 필요한 것만 다시 검색. 긴 파일(index.html)은 offset+limit으로 필요한 줄만 읽어라.

---

## 완료된 기능 전체 목록 (V2-3 기준, 2026-07-11)

### 고객 화면
- **로그인**: 닉네임 + 전화번호 필수 입력 (개인정보 동의 모달 포함)
- **개인정보 동의**: 수집항목/이용목적/보관기간(2년)/제3자 제공(매장명+DG스튜디오) 법적 고지
- **메인 게임 3종**: 룰렛 / 카드뽑기 / 긁는복권 (매장 관리자가 택1)
- **추가이벤트 3종**: 카카오맵 / 구글 / 티맵 — 플랫폼별 독립 게임·상품·확률 설정
- **홈화면**: 추가이벤트(카카오/구글/티맵) 카드 → 직접 게임 진입
- **VIP 등급**: 브론즈~다이아 5단계 (10/20/30/50회 방문 기준) + 자동 쿠폰
- **스탬프 카드**: 고객별 독립 카운트, 설문 제출 시 자동 적립 + 팝업
- **만족도 설문**: 방문경로 복수선택 + 항목별 반별점(0.5단위) + 주관식
- **쿠폰함**: 자동 발급 쿠폰 관리
- **네이버 플레이스**: 리뷰 유도 화면

### 매장 관리자 화면
- **통계**: 일/주/월 참여 차트, VIP 분포, 추가이벤트 현황
- **고객·연락처**: 방문/미방문 토글 + 기간 슬라이더 필터 (전체~1년), CSV/TXT 다운로드
- **CRM 발송**: 고객 체크박스 선택 + 문자 템플릿 (변수: {고객명}{매장명}{쿠폰명}{쿠폰번호}{유효기간}) + 바이트 카운터
- **QR코드**: 매장별 고유 QR (?store=ID 방식)
- **룰렛/게임**: 상품·확률·게임방식 설정
- **쿠폰**: CRM 발송 이력 관리
- **설문**: 문항 관리 (accordion) + 응답 통계 그래프 (막대차트) + 개별 응답 (accordion)
- **추가이벤트**: 플랫폼별 ON/OFF, 링크, 게임방식, 상품
- **매장설정**: 배경이미지, 소셜채널, PIN, 스탬프, VIP, CRM 템플릿
- **👁 고객화면 버튼**: 헤더에서 고객 게임화면 미리보기 진입

### 총괄 관리자
- **진입**: 랜딩 하단 "총괄관리자" 링크 → 로그인 (개발 힌트박스 포함)
- **매장 현황**: 신호등(7일/8~14일/15일+) + 휴면순 정렬
- **매장 관리**: 승인/정지, 프리미엄 부여, 세팅 대리 관리
- **🔄 데이터 초기화**: 매장별 데이터 리셋 (프로필 유지)
- **🗑️ 매장 삭제**: 완전 삭제
- **DB 다운로드**: 전체 매장 CSV

### 개발 모드 편의 기능
- 총괄관리자 / 사장님 / 직원 로그인 화면 모두 기본 자격증명 힌트박스 + 자동입력 버튼
- 구버전 설문문항(이모지 rating) → 신버전 자동 마이그레이션

---

## 기본 접속 정보 (개발용)

| 구분 | 계정 | 비밀번호 |
|------|------|---------|
| 총괄관리자 | platform@admin.com | platform1234 |
| 사장님(demo 매장) | admin@example.com | admin1234 |
| 직원 | STAFF001 | 1234 |

---

## 기본 상품 확률

| 상품 | 확률 |
|------|------|
| 희망 메뉴 1개 | 2% |
| 희망 사이드 | 20% |
| 지정 사이드 | 40% |
| 음료수 1개 | 25% |
| 꽝 | 13% |

---

## 코드 구조 지도

### HTML 섹션 (화면별 id)
| id | 화면 |
|----|------|
| `s-landing` | 시작 화면 (총괄관리자/사장님 링크 포함) |
| `s-login` | 고객 로그인 (닉네임+전화번호) |
| `s-home` | 고객 홈 (추가이벤트 카드 + 쿠폰/스탬프/설문) |
| `s-roulette` | 룰렛 게임 |
| `s-card` | 카드뽑기 게임 |
| `s-scratch` | 긁는복권 |
| `s-result` | 게임 결과 |
| `s-extra-roulette` | 추가이벤트 룰렛 |
| `s-extra-card` | 추가이벤트 카드 |
| `s-extra-scratch` | 추가이벤트 복권 |
| `s-coupons` | 내 쿠폰함 |
| `s-stamp` | 스탬프 카드 |
| `s-survey` | 만족도 설문 |
| `s-naver` | 네이버 플레이스 |
| `s-myinfo` | 내 정보 |
| `s-admin-login` | 사장님 로그인 |
| `s-admin` | 매장 관리자 대시보드 (탭 구조) |
| `s-platform-login` | 총괄관리자 로그인 |
| `s-platform` | 총괄관리자 대시보드 |
| `s-owner-signup` | 사장님 회원가입 |
| `s-staff-check` | 직원 쿠폰 확인 |

### 주요 함수
| 함수 | 역할 |
|------|------|
| `show(id)` | 화면 전환 |
| `phoneLogin()` | 고객 로그인 처리 |
| `refreshHome()` | 홈 화면 데이터 갱신 (추가이벤트 동적 렌더링 포함) |
| `doSpin()` | 룰렛 실행 |
| `showResult(prize)` | 게임 결과 표시 |
| `openExtraRoulette(evId)` | 추가이벤트 게임 진입 |
| `renderAdmin(tab)` | 관리자 탭 렌더링 |
| `renderSurveyAdmin(el)` | 설문 관리 (차트 포함) |
| `renderSurveyCharts()` | 설문 응답 통계 차트 생성 |
| `renderCustomersTab(el)` | 고객 목록 (필터 포함) |
| `setMatrixRating(qid,item,val,rowEl)` | 반별점(0.5단위) 설정 |
| `saveState()` | localStorage 저장 |
| `seedDemoStore()` | 새 매장 기본 데이터 생성 |
| `migrateStore(s)` | 구버전 매장 데이터 마이그레이션 |

### 데이터 구조 (STORE 객체)
```javascript
STORE = {
  profile: {
    name, address, phone, emoji,
    bgImage, naverUrl, kakaoUrl, kakaoChannelUrl,
    pin  // 매장 관리자 PIN
  },
  users: [{
    id, name, phone, marketing,
    joined,       // 가입일 'YYYY-MM-DD'
    visits,       // 총 방문 횟수
    nameHistory   // [{name, date}]
  }],
  coupons: [{
    id, uid,      // uid = userId
    name, benefit,
    status,       // 'available' | 'used' | 'expired'
    issued,       // 발급일
    usedAt,       // 사용일
    sentAt        // CRM 발송일
  }],
  spins: [{
    userId, date, gameType  // 게임 참여 로그
  }],
  surveys: [{
    userId, name, phone, date, datetime,
    answers: {
      q1: ['네이버 검색', '지인 추천'],   // multicheck
      q2: {'가격대비 맛': 4.5, ...},       // matrix (0.5단위)
      q3: '주관식 텍스트'
    }
  }],
  surveyQuestions: [{
    id, type,     // 'multicheck'|'matrix'|'choice'|'text'|'rating'
    label,
    options,      // multicheck/choice용
    items         // matrix용
  }],
  staff: [{ code, pin, name, active }],
  stampSettings: { goal, reward, rewardImage, grantStamp },
  stampCards: { [userId]: { count, history: [{date, reason}] } },
  vip: { tiers: [{name, minVisits, ...}], autoCoupons: [...] },
  events: [{
    id, platform,   // 'kakao'|'google'|'tmap'
    label, active,
    link, gameType, prizes: [{name, prob, benefit, ...}],
    emoji, color
  }],
  extraSpinLog: { [userId_platform_date]: true },
  extraEventLog: [{ platform, date, userId, prize }],
  mainGame: { type: 'roulette'|'card'|'scratch', prizes: [...] },
  gameMode,         // mainGame.type alias
  spinLog: [...],   // 전체 스핀 로그
  visits,           // 총 방문 수 (매장)
  crmTemplate,      // 문자 발송 템플릿
  adminEmail, adminPassword
}

// 전체 플랫폼 데이터
storesDB = { [storeId]: STORE }
PLATFORM = { email: 'platform@admin.com', password: 'platform1234' }
```

---

## 로그인/인증 구조

### 고객 접근
- 로그인 화면(`s-login`)에서 닉네임 + 전화번호 입력
- 전화번호 기준으로 기존 사용자 매칭, 없으면 신규 생성
- `currentUser` 변수에 로그인된 사용자 저장

### 매장 관리자
- 랜딩 하단 "사장님 로그인" 링크 → `s-admin-login` → 이메일/비밀번호
- `STORE.adminEmail`, `STORE.adminPassword` 와 비교

### 총괄 관리자
- 랜딩 하단 "총괄관리자" 링크 → `s-platform-login` → 이메일/비밀번호
- `PLATFORM.email`, `PLATFORM.password` 와 비교

---

## Git / 배포

```bash
# 수정 후 배포
git add index.html
git commit -m "설명"
git push
# → 자동으로 Vercel 배포됨 (1~2분 소요)
```

- GitHub: https://github.com/jangsamarketing-hub/review-event-platform
- Vercel 대시보드: https://vercel.com/dashboard (jangsa.marketing@gmail.com)
- 라이브: https://review-event-do.vercel.app
- QR URL 패턴: `https://review-event-do.vercel.app/?store={storeId}`

---

## 알려진 이슈 및 한계

- **localStorage 기반** → 같은 브라우저에서만 데이터 유지, 다른 기기 불가
- **Supabase 이전 예정** → 다중 기기 지원, 실시간 동기화, 다중 매장 통합 관리
- 총괄관리자의 "대신 관리" 기능은 같은 브라우저 세션에서만 작동
- 설문 별점은 0.5 단위 저장되나 구버전 응답은 정수 가능

---

## 다음 작업 (우선순위 순)

1. **Supabase 백엔드 이전** — localStorage → Supabase, 다중 기기 지원
2. **ERP 연동** — 업체관리 ERP에 리뷰게임 참여도/CRM/설문/포인트 데이터 연동
3. 파일 분리 (JS/CSS) — Supabase 이전 시점에 함께 진행
