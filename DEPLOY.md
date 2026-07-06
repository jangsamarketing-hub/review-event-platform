# Vercel 배포 가이드

리뷰이벤트 플랫폼을 Vercel에 배포하는 방법입니다.

## 방법 1: GitHub를 통한 배포 (권장)

### 1단계: GitHub에 업로드
```bash
# 1. git 초기화 (처음 한 번만)
git init

# 2. 파일 추가
git add .

# 3. 첫 커밋
git commit -m "Initial commit: Review Event Platform"

# 4. GitHub에 새 저장소 생성 후
git remote add origin https://github.com/YOUR_USERNAME/review-event-platform.git
git branch -M main
git push -u origin main
```

### 2단계: Vercel에서 배포
1. [Vercel.com](https://vercel.com)에 접속하여 GitHub 계정으로 로그인
2. "New Project" 클릭
3. 위에서 생성한 저장소 선택
4. Project Name: `review-event-platform` (또는 원하는 이름)
5. Framework Preset: **Other** 선택
6. "Deploy" 클릭

완료! 자동으로 배포되고 URL이 생성됩니다.

---

## 방법 2: Vercel CLI를 통한 직접 배포

### 설치
```bash
npm install -g vercel
```

### 배포
```bash
# 현재 폴더에서
vercel

# 또는 특정 폴더를 지정
vercel /path/to/review-event-platform
```

프롬프트에 따라 진행하면 자동으로 배포됩니다.

---

## 방법 3: Vercel 웹 대시보드에서 직접 업로드

1. [Vercel.com](https://vercel.com)에 로그인
2. "Add New..." → "Project"
3. "Import Git Repository" 대신 **"Create a new project"** 선택
4. HTML/정적 파일 업로드 옵션 선택
5. `index.html` 등 파일 업로드

---

## 배포 후 설정

### 매장별 도메인 설정 (선택사항)
Vercel 프로젝트 Settings → Domains에서 커스텀 도메인 추가 가능:
- `masang1.review-event.com` (매장1)
- `masang2.review-event.com` (매장2)

### 환경별 배포 (선택사항)
- Production: https://review-event-platform.vercel.app
- Preview: Pull Request마다 자동 생성

---

## 사용 시 주의사항

### 데이터 저장
- **모든 데이터는 localStorage에 저장됩니다**
- 브라우저별로 독립적으로 저장됨
- 다른 기기에서 접속 시 별도의 새 데이터 생성

### 실제 운영을 위한 다음 단계
1. **공유 백엔드 필요** (Supabase 권장)
   - 다중 매장 데이터 통합
   - 사장님이 여러 기기에서 접근 가능
   - 총괄 관리자 기능 활성화

2. **도메인 연결**
   - 매장별 고유 URL 또는
   - 매장코드/QR로 매칭

3. **모바일 앱 (선택)**
   - Progressive Web App(PWA) 추가

---

## 문제 해결

### 배포 후 CSS/JS가 안 보일 때
- Vercel 캐시 초기화: Settings → Storage → Clear Cache
- 배포 재실행: Deployments → Redeploy

### 데이터 손실 우려
- 현재는 localStorage 기반이므로 브라우저 데이터 삭제 금지
- CSV 다운로드 기능으로 정기 백업 필요

### 성능 이슈
- Vercel은 자동으로 CDN 캐싱 제공
- 약 3600초(1시간) 캐시 설정됨 (vercel.json 참고)

---

## 개발 중 로컬 실행

```bash
npm run dev
# 또는
python -m http.server 8420
```

http://localhost:8420 에서 접속 가능

---

## 파일 구조

```
review-event-platform/
├── index.html          # 메인 앱 파일
├── package.json        # 프로젝트 설정
├── vercel.json         # Vercel 배포 설정
├── .gitignore          # Git 무시 파일
├── HANDOFF.md          # 개발 이력 및 다음 할 일
├── DEPLOY.md           # 이 파일
└── .claude/            # Claude Code 설정 (git 무시됨)
```

---

## 지원

문제 발생 시:
1. 브라우저 개발자 도구(F12) → Console 에러 확인
2. Vercel 대시보드 → Deployments → 해당 배포 로그 확인
3. HANDOFF.md의 "버그" 섹션 참고
