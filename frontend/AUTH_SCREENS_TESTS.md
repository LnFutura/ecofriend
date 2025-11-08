# Тесты для экранов авторизации (Вариант 1: Минимум для продакшена)

## Структура тестов

```
frontend/test/
├── screens/              # Widget-тесты (быстрые, UI-проверки)
│   ├── welcome_screen_test.dart
│   ├── login_screen_test.dart
│   └── register_screen_test.dart
├── integration/          # Integration-тесты (полноценные флоу)
│   ├── login_integration_test.dart
│   └── register_integration_test.dart
└── ...
```

## Созданные тесты

### 1. **Welcome Screen** (1 smoke-тест)
- ✅ `welcome_screen_test.dart` - 2 теста
  - Проверка отображения всех UI элементов (медведь, кнопки, текст)
  - Проверка кликабельности кнопки входа

### 2. **Login Screen** (5 тестов: 3 integration + 2 widget)

#### Widget-тесты (`login_screen_test.dart`)
- ✅ Проверка наличия всех UI элементов (облако, поля ввода, кнопки)
- ✅ Проверка работы переключателя видимости пароля

#### Integration-тесты (`login_integration_test.dart`)
- ✅ Успешный вход с валидными данными
- ✅ Обработка ошибки при неверных данных
- ✅ Валидация формы (предотвращение отправки пустой формы)

### 3. **Register Screen** (2 теста: 1 integration + 1 widget)

#### Widget-тесты (`register_screen_test.dart`)
- ✅ Динамическое появление кнопки "Продолжить" при заполнении полей
- ✅ Проверка наличия всех UI элементов

#### Integration-тесты (`register_integration_test.dart`)
- ✅ Успешный флоу регистрации с проверкой динамики

## Запуск тестов

### Все тесты для экранов авторизации:
```bash
cd frontend
flutter test test/screens/ test/integration/
```

### Только widget-тесты (быстрые):
```bash
flutter test test/screens/
```

### Только integration-тесты:
```bash
flutter test test/integration/
```

### Конкретный файл:
```bash
flutter test test/screens/login_screen_test.dart
```

## Результаты

```
✅ 10/10 тестов прошли успешно

Login Screen:       5 тестов ✅
Register Screen:    3 теста ✅
Welcome Screen:     2 теста ✅
```

## Важные замечания

### Для integration-тестов:
- **Backend не требуется** - тесты используют mock API
- Тесты проверяют UI логику и навигацию
- Для полноценного тестирования с реальным backend требуется дополнительная настройка

### Адаптивность:
- Все тесты используют `tester.view.physicalSize` для установки размеров экрана
- Welcome Screen и Login integration тесты используют размер `1080x1920` для предотвращения overflow

### Что НЕ покрыто (опционально для будущего):
- Тесты с реальным backend API
- Тесты локального хранилища (token persistence)
- Тесты производительности
- Snapshot-тесты для проверки точности дизайна

## Типы тестов

### Widget Tests (быстрые, ~1-2 секунды)
- Проверяют отдельные виджеты
- Проверяют UI элементы и их взаимодействие
- Идеальны для TDD и CI/CD

### Integration Tests (средние, ~3-5 секунд)
- Проверяют полные сценарии пользователя
- Проверяют навигацию между экранами
- Проверяют валидацию и обработку ошибок

## CI/CD Integration

Добавьте в `.github/workflows/test.yml`:
```yaml
- name: Run Auth Screen Tests
  run: |
    cd frontend
    flutter test test/screens/ test/integration/
```

## Покрытие кода

Для проверки покрытия:
```bash
cd frontend
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

**Создано:** 2025-11-08  
**Тип:** Минимум для продакшена (Вариант 1)  
**Статус:** ✅ Все тесты работают

