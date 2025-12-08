# 🎨 Визуальная архитектура EcoDrug

## 📊 Общая схема системы

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                    ПОЛЬЗОВАТЕЛЬСКИЙ СЛОЙ                          ┃
┃  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           ┃
┃  │   Flutter    │  │   Flutter    │  │   Flutter    │           ┃
┃  │     Web      │  │     iOS      │  │   Android    │           ┃
┃  └──────────────┘  └──────────────┘  └──────────────┘           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                                │
                            REST API
                                │
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                         API GATEWAY                               ┃
┃                   Express.js + Node.js                            ┃
┃                     (Port 5000/3000)                              ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
           │              │              │              │
       ┌───────┐     ┌────────┐    ┌────────┐    ┌─────────┐
       │ Auth  │     │Profile │    │ News   │    │ Events  │
       │Routing│     │Routing │    │Routing │    │ Routing │
       └───────┘     └────────┘    └────────┘    └─────────┘
           │              │              │              │
       ┌───────┐     ┌────────┐    ┌────────┐    ┌─────────┐
       │ Auth  │     │Profile │    │ News   │    │ Event   │
       │Ctrl   │     │ Ctrl   │    │ Ctrl   │    │  Ctrl   │
       └───────┘     └────────┘    └────────┘    └─────────┘
           │              │              │              │
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                      DATABASE LAYER                               ┃
┃                    MongoDB (Port 27017)                           ┃
┃  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   ┃
┃  │  users  │ │profiles │ │  news   │ │ events  │ │ courses │   ┃
┃  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘   ┃
┃  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐               ┃
┃  │achieve- │ │challeng-│ │recycling│ │notifica-│               ┃
┃  │ ments   │ │   es    │ │ points  │ │ tions   │               ┃
┃  └─────────┘ └─────────┘ └─────────┘ └─────────┘               ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 🏗️ Backend MVC Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         HTTP REQUEST                             │
│                    (Client → Server)                             │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                        MIDDLEWARE CHAIN                          │
├─────────────────────────────────────────────────────────────────┤
│  1. CORS           → Allow origins                              │
│  2. Body Parser    → Parse JSON                                 │
│  3. Auth           → Verify JWT token (if protected)            │
│  4. Validation     → Validate request data                      │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                          ROUTES LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  /api/auth         → Auth routes                                │
│  /api/profile      → Profile routes                             │
│  /api/news         → News routes                                │
│  /api/events       → Events routes                              │
│  /api/education    → Education routes                           │
│  /api/achievements → Achievements routes                        │
│  /api/challenges   → Challenges routes                          │
│  /api/recycling-points → Recycling routes                       │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                      CONTROLLERS LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  • Business Logic                                               │
│  • Request validation                                           │
│  • Call Model methods                                           │
│  • Format responses                                             │
│  • Error handling (try-catch)                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                        MODELS LAYER (ODM)                        │
├─────────────────────────────────────────────────────────────────┤
│  • Mongoose Schemas                                             │
│  • Validation rules                                             │
│  • Indexes                                                      │
│  • Pre/Post hooks                                               │
│  • Instance/Static methods                                      │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                          MONGODB                                 │
├─────────────────────────────────────────────────────────────────┤
│  • Collections                                                  │
│  • Indexes (B-tree, 2dsphere)                                   │
│  • Aggregation pipeline                                         │
│  • Transactions (if needed)                                     │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                         HTTP RESPONSE                            │
│              { success: true/false, data: {...} }               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📱 Frontend Provider Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                            SCREENS                               │
├─────────────────────────────────────────────────────────────────┤
│  LoginScreen, RegisterScreen, ProfileScreen, NewsFeedScreen,    │
│  EventsScreen, CoursesScreen, MapScreen, AchievementsScreen     │
│                                                                  │
│  • Build UI                                                     │
│  • Listen to Providers (Consumer/Provider.of)                   │
│  • Call Provider methods on user actions                        │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                          PROVIDERS                               │
├─────────────────────────────────────────────────────────────────┤
│  AuthProvider, ProfileProvider, NewsProvider, EventsProvider    │
│                                                                  │
│  • State management (extends ChangeNotifier)                    │
│  • Call Services                                                │
│  • Update state + notifyListeners()                             │
│  • Handle loading/error states                                  │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                          SERVICES                                │
├─────────────────────────────────────────────────────────────────┤
│  AuthService, ProfileService, NewsService, EducationService,    │
│  MapService, UploadService                                      │
│                                                                  │
│  • HTTP requests (GET, POST, PUT, DELETE)                       │
│  • Add JWT token to headers                                     │
│  • Parse responses                                              │
│  • Throw exceptions on errors                                   │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                          MODELS                                  │
├─────────────────────────────────────────────────────────────────┤
│  User, Profile, News, Event, Course, Achievement, RecyclingPoint│
│                                                                  │
│  • Data classes                                                 │
│  • fromJson() factory constructors                              │
│  • toJson() methods                                             │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                      LOCAL STORAGE                               │
├─────────────────────────────────────────────────────────────────┤
│  SharedPreferences (Web: localStorage, Mobile: native prefs)    │
│                                                                  │
│  • Store JWT token                                              │
│  • Store user preferences                                       │
│  • Cache data                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔒 Security Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                        USER LOGIN                                 │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  POST /api/auth/login                                            │
│  Body: { email, password }                                       │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  Backend: authController.login()                                 │
│    1. Find user by email                                         │
│    2. Compare password with bcrypt                               │
│    3. If valid → generate JWT token                              │
│    4. Return { user, token }                                     │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  Frontend: AuthProvider saves token                              │
│    - StorageService.saveToken(token)                             │
│    - Store in localStorage/SharedPreferences                     │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│             AUTHENTICATED REQUEST                                │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  GET /api/profile/me                                             │
│  Headers: { Authorization: Bearer <token> }                      │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  Middleware: auth.js                                             │
│    1. Extract token from header                                  │
│    2. Verify token with jwt.verify(token, JWT_SECRET)            │
│    3. Decode user ID from token                                  │
│    4. Attach req.user = { userId, role }                         │
│    5. If invalid → 401 Unauthorized                              │
└──────────────────────────────────────────────────────────────────┘
                                ↓
