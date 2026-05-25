import time
import random

def crawl(keyword, sleep_time):
    """실제 크롤링 대신 더미 동작"""
    time.sleep(sleep_time)  # 크롤링하는 척 대기

    # 20% 확률로 실패 시뮬레이션
    if random.random() < 0.2:
        raise Exception(f"Connection timeout for '{keyword}'")

    # 가짜 결과 2~5개 생성
    count = random.randint(2, 5)
    return [
        {
            "url": f"http://example.com/{keyword}/{i}",
            "title": f"{keyword} 관련 글{i}",
        }
        for i in range(1, count + 1)
    ]