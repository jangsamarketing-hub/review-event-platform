# 리뷰팡 — Claude Code / Codex 인수인계

## 프로젝트 기본 정보

| 항목 | 내용 |
|------|------|
| 브랜드명 | **리뷰팡** (ReviewPang) |
| 메인 파일 | `index.html` (단일 파일, 약 280KB, ~6,130줄) |
| 기술 스택 | Vanilla JS + HTML5 Canvas + Supabase JS v2 |
| 저장소 | localStorage (캐시) + Supabase (클라우드 동기화) |
| GitHub | https://github.com/jangsamarketing-hub/reviewpang |
| 라이브 URL | https://reviewpang.vercel.app |
| Vercel 대시보드 | https://vercel.com/dashboard (jangsa.marketing@gmail.com) |
| 배포 방식 | GitHub push → Vercel 자동 배포 |
| Supabase | https://pauzkmqmliuumybpinqi.supabase.co |
| 최종 업데이트 | 2026-07-18 |

---

## 개발 규칙 (반드시 지켜야 함)

1. **수정 후 항상 브라우저에서 직접 확인** — 콘솔 에러(F12) 없는지 체크
2. **비개발자 사용자** — 전문용어 최소화, 뭘 왜 하는지 한 줄씩 설명하며 진행
3. **큰 구조 변경(파일 분리 등)은 사용자 승인 후에만** 진행
4. **단일 HTML 파일 유지** — 별도 JS/CSS 파일 분리하지 말 것
5. 로컬 개발: `python -m http.server 8420` → http://localhost:8420

### 토큰 절약 전략

6. **search-first** — 코드를 읽기 전에 Grep/Glob으로 먼저 위치를 찾는다
7. **minimal-edit** — 변경할 함수/섹션만 파악 후 최소 범위만 Edit. 전체 파일 재작성 금지
8. **offset+limit** — 긴 파일(index.html)은 필요한 줄만 읽어라

---

## 비즈니스 모델 (2026-07-18 기준)

**현재 전략: 전체 무료 개방으로 빠른 확산**
- 모든 기능을 무료로 제공해 매장 가입을 최대화
- 문의·컨설팅·DB 수집으로 수익화
- 활성 유저 확보 후 유료 플랜은 천천히 도입
- 총괄관리자에서 언제든 개별 플랜 적용 모드로 전환 가능

**수익화 준비된 구조 (코드에 유지 중)**
- `isPremium()` 함수: `_platformConfig.forceAllPremium` 전역 플래그 → `true`면 전체 개방
- 총괄관리자 → "전체 개방 ON/OFF" 버튼으로 즉시 전환 가능

---

## 완료된 기능 목록 (2026-07-18 기준)

### 고객 화면
- **로그인**: 닉네임 + 전화번호 (개인정보 동의 포함)
- **메인 게임 3종**: 룰렛 / 카드뽑기 / 긁는복권
- **추가이벤트 3종**: 카카오맵 / 구글 / 티맵 (플랫폼별 독립 게임)
- **VIP 등급**: 브론즈~다이아 5단계 + 자동 쿠폰
- **스탬프 카드**: 설문 제출 시 자동 적립
- **만족도 설문**: 방문경로·방문계기·이동시간(선택) + 별점(필수) + 주관식(필수)
- **쿠폰함 / 네이버 플레이스 리뷰 유도**

### 매장 관리자 화면
- **통계**: 일/주/월 참여 차트, VIP 분포
- **고객·연락처**: 방문/미방문 필터 + 기간 슬라이더, CSV/TXT 다운로드
- **CRM**: 고객 선택 + 문자 템플릿 발송
- **QR코드**: 매장별 고유 QR
- **게임 설정**: 룰렛/카드/복권 상품·확률
- **쿠폰·설문·추가이벤트·매장설정** 관리

### 총괄 관리자
- **매장 현황**: 신호등(7일/8~14일/15일+) + 휴면순 정렬
- **매장 관리**: 승인/정지, 프리미엄 개별 부여
- **🔓 전체 기능 개방 토글**: 일괄 ON/OFF 버튼
- **🔄 데이터 초기화 / 🗑️ 매장 삭제 / DB 다운로드**

---

## 접속 정보 (개발용)

| 구분 | 계정 | 비밀번호 |
|------|------|---------|
| 총괄관리자 | jayden | 194360 |
| 사장님(demo 매장) | admin@example.com | admin1234 |
| 직원 | STAFF001 | 1234 |

---

## Supabase 구조

```
URL: https://pauzkmqmliuumybpinqi.supabase.co
테이블: stores (store_id TEXT PK, data JSONB, updated_at TIMESTAMPTZ)
RLS: 비활성화 (anon key로 직접 읽기/쓰기)
```

### 동기화 흐름
- `saveState()` → `STORE._sbTs = Date.now()` 타임스탬프 후 `_sbPush(storeId)` 자동 호출
- 앱 시작 시 → `_sbSync(storeId)` 백그라운드 실행 (원격이 더 최신이면 갱신)
- 어드민 진입 시 → `_sbSync` 후 더 최신 데이터면 재렌더
- QR로 첫 방문 (localStorage 없음) → `_sbLoad`로 Supabase에서 직접 로드
- 매장 가입 → `_sbPush` 즉시 실행 (다른 기기에서 QR 공유 즉시 접근 가능)
- 랜딩 매장 검색 → `_sbLoadAll()`로 Supabase 전체 조회

