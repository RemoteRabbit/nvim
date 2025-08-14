;; yaml
# {{_file_name_}} - Docker Compose for {{_input_:project_name_}}
# Author: {{_author_}}
# Date: {{_date_}}

version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: {{_input_:build_target_}}
    container_name: {{_input_:project_name_}}-app
    ports:
      - "{{_input_:host_port_}}:{{_input_:container_port_}}"
    environment:
      - NODE_ENV={{_input_:environment_}}
      - DATABASE_URL=postgresql://{{_input_:db_user_}}:{{_input_:db_password_}}@db:5432/{{_input_:db_name_}}
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./{{_input_:volume_source_}}:/app/{{_input_:volume_target_}}
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "{{_input_:health_command_}}"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  db:
    image: postgres:15-alpine
    container_name: {{_input_:project_name_}}-db
    environment:
      - POSTGRES_DB={{_input_:db_name_}}
      - POSTGRES_USER={{_input_:db_user_}}
      - POSTGRES_PASSWORD={{_input_:db_password_}}
    volumes:
      - db_data:/var/lib/postgresql/data
      - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U {{_input_:db_user_}} -d {{_input_:db_name_}}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: {{_input_:project_name_}}-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - app-network
    restart: unless-stopped
    command: redis-server --appendonly yes

  nginx:
    image: nginx:alpine
    container_name: {{_input_:project_name_}}-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - app
    networks:
      - app-network
    restart: unless-stopped

networks:
  app-network:
    driver: bridge

volumes:
  db_data:
    driver: local
  redis_data:
    driver: local

{{_cursor_}}
