# GitHub Actions CI/CD Setup для EcoDrug

## 🚀 Что сделано

Создана полноценная CI/CD система для автоматического тестирования проекта EcoDrug при каждом push и pull request.

## 📦 Структура тестирования

### 1. Backend Tests (Node.js + MongoDB)
- **Unit тесты**: Тестирование контроллеров и моделей в изоляции
  - `authController.test.js` - регистрация, логин, получение текущего пользователя
  - `profileController.test.js` - получение и обновление профиля
- **Integration тесты**: Полное тестирование API endpoints с реальной БД
  - `auth.test.js` - полный цикл авторизации
  - `profile.test.js` - работа с профилем пользователя
- **Coverage**: Минимальное покрытие кода 70%
- **Матрица тестирования**: Node.js 18.x и 20.x

### 2. Frontend Tests (Flutter)
- **Widget тесты**: Тестирование UI компонентов
- **Model тесты**: Проверка JSON сериализации/десериализации
- **Service тесты**: Тестирование StorageService и других утилит
- **Static Analysis**: Flutter analyzer для проверки качества кода

### 3. End-to-End Tests
- Запуск backend сервера
- Проверка health check endpoint
- API integration тесты

### 4. Security Audit
- `npm audit` для backend зависимостей
- `flutter pub outdated` для frontend пакетов

### 5. Docker Build Tests
- Сборка backend Docker образа
- Сборка frontend Docker образа
- Валидация docker-compose.yml

## 📁 Созданные файлы

```
ecodrug/
├── .github/
│   └── workflows/
│       └── test.yml                        # GitHub Actions workflow
├── backend/
│   ├── tests/
│   │   ├── setup.js                       # Конфигурация тестов
│   │   ├── unit/
│   │   │   ├── authController.test.js     # Unit тесты auth
│   │   │   └── profileController.test.js  # Unit тесты profile
│   │   └── integration/
│   │       ├── auth.test.js               # API тесты auth
│   │       └── profile.test.js            # API тесты profile
│   ├── jest.config.js                      # Конфигурация Jest
│   └── package.json                        # Обновлены npm scripts
├── frontend/
│   └── test/
│       ├── widget_test.dart               # Тесты виджетов
│       ├── models_test.dart               # Тесты моделей
│       └── services_test.dart             # Тесты сервисов
├── TESTING.md                              # Полное руководство
└── CI_CD_SETUP.md                          # Этот файл
```

## 🔧 Локальный запуск тестов

### Backend

```bash
cd backend

# Все тесты с покрытием
npm test

# Только unit тесты
npm run test:unit

# Только интеграционные тесты
npm run test:integration

# Watch режим для разработки
npm run test:watch

# Линтер (когда настроен ESLint)
npm run lint
```

### Frontend

```bash
cd frontend

# Все тесты
flutter test

# С покрытием кода
flutter test --coverage

# Статический анализ
flutter analyze

# Форматирование
flutter format .
```

### Docker

```bash
# Проверка docker-compose
docker-compose config

# Сборка образов
docker-compose build

# Запуск тестов в контейнерах
docker-compose up -d mongodb
cd backend && npm test
```

## 🎯 GitHub Actions Jobs

### Job 1: `backend-tests`
- Запускает MongoDB в Docker контейнере
- Устанавливает зависимости
- Выполняет ESLint
- Запускает unit и integration тесты
- Загружает coverage в Codecov
- **Матрица**: Node.js 18.x, 20.x

### Job 2: `frontend-tests`
- Устанавливает Flutter 3.16.0
- Выполняет `flutter analyze`
- Запускает все тесты
- Загружает coverage в Codecov

### Job 3: `e2e-tests`
- Зависит от успешного прохождения backend-tests и frontend-tests
- Запускает MongoDB
- Стартует backend сервер
- Проверяет health endpoints
- Выполняет E2E тесты

### Job 4: `security-audit`
- `npm audit` для backend (только high-level уязвимости)
- `flutter pub outdated` для frontend

### Job 5: `docker-build`
- Собирает Docker образы для backend и frontend
- Проверяет docker-compose.yml

### Job 6: `all-tests-passed`
- Финальная проверка что все jobs успешны
- Выводит сводку результатов

