# ЭкоДруг (EcoDrug)

Мобильное приложение для формирования экологически ответственного поведения граждан.

## Описание проекта

Универсальное цифровое решение, которое объединяет:
- Экологические новости и статьи
- Афишу экологических мероприятий
- Интерактивную карту пунктов переработки отходов
- Образовательные материалы и курсы
- Систему геймификации (баллы, достижения, уровни)
- Челленджи и рейтинги пользователей

## Технологии

- **Backend**: Node.js, Express, MongoDB
- **Frontend**: Flutter Web (позже - Android/iOS)
- **Аутентификация**: JWT + bcrypt
- **База данных**: MongoDB

## Структура проекта

```
ecodrug/
├── backend/              # Node.js + Express backend
│   ├── config/          # Конфигурация БД
│   ├── controllers/     # Бизнес-логика
│   ├── middleware/      # Middleware (auth, validation, errors)
│   ├── models/          # MongoDB схемы
│   ├── routes/          # API маршруты
│   ├── utils/           # Утилиты
│   ├── package.json
│   └── server.js        # Точка входа
│
└── frontend/            # Flutter Web frontend
    ├── lib/
    │   ├── config/      # Константы и конфигурация
    │   ├── models/      # Модели данных
    │   ├── providers/   # State management (Provider)
    │   ├── screens/     # Экраны приложения
    │   ├── services/    # API сервисы
    │   ├── utils/       # Утилиты и валидаторы
    │   ├── widgets/     # Переиспользуемые виджеты
    │   └── main.dart    # Точка входа
    └── pubspec.yaml
```

## Установка и запуск

### Требования

**Вариант 1 (Рекомендуется): Docker**
- Docker Desktop 20+
- Docker Compose 2+

**Вариант 2 (Без Docker):**
- Node.js 16+ и npm
- MongoDB 6+
- Flutter 3.0+
- Dart 3.0+

---

## 🐳 Быстрый старт с Docker (Рекомендуется)

### Вариант A: С помощью Makefile (проще)

```bash
# Запустить backend + MongoDB в Docker
make up

# Запустить frontend локально (в новом терминале)
make frontend

# Или полный запуск одной командой
make dev
```

### Вариант B: С помощью docker-compose напрямую

```bash
# Запустить backend + MongoDB
docker-compose up -d

# Проверить статус
docker-compose ps

# Посмотреть логи
docker-compose logs -f

# Запустить frontend (в новом терминале)
cd frontend
flutter pub get
flutter run -d chrome
```

### Полезные команды

```bash
make help              # Показать все команды
make up                # Запустить сервисы
make down              # Остановить сервисы
make logs              # Показать логи
make backend-logs      # Логи только backend
make restart           # Перезапустить сервисы
make clean             # Удалить контейнеры и volumes
make status            # Статус контейнеров
make db-shell          # MongoDB shell
```

**Доступ к сервисам:**
- Backend API: `http://localhost:5000`
- Frontend: `http://localhost:*` (Flutter покажет порт)
- MongoDB: `localhost:27017`
  - Username: `admin`
  - Password: `admin123`
  - Database: `ecodrug`

---

## 💻 Запуск без Docker

### Backend

1. Перейдите в папку backend:
```bash
cd backend
```

2. Установите зависимости:
```bash
npm install
```

3. Создайте файл `.env`:
```bash
cp .env.example .env
```

4. Отредактируйте `.env` и укажите:
   - `MONGO_URI` - строка подключения к MongoDB
   - `JWT_SECRET` - секретный ключ для JWT (используйте длинную случайную строку)
   - `CLIENT_URL` - URL фронтенда (для CORS)

5. Запустите MongoDB (если локально):
```bash
mongod
```

6. Запустите backend сервер:
```bash
npm run dev
```

Backend будет доступен на `http://localhost:5000`

### Frontend

1. Перейдите в папку frontend:
```bash
cd frontend
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Запустите приложение:
```bash
flutter run -d chrome
```

Frontend будет доступен на `http://localhost:*` (Flutter покажет порт)

## API Endpoints

### Авторизация
- `POST /api/auth/register` - Регистрация нового пользователя
- `POST /api/auth/login` - Вход в систему
- `GET /api/auth/me` - Получить текущего пользователя (требуется токен)

### Профиль
- `GET /api/profile/:id` - Получить профиль по ID пользователя
- `GET /api/profile/me` - Получить свой профиль (требуется токен)
- `PUT /api/profile` - Обновить профиль (требуется токен)
- `POST /api/profile/points` - Добавить баллы (требуется токен)
- `GET /api/profile/leaderboard` - Таблица лидеров

## Статус разработки

### ✅ Фаза 1: Базовая инфраструктура Backend (Завершена)
- Backend setup с Express и MongoDB
- Middleware (auth, validation, error handling)
- Модели User и Profile
- Контроллеры и маршруты для авторизации и профиля

### ✅ Фаза 2: Базовая инфраструктура Frontend (Завершена)
- Flutter setup с Provider
- Модели User и Profile
- Сервисы (API, Auth, Profile, Storage)
- Базовые виджеты (кнопки, поля ввода)
- Экраны авторизации (логин, регистрация)
- Главный экран с навигацией
- Экран профиля

### 🔄 Фаза 3: Контентные модули Backend (В планах)
- Модели News, Event, Course, Quiz, RecyclingPoint
- Контроллеры и маршруты для контентных модулей

### 🔄 Фаза 4: Контентные модули Frontend (В планах)
- Экраны новостей, событий, курсов, карты
- Дополнительные экраны профиля

### 🔄 Фаза 5: Геймификация Backend (В планах)
- Модели Achievement, Challenge, Notification, Donation, Organization
- Контроллеры и маршруты для геймификации

### 🔄 Фаза 6: Геймификация Frontend (В планах)
- Экраны достижений, челленджей, уведомлений
- Панель администратора

## 🧪 Тестирование

### Backend
```bash
cd backend
npm test

# Или с Docker
make test-backend
```

### Frontend
```bash
cd frontend
flutter test

# Или с Makefile
make test-frontend
```

## 🗄️ Управление базой данных

### Доступ к MongoDB shell
```bash
make db-shell

# Или напрямую
docker exec -it ecodrug-mongodb mongosh -u admin -p admin123 ecodrug
```

### Backup базы данных
```bash
make db-backup
```

## 🐛 Troubleshooting

### Backend не запускается
- Проверьте, что Docker запущен: `docker ps`
- Проверьте логи: `make backend-logs`
- Пересоздайте контейнеры: `make clean && make up`

### Frontend не может подключиться к backend
- Убедитесь, что backend запущен: `curl http://localhost:5000/api/health`
- Проверьте CORS настройки в `backend/server.js`
- Проверьте API URL в `frontend/lib/config/constants.dart`

### Ошибки MongoDB
- Проверьте логи: `make db-logs`
- Пересоздайте volume: `make clean && make up`

### Очистка всего окружения
```bash
make clean
docker system prune -a
```

## Правила разработки

См. файлы в `.cursor/rules/`:
- `project-structure.mdc` - Общая архитектура
- `backend-conventions.mdc` - Конвенции backend
- `frontend-conventions.mdc` - Конвенции frontend
- `security-guidelines.mdc` - Правила безопасности
- `api-design.mdc` - Дизайн API
- `data-models.mdc` - Модели данных

## Лицензия

MIT

## Команда

EcoDrug Team
