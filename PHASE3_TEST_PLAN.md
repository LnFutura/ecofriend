# 🧪 План тестирования Фазы 3

## 📋 Текущее состояние

### ✅ Готово к тестированию (Backend - 100%)
- 13 MongoDB моделей
- 6 контроллеров
- 6 роутов (~54 endpoints)
- Все endpoints подключены к server.js

### ⚙️ Частично готово (Frontend - 40%)
- 5 Dart моделей
- 3 сервиса (Education, News, Map)
- Базовые экраны из Фазы 2

---

## 🎯 Этапы тестирования

### ЭТАП 1: Backend API тестирование (30 минут)

#### 1.1 Создание тестовых данных

##### Создать администратора
```bash
# Регистрация admin пользователя
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@ecodrug.ru",
    "username": "admin",
    "password": "admin123"
  }'

# Вручную обновить role в MongoDB на 'admin'
```

##### Создать достижения
```bash
# Получить токен админа
TOKEN="<admin_token>"

# Создать первое достижение
curl -X POST http://localhost:5000/api/achievements \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Первый шаг",
    "description": "Зарегистрируйтесь в приложении",
    "icon": "🎉",
    "type": "special",
    "condition": {
      "type": "register",
      "value": 1
    },
    "points": 10,
    "rarity": "common"
  }'

# Создать достижение за курсы
curl -X POST http://localhost:5000/api/achievements \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Эко-ученик",
    "description": "Завершите 3 курса",
    "icon": "🎓",
    "type": "course",
    "condition": {
      "type": "complete_courses",
      "value": 3
    },
    "points": 50,
    "rarity": "rare"
  }'

# Создать достижение за события
curl -X POST http://localhost:5000/api/achievements \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Эко-активист",
    "description": "Посетите 5 событий",
    "icon": "🌱",
    "type": "event",
    "condition": {
      "type": "attend_events",
      "value": 5
    },
    "points": 100,
    "rarity": "epic"
  }'
```

##### Создать челлендж
```bash
curl -X POST http://localhost:5000/api/challenges \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Эко-неделя",
    "description": "Завершите 2 курса за неделю",
    "type": "weekly",
    "startDate": "2025-10-28T00:00:00Z",
    "endDate": "2025-11-04T23:59:59Z",
    "goal": {
      "type": "complete_courses",
      "target": 2
    },
    "reward": {
      "points": 150
    },
    "active": true
  }'
```

##### Создать курсы
```bash
# Курс по переработке
curl -X POST http://localhost:5000/api/education/courses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Основы раздельного сбора",
    "description": "Научитесь правильно сортировать отходы для переработки",
    "content": "Раздельный сбор - это первый шаг к экологически ответственному поведению.",
    "category": "recycling",
    "level": "beginner",
    "duration": 30,
    "points": 50,
    "modules": [
      {
        "title": "Введение",
        "content": "Что такое раздельный сбор и зачем он нужен",
        "order": 1,
        "resources": []
      },
      {
        "title": "Типы отходов",
        "content": "Пластик, стекло, бумага, металл - как различать",
        "order": 2,
        "resources": []
      },
      {
        "title": "Практика",
        "content": "Как организовать раздельный сбор дома",
        "order": 3,
        "resources": []
      }
    ],
    "published": true
  }'

# Курс по энергосбережению
curl -X POST http://localhost:5000/api/education/courses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Энергосбережение дома",
    "description": "Как снизить потребление энергии и сэкономить",
    "content": "Простые способы экономии энергии в быту",
    "category": "energy",
    "level": "beginner",
    "duration": 25,
    "points": 40,
    "modules": [
      {
        "title": "Основы",
        "content": "Откуда берутся потери энергии",
        "order": 1,
        "resources": []
      },
      {
        "title": "Освещение",
        "content": "LED лампы и датчики движения",
        "order": 2,
        "resources": []
      }
    ],
    "published": true
  }'
```

##### Создать новости
```bash
# Новость 1
curl -X POST http://localhost:5000/api/news \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "В Москве открылся новый пункт переработки",
    "content": "На территории парка Горького открылся современный пункт приема вторсырья. Принимаются пластик, стекло, бумага и металл.",
    "excerpt": "Новый пункт переработки в парке Горького",
    "category": "news",
    "tags": ["переработка", "москва", "новости"],
    "status": "approved",
    "publishedAt": "2025-10-29T10:00:00Z"
  }'

# Модерировать (если нужно)
NEWS_ID="<news_id>"
curl -X PUT http://localhost:5000/api/news/$NEWS_ID/moderate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "status": "approved"
  }'
```