### 주요 Supabase 함수
| 함수 | 역할 |
|------|------|
| `_sbPush(storeId)` | 단일 매장 저장 |
| `_sbLoad(storeId)` | 단일 매장 로드 |
| `_sbSync(storeId)` | 타임스탬프 기반 스마트 동기화 |
| `_sbLoadAll()` | 전체 매장 목록 조회 |

---

## 코드 구조 지도

### HTML 섹션 (화면별 id)
| id | 화면 |
|----|------|
| `s-landing` | 시작 화면 |
| `s-login` | 고객 로그인 |
| `s-home` | 고객 홈 |
| `s-roulette` | 룰렛 게임 |
| `s-card` | 카드뽑기 |
| `s-scratch` | 긁는복권 |
| `s-result` | 게임 결과 |
| `s-extra-roulette/card/scratch` | 추가이벤트 게임 |
| `s-coupons` | 쿠폰함 |
| `s-stamp` | 스탬프 카드 |
| `s-survey` | 만족도 설문 |
| `s-naver` | 네이버 플레이스 |
| `s-admin-login` | 사장님 로그인 |
| `s-admin` | 매장 관리자 대시보드 |
| `s-platform-login` | 총괄관리자 로그인 |
| `s-platform` | 총괄관리자 대시보드 |
| `s-owner-signup` | 사장님 회원가입 |
| `s-staff-check` | 직원 쿠폰 확인 |

### 주요 함수
| 함수 | 역할 |
|------|------|
| `show(id)` | 화면 전환 |
| `saveState()` | localStorage 저장 + Supabase push |
| `isPremium()` | 프리미엄 여부 (`forceAllPremium` 플래그 우선) |
| `bulkSetPremium(bool)` | 전체 기능 개방 ON/OFF |
| `phoneLogin()` | 고객 로그인 |
| `refreshHome()` | 홈 화면 갱신 |
| `doSpin()` | 룰렛 실행 |
| `renderAdmin(tab)` | 관리자 탭 렌더링 |
| `renderPlatform()` | 총괄관리자 렌더링 |
| `seedDemoStore()` | 새 매장 기본 데이터 생성 |
| `migrateStore(s)` | 구버전 데이터 마이그레이션 |
| `createStore()` | 사장님 회원가입 처리 |

### 전역 상태
```javascript
STORE_ID       // 현재 매장 ID (URL ?store= 파라미터)
STORE          // 현재 매장 데이터 객체
storesDB       // 전체 매장 { [storeId]: STORE }
currentUser    // 현재 로그인 고객
PLATFORM       // 총괄관리자 자격증명
_platformConfig // 플랫폼 전역 설정 { forceAllPremium: true }
```

---

## 데이터 구조 (STORE 객체)

```javascript
STORE = {
  _sbTs,        // Supabase 동기화 타임스탬프
  approved,     // 총괄관리자 승인 여부
  premium,      // 개별 프리미엄 여부 (forceAllPremium이면 무관)
  plan,         // 'free' | 'premium'
  profile: { name, address, phone, emoji, bgImage, naverUrl, kakaoUrl, pin },
  adminEmail, adminPassword,
  owner: { name, phone },
  users: [{ id, name, phone, marketing, joined, visits, nameHistory }],
  coupons: [{ id, uid, name, benefit, status, issued, usedAt, sentAt }],
  spinLog: [{ userId, date, gameType }],
  surveys: [{ userId, name, phone, date, answers: { q1, q2, q3, ... } }],
  surveyQuestions: [{ id, type, label, options?, items? }],
  staff: [{ code, pin, name, active }],
  stampSettings: { goal, reward, grantStamp },
  stampCards: { [userId]: { count, history } },
  vip: { tiers, autoCoupons },
  events: [{ id, platform, label, active, link, gameType, prizes }],
  extraSpinLog: { [userId_platform_date]: true },
  extraEventLog: [{ platform, date, userId, prize }],
  mainGame: { type, prizes },
}
```

---

## Git / 배포

```bash
git add index.html
git commit -m "feat: 설명"
git push
# → Vercel 자동 배포 (1~2분)
```

---

## 알려진 이슈

- 총괄관리자 `_platformConfig`는 브라우저 localStorage에 저장됨 → 다른 기기에서 변경 시 각 기기에서 따로 설정 필요 (추후 Supabase `platform` 테이블로 이전 권장)
- Supabase anon key가 HTML 소스에 노출됨 → RLS 도입 전까지는 공개 데이터로 취급
- 총괄관리자 "대신 관리" 기능은 같은 브라우저 세션에서만 작동

---

## 다음 작업 우선순위

1. **ERP 연동** — 업체관리 ERP에 리뷰게임 참여도/CRM/설문 데이터 연동
2. **Supabase Auth 도입** — 사장님 계정을 Supabase Auth로 이전 (보안 강화)
3. **`_platformConfig` Supabase 동기화** — 총괄 설정을 DB에 저장
4. **파일 분리 (JS/CSS)** — 코드베이스가 커지면 분리 논의
5. **문의 폼 / 랜딩 페이지** — 리뷰팡 브랜드 소개 페이지
