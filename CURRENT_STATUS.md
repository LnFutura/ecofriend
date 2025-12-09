# 📊 Текущее состояние проекта EcoDrug

> **Последнее обновление**: 4 декабря 2025

---

## 🎯 Что это за проект?

**ЭкоДруг** — мобильное приложение для формирования экологически ответственного поведения граждан.

**Основные возможности:**
- 📰 Экологические новости
- 📅 Афиша экологических мероприятий
- 🗺️ Карта пунктов переработки с геопоиском
- 📚 Образовательные курсы и тесты
- 🏆 Геймификация (баллы, достижения, челленджи)
- 👤 Профили пользователей и организаций
- 📊 Рейтинги и таблица лидеров

---

## 💻 Технологический стек

### Backend
- **Node.js 18/20** + **Express.js 4.18**
- **MongoDB 7.0** + **Mongoose 8.0**
- **JWT** для аутентификации
- **bcrypt** для хеширования паролей
- **Jest** для тестирования
- **Multer** для загрузки файлов

### Frontend
- **Flutter 3.16+** (Web + iOS + Android)
- **Dart 3.0+**
- **Provider** для state management
- **HTTP** client для API
- **flutter_map** для карт
- **flutter_svg** для иконок

### DevOps
- **Docker** + **Docker Compose**
- **GitHub Actions** для CI/CD
- **Makefile** для автоматизации

---

## 📁 Структура проекта

```
ecodrug/
├── backend/              # Node.js API сервер
│   ├── models/          # 11 MongoDB моделей ✅
│   ├── controllers/     # 8 контроллеров ✅
│   ├── routes/          # 8 роутов (54+ endpoints) ✅
│   ├── middleware/      # Auth, validation, errors ✅
│   ├── tests/           # 32 теста ✅
│   └── server.js        # Точка входа ✅
│
├── frontend/            # Flutter приложение
│   ├── lib/
│   │   ├── models/      # 7 Dart моделей ✅
│   │   ├── services/    # 8 API сервисов ✅
│   │   ├── providers/   # 4 провайдера ⚠️
│   │   ├── screens/     # 7 экранов ⚠️
│   │   └── widgets/     # 10+ виджетов ⚠️
│   └── test/            # 15+ тестов ✅
│
├── .github/workflows/   # CI/CD ✅
├── docker-compose.yml   # Оркестрация ✅
└── Makefile            # Команды автоматизации ✅
```

---

## ✅ Что реализовано (Backend)

### 1. **Модели MongoDB (11 моделей)** — 100% ✅

| Модель | Описание | Статус |
|--------|----------|--------|
| `User` | Пользователь (email, пароль, роль) | ✅ |
| `Profile` | Профиль (баллы, уровень, достижения) | ✅ |
| `Achievement` | Достижения пользователей | ✅ |
| `Challenge` | Челленджи и вызовы | ✅ |
| `Course` | Образовательные курсы | ✅ |
| `Quiz` | Тесты к курсам | ✅ |
| `News` | Новости с модерацией | ✅ |
| `Event` | События и мероприятия | ✅ |
| `RecyclingPoint` | Пункты переработки (с geo-индексом) | ✅ |
| `Notification` | Уведомления | ✅ |
| `Organization` | Организации | ✅ |

### 2. **Контроллеры (8 контроллеров)** — 100% ✅

| Контроллер | Основные методы | Статус |
|------------|----------------|--------|
| `authController` | register, login, getMe | ✅ |
| `profileController` | getProfile, updateProfile, addPoints, leaderboard | ✅ |
| `achievementController` | getAll, unlock, getUserAchievements | ✅ |
| `challengeController` | getAll, join, updateProgress | ✅ |
| `educationController` | getCourses, enroll, complete, submitQuiz | ✅ |
| `newsController` | getAll, create, like, comment, moderate | ✅ |
| `eventController` | getAll, register, attend, calendar | ✅ |
| `recyclingController` | getAll, nearby (geo-поиск), review | ✅ |