## 🔐 GitHub Secrets

Для полноценной работы CI/CD могут потребоваться следующие secrets (опционально):

```
CODECOV_TOKEN          # Для загрузки coverage в Codecov
DOCKER_USERNAME        # Для публикации Docker образов
DOCKER_PASSWORD        # Для публикации Docker образов
```

Настройка secrets: GitHub Repository → Settings → Secrets and variables → Actions

## ✅ Как проверить работу CI/CD

### 1. Локальная проверка перед push
```bash
# Backend
cd backend && npm test && cd ..

# Frontend
cd frontend && flutter test && flutter analyze && cd ..

# Docker
docker-compose config
```

### 2. Создать feature branch
```bash
git checkout -b feature/my-feature
# Внести изменения
git add .
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

### 3. Создать Pull Request
- GitHub автоматически запустит все тесты
- В PR будут видны статусы всех jobs
- Зеленые галочки ✅ означают успех

### 4. Мониторинг в GitHub Actions
- Перейдите в раздел **Actions**
- Выберите ваш workflow run
- Просмотрите логи каждого job
- Скачайте coverage reports

## 🐛 Troubleshooting

### Backend тесты падают: MongoDB connection error
```bash
# Локально запустите MongoDB
docker-compose up -d mongodb

# Или обновите MONGO_URI в .env.test
```

### Frontend тесты падают
```bash
# Очистите кэш
flutter clean
flutter pub get

# Проверьте версию Flutter
flutter --version  # Должна быть >= 3.16.0
```

### Docker build fails
```bash
# Проверьте синтаксис Dockerfile
docker build -t test-backend ./backend

# Проверьте docker-compose
docker-compose config
```

### GitHub Actions: Service MongoDB не запускается
- Проверьте, что используется `mongo:7.0` image
- Убедитесь, что health check настроен правильно
- Увеличьте `health-retries` если нужно

## 📊 Coverage Reports

После успешного прохождения тестов:

### Локально (Backend)
```bash
cd backend
npm test
open coverage/lcov-report/index.html
```

### Локально (Frontend)
```bash
cd frontend
flutter test --coverage
# Установите lcov: brew install lcov (macOS)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### CI/CD (Codecov)
- Coverage автоматически загружается в Codecov (если настроен CODECOV_TOKEN)
- Смотрите отчеты на https://codecov.io/gh/YOUR_USERNAME/ecodrug

## 🎨 Badges для README

Добавьте в главный `README.md`:

```markdown
[![CI/CD Tests](https://github.com/YOUR_USERNAME/ecodrug/workflows/EcoDrug%20CI%2FCD%20-%20Full%20Test%20Suite/badge.svg)](https://github.com/YOUR_USERNAME/ecodrug/actions)
[![codecov](https://codecov.io/gh/YOUR_USERNAME/ecodrug/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/ecodrug)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)](https://flutter.dev/)
[![Node Version](https://img.shields.io/badge/Node.js-18%20%7C%2020-green.svg)](https://nodejs.org/)
```

## 🔄 Дальнейшие улучшения

1. **ESLint Configuration**
   ```bash
   cd backend
   npm install --save-dev eslint eslint-config-airbnb-base eslint-plugin-import
   npx eslint --init
   ```

2. **Pre-commit Hooks** (Husky)
   ```bash
   npm install --save-dev husky lint-staged
   npx husky-init
   ```

3. **Codecov Integration**
   - Зарегистрируйтесь на codecov.io
   - Подключите репозиторий
   - Добавьте CODECOV_TOKEN в GitHub Secrets

4. **Автоматический деплой**
   - Добавьте deploy job после успешного прохождения всех тестов
   - Настройте деплой на staging/production

5. **Больше тестов**
   - Добавить тесты для остальных контроллеров
   - E2E тесты с Cypress или Playwright
   - Performance тесты

## 📚 Дополнительные ресурсы

- [TESTING.md](./TESTING.md) - Подробное руководство по тестированию
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Jest Documentation](https://jestjs.io/)
- [Flutter Testing](https://docs.flutter.dev/testing)

---

**Готово к использованию!** 🎉

Теперь каждый push и PR будет автоматически тестироваться на корректность кода, покрытие тестами, безопасность и сборку Docker образов.

