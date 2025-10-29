# EcoDrug Development Makefile

.PHONY: help up down restart logs backend-logs frontend-logs clean install test test-all test-backend test-frontend test-backend-unit test-backend-integration test-coverage

# Default target
help:
	@echo "🌱 EcoDrug Development Commands:"
	@echo ""
	@echo "📦 Docker Services:"
	@echo "  make up                      - Запустить все сервисы (MongoDB + Backend)"
	@echo "  make down                    - Остановить все сервисы"
	@echo "  make restart                 - Перезапустить все сервисы"
	@echo "  make logs                    - Показать логи всех сервисов"
	@echo "  make backend-logs            - Показать логи backend"
	@echo "  make status                  - Статус контейнеров"
	@echo "  make clean                   - Удалить все контейнеры и volumes"
	@echo ""
	@echo "🚀 Development:"
	@echo "  make frontend                - Запустить Flutter frontend локально"
	@echo "  make install                 - Установить все зависимости"
	@echo "  make dev                     - Полный запуск для разработки"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test                    - Запустить ВСЕ тесты (backend + frontend)"
	@echo "  make test-all                - То же что и test"
	@echo "  make test-backend            - Backend тесты (unit + integration)"
	@echo "  make test-frontend           - Frontend тесты + analyzer"
	@echo "  make test-backend-unit       - Только unit тесты backend"
	@echo "  make test-backend-integration - Только integration тесты backend"
	@echo "  make test-coverage           - Тесты с покрытием кода"
	@echo ""
	@echo "🗄️  Database:"
	@echo "  make db-shell                - MongoDB shell"
	@echo "  make db-backup               - Создать backup БД"
	@echo "  make db-logs                 - Логи MongoDB"

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

# ========================================
# Testing Commands
# ========================================

# Run all tests (backend + frontend)
test: test-all

test-all:
	@echo "🧪 Running all tests..."
	@./test-all.sh

# Backend tests (all)
test-backend:
	@echo "📦 Running backend tests..."
	cd backend && npm test

# Backend unit tests only
test-backend-unit:
	@echo "📦 Running backend unit tests..."
	cd backend && npm run test:unit

# Backend integration tests only
test-backend-integration:
	@echo "📦 Running backend integration tests..."
	@echo "⚠️  Убедитесь, что MongoDB запущена: make up"
	cd backend && npm run test:integration

# Frontend tests
test-frontend:
	@echo "🎨 Running frontend tests..."
	cd frontend && flutter test

# Frontend analyzer
test-frontend-analyze:
	@echo "🎨 Running Flutter analyzer..."
	cd frontend && flutter analyze

# Run tests with coverage
test-coverage:
	@echo "📊 Running tests with coverage..."
	@echo "Backend coverage:"
	cd backend && npm test -- --coverage
	@echo "\nFrontend coverage:"
	cd frontend && flutter test --coverage
	@echo "\n✅ Coverage reports generated!"
	@echo "Backend: backend/coverage/lcov-report/index.html"
	@echo "Frontend: frontend/coverage/lcov.info"

# Watch mode for development
test-watch-backend:
	@echo "👀 Backend tests in watch mode..."
	cd backend && npm run test:watch

# CI/CD simulation
test-ci:
	@echo "🤖 Simulating CI/CD tests..."
	@echo "\n1️⃣  Backend tests..."
	@make test-backend
	@echo "\n2️⃣  Frontend tests..."
	@make test-frontend
	@echo "\n3️⃣  Flutter analyzer..."
	@make test-frontend-analyze
	@echo "\n4️⃣  Docker validation..."
	docker-compose config > /dev/null && echo "✅ Docker Compose valid"
	@echo "\n✅ All CI/CD checks passed!"

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