### 3. **API Routes (54+ endpoints)** — 100% ✅

#### Authorization (`/api/auth`)
```
POST /api/auth/register     # Регистрация
POST /api/auth/login        # Вход
GET  /api/auth/me           # Текущий пользователь
```

#### Profile (`/api/profile`)
```
GET  /api/profile/me        # Мой профиль
PUT  /api/profile           # Обновить профиль
POST /api/profile/avatar    # Загрузить аватар
GET  /api/profile/leaderboard # Таблица лидеров
```

#### Achievements (`/api/achievements`)
```
GET  /api/achievements           # Все достижения
POST /api/achievements/:id/unlock # Разблокировать
```

#### Education (`/api/education`)
```
GET  /api/education/courses          # Список курсов
POST /api/education/courses/:id/enroll # Записаться
POST /api/education/quizzes/:id/submit # Сдать тест
```

#### News (`/api/news`)
```
GET  /api/news              # Все новости
POST /api/news/:id/like     # Лайкнуть
POST /api/news/:id/comment  # Комментировать
```

#### Events (`/api/events`)
```
GET  /api/events                # Все события
POST /api/events/:id/register   # Зарегистрироваться
GET  /api/events/calendar       # Календарь
```

#### Recycling (`/api/recycling-points`)
```
GET  /api/recycling-points          # Все пункты
GET  /api/recycling-points/nearby   # Ближайшие (геопоиск)
POST /api/recycling-points/:id/review # Отзыв
```

### 4. **Безопасность** — 100% ✅
- ✅ JWT токены (срок действия 7 дней)
- ✅ Хеширование паролей (bcrypt)
- ✅ Middleware для проверки авторизации
- ✅ Валидация входных данных (express-validator)
- ✅ CORS настроен
- ✅ Роли: user, organization, moderator, admin

### 5. **Тестирование** — 80% ✅
- ✅ 17 unit тестов (authController, profileController)
- ✅ 15 integration тестов (API endpoints)
- ✅ Coverage ~70%
- ⚠️ Нужно добавить тесты для новых модулей

---

## ✅ Что реализовано (Frontend)

### 1. **Модели Dart (7 моделей)** — 100% ✅

| Модель | fromJson | toJson | Статус |
|--------|----------|--------|--------|
| `User` | ✅ | ✅ | ✅ |
| `Profile` | ✅ | ✅ | ✅ |
| `Achievement` | ✅ | ✅ | ✅ |
| `Course` | ✅ | ✅ | ✅ |
| `News` | ✅ | ✅ | ✅ |
| `Event` | ✅ | ✅ | ✅ |
| `RecyclingPoint` | ✅ | ✅ | ✅ |

### 2. **Сервисы (8 сервисов)** — 100% ✅

| Сервис | Основные методы | Статус |
|--------|----------------|--------|
| `ApiService` | Базовый HTTP client | ✅ |
| `AuthService` | register, login, getMe | ✅ |
| `ProfileService` | getProfile, updateProfile, uploadAvatar | ✅ |
| `NewsService` | getNews, likeNews, commentNews | ✅ |
| `EducationService` | getCourses, enrollCourse | ✅ |
| `MapService` | getRecyclingPoints, getNearby | ✅ |
| `StorageService` | saveToken, getToken | ✅ |
| `UploadService` | uploadFile | ✅ |

### 3. **Провайдеры (4 провайдера)** — 70% ⚠️

| Провайдер | State управление | Статус |
|-----------|-----------------|--------|
| `AuthProvider` | Авторизация | ✅ |
| `ProfileProvider` | Профиль | ✅ |
| `NewsProvider` | Новости | ✅ |
| `ThemeProvider` | Тема приложения | ✅ |
| `EducationProvider` | Курсы | ❌ TODO |
| `EventsProvider` | События | ❌ TODO |
| `MapProvider` | Карта | ❌ TODO |

