# ⚡ Быстрый старт - Тестирование EcoDrug

## 🎯 Цель
Этот файл содержит самые быстрые команды для запуска тестов.

---

## 1️⃣ Первый раз? Установите зависимости

```bash
# Backend
cd backend
npm install
cd ..

# Frontend
cd frontend
flutter pub get
cd ..
```

---

## 2️⃣ Запустите MongoDB (для интеграционных тестов)

```bash
# С Docker (рекомендуется)
make up

# Или
docker-compose up -d mongodb
```

---

## 3️⃣ Запустите тесты

### 🚀 Все тесты сразу (рекомендуется)
```bash
make test
# или
./test-all.sh
```

### 📦 Только Backend
```bash
make test-backend
# или
cd backend && npm test
```

### 🎨 Только Frontend
```bash
make test-frontend
# или
cd frontend && flutter test
```

---

## 📊 Полезные команды

| Команда | Описание |
|---------|----------|
| `make test` | Все тесты (backend + frontend) |
| `make test-backend-unit` | Только unit тесты backend |
| `make test-backend-integration` | Только integration тесты (нужна MongoDB) |
| `make test-frontend` | Тесты Flutter |
| `make test-coverage` | Тесты с coverage reports |
| `make test-watch-backend` | Backend тесты в watch режиме |
| `make test-ci` | Симуляция CI/CD локально |

---

## 🔍 Результаты

### Backend (32 теста)
- ✅ authController: 11 unit тестов
- ✅ profileController: 6 unit тестов
- ✅ auth API: 9 integration тестов
- ✅ profile API: 6 integration тестов

### Frontend (15+ тестов)
- ✅ Widget тесты: 3
- ✅ Model тесты: 10+
- ✅ Service тесты: 5

### Coverage
- Backend: >70%
- Frontend: базовое покрытие

---

## 🐛 Проблемы?

### MongoDB connection failed
```bash
# Убедитесь что MongoDB запущена
docker-compose up -d mongodb
```

### Backend тесты падают
```bash
# Переустановите зависимости
cd backend
rm -rf node_modules package-lock.json
npm install
```

### Frontend тесты падают
```bash
# Очистите кэш
flutter clean
flutter pub get
```

---

## 📚 Подробная документация

- [TESTING.md](./TESTING.md) - Полное руководство (70+ минут)
- [CI_CD_SETUP.md](./CI_CD_SETUP.md) - Настройка GitHub Actions
- [GITHUB_WORKFLOW_SUMMARY.md](./GITHUB_WORKFLOW_SUMMARY.md) - Что создано

---

## 🎊 Готово!

Теперь вы можете:
1. ✅ Запускать тесты локально
2. ✅ Проверять качество кода
3. ✅ Коммитить с уверенностью
4. ✅ GitHub Actions проверит автоматически

**Следующий шаг**: `git push` и посмотрите GitHub Actions! 🚀

