#!/bin/bash
set -e

# 이번 실행의 로그 파일명 (타임스탬프 포함)
RUN_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="myapp_${RUN_TIMESTAMP}.log"

# 환경변수 (필요 시 외부에서 override)
DB_PASSWORD="${DB_PASSWORD:-myapp1234!}"

echo "===== 실행 시작:$(date) ====="
echo "로그 파일:$LOG_FILE"

# 워커 1개 실행
docker run --rm --name worker-1 \
  --network myapp-net \
  -v myapp-logs:/logs \
  -e WORKER_ID=1 \
  -e SLEEP_TIME=0.5 \
  -e LOG_FILE="$LOG_FILE" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e TZ=Asia/Seoul \
  worker:latest

echo "===== 실행 종료:$(date) ====="
echo "결과: /var/lib/docker/volumes/myapp-logs/_data/$LOG_FILE"