┌──────────────────────────────────────────────────────────────────┐
│  Controller: profileController.getMyProfile()                    │
│    - Use req.user.userId to fetch profile                        │
│    - Return profile data                                         │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Schema Relationships

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│     User     │ 1     1 │   Profile    │ *     * │ Achievement  │
│──────────────│◄────────┤──────────────│◄────────┤──────────────│
│ _id          │         │ userId  (FK) │         │ _id          │
│ email        │         │ firstName    │         │ name         │
│ password     │         │ lastName     │         │ description  │
│ username     │         │ ecoPoints    │         │ points       │
│ role         │         │ level        │         │ icon         │
└──────────────┘         │ achievements │         └──────────────┘
                         └──────────────┘
                                │
                         ┌──────┴──────┐
                         │             │
                    * ┌──▼───────┐ * ┌─▼──────────┐
                      │  Course  │   │   Event    │
                      │──────────│   │────────────│
                      │ _id      │   │ _id        │
                      │ title    │   │ title      │
                      │ enrolled │   │ registered │
                      │   Users  │   │   Users    │
                      └──────────┘   └────────────┘
                           │
                       1   │
                           │
                      ┌────▼─────┐
                      │   Quiz   │
                      │──────────│
                      │ _id      │
                      │ courseId │
                      │ questions│
                      └──────────┘

┌──────────────┐         ┌──────────────┐
│     News     │ *     1 │     User     │
│──────────────│◄────────┤ (author)     │
│ _id          │         └──────────────┘
│ title        │
│ content      │
│ author (FK)  │
│ likes [FK]   │
│ comments [{  │
│   userId(FK) │
│   text       │
│ }]           │
└──────────────┘

┌───────────────────┐     ┌──────────────┐
│  RecyclingPoint   │  *  │Organization  │
│───────────────────│     │──────────────│
│ _id               │     │ _id          │
│ name              │     │ name         │
│ location (geo)    │     │ description  │
│ wasteTypes []     │     │ isVerified   │
│ reviews [{        │     └──────────────┘
│   userId (FK)     │            │
│   rating          │            │ 1
│ }]                │            │
└───────────────────┘     ┌──────▼───────┐
                          │    Event     │
                          │──────────────│
                          │ organizer(FK)│
                          └──────────────┘
