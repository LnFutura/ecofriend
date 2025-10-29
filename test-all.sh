#!/bin/bash

# Скрипт для запуска всех тестов проекта EcoDrug
# Использование: ./test-all.sh

set -e  # Exit on error

echo "🧪 ========================================="
echo "🧪 EcoDrug - Запуск всех тестов"
echo "🧪 ========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track failures
FAILURES=0

# 1. Backend Tests
echo "📦 BACKEND TESTS"
echo "----------------------------------------"
cd backend

if [ -f "package.json" ]; then
    echo "▶️  Installing dependencies..."
    npm ci --silent

    echo "▶️  Running backend tests..."
    if npm test; then
        echo -e "${GREEN}✅ Backend tests PASSED${NC}"
    else
        echo -e "${RED}❌ Backend tests FAILED${NC}"
        FAILURES=$((FAILURES + 1))
    fi

    echo ""
    echo "▶️  Running ESLint..."
    if npm run lint; then
        echo -e "${GREEN}✅ ESLint PASSED${NC}"
    else
        echo -e "${YELLOW}⚠️  ESLint warnings (non-critical)${NC}"
    fi
else
    echo -e "${RED}❌ Backend package.json not found${NC}"
    FAILURES=$((FAILURES + 1))
fi

cd ..
echo ""

# 2. Frontend Tests
echo "🎨 FRONTEND TESTS"
echo "----------------------------------------"
cd frontend

if [ -f "pubspec.yaml" ]; then
    echo "▶️  Getting Flutter dependencies..."
    flutter pub get > /dev/null

    echo "▶️  Running Flutter analyzer..."
    if flutter analyze; then
        echo -e "${GREEN}✅ Flutter analyzer PASSED${NC}"
    else
        echo -e "${RED}❌ Flutter analyzer FAILED${NC}"
        FAILURES=$((FAILURES + 1))
    fi

    echo ""
    echo "▶️  Running Flutter tests..."
    if flutter test; then
        echo -e "${GREEN}✅ Flutter tests PASSED${NC}"
    else
        echo -e "${RED}❌ Flutter tests FAILED${NC}"
        FAILURES=$((FAILURES + 1))
    fi
else
    echo -e "${RED}❌ Frontend pubspec.yaml not found${NC}"
    FAILURES=$((FAILURES + 1))
fi

cd ..
echo ""

# 3. Docker Validation
echo "🐳 DOCKER VALIDATION"
echo "----------------------------------------"
if command -v docker-compose &> /dev/null; then
    echo "▶️  Validating docker-compose.yml..."
    if docker-compose config > /dev/null; then
        echo -e "${GREEN}✅ Docker Compose config VALID${NC}"
    else
        echo -e "${RED}❌ Docker Compose config INVALID${NC}"
        FAILURES=$((FAILURES + 1))
    fi
else
    echo -e "${YELLOW}⚠️  Docker Compose not installed (skipping)${NC}"
fi

echo ""

# Summary
echo "🎯 ========================================="
echo "🎯 SUMMARY"
echo "🎯 ========================================="

if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ All tests PASSED! 🎉${NC}"
    echo ""
    echo "You can now safely commit and push your changes."
    exit 0
else
    echo -e "${RED}❌ $FAILURES test(s) FAILED${NC}"
    echo ""
    echo "Please fix the failing tests before committing."
    exit 1
fi