##### Создать события
```bash
# Субботник
curl -X POST http://localhost:5000/api/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Экологический субботник в парке",
    "description": "Присоединяйтесь к уборке парка! Инвентарь предоставляется.",
    "type": "cleanup",
    "date": "2025-11-15T10:00:00Z",
    "endDate": "2025-11-15T14:00:00Z",
    "location": {
      "address": "Парк Горького",
      "city": "Москва",
      "country": "Россия",
      "coordinates": [37.6173, 55.7308]
    },
    "isOnline": false,
    "capacity": 50,
    "tags": ["субботник", "уборка", "москва"],
    "status": "approved",
    "points": 100
  }'

# Вебинар
curl -X POST http://localhost:5000/api/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Вебинар: Как стать эко-блогером",
    "description": "Онлайн-встреча с популярными эко-блогерами",
    "type": "webinar",
    "date": "2025-11-10T18:00:00Z",
    "endDate": "2025-11-10T20:00:00Z",
    "isOnline": true,
    "onlineLink": "https://zoom.us/j/example",
    "capacity": 100,
    "tags": ["вебинар", "онлайн"],
    "status": "approved",
    "points": 50
  }'
```

##### Создать пункты переработки
```bash
# Пункт 1 - Москва
curl -X POST http://localhost:5000/api/recycling-points \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Экоцентр Парк Горького",
    "type": ["plastic", "glass", "paper", "metal"],
    "address": "Крымский Вал, 9",
    "city": "Москва",
    "coordinates": {
      "type": "Point",
      "coordinates": [37.6017, 55.7308]
    },
    "workingHours": "Пн-Вс: 9:00-21:00",
    "phone": "+7 (495) 123-45-67",
    "description": "Принимаем все виды пластика, стекло, бумагу, металл",
    "verified": true,
    "rating": 4.5
  }'

# Пункт 2 - Москва
curl -X POST http://localhost:5000/api/recycling-points \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Пункт приема батареек ТЦ Европейский",
    "type": ["batteries", "electronics"],
    "address": "пл. Киевского Вокзала, 2",
    "city": "Москва",
    "coordinates": {
      "type": "Point",
      "coordinates": [37.5656, 55.7442]
    },
    "workingHours": "Пн-Вс: 10:00-22:00",
    "description": "Принимаем батарейки и мелкую электронику",
    "verified": true,
    "rating": 4.8
  }'

# Пункт 3 - СПб
curl -X POST http://localhost:5000/api/recycling-points \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Экодвор на Невском",
    "type": ["plastic", "glass", "paper", "clothes"],
    "address": "Невский проспект, 100",
    "city": "Санкт-Петербург",
    "coordinates": {
      "type": "Point",
      "coordinates": [30.3609, 59.9311]
    },
    "workingHours": "Круглосуточно",
    "verified": true,
    "rating": 4.2
  }'
```

#### 1.2 Тестирование GET endpoints

```bash
# Все достижения
curl -s http://localhost:5000/api/achievements | python3 -m json.tool

# Все челленджи
curl -s http://localhost:5000/api/challenges | python3 -m json.tool

# Все курсы
curl -s http://localhost:5000/api/education/courses | python3 -m json.tool

# Курсы по категории
curl -s "http://localhost:5000/api/education/courses?category=recycling" | python3 -m json.tool

# Все новости
curl -s http://localhost:5000/api/news | python3 -m json.tool

# Все события
curl -s http://localhost:5000/api/events | python3 -m json.tool

# Предстоящие события
curl -s "http://localhost:5000/api/events?upcoming=true" | python3 -m json.tool

# Все пункты
curl -s http://localhost:5000/api/recycling-points | python3 -m json.tool

# Пункты в Москве
curl -s "http://localhost:5000/api/recycling-points?city=Москва" | python3 -m json.tool

# Ближайшие пункты (Москва центр)
curl -s "http://localhost:5000/api/recycling-points/nearby?lat=55.7558&lng=37.6173&radius=5000" | python3 -m json.tool

# Типы отходов
curl -s http://localhost:5000/api/recycling-points/types | python3 -m json.tool
```

#### 1.3 Тестирование пользовательских действий

