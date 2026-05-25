#!/bin/bash
set -e

# 환경변수 (필요 시 외부에서 override)
DB_PASSWORD="${DB_PASSWORD:-myapp1234!}"

echo "===== 키워드 상태 리셋 ====="

docker exec mysql-db mysql -uappuser -p"$DB_PASSWORD" myapp -e "UPDATE keywords SET status='pending', worker_id=NULL, result_count=NULL, error_message=NULL WHERE status IN ('processing','done','failed');"

echo "완료. 현재 상태:"

docker exec mysql-db mysql -uappuser -p"$DB_PASSWORD" myapp -e "SELECT status, COUNT(*) AS cnt FROM keywords GROUP BY status;"