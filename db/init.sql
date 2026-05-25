-- 데이터베이스
CREATE DATABASE IF NOT EXISTS myapp
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE myapp;

-- 키워드 테이블 (작업 큐 역할)
CREATE TABLE IF NOT EXISTS keywords (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  keyword       VARCHAR(255) NOT NULL,
  status        ENUM('pending', 'processing', 'done', 'failed') NOT NULL DEFAULT 'pending',
  worker_id     VARCHAR(64) NULL,
  result_count  INT NULL,
  error_message VARCHAR(500) NULL,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 샘플 키워드
INSERT INTO keywords (keyword) VALUES
  ('docker'),
  ('kubernetes'),
  ('aws'),
  ('python'),
  ('mysql'),
  ('linux'),
  ('nginx'),
  ('redis');

-- 원격 접속용 유저 (워커 컨테이너 + DBeaver 공용)
-- 비밀번호는 본인의 값으로 교체할 것
CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'myapp1234!';
GRANT ALL PRIVILEGES ON myapp.* TO 'appuser'@'%';
FLUSH PRIVILEGES;