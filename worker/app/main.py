import os
from db import fetch_batch, mark_done, mark_failed, close
from crawler import crawl
from logger import log

def main():
    # 환경변수에서 설정 읽기
    worker_id  = os.environ["WORKER_ID"]          # 문자열로 받음 (keywords.worker_id가 VARCHAR)
    sleep_time = float(os.environ.get("SLEEP_TIME", "0.5"))
    batch_size = int(os.environ.get("BATCH_SIZE", "5"))

    log(f"worker-{worker_id} started")
    total_processed = 0

    # pending 작업이 없을 때까지 반복
    while True:
        jobs = fetch_batch(worker_id, batch_size)
        if not jobs:
            break  # 더 이상 할 일 없음 → 종료

        for kw_id, keyword in jobs:
            try:
                results = crawl(keyword, sleep_time)
                mark_done(kw_id, len(results))
                log(f"done:{keyword} ({len(results)} results)")
            except Exception as e:
                mark_failed(kw_id, str(e))
                log(f"failed:{keyword} -{e}")
            total_processed += 1

    log(f"worker-{worker_id} finished, processed {total_processed} jobs")
    close()

if __name__ == "__main__":
    main()