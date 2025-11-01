#!/bin/bash
set -e
echo "setting up env..."

#creat main dir
mkdir -p microservices-app

#docker compose
cat > docker-compose.yml << 'EOF'
version: "3.9"

networks:
  micro_net:
    driver: bridge

volumes:
  pgdata:


services:
  
  api:
    build: ./microservices-app/api
    container_name: api-service
    restart: always
    ports:
      - "4000:4000"
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USER: postgres
      DB_PASSWORD: postgres
      DB_NAME: microdb
      REDIS_HOST: redis
      REDIS_PORT: 6379
    depends_on:
      - postgres
      - redis
    networks:
      - micro_net
  
  worker:
    build: ./microservices-app/worker
    container_name: worker-service
    restart: always
    environment:
      DATABASE_URL: postgres://postgres:postgres@postgres:5432/microdb
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis
    networks:
      - micro_net
      
  redis:
    image: redis:7-alpine
    container_name: redis-service
    restart: always
    expose:
      - "6379"
    networks:
      - micro_net

  postgres:
    image: postgres:17-alpine
    container_name: postgres-service
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: microdb
    volumes:
      - pgdata:/var/lib/postgresql/data
    expose:
      - "5432"
    networks:
      - micro_net
EOF


#start evrything
docker compose up -d --build

sleep 5

echo "everything is ready!"
