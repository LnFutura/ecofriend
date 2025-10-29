# Руководство по тестированию EcoDrug

Этот документ описывает процесс тестирования проекта EcoDrug (backend + frontend).

## 📋 Содержание

- [Backend тесты](#backend-тесты)
- [Frontend тесты](#frontend-тесты)
- [CI/CD тестирование](#cicd-тестирование)
- [Локальное тестирование](#локальное-тестирование)

---

## Backend Тесты

### Требования

- Node.js 18+ или 20+
- MongoDB 7.0+ (запущенный локально или в Docker)
- npm или yarn

### Структура тестов

```
backend/
├── tests/
│   ├── setup.js                 # Общая настройка тестов
│   ├── unit/                    # Unit тесты
│   │   ├── authController.test.js
│   │   └── profileController.test.js
│   └── integration/             # Интеграционные тесты
│       ├── auth.test.js
│       └── profile.test.js
├── jest.config.js               # Конфигурация Jest
└── .env.test                    # Переменные окружения для тестов
```

### Запуск тестов

#### Все тесты с покрытием кода:
```bash
cd backend
npm test
```

#### Только unit тесты:
```bash
npm run test:unit
```

#### Только интеграционные тесты:
```bash
npm run test:integration
```

#### Тесты в режиме watch (для разработки):
```bash
npm run test:watch
```

### Настройка MongoDB для тестов

#### Вариант 1: Docker (рекомендуется)
```bash
# Запустить MongoDB в Docker
docker-compose up -d mongodb
```

#### Вариант 2: Локальная MongoDB
Убедитесь, что MongoDB запущена на `localhost:27017` с учетными данными:
- Username: `admin`
- Password: `password123`
- Database: `ecodrug_test`

### Переменные окружения для тестов

Создайте файл `backend/.env.test`:
```env
NODE_ENV=test
MONGO_URI=mongodb://admin:password123@localhost:27017/ecodrug_test?authSource=admin
JWT_SECRET=test_jwt_secret_key_12345
PORT=5000
```

### Покрытие кода

После запуска тестов с флагом `--coverage`, отчет будет доступен в:
- `backend/coverage/lcov-report/index.html` - HTML отчет
- `backend/coverage/lcov.info` - для CI/CD

**Минимальное требование к покрытию:**
- Branches: 70%
- Functions: 70%
- Lines: 70%
- Statements: 70%

---

## Frontend Тесты

### Требования

- Flutter 3.16.0+
- Dart SDK 3.0+

### Структура тестов

```
frontend/
├── test/
│   ├── widget_test.dart         # Тесты виджетов
│   ├── models_test.dart         # Тесты моделей
│   └── services_test.dart       # Тесты сервисов
└── pubspec.yaml
```

### Запуск тестов

#### Все тесты:
```bash
cd frontend
flutter test
```

#### Тесты с покрытием кода:
```bash
flutter test --coverage
```

#### Просмотр HTML отчета покрытия (требует genhtml):
```bash
# На macOS
brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# На Linux
sudo apt-get install lcov
genhtml coverage/lcov.info -o coverage/html
xdg-open coverage/html/index.html
```

### Анализ кода Flutter

```bash
# Статический анализ
flutter analyze

# Форматирование кода
flutter format .

# Проверка форматирования без изменений
flutter format --set-exit-if-changed .
```

---

## CI/CD Тестирование

Проект использует GitHub Actions для автоматического тестирования при каждом push и pull request.

### Workflow файл

`.github/workflows/test.yml` включает следующие проверки:

#### 1. Backend Tests
- ✅ Запуск unit тестов
- ✅ Запуск интеграционных тестов
- ✅ Проверка покрытия кода
- ✅ ESLint (если настроен)
- ✅ Тестирование на Node.js 18 и 20

#### 2. Frontend Tests
- ✅ Flutter analyzer
- ✅ Flutter tests
- ✅ Проверка покрытия кода

#### 3. End-to-End Tests
- ✅ Запуск backend сервера
- ✅ Тестирование API endpoints
- ✅ Health check

#### 4. Security Audit
- ✅ npm audit для backend
- ✅ Flutter pub outdated для frontend

#### 5. Docker Build
- ✅ Сборка backend Docker образа
- ✅ Сборка frontend Docker образа
- ✅ Валидация docker-compose.yml

### Просмотр результатов CI/CD

1. Перейдите на GitHub в раздел **Actions**
2. Выберите workflow **"EcoDrug CI/CD - Full Test Suite"**
3. Просмотрите результаты каждого job

### Badges (опционально)

Добавьте в README.md:

```markdown
![Backend Tests](https://github.com/YOUR_USERNAME/ecodrug/workflows/EcoDrug%20CI%2FCD%20-%20Full%20Test%20Suite/badge.svg)
![Coverage](https://codecov.io/gh/YOUR_USERNAME/ecodrug/branch/main/graph/badge.svg)
```

---

## Локальное тестирование

### Полный цикл тестирования перед push

```bash
# 1. Backend тесты
cd backend
npm test
npm run lint

# 2. Frontend тесты
cd ../frontend
flutter test
flutter analyze

# 3. Docker build test
cd ..
docker-compose build

# 4. Проверка docker-compose
docker-compose config
```

### Отладка упавших тестов

#### Backend:
```bash
# Запустить конкретный тест
npm test -- tests/unit/authController.test.js

# Verbose режим
npm test -- --verbose

# Без coverage (быстрее)
npm test -- --no-coverage
```

#### Frontend:
```bash
# Запустить конкретный тест
flutter test test/widget_test.dart

# Verbose режим
flutter test --verbose
```

---

## Написание новых тестов

### Backend Unit Test Template

```javascript
const Model = require('../../models/Model');
const { functionToTest } = require('../../controllers/controller');

jest.mock('../../models/Model');

describe('Feature - Unit Tests', () => {
  let req, res;

  beforeEach(() => {
    req = { body: {}, user: {}, params: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    jest.clearAllMocks();
  });

  test('should do something', async () => {
    // Arrange
    req.body = { data: 'test' };
    Model.find.mockResolvedValue([]);

    // Act
    await functionToTest(req, res);

    // Assert
    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ success: true })
    );
  });
});
```

### Backend Integration Test Template

```javascript
const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../../server');
const Model = require('../../models/Model');

describe('API Endpoint - Integration Tests', () => {
  let token;

  beforeAll(async () => {
    const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/ecodrug_test';
    if (mongoose.connection.readyState === 0) {
      await mongoose.connect(mongoUri);
    }
  });

  beforeEach(async () => {
    await Model.deleteMany({});
    // Setup: register user and get token
  });

  afterAll(async () => {
    await Model.deleteMany({});
    await mongoose.connection.close();
  });

  test('should handle request', async () => {
    const response = await request(app)
      .get('/api/endpoint')
      .set('Authorization', `Bearer ${token}`);

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
  });
});
```

### Flutter Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Widget should render', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: YourWidget(),
      ),
    );

    expect(find.text('Expected Text'), findsOneWidget);
    expect(find.byType(SomeWidget), findsOneWidget);
  });
}
```

---

## Troubleshooting

### Backend: MongoDB connection failed
```bash
# Проверьте, что MongoDB запущена
docker-compose ps

# Перезапустите MongoDB
docker-compose restart mongodb
```

### Backend: JWT token errors
```bash
# Убедитесь, что JWT_SECRET установлен
cat backend/.env.test
```

### Frontend: Flutter tests fail
```bash
# Очистите кэш
flutter clean
flutter pub get

# Проверьте версию Flutter
flutter --version
```

### CI/CD: Tests timeout
- Увеличьте timeout в `jest.config.js` (backend)
- Проверьте, что MongoDB service запускается корректно

---

## Метрики качества

### Текущие цели:

- ✅ **Backend**: >70% code coverage
- ✅ **Frontend**: >60% code coverage
- ✅ **All tests**: Проходят на CI/CD
- ✅ **ESLint/Flutter Analyze**: 0 критических ошибок
- ✅ **Security Audit**: 0 высоких уязвимостей
- ✅ **Docker Build**: Успешная сборка

---

## Полезные ссылки

- [Jest Documentation](https://jestjs.io/)
- [Supertest Documentation](https://github.com/visionmedia/supertest)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Последнее обновление:** 2024-01-27

