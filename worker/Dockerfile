FROM python:3.11-slim

WORKDIR /app

# 의존성 먼저 복사 후 설치 (캐시 활용)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 코드 복사
COPY app/ ./

# 기본 실행 명령
CMD ["python", "main.py"]