```

---

## 🔄 Data Flow Example: Like a News Post

```
┌────────────────────────────────────────────────────────────────────┐
│  USER ACTION: Click "Like" button on news card                    │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  FRONTEND: NewsProvider.likeNews(newsId)                          │
│    • Set loading state                                            │
│    • Call NewsService.likeNews(newsId)                            │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  SERVICE: NewsService.likeNews(newsId)                            │
│    • POST /api/news/:id/like                                      │
│    • Headers: { Authorization: Bearer <token> }                   │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  BACKEND MIDDLEWARE: auth.js                                      │
│    • Verify JWT token                                             │
│    • Extract userId from token                                    │
│    • Add to req.user                                              │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  BACKEND ROUTES: /api/news/:id/like → newsController.likeNews     │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  CONTROLLER: newsController.likeNews(req, res)                    │
│    1. Get newsId from req.params                                  │
│    2. Get userId from req.user                                    │
│    3. Find news by ID                                             │
│    4. Check if already liked                                      │
│    5. If liked → remove from likes array                          │
│       If not → add to likes array                                 │
│    6. Save updated news                                           │
│    7. Return { success: true, data: updatedNews }                 │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  MONGODB: Update operation                                        │
│    db.news.updateOne(                                             │
│      { _id: newsId },                                             │
│      { $addToSet: { likes: userId } }  // or $pull to remove      │
│    )                                                              │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  RESPONSE TO FRONTEND                                             │
│    { success: true, data: { ...updatedNews } }                    │
└────────────────────────────────────────────────────────────────────┘
                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│  FRONTEND: NewsProvider updates state                             │
│    • Update news item in list                                     │
│    • notifyListeners()                                            │
│    • UI re-renders with new like status                           │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Модульная структура проекта

```
ecodrug/
│
├── 🔧 backend/                      # Node.js + Express + MongoDB
│   ├── config/                     # Конфигурации (DB, env)
│   ├── controllers/                # Бизнес-логика (8 контроллеров)
│   ├── middleware/                 # Auth, validation, errors, upload
│   ├── models/                     # Mongoose схемы (11 моделей)
│   ├── routes/                     # API endpoints (8 роутов)
│   ├── scripts/                    # Утилиты и seed-скрипты
│   ├── tests/                      # Unit + Integration тесты
│   ├── uploads/                    # Загруженные файлы (аватары)
│   ├── utils/                      # Вспомогательные функции
│   ├── server.js                   # ✅ Точка входа
│   ├── package.json                # ✅ Зависимости
│   └── .env                        # Переменные окружения
│
├── 📱 frontend/                     # Flutter Web/Mobile
│   ├── lib/
│   │   ├── config/                 # Константы (API URL)
│   │   ├── models/                 # Dart классы (7 моделей)
│   │   ├── providers/              # State management (4 провайдера)
│   │   ├── screens/                # UI экраны (7 экранов)
│   │   ├── services/               # HTTP клиенты (8 сервисов)
│   │   ├── utils/                  # Валидаторы, helpers
│   │   ├── widgets/                # Переиспользуемые UI (10+ виджетов)
│   │   └── main.dart               # ✅ Точка входа
│   ├── assets/                     # Изображения, иконки, шрифты
│   ├── test/                       # Тесты (widget, model, service)
│   ├── pubspec.yaml                # ✅ Зависимости
│   └── README.md
│
├── 🐳 DevOps/
│   ├── docker-compose.yml          # ✅ Оркестрация контейнеров
│   ├── Dockerfile (backend)        # ✅ Backend образ
│   ├── Dockerfile (frontend)       # ✅ Frontend образ
│   ├── Makefile                    # ✅ Автоматизация команд
│   └── .github/workflows/
│       └── test.yml                # ✅ CI/CD pipeline
│
└── 📚 Documentation/
    ├── README.md                   # Основная документация
    ├── PROJECT_ARCHITECTURE.md     # 📄 Этот файл (детальная архитектура)
    ├── ARCHITECTURE_VISUAL.md      # 🎨 Визуальные схемы
    ├── TESTING.md                  # Руководство по тестированию
    ├── CI_CD_SETUP.md              # Настройка CI/CD
    ├── CHANGES_SUMMARY.md          # История изменений
    ├── CREDENTIALS.md              # Доступы и учётные данные
    └── *.md                        # Другие документы
```

---

## 🎯 Основные фичи по модулям

### 1️⃣ Authorization (Авторизация) - ✅ 100%
- Регистрация с email/password
- Вход (JWT токен)
- Хеширование паролей (bcrypt)
- Проверка токена на защищённых маршрутах

