-- ============================================================
-- 리뷰팡 Supabase 스키마
-- Supabase 대시보드 → SQL Editor 에서 실행하세요
-- https://supabase.com/dashboard/project/pauzkmqmliuumybpinqi/sql
-- ============================================================

-- 매장 데이터 테이블 (JSONB 방식)
CREATE TABLE IF NOT EXISTS stores (
  store_id   text        PRIMARY KEY,
  data       jsonb       NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- anon key 로 직접 읽기/쓰기 허용 (RLS 비활성화)
ALTER TABLE stores DISABLE ROW LEVEL SECURITY;

-- updated_at 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- updated_at 자동 갱신 트리거
DROP TRIGGER IF EXISTS stores_updated_at ON stores;
CREATE TRIGGER stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 조회 성능용 인덱스
CREATE INDEX IF NOT EXISTS idx_stores_updated_at ON stores (updated_at DESC);

-- 확인용 쿼리 (실행 후 stores 테이블 보임)
SELECT 'stores 테이블 생성 완료 ✅' AS result;
