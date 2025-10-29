# EcoDrug Development Makefile

.PHONY: help up down restart logs backend-logs frontend-logs clean install

# Default target
help:
	@echo "EcoDrug Development Commands:"
	@echo "  make up              - Запустить все сервисы (MongoDB + Backend)"
	@echo "  make down            - Остановить все сервисы"
	@echo "  make restart         - Перезапустить все сервисы"
	@echo "  make logs            - Показать логи всех сервисов"
	@echo "  make backend-logs    - Показать логи backend"
	@echo "  make frontend        - Запустить Flutter frontend локально"
	@echo "  make clean           - Удалить все контейнеры и volumes"
	@echo "  make install         - Установить зависимости"
	@echo "  make dev             - Полный запуск для разработки"

# Start all services
up:
	docker-compose up -d
	@echo "\n✅ Сервисы запущены!"
	@echo "Backend API: http://localhost:5000"
	@echo "MongoDB: localhost:27017"
	@echo "\nЗапустите frontend командой: make frontend"

# Stop all services
down:
	docker-compose down

# Restart services
restart:
	docker-compose restart

# View logs
logs:
	docker-compose logs -f

# Backend logs only
backend-logs:
	docker-compose logs -f backend

# MongoDB logs
db-logs:
	docker-compose logs -f mongodb

# Start frontend locally (recommended for development)
frontend:
	@echo "Запуск Flutter frontend..."
	cd frontend && flutter pub get && flutter run -d chrome

# Clean everything
clean:
	docker-compose down -v
	@echo "✅ Все контейнеры и volumes удалены"

# Install dependencies
install:
	@echo "Установка backend зависимостей..."
	cd backend && npm install
	@echo "Установка frontend зависимостей..."
	cd frontend && flutter pub get
	@echo "✅ Все зависимости установлены"

# Full dev setup
dev: up
	@echo "\n⏳ Ждём запуска backend (5 секунд)..."
	@sleep 5
	@echo "\n🚀 Запуск frontend..."
	@make frontend

# Build production images
build:
	docker-compose build

# Run tests
test-backend:
	cd backend && npm test

test-frontend:
	cd frontend && flutter test

# Database management
db-shell:
	docker exec -it ecodrug-mongodb mongosh -u admin -p admin123 ecodrug

db-backup:
	@echo "Creating database backup..."
	docker exec ecodrug-mongodb mongodump --authenticationDatabase admin -u admin -p admin123 -d ecodrug --out /dump
	docker cp ecodrug-mongodb:/dump ./backup-$(shell date +%Y%m%d-%H%M%S)
	@echo "✅ Backup created"

# Check status
status:
	docker-compose ps