### 4. **Экраны (7 экранов)** — 60% ⚠️

| Экран | Описание | Статус |
|-------|----------|--------|
| `WelcomeScreen` | Приветственный экран | ✅ |
| `LoginScreen` | Вход | ✅ |
| `RegisterScreen` | Регистрация | ✅ |
| `ProfileScreen` | Профиль пользователя | ✅ |
| `NewsFeedScreen` | Лента новостей | ✅ |
| `NewsDetailScreen` | Детали новости | ✅ |
| `CoursesScreen` | Список курсов | ⚠️ Базовый |
| `CourseDetailScreen` | Детали курса | ❌ TODO |
| `QuizScreen` | Тестирование | ❌ TODO |
| `EventsScreen` | События | ❌ TODO |
| `MapScreen` | Карта пунктов | ❌ TODO |
| `AchievementsScreen` | Достижения | ❌ TODO |
| `ChallengesScreen` | Челленджи | ❌ TODO |

### 5. **Виджеты (10+ виджетов)** — 70% ⚠️

| Виджет | Назначение | Статус |
|--------|------------|--------|
| `CustomButton` | Кнопка | ✅ |
| `CustomTextField` | Поле ввода | ✅ |
| `LoadingIndicator` | Индикатор загрузки | ✅ |
| `AvatarWidget` | Аватар пользователя | ✅ |
| `StatsCard` | Карточка статистики | ✅ |
| `AchievementsWidget` | Список достижений | ✅ |
| `BottomNavBar` | Нижняя навигация | ✅ |
| `NewsCard` | Карточка новости | ✅ |
| `EventCard` | Карточка события | ❌ TODO |
| `CourseCard` | Карточка курса | ❌ TODO |

---

## 📊 Общая статистика проекта

### Кодовая база
- **Backend**: ~5000+ строк кода
- **Frontend**: ~4000+ строк кода
- **Тесты**: ~1500+ строк кода
- **Документация**: ~3000+ строк
- **Всего**: ~13500+ строк кода

### API
- **54+ endpoints** готовы к использованию
- **40+ защищённых** (требуют JWT токен)
- **14 публичных**

### База данных
- **11 коллекций** MongoDB
- **Geo-индексы** для карты (2dsphere)
- **B-tree индексы** для поиска и сортировки

### Тестирование
- **32 backend теста** (unit + integration)
- **15+ frontend тестов** (widget + model + service)
- **Coverage**: Backend ~70%, Frontend ~60%

---

## 🎯 Текущий статус по модулям

| Модуль | Backend | Frontend | Статус |
|--------|---------|----------|--------|
| **Auth** | ✅ 100% | ✅ 100% | ✅ Готово |
| **Profile** | ✅ 100% | ✅ 100% | ✅ Готово |
| **News** | ✅ 95% | ✅ 85% | ⚠️ Почти готово |
| **Education** | ✅ 90% | ⚠️ 40% | ⚠️ В процессе |
| **Events** | ✅ 90% | ⚠️ 25% | ⚠️ В процессе |
| **Map** | ✅ 90% | ⚠️ 30% | ⚠️ В процессе |
| **Achievements** | ✅ 90% | ⚠️ 25% | ⚠️ В процессе |
| **Challenges** | ✅ 90% | ❌ 0% | ⚠️ Backend готов |
| **Notifications** | ⚠️ 30% | ❌ 0% | ❌ TODO |
| **Organizations** | ⚠️ 30% | ❌ 0% | ❌ TODO |
| **Admin Panel** | ❌ 0% | ❌ 0% | ❌ TODO |

### Легенда:
- ✅ **Готово** — полностью реализовано и протестировано
- ⚠️ **В процессе** — частично реализовано, требуется доработка
- ❌ **TODO** — не начато

---

## 🔥 Что работает прямо сейчас

