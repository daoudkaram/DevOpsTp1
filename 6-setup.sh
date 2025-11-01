#!/bin/bash
set -e

echo "Setting up PostgreSQL env"

#create project directory struct
mkdir -p db/init

#create Docker compose file
cat > docker-compose.yml <<'EOF'
version: "3.9"

services:
  postgres:
    image: postgres:17-alpine
    container_name: test-postgres
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: testdb
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./db/init:/docker-entrypoint-initdb.d

volumes:
  pgdata:
    driver: local

EOF

# Create initialization for the sql file
cat > db/init/init.sql <<'EOF'
-- init.sq -Initialize database schema

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0
);
EOF

#start Docker compose
echo "Starting PostgreSQL container..."
docker compose up -d

#wait for db to init
sleep 5

#display status and into
echo ""
echo "✅ PostgreSQL setup complete!"
echo "Container name: test-postgres"
echo "Database: testdb"
echo "User: postgres"
echo "Password: postgres"
echo "Host: localhost:5432"
echo ""
echo "To verify tables, run:"
echo "  docker exec -it test-postgres psql -U postgres -d testdb -c '\\dt'"
