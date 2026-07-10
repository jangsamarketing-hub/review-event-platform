# 리뷰이벤트 플랫폼 — Claude Code 인수인계

## 프로젝트 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트 이름 | 리뷰이벤트 플랫폼 (요식업 매장용) |
| 메인 파일 | `index.html` (단일 파일, 약 220KB, 3,300줄) |
| 기술 스택 | Vanilla JS + HTML5 Canvas, localStorage |
| GitHub | https://github.com/jangsamarketing-hub/review-event-platform |
| 라이브 URL | https://review-event-platform-prod.vercel.app |
| 배포 방식 | GitHub push → Vercel 자동 배포 |

---

## 개발 규칙 (반드시 지켜야 함)

1. **수정 후 항상 브라우저에서 직접 확인** — 콘솔 에러(F12) 없는지 체크
2. **비개발자 사용자** — 전문용어 최소화, 뭘 왜 하는지 한 줄씩 설명하며 진행
3. **큰 구조 변경(파일 분리 등)은 사용자 승인 후에만** 진행
4. **단일 HTML 파일 유지** — 별도 JS/CSS 파일 분리하지 말 것 (Supabase 이전 시점에 같이 논의)
5. 로컬 개발: `python -m http.server 8420` → http://localhost:8420

---

## 현재 완료된 작업 (2026-07-10 기준)

### ✅ 완료
- 메인 게임 3종 (룰렛/카드뽑기/긁는복권) 정상 작동
- 추가이벤트 3종 (카카오맵/구글/티맵) 독립 설정
- 구글 리뷰 결과 화면 표시 버그 수정 (`showExtraResult` DOM 업데이트)
- 카드뽑기 카드 크기 개선 (80×114px, 폰트 비례 확대)
- "사장님이신가요?" 버튼 강조 스타일 (파란색, 3개 위치)
- **고객 로그인 제거** — 도메인 접속 시 로그인 없이 바로 홈 화면 진입 (게스트 자동 생성)
- Vercel 배포 완료 + GitHub 자동 배포 연동

### ⏳ 다음 할 일 (우선순위 순)

#### 1순위: 홈 화면 문구/구조 변경
- "룰렛 이벤트" → "리뷰이벤트 게임" 명칭 통일
- 홈에 "추가 이벤트 참여하기" 배너 추가 (카카오맵/구글/티맵 진입 가능하게)
- 참고: `s-home` HTML 섹션, `refreshHome()` 함수

#### 2순위: 쿠폰탭 + 고객탭 통합 + CRM 발송
- 고객별 최근 방문일 + 보유 쿠폰을 한 화면에
- 기간 필터 (N일 미방문 고객 필터링)
- CRM 문자 발송 템플릿 (사장님이 문구 직접 수정 가능)
- 바이트 카운터 (SMS 80byte 기준 실시간 표시)
- 참고: `renderAdmin` 함수의 `tab==='coupons'`, `tab==='customers'` 분기, `copyCouponMessage`, `markCouponSent` 함수

#### 3순위: 설문 응답 → 그래프화
- 매트릭스 문항 항목별 평균 별점 막대그래프
- 참고: `renderSurveyAdmin` 함수, `STORE.surveys` 데이터

#### 4순위 (나중): Supabase 백엔드 이전
- localStorage → Supabase로 데이터 이전
- 다중 기기 지원, 실시간 동기화
- 이 시점에 파일 분리(JS/CSS)도 함께 검토

---

## 코드 구조 지도

### HTML 섹션 (화면별 id)
| id | 화면 |
|----|------|
| `s-landing` | 시작 화면 |
| `s-login` | 로그인 (현재 자동 스킵됨) |
| `s-home` | 고객 홈 |
| `s-roulette` | 룰렛 게임 |
| `s-card` | 카드뽑기 게임 |
| `s-scratch` | 긁는복권 |
| `s-result` | 게임 결과 |
| `s-coupons` | 내 쿠폰함 |
| `s-stamp` | 스탬프 카드 |
| `s-survey` | 만족도 설문 |
| `s-extra-*` | 추가이벤트 (카카오/구글/티맵) |
| `s-owner` | 매장 관리자 (탭 구조) |
| `s-platform` | 총괄 관리자 |

### 주요 함수
| 함수 | 역할 |
|------|------|
| `show(id)` | 화면 전환 |
| `phoneLogin()` | 로그인 처리 (현재 자동 스킵) |
| `refreshHome()` | 홈 화면 데이터 갱신 |
| `doSpin()` | 룰렛 실행 |
| `showResult(prize)` | 게임 결과 표시 |
| `showExtraResult(prize)` | 추가이벤트 결과 표시 |
| `initMainCard()` | 카드뽑기 초기화 |
| `initScratchCard()` | 긁는복권 초기화 |
| `renderAdmin(tab)` | 관리자 탭 렌더링 |
| `saveState()` | localStorage 저장 |
| `loadState()` | localStorage 불러오기 |

### 데이터 구조
```javascript
STORE = {
  profile: { name, address, phone, pin, bgImage, naverUrl, kakaoUrl },
  users: [{ id, name, phone, marketing, joined, visits, nameHistory }],
  coupons: [{ id, userId, name, benefit, issued, used, usedAt, sentAt }],
  spins: [{ userId, date, gameType }],
  surveys: [{ userId, date, answers }],
  staff: [{ code, pin }],
  stamps: { goal, reward, rewardImage, counts: {userId: count} },
  vip: { tiers: [...], autoCoupons: [...] },
  events: [{ id, platform, label, active, link, gameType, prizes }],
  mainGame: { type: 'roulette'|'card'|'scratch', prizes: [...] },
  adminEmail, adminPassword
}
```

---

## 로그인/인증 구조 (중요)

### 고객 접근
- **현재: 로그인 없이 자동 접속** (2026-07-10 변경)
- 도메인 접속 시 `s-home` 으로 바로 이동
- 게스트 사용자 자동 생성 (phone: `010-9999-9999`)
- 코드 위치: `index.html` 맨 하단 `/* 초기화 */` 섹션

### 매장 관리자
- 홈 화면 → "사장님이신가요?" 버튼 → PIN 입력
- PIN은 매장설정에서 변경 가능

### 총괄 관리자
- 별도 이메일/비밀번호 (플랫폼 관리자용)
- `PLATFORM` 객체로 관리

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
- Vercel: https://vercel.com/dashboard (jangsa.marketing@gmail.com 계정)
- 라이브: https://review-event-platform-prod.vercel.app

---

## 알려진 이슈

- localStorage 기반 → **같은 브라우저에서만** 데이터 유지 (다른 기기 불가)
- 총괄관리자의 "대신 관리" 기능은 **같은 브라우저에서만** 작동
- 게스트 자동 로그인으로 모든 고객이 같은 사용자로 잡힘 → 추후 닉네임 입력 팝업 추가 검토
