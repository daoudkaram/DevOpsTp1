import redis
import psycopg2
import json
import time
import os
from datetime import datetime

REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
REDIS_PORT = int(os.getenv('REDIS_PORT', 6379))
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = int(os.getenv('DB_PORT', 5432))
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'postgres')
DB_NAME = os.getenv('DB_NAME', 'microservices')

def connect_redis():
    while True:
        try:
            r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)
            r.ping()
            print(f"Connected to Redis at {REDIS_HOST}:{REDIS_PORT}")
            return r
        except Exception as e:
            print(f"Redis connection failed: {e}. Retrying in 5 seconds...")
            time.sleep(5)

def connect_db():
    while True:
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                port=DB_PORT,
                user=DB_USER,
                password=DB_PASSWORD,
                database=DB_NAME
            )
            print(f"Connected to PostgreSQL at {DB_HOST}:{DB_PORT}")
            return conn
        except Exception as e:
            print(f"Database connection failed: {e}. Retrying in 5 seconds...")
            time.sleep(5)

def process_task(task_data, db_conn):
    try:
        cursor = db_conn.cursor()
        cursor.execute(
            "INSERT INTO processed_tasks (task_data, processed_at) VALUES (%s, %s)",
            (task_data, datetime.now())
        )
        db_conn.commit()
        cursor.close()
        print(f"Processed task: {task_data}")
    except Exception as e:
        print(f"Error processing task: {e}")
        db_conn.rollback()

def init_db(db_conn):
    try:
        cursor = db_conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS processed_tasks (
                id SERIAL PRIMARY KEY,
                task_data TEXT,
                processed_at TIMESTAMP
            )
        """)
        db_conn.commit()
        cursor.close()
        print("Database initialized")
    except Exception as e:
        print(f"Error initializing database: {e}")

def main():
    print("Worker service starting...")
    
    redis_client = connect_redis()
    db_conn = connect_db()
    
    init_db(db_conn)
    
    print("Worker is ready. Waiting for tasks...")
    
    while True:
        try:
            task = redis_client.blpop('tasks', timeout=5)
            if task:
                task_data = json.loads(task[1])
                print(f"Received task: {task_data}")
                process_task(json.dumps(task_data), db_conn)
        except KeyboardInterrupt:
            print("Worker shutting down...")
            break
        except Exception as e:
            print(f"Error in worker loop: {e}")
            time.sleep(1)
    
    db_conn.close()
    redis_client.close()

if __name__ == "__main__":
    main()
