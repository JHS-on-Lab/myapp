import os
import pymysql

# DB 연결 (컨테이너 이름으로 호스트 지정, 5장에서 만든 appuser 사용)
conn = pymysql.connect(
    host=os.environ.get("DB_HOST", "mysql-db"),
    user=os.environ.get("DB_USER", "appuser"),
    password=os.environ["DB_PASSWORD"],
    database=os.environ.get("DB_NAME", "myapp"),
    autocommit=False,
)

def fetch_batch(worker_id, batch_size):
    """pending 키워드를 batch_size만큼 잠그고 processing으로 마킹"""
    with conn.cursor() as cur:
        # 핵심: SKIP LOCKED로 다른 워커가 잠근 행은 건너뜀
        cur.execute("""
            SELECT id, keyword
              FROM keywords
             WHERE status='pending'
             LIMIT %s
               FOR UPDATE SKIP LOCKED
        """, (batch_size,))
        rows = cur.fetchall()

        if rows:
            ids = [r[0] for r in rows]
            placeholders = ','.join(['%s'] * len(ids))
            # 가져온 키워드를 processing으로 마킹 + 점유 워커 기록
            cur.execute(f"""
                UPDATE keywords
                   SET status='processing', worker_id=%s
                 WHERE id IN ({placeholders})
            """, [worker_id] + ids)
        conn.commit()
        return rows

def mark_done(keyword_id, result_count):
    """크롤링 성공: status=done + 결과 개수 기록"""
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE keywords
               SET status='done', result_count=%s, error_message=NULL
             WHERE id=%s
        """, (result_count, keyword_id))
        conn.commit()

def mark_failed(keyword_id, error_message):
    """크롤링 실패: status=failed + 에러 메시지 기록"""
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE keywords
               SET status='failed', error_message=%s
             WHERE id=%s
        """, (error_message[:500], keyword_id))
        conn.commit()

def close():
    conn.close()