```bash
# Логин обычного пользователя
USER_TOKEN=$(curl -s -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "vlad@ecodrug.ru", "password": "test123"}' | \
  python3 -c "import sys, json; print(json.load(sys.stdin)['token'])")

# Записаться на курс
COURSE_ID="<course_id>"
curl -X POST http://localhost:5000/api/education/courses/$COURSE_ID/enroll \
  -H "Authorization: Bearer $USER_TOKEN"

# Завершить курс
curl -X POST http://localhost:5000/api/education/courses/$COURSE_ID/complete \
  -H "Authorization: Bearer $USER_TOKEN"

# Присоединиться к челленджу
CHALLENGE_ID="<challenge_id>"
curl -X POST http://localhost:5000/api/challenges/$CHALLENGE_ID/join \
  -H "Authorization: Bearer $USER_TOKEN"

# Лайкнуть новость
NEWS_ID="<news_id>"
curl -X POST http://localhost:5000/api/news/$NEWS_ID/like \
  -H "Authorization: Bearer $USER_TOKEN"

# Комментировать новость
curl -X POST http://localhost:5000/api/news/$NEWS_ID/comment \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{"text": "Отличная новость!"}'

# Зарегистрироваться на событие
EVENT_ID="<event_id>"
curl -X POST http://localhost:5000/api/events/$EVENT_ID/register \
  -H "Authorization: Bearer $USER_TOKEN"

# Проверить профиль (должны быть очки)
curl -s http://localhost:5000/api/profile/me \
  -H "Authorization: Bearer $USER_TOKEN" | python3 -m json.tool
```

#### 1.4 Чек-лист Backend тестов

- [ ] Health endpoint работает
- [ ] Все GET endpoints возвращают данные
- [ ] Достижения создаются и отображаются
- [ ] Челленджи активны
- [ ] Курсы доступны для записи
- [ ] Новости показываются с approved статусом
- [ ] События с фильтром upcoming работают
- [ ] Geo-поиск пунктов переработки работает
- [ ] Пользователь может записаться на курс
- [ ] Пользователь получает очки за завершение курса
- [ ] Пользователь может лайкать и комментировать
- [ ] Пользователь может регистрироваться на события
- [ ] Profile показывает накопленные очки

---

### ЭТАП 2: Frontend интеграция (1 час)

#### 2.1 Обновить IP адрес

```dart
// frontend/lib/config/constants.dart
static const String apiBaseUrl = 'http://YOUR_MAC_IP:5000/api';
```

#### 2.2 Создать простой экран для тестирования

Создать `test_phase3_screen.dart` с кнопками:
- Загрузить достижения
- Загрузить курсы
- Загрузить новости
- Загрузить события
- Загрузить пункты на карте

#### 2.3 Запустить на iPhone

```bash
cd frontend
flutter run --release -d <iphone_id>
```

#### 2.4 Чек-лист Frontend тестов

- [ ] Приложение открывается
- [ ] Сервисы подключаются к backend
- [ ] Достижения загружаются
- [ ] Курсы отображаются
- [ ] Новости читаются
- [ ] События показываются
- [ ] Пункты загружаются
- [ ] Нет ClientException ошибок

---

### ЭТАП 3: Integration тесты (30 минут)

#### 3.1 Полный user flow

1. **Регистрация** → Получение первого достижения (если реализовано)
2. **Логин** → Переход в приложение
3. **Просмотр курсов** → Выбор курса → Запись
4. **Завершение курса** → Получение очков → Проверка профиля
5. **Просмотр новостей** → Лайк → Комментарий
6. **Просмотр событий** → Регистрация на событие
7. **Карта** → Просмотр ближайших пунктов
8. **Профиль** → Проверка очков, достижений

#### 3.2 Чек-лист Integration

- [ ] Полный цикл регистрация-курс-очки работает
- [ ] Данные синхронизируются между экранами
- [ ] Очки правильно начисляются
- [ ] Токен сохраняется и работает
- [ ] Logout очищает данные

---

## 📊 Ожидаемые результаты

### Backend
- ✅ Все endpoints возвращают 200 OK
- ✅ Созданные данные доступны через API
- ✅ Авторизация работает
- ✅ Очки начисляются правильно
- ✅ Geo-поиск находит ближайшие точки

### Frontend
- ✅ Приложение подключается к backend
- ✅ Данные загружаются и отображаются
- ✅ Нет network errors

---

## 🐛 Возможные проблемы

### 1. ClientException
**Решение**: Проверить IP адрес в constants.dart

### 2. 401 Unauthorized
**Решение**: Проверить JWT token в заголовках

### 3. Пустые данные
**Решение**: Проверить, что sample data созданы в MongoDB

### 4. Geo-поиск не работает
**Решение**: Проверить, что создан 2dsphere индекс

---

## ✅ Критерии успеха

Фаза 3 Backend считается успешной, если:
- ✅ Все 54 endpoints работают
- ✅ Sample data загружаются
- ✅ Пользователь может взаимодействовать с API
- ✅ Очки начисляются корректно
- ✅ Geo-поиск находит пункты

Frontend интеграция успешна, если:
- ✅ Сервисы загружают данные
- ✅ Нет ошибок подключения
- ✅ Модели правильно парсят JSON

---

## 📝 Документирование результатов

После тестирования обновить:
- `TEST_PLAN.md` - результаты тестов
- `PHASE3_SUMMARY.md` - финальные метрики
- `README.md` - инструкции по использованию новых функций

