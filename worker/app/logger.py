from datetime import datetime
import os

LOG_DIR  = "/logs"
LOG_FILE = os.environ.get("LOG_FILE", "myapp.log")
LOG_PATH = os.path.join(LOG_DIR, LOG_FILE)

def log(message):
    """파일과 stdout에 동시 기록"""
    worker_id = os.environ.get("WORKER_ID", "?")
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{timestamp}] worker-{worker_id} |{message}\n"

    # 파일 기록 (append + line buffering)
    with open(LOG_PATH, "a", buffering=1) as f:
        f.write(line)

    # stdout 출력 (docker logs로 확인용)
    print(line, end="", flush=True)