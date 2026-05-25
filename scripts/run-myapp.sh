#!/bin/bash
set -e

# 이번 실행의 로그 파일명 (타임스탬프 포함)
RUN_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="myapp_${RUN_TIMESTAMP}.log"

# 환경변수 (필요 시 외부에서 override)
DB_PASSWORD="${DB_PASSWORD:-myapp1234!}"

echo "===== 실행 시작:$(date) ====="
echo "로그 파일:$LOG_FILE"

# 워커 3개 병렬 실행
for i in 1 2 3; do
  case $i in
    1) sleep_time=0.3 ;;
    2) sleep_time=0.5 ;;
    3) sleep_time=1.0 ;;
  esac

  docker run --rm --name worker-$i \
    --network myapp-net \
    -v myapp-logs:/logs \
    -e WORKER_ID=$i \
    -e SLEEP_TIME=$sleep_time \
    -e LOG_FILE="$LOG_FILE" \
    -e DB_PASSWORD="$DB_PASSWORD" \
    -e TZ=Asia/Seoul \
    worker:latest &
done

# 모든 워커 종료 대기
wait

echo "===== 실행 종료:$(date) ====="
echo "결과: /var/lib/docker/volumes/myapp-logs/_data/$LOG_FILE"