### 2️⃣ Profile (Профиль) - ✅ 100%
- Просмотр и редактирование профиля
- Загрузка аватара
- Баллы (ecoPoints) и уровень (level)
- Таблица лидеров (leaderboard)
- Список достижений

### 3️⃣ Education (Образование) - ⚠️ 85%
- Список курсов с фильтрацией
- Запись на курс
- Прохождение модулей
- Тесты (quizzes) с автоматической проверкой
- Отзывы и рейтинги
- **TODO**: Frontend экраны для курсов

### 4️⃣ News (Новости) - ✅ 90%
- Лента новостей с изображениями
- Лайки и комментарии
- Модерация контента
- Категории и теги
- Детальный просмотр
- **TODO**: Создание новостей через UI

### 5️⃣ Events (События) - ⚠️ 85%
- Календарь событий
- Регистрация на событие
- Отметка посещения (баллы)
- Онлайн/оффлайн формат
- Ограничение по вместимости
- **TODO**: Frontend экраны для событий

### 6️⃣ Map (Карта) - ⚠️ 85%
- Пункты переработки
- Геопоиск (ближайшие пункты)
- Фильтрация по типам отходов
- Отзывы и рейтинги
- **TODO**: Интерактивная карта (flutter_map)

### 7️⃣ Gamification (Геймификация) - ⚠️ 80%
- Достижения (achievements)
- Челленджи (challenges)
- Баллы за активность
- Уровни пользователей
- **TODO**: Frontend экраны достижений и челленджей

### 8️⃣ Notifications (Уведомления) - ⚠️ 30%
- Модель создана
- **TODO**: Push-уведомления (FCM)
- **TODO**: Email-уведомления

### 9️⃣ Organizations (Организации) - ⚠️ 30%
- Модель создана
- **TODO**: Верификация организаций
- **TODO**: CRUD API

### 🔟 Admin Panel (Админка) - ❌ 0%
- **TODO**: Модерация контента
- **TODO**: Управление пользователями
- **TODO**: Статистика

---

## 🚀 Deployment Architecture (Planned)

```
┌────────────────────────────────────────────────────────────────────┐
│                         USERS / CLIENTS                            │
│              (Web browsers, iOS, Android apps)                     │
└────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ HTTPS
                                  ▼
┌────────────────────────────────────────────────────────────────────┐
│                          CDN / LOAD BALANCER                       │
│                    (Cloudflare / Nginx / AWS ALB)                  │
└────────────────────────────────────────────────────────────────────┘
                    │                              │
           ┌────────┴────────┐          ┌─────────┴─────────┐
           │                 │          │                   │
           ▼                 ▼          ▼                   ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  Flutter Web     │  │   Flutter iOS    │  │  Flutter Android │
│  (Static files)  │  │   (App Store)    │  │  (Google Play)   │
│                  │  │                  │  │                  │
│  Vercel/Netlify  │  │  TestFlight →    │  │  Internal Test → │
│  Firebase Hosting│  │  Production      │  │  Production      │
└──────────────────┘  └──────────────────┘  └──────────────────┘
                                  │
                                  │ REST API (HTTPS)
                                  ▼
┌────────────────────────────────────────────────────────────────────┐
│                          API SERVER                                │
│                   (Node.js + Express backend)                      │
│                                                                    │
│  AWS EC2 / DigitalOcean Droplet / Yandex Cloud VM                 │
│  • Docker container                                               │
│  • PM2 process manager                                            │
│  • Nginx reverse proxy                                            │
│  • SSL (Let's Encrypt)                                            │
└────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ MongoDB Connection
                                  ▼
┌────────────────────────────────────────────────────────────────────┐
│                        DATABASE SERVER                             │
│                         MongoDB Atlas                              │
│                                                                    │
│  • Managed MongoDB cluster                                        │
│  • Automatic backups                                              │
│  • Replica sets                                                   │
│  • Geo-redundancy                                                 │
└────────────────────────────────────────────────────────────────────┘

         ┌────────────────────────────────────────┐
         │          MONITORING & LOGGING          │
         ├────────────────────────────────────────┤
         │  • Sentry (error tracking)             │
         │  • Google Analytics / Yandex Metrica   │
         │  • CloudWatch / Grafana (metrics)      │
         │  • ELK Stack (logs aggregation)        │
         └────────────────────────────────────────┘
```

---

**Дата создания**: 4 декабря 2025  
**Версия**: 1.0.0