### ✅ Можно использовать:
1. **Регистрация и вход** в приложение
2. **Просмотр и редактирование профиля**
3. **Загрузка аватара**
4. **Просмотр ленты новостей** с изображениями
5. **Лайки и комментарии** к новостям
6. **Просмотр таблицы лидеров**
7. **Баллы и уровни пользователей**
8. **API для курсов, событий, карты** (backend готов)

### ⚠️ В разработке:
1. **Детальный просмотр курсов** и прохождение
2. **Тестирование** (quizzes)
3. **Календарь событий**
4. **Интерактивная карта** пунктов переработки
5. **Экраны достижений и челленджей**

### ❌ Запланировано:
1. **Push-уведомления**
2. **Email-уведомления**
3. **Административная панель**
4. **Верификация организаций**
5. **Мобильные сборки** (iOS, Android)

---

## 🚀 Как запустить проект

### С Docker (рекомендуется)
```bash
# Запустить backend + MongoDB
make up

# Запустить frontend (в новом терминале)
make frontend

# Или всё вместе
make dev
```

### Без Docker
```bash
# Backend
cd backend
npm install
npm run dev

# Frontend (в новом терминале)
cd frontend
flutter pub get
flutter run -d chrome
```

### Seed тестовые данные
```bash
cd backend

# Создать админа
node scripts/createAdmin.js

# Добавить новости
node scripts/seedNews.js

# Создать тестовых пользователей
node scripts/createTestUsers.js
```

---

## 🧪 Запуск тестов

```bash
# Все тесты
make test

# Backend тесты
make test-backend

# Frontend тесты
make test-frontend

# С покрытием
make test-coverage
```

---

## 📝 Следующие шаги

### Приоритет 1: Завершить Frontend (2-3 недели)
- [ ] Создать экраны для курсов (список, детали, тесты)
- [ ] Создать экраны для событий (список, календарь)
- [ ] Реализовать интерактивную карту с `flutter_map`
- [ ] Добавить экраны достижений и челленджей
- [ ] Создать недостающие провайдеры

### Приоритет 2: Доработать Backend (1-2 недели)
- [ ] Реализовать push-уведомления (FCM)
- [ ] Добавить email-уведомления (Nodemailer)
- [ ] Создать API для организаций
- [ ] Добавить административную панель
- [ ] Написать тесты для новых модулей

### Приоритет 3: Mobile сборки (3-4 недели)
- [ ] iOS build и тестирование
- [ ] Android build и APK
- [ ] Адаптация UI для мобильных устройств
- [ ] Интеграция с нативными фичами (камера, геолокация)

### Приоритет 4: Production Deployment (1-2 недели)
- [ ] Настроить сервер (VPS/Cloud)
- [ ] MongoDB Atlas для production
- [ ] SSL сертификаты
- [ ] CI/CD для автоматического деплоя
- [ ] Мониторинг и аналитика

---

## 📚 Документация

| Файл | Описание |
|------|----------|
| [README.md](./README.md) | Быстрый старт |
| [PROJECT_ARCHITECTURE.md](./PROJECT_ARCHITECTURE.md) | Детальная архитектура (60+ страниц) |
| [ARCHITECTURE_VISUAL.md](./ARCHITECTURE_VISUAL.md) | Визуальные схемы |
| [TESTING.md](./TESTING.md) | Руководство по тестированию |
| [CI_CD_SETUP.md](./CI_CD_SETUP.md) | Настройка CI/CD |
| [CREDENTIALS.md](./CREDENTIALS.md) | Доступы и учётные данные |

---

## 📞 Контакты

- **GitHub**: [ecodrug](https://github.com/YOUR_USERNAME/ecodrug)
- **Email**: support@ecodrug.ru (TODO)

---

**Последнее обновление**: 4 декабря 2025  
**Версия**: 1.0.0  
**Статус**: 🟡 В активной разработке (Backend 95%, Frontend 60%)





