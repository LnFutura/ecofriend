# 🏗️ Архитектура проекта EcoDrug

> **Версия**: 1.0.0  
> **Дата**: 4 декабря 2025  
> **Статус**: В активной разработке

---

## 📋 Содержание

1. [Обзор проекта](#обзор-проекта)
2. [Технологический стек](#технологический-стек)
3. [Архитектура системы](#архитектура-системы)
4. [Backend архитектура](#backend-архитектура)
5. [Frontend архитектура](#frontend-архитектура)
6. [База данных](#база-данных)
7. [API структура](#api-структура)
8. [Безопасность](#безопасность)
9. [Текущий статус реализации](#текущий-статус-реализации)
10. [Дорожная карта](#дорожная-карта)

---

## 🎯 Обзор проекта

**ЭкоДруг (EcoDrug)** — это универсальное мобильное приложение для формирования экологически ответственного поведения граждан.

### Основные возможности

- 📰 **Экологические новости** — лента новостей с модерацией
- 📅 **Афиша мероприятий** — календарь экологических событий
- 🗺️ **Интерактивная карта** — пункты сбора и переработки отходов с геопоиском
- 📚 **Образование** — курсы, статьи, тесты, видеоматериалы
- 🏆 **Геймификация** — баллы, достижения, уровни, челленджи
- 👥 **Профили организаций** — НКО и эко-компании
- 🎖️ **Рейтинги** — таблица лидеров пользователей

### Целевая аудитория

- Граждане, интересующиеся экологией
- Эко-активисты
- Студенты и волонтёры
- НКО и экологические компании

---

## 💻 Технологический стек

### Backend

| Технология | Версия | Назначение |
|------------|--------|------------|
| **Node.js** | 18/20 | Runtime environment |
| **Express.js** | 4.18 | Web framework |
| **MongoDB** | 7.0 | NoSQL база данных |
| **Mongoose** | 8.0 | ODM для MongoDB |
| **JWT** | 9.0 | Аутентификация |
| **bcryptjs** | 2.4 | Хеширование паролей |
| **Jest** | 29.7 | Тестирование |
| **Multer** | 1.4 | Загрузка файлов |

### Frontend

| Технология | Версия | Назначение |
|------------|--------|------------|
| **Flutter** | 3.16+ | UI framework |
| **Dart** | 3.0+ | Язык программирования |
| **Provider** | 6.1 | State management |
| **HTTP** | 1.1 | HTTP client |
| **SharedPreferences** | 2.2 | Локальное хранилище |
| **flutter_map** | 6.1 | Карты |
| **flutter_svg** | 2.0 | SVG иконки |
| **image_picker** | 1.0 | Выбор изображений |

### DevOps & CI/CD

- **Docker** — контейнеризация
- **Docker Compose** — оркестрация
- **GitHub Actions** — CI/CD pipeline
- **Makefile** — автоматизация задач

---

## 🏛️ Архитектура системы

### Общая схема

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│                 │         │                 │         │                 │
│  Flutter Web/   │ ◄─────► │   Express.js    │ ◄─────► │    MongoDB      │
│  Mobile App     │  REST   │   API Server    │   ODM   │    Database     │
│                 │   API   │                 │ Mongoose│                 │
└─────────────────┘         └─────────────────┘         └─────────────────┘
      Frontend                     Backend                  Data Layer
```

### Компонентная архитектура

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│  (Screens, Widgets, UI Components)                          │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    State Management Layer                    │
│  (Providers - AuthProvider, ProfileProvider, NewsProvider)  │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│  (API Services - Auth, Profile, News, Education, Map)       │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Network Layer                          │
│  (HTTP Client, Token Management, Error Handling)            │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Backend API Layer                       │
│  (Routes, Controllers, Middleware)                          │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                      │
│  (Controllers - Auth, Profile, News, Education, etc.)       │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Access Layer                       │
│  (MongoDB Models - User, Profile, News, Event, etc.)        │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Database Layer                         │
│  (MongoDB - Collections, Indexes, Aggregations)             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 Backend архитектура

### Структура проекта

```
backend/
├── config/
│   └── db.js                    # MongoDB connection
├── controllers/
│   ├── authController.js        # ✅ Регистрация, вход, получение пользователя
│   ├── profileController.js     # ✅ CRUD профиля, баллы, лидерборд
│   ├── achievementController.js # ✅ Достижения, разблокировка
│   ├── challengeController.js   # ✅ Челленджи, участие, прогресс
│   ├── educationController.js   # ✅ Курсы, тесты, прохождение
│   ├── newsController.js        # ✅ Новости, лайки, комментарии
│   ├── eventController.js       # ✅ События, регистрация, календарь
│   └── recyclingController.js   # ✅ Пункты переработки, геопоиск
├── middleware/
│   ├── auth.js                  # ✅ JWT верификация
│   ├── validation.js            # ✅ Валидация запросов
│   ├── errorHandler.js          # ✅ Централизованная обработка ошибок
│   └── upload.js                # ✅ Загрузка файлов (Multer)
├── models/
│   ├── User.js                  # ✅ Пользователь (email, пароль, роль)
│   ├── Profile.js               # ✅ Профиль (баллы, уровень, достижения)
│   ├── Achievement.js           # ✅ Достижения
│   ├── Challenge.js             # ✅ Челленджи
│   ├── Course.js                # ✅ Образовательные курсы
│   ├── Quiz.js                  # ✅ Тесты к курсам
│   ├── News.js                  # ✅ Новости
│   ├── Event.js                 # ✅ События
│   ├── RecyclingPoint.js        # ✅ Пункты переработки (с geo-индексом)
│   ├── Notification.js          # ✅ Уведомления
│   └── Organization.js          # ✅ Организации
├── routes/
│   ├── auth.js                  # ✅ /api/auth
│   ├── profile.js               # ✅ /api/profile
│   ├── achievement.js           # ✅ /api/achievements
│   ├── challenge.js             # ✅ /api/challenges
│   ├── education.js             # ✅ /api/education
│   ├── news.js                  # ✅ /api/news
│   ├── event.js                 # ✅ /api/events
│   └── recycling.js             # ✅ /api/recycling-points
├── scripts/
│   ├── createAdmin.js           # Создание админа
│   ├── createTestUsers.js       # Создание тестовых пользователей
│   ├── seedNews.js              # ✅ Seed данных для новостей
│   └── resetAllPasswords.js     # Сброс паролей
├── tests/
│   ├── unit/                    # ✅ Unit тесты (17 тестов)
│   └── integration/             # ✅ Integration тесты (15 тестов)
├── utils/
│   ├── generateToken.js         # JWT token generation
│   └── sendEmail.js             # Email отправка
├── uploads/                     # Загруженные файлы
│   └── avatars/                 # Аватары пользователей
├── .env                         # Переменные окружения
├── server.js                    # ✅ Точка входа
├── package.json                 # ✅ Зависимости
└── jest.config.js               # ✅ Конфигурация Jest
```

### MVC паттерн

#### 1. **Models (Модели)**
- Определяют схемы MongoDB через Mongoose
- Содержат валидацию на уровне схемы
- Включают индексы для оптимизации запросов
- Реализуют методы модели (статические и инстанс методы)

**Пример: User.js**
```javascript
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  username: { type: String, required: true },
  role: { type: String, enum: ['user', 'organization', 'moderator', 'admin'] }
}, { timestamps: true });

// Pre-save hook для хеширования пароля
userSchema.pre('save', async function(next) {
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 10);
  }
  next();
});
```

#### 2. **Controllers (Контроллеры)**
- Обрабатывают бизнес-логику
- Взаимодействуют с моделями
- Возвращают единообразные ответы

**Структура ответа:**
```javascript
// Success
{
  success: true,
  data: { ... },
  message: "Operation successful"
}

// Error
{
  success: false,
  error: "Error message",
  message: "User-friendly message"
}
```

#### 3. **Routes (Маршруты)**
- Определяют API endpoints
- Применяют middleware (auth, validation)
- Вызывают методы контроллеров

**Пример: auth.js**
```javascript
router.post('/register', [
  body('email').isEmail(),
  body('password').isLength({ min: 6 })
], authController.register);

router.post('/login', authController.login);
router.get('/me', auth, authController.getMe);
```

### Middleware

#### Auth Middleware (`auth.js`)
```javascript
// Верификация JWT токена
// Добавляет req.user с данными пользователя
// Используется на всех защищённых маршрутах
```

#### Validation Middleware (`validation.js`)
```javascript
// Express-validator для проверки входных данных
// Email, пароли, required поля
```

#### Error Handler (`errorHandler.js`)
```javascript
// Централизованная обработка ошибок
// Логирование и правильные HTTP статусы
```

#### Upload Middleware (`upload.js`)
```javascript
// Multer для загрузки файлов
// Аватары, изображения для новостей
// Ограничение размера и типов файлов
```

---

## 📱 Frontend архитектура

### Структура проекта

```
frontend/
├── lib/
│   ├── config/
│   │   └── constants.dart       # ✅ API URLs, константы
│   ├── models/
│   │   ├── user.dart           # ✅ User модель
│   │   ├── profile.dart        # ✅ Profile модель
│   │   ├── achievement.dart    # ✅ Achievement модель
│   │   ├── course.dart         # ✅ Course модель
│   │   ├── news.dart           # ✅ News модель
│   │   ├── event.dart          # ✅ Event модель
│   │   └── recycling_point.dart # ✅ RecyclingPoint модель
│   ├── providers/
│   │   ├── auth_provider.dart   # ✅ Авторизация state
│   │   ├── profile_provider.dart # ✅ Профиль state
│   │   ├── news_provider.dart   # ✅ Новости state
│   │   └── theme_provider.dart  # ✅ Тема приложения
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart    # ✅ Экран входа
│   │   │   └── register_screen.dart # ✅ Экран регистрации
│   │   ├── profile/
│   │   │   └── profile_screen.dart  # ✅ Экран профиля
│   │   ├── news/
│   │   │   ├── news_feed_screen.dart   # ✅ Лента новостей
│   │   │   └── news_detail_screen.dart # ✅ Детали новости
│   │   ├── courses/
│   │   │   └── courses_screen.dart  # ✅ Список курсов
│   │   └── welcome_screen.dart      # ✅ Приветственный экран
│   ├── services/
│   │   ├── api_service.dart         # ✅ Базовый HTTP client
│   │   ├── auth_service.dart        # ✅ Авторизация API
│   │   ├── profile_service.dart     # ✅ Профиль API
│   │   ├── news_service.dart        # ✅ Новости API
│   │   ├── education_service.dart   # ✅ Образование API
│   │   ├── map_service.dart         # ✅ Карта API
│   │   ├── storage_service.dart     # ✅ Локальное хранилище
│   │   └── upload_service.dart      # ✅ Загрузка файлов
│   ├── utils/
│   │   ├── validators.dart      # ✅ Валидаторы форм
│   │   └── constants.dart       # ✅ Константы приложения
│   ├── widgets/
│   │   ├── custom_button.dart       # ✅ Кнопка
│   │   ├── custom_text_field.dart   # ✅ Поле ввода
│   │   ├── loading_indicator.dart   # ✅ Индикатор загрузки
│   │   ├── profile/
│   │   │   ├── avatar_widget.dart       # ✅ Аватар
│   │   │   ├── stats_card.dart          # ✅ Карточка статистики
│   │   │   └── achievements_widget.dart # ✅ Достижения
│   │   └── bottom_nav.dart          # ✅ Нижняя навигация
│   └── main.dart                    # ✅ Точка входа
├── assets/
│   ├── fonts/                   # Neucha шрифт
│   ├── icons/                   # SVG иконки
│   ├── images/                  # Изображения
│   └── screens/                 # Скриншоты дизайна Figma
├── test/
│   ├── widget_test.dart         # ✅ UI тесты
│   ├── models_test.dart         # ✅ Тесты моделей
│   └── services_test.dart       # ✅ Тесты сервисов
├── pubspec.yaml                 # ✅ Зависимости
└── README.md
```

### Архитектурный паттерн: Provider

#### 1. **Models (Модели)**
Dart классы для представления данных с JSON сериализацией:

```dart
class User {
  final String id;
  final String email;
  final String username;
  
  User({required this.id, required this.email, required this.username});
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'],
    email: json['email'],
    username: json['username'],
  );
  
  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'username': username,
  };
}
```

#### 2. **Services (Сервисы)**
HTTP клиенты для взаимодействия с API:

```dart
class AuthService {
  static const String baseUrl = '${ApiConstants.baseUrl}/auth';
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }
}
```

#### 3. **Providers (Провайдеры)**
State management с ChangeNotifier:

```dart
class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _authService.login(email, password);
      _user = User.fromJson(response['data']['user']);
      await StorageService.saveToken(response['data']['token']);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### 4. **Screens (Экраны)**
UI с использованием Provider:

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return LoadingIndicator();
        }
        
        return Scaffold(
          body: LoginForm(
            onSubmit: (email, password) {
              authProvider.login(email, password);
            },
          ),
        );
      },
    );
  }
}
```

#### 5. **Widgets (Виджеты)**
Переиспользуемые UI компоненты:

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

### Навигация

```dart
MaterialApp(
  initialRoute: '/welcome',
  routes: {
    '/welcome': (context) => WelcomeScreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
    '/profile': (context) => ProfileScreen(),
    '/news': (context) => NewsFeedScreen(),
    '/courses': (context) => CoursesScreen(),
  },
);
```

---

## 🗄️ База данных

### MongoDB структура

```
ecodrug (database)
├── users                    # Пользователи
├── profiles                 # Профили пользователей
├── achievements             # Достижения
├── challenges               # Челленджи
├── courses                  # Курсы
├── quizzes                  # Тесты
├── news                     # Новости
├── events                   # События
├── recyclingpoints          # Пункты переработки
├── notifications            # Уведомления
└── organizations            # Организации
```

### Основные модели

#### User (Пользователь)
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed, required),
  username: String (required),
  role: String (enum: ['user', 'organization', 'moderator', 'admin']),
  isVerified: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: `email`, `username`, `role`

#### Profile (Профиль)
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: 'User', unique),
  firstName: String,
  lastName: String,
  avatar: String (URL),
  bio: String,
  city: String,
  ecoPoints: Number (default: 0),
  level: Number (default: 1),
  achievements: [ObjectId] (ref: 'Achievement'),
  completedCourses: [ObjectId] (ref: 'Course'),
  attendedEvents: [ObjectId] (ref: 'Event'),
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: `userId`, `ecoPoints` (для leaderboard)

#### Achievement (Достижение)
```javascript
{
  _id: ObjectId,
  name: String (required),
  description: String,
  icon: String (URL),
  category: String (enum: ['education', 'events', 'recycling', 'social', 'other']),
  points: Number (required),
  condition: {
    type: String (enum: ['course_complete', 'event_attend', 'points_reach', 'custom']),
    value: Number
  },
  isActive: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

#### Course (Курс)
```javascript
{
  _id: ObjectId,
  title: String (required),
  description: String,
  category: String (enum: ['recycling', 'energy', 'water', 'biodiversity', 'climate', 'general']),
  difficulty: String (enum: ['beginner', 'intermediate', 'advanced']),
  duration: Number (minutes),
  points: Number (award for completion),
  coverImage: String (URL),
  modules: [{
    title: String,
    content: String,
    videoUrl: String,
    resources: [String]
  }],
  quiz: ObjectId (ref: 'Quiz'),
  enrolledUsers: [ObjectId] (ref: 'User'),
  reviews: [{
    userId: ObjectId,
    rating: Number (1-5),
    comment: String,
    createdAt: Date
  }],
  isPublished: Boolean,
  createdBy: ObjectId (ref: 'User'),
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: `category`, `difficulty`, `isPublished`

#### News (Новость)
```javascript
{
  _id: ObjectId,
  title: String (required),
  excerpt: String,
  content: String (required),
  coverImage: String (URL),
  category: String (enum: ['news', 'article', 'guide', 'event_report', 'research']),
  tags: [String],
  author: ObjectId (ref: 'User', required),
  status: String (enum: ['draft', 'pending', 'approved', 'rejected']),
  likes: [ObjectId] (ref: 'User'),
  comments: [{
    userId: ObjectId,
    text: String,
    createdAt: Date
  }],
  views: Number (default: 0),
  publishedAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: `category`, `status`, `publishedAt`, `tags`

#### Event (Событие)
```javascript
{
  _id: ObjectId,
  title: String (required),
  description: String (required),
  type: String (enum: ['cleanup', 'workshop', 'conference', 'webinar', 'tree_planting', 'other']),
  startDate: Date (required),
  endDate: Date,
  location: {
    address: String,
    city: String,
    coordinates: {
      type: { type: String, default: 'Point' },
      coordinates: [Number] // [longitude, latitude]
    }
  },
  isOnline: Boolean,
  onlineLink: String,
  capacity: Number,
  registeredUsers: [ObjectId] (ref: 'User'),
  attendedUsers: [ObjectId] (ref: 'User'),
  points: Number (award for attendance),
  coverImage: String (URL),
  organizer: ObjectId (ref: 'Organization'),
  status: String (enum: ['draft', 'published', 'cancelled', 'completed']),
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: `startDate`, `type`, `status`, геоиндекс на `location.coordinates`

#### RecyclingPoint (Пункт переработки)
```javascript
{
  _id: ObjectId,
  name: String (required),
  description: String,
  address: String (required),
  city: String (required),
  location: {
    type: { type: String, default: 'Point' },
    coordinates: [Number] // [longitude, latitude]
  },
  wasteTypes: [String] (enum: ['plastic', 'paper', 'glass', 'metal', 'electronics', 'batteries', 'clothes', 'hazardous', 'organic']),
  workingHours: {
    monday: String,
    tuesday: String,
    // ... other days
  },
  phone: String,
  website: String,
  isVerified: Boolean,
  photos: [String] (URLs),
  rating: Number (1-5),
  reviews: [{
    userId: ObjectId,
    rating: Number,
    comment: String,
    createdAt: Date
  }],
  addedBy: ObjectId (ref: 'User'),
  createdAt: Date,
  updatedAt: Date
}
```

**Индексы**: Геоиндекс `2dsphere` на `location`, `city`, `wasteTypes`, `isVerified`

---

## 🔌 API структура

### Базовый URL
```
Development: http://localhost:5000/api
Production: https://api.ecodrug.ru/api
```

### Endpoints по модулям

#### 1. Authentication (`/api/auth`)
```
POST   /api/auth/register      # Регистрация
POST   /api/auth/login         # Вход
GET    /api/auth/me            # Получить текущего пользователя (auth required)
```

#### 2. Profile (`/api/profile`)
```
GET    /api/profile/me         # Получить свой профиль (auth)
GET    /api/profile/:id        # Получить профиль по ID
PUT    /api/profile            # Обновить профиль (auth)
POST   /api/profile/avatar     # Загрузить аватар (auth, multipart)
POST   /api/profile/points     # Добавить баллы (auth)
GET    /api/profile/leaderboard # Таблица лидеров
```

#### 3. Achievements (`/api/achievements`)
```
GET    /api/achievements           # Все достижения
GET    /api/achievements/user/:id  # Достижения пользователя
POST   /api/achievements/:id/unlock # Разблокировать достижение (auth)
GET    /api/achievements/:id       # Одно достижение
POST   /api/achievements           # Создать достижение (admin)
PUT    /api/achievements/:id       # Обновить достижение (admin)
DELETE /api/achievements/:id       # Удалить достижение (admin)
```

#### 4. Challenges (`/api/challenges`)
```
GET    /api/challenges             # Все активные челленджи
GET    /api/challenges/:id         # Один челлендж
POST   /api/challenges/:id/join    # Присоединиться к челленджу (auth)
POST   /api/challenges/:id/progress # Обновить прогресс (auth)
GET    /api/challenges/my          # Мои челленджи (auth)
POST   /api/challenges             # Создать челлендж (admin)
PUT    /api/challenges/:id         # Обновить челлендж (admin)
```

#### 5. Education (`/api/education`)
```
GET    /api/education/courses          # Все курсы
GET    /api/education/courses/:id      # Один курс
POST   /api/education/courses/:id/enroll # Записаться на курс (auth)
GET    /api/education/courses/my       # Мои курсы (auth)
POST   /api/education/courses/:id/complete # Завершить курс (auth)
POST   /api/education/courses/:id/review   # Оставить отзыв (auth)
POST   /api/education/quizzes/:id/submit   # Отправить ответы на тест (auth)
GET    /api/education/quizzes/:id          # Получить тест
POST   /api/education/courses              # Создать курс (admin)
PUT    /api/education/courses/:id          # Обновить курс (admin)
```

#### 6. News (`/api/news`)
```
GET    /api/news               # Все одобренные новости
GET    /api/news/:id           # Одна новость
POST   /api/news/:id/like      # Лайкнуть новость (auth)
POST   /api/news/:id/comment   # Комментировать (auth)
GET    /api/news/my            # Мои новости (auth)
POST   /api/news               # Создать новость (auth)
PUT    /api/news/:id           # Обновить новость (auth, own)
DELETE /api/news/:id           # Удалить новость (auth, own or admin)
PUT    /api/news/:id/moderate  # Модерировать новость (moderator)
```

#### 7. Events (`/api/events`)
```
GET    /api/events                 # Все опубликованные события
GET    /api/events/:id             # Одно событие
POST   /api/events/:id/register    # Зарегистрироваться (auth)
POST   /api/events/:id/attend      # Отметить посещение (auth)
GET    /api/events/calendar        # Календарь событий по месяцам
GET    /api/events/upcoming        # Ближайшие события
GET    /api/events/my              # Мои события (auth)
POST   /api/events                 # Создать событие (organization)
PUT    /api/events/:id             # Обновить событие (organization, own)
DELETE /api/events/:id             # Удалить событие (organization, own or admin)
PUT    /api/events/:id/moderate    # Модерировать событие (moderator)
```

#### 8. Recycling Points (`/api/recycling-points`)
```
GET    /api/recycling-points           # Все пункты
GET    /api/recycling-points/:id       # Один пункт
GET    /api/recycling-points/nearby    # Ближайшие пункты (query: lat, lng, maxDistance)
POST   /api/recycling-points/:id/review # Оставить отзыв (auth)
POST   /api/recycling-points           # Добавить пункт (auth)
PUT    /api/recycling-points/:id       # Обновить пункт (auth, own or admin)
DELETE /api/recycling-points/:id       # Удалить пункт (admin)
PUT    /api/recycling-points/:id/verify # Верифицировать пункт (moderator)
```

### Формат ответов

#### Success Response
```json
{
  "success": true,
  "data": {
    // Actual data
  },
  "message": "Operation successful"
}
```

#### Error Response
```json
{
  "success": false,
  "error": "Technical error message",
  "message": "User-friendly message"
}
```

### HTTP Status Codes
- `200` — OK (успешный GET, PUT, DELETE)
- `201` — Created (успешный POST)
- `400` — Bad Request (валидация не прошла)
- `401` — Unauthorized (не авторизован)
- `403` — Forbidden (нет прав доступа)
- `404` — Not Found (ресурс не найден)
- `500` — Internal Server Error (ошибка сервера)

---

## 🔐 Безопасность

### Аутентификация и авторизация

#### JWT Токены
- Токены генерируются при успешном входе
- Срок действия: **7 дней**
- Хранятся в `localStorage` (Flutter: `SharedPreferences`)
- Передаются в заголовке: `Authorization: Bearer <token>`

#### Хеширование паролей
- Используется **bcrypt** с salt rounds = 10
- Пароли **никогда** не хранятся в открытом виде
- Pre-save hook в модели User автоматически хеширует пароль

#### Защищённые маршруты
```javascript
// Middleware auth проверяет JWT
router.get('/profile/me', auth, profileController.getMyProfile);

// Дополнительная проверка роли
router.post('/news/:id/moderate', auth, roleCheck(['moderator', 'admin']), ...);
```

### Роли пользователей

| Роль | Права доступа |
|------|---------------|
| **user** | Базовый пользователь — просмотр, лайки, комментарии, участие в курсах/событиях |
| **organization** | Организация — создание событий, верифицированный профиль |
| **moderator** | Модератор — одобрение новостей, событий, пунктов переработки |
| **admin** | Администратор — полный доступ, создание достижений, челленджей |

### Валидация данных

#### Backend (Express-validator)
```javascript
router.post('/register', [
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('username').trim().notEmpty()
], authController.register);
```

#### Frontend (Validators)
```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email обязателен';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Некорректный email';
  }
  return null;
}
```

### Защита от атак

- **SQL Injection**: MongoDB + Mongoose (NoSQL, параметризованные запросы)
- **XSS**: Sanitization входных данных, escape HTML
- **CSRF**: SameSite cookies, CORS настройки
- **Rate Limiting**: Ограничение запросов на auth endpoints
- **Brute Force**: Блокировка после N неудачных попыток входа (TODO)

### CORS конфигурация

```javascript
app.use(cors({
  origin: [
    'http://localhost:3000',
    'http://localhost:8080',  // Flutter Web
    process.env.CLIENT_URL    // Production URL
  ],
  credentials: true,
}));
```

### Переменные окружения

**Никогда не коммитим `.env` файл!**

```bash
# backend/.env
MONGO_URI=mongodb://admin:admin123@localhost:27017/ecodrug
JWT_SECRET=your_super_secret_key_here_min_32_chars
PORT=5000
NODE_ENV=development
CLIENT_URL=http://localhost:8080
```

---

## ✅ Текущий статус реализации

### Backend: **95% завершено** ✅

| Модуль | Модели | Контроллеры | Routes | Тесты | Статус |
|--------|--------|-------------|--------|-------|--------|
| Auth | ✅ User | ✅ | ✅ | ✅ | 100% |
| Profile | ✅ Profile | ✅ | ✅ | ✅ | 100% |
| Achievements | ✅ | ✅ | ✅ | ⚠️ | 90% |
| Challenges | ✅ | ✅ | ✅ | ⚠️ | 90% |
| Education | ✅ Course, Quiz | ✅ | ✅ | ⚠️ | 85% |
| News | ✅ | ✅ | ✅ | ⚠️ | 90% |
| Events | ✅ | ✅ | ✅ | ⚠️ | 85% |
| Recycling | ✅ RecyclingPoint | ✅ | ✅ | ⚠️ | 85% |
| Notifications | ✅ | ❌ | ❌ | ❌ | 30% |
| Organizations | ✅ | ❌ | ❌ | ❌ | 30% |

**Итого Backend**:
- ✅ **11 моделей MongoDB** готовы
- ✅ **8 контроллеров** реализованы
- ✅ **8 роутов** настроены
- ✅ **54+ API endpoints** работают
- ⚠️ **32 теста** (нужно больше для новых модулей)

### Frontend: **60% завершено** ⚠️

| Модуль | Модели | Services | Providers | Screens | Виджеты | Статус |
|--------|--------|----------|-----------|---------|---------|--------|
| Auth | ✅ User | ✅ | ✅ | ✅ | ✅ | 100% |
| Profile | ✅ Profile | ✅ | ✅ | ✅ | ✅ | 100% |
| News | ✅ News | ✅ | ✅ | ✅ | ⚠️ | 85% |
| Education | ✅ Course | ✅ | ❌ | ⚠️ | ❌ | 40% |
| Events | ✅ Event | ❌ | ❌ | ❌ | ❌ | 25% |
| Map | ✅ RecyclingPoint | ✅ | ❌ | ❌ | ❌ | 30% |
| Achievements | ✅ | ❌ | ❌ | ❌ | ⚠️ | 25% |
| Challenges | ❌ | ❌ | ❌ | ❌ | ❌ | 0% |

**Итого Frontend**:
- ✅ **7 моделей Dart** реализованы
- ✅ **8 сервисов** готовы
- ⚠️ **4 провайдера** (нужно ещё ~4)
- ⚠️ **5 экранов** готовы (нужно ещё ~6)
- ⚠️ **10 виджетов** (нужно больше для курсов, карты, событий)

### CI/CD & Testing: **75% завершено** ✅

- ✅ GitHub Actions workflow настроен
- ✅ Backend unit tests (17 тестов)
- ✅ Backend integration tests (15 тестов)
- ✅ Frontend widget/model/service tests (15+ тестов)
- ⚠️ E2E тесты (базовые)
- ✅ Docker & docker-compose
- ✅ Makefile для автоматизации

---

## 🗺️ Дорожная карта

### Фаза 4: Завершение Frontend (2-3 недели)

**Приоритет: Высокий**

#### 4.1 Экраны образования
- [ ] `courses_list_screen.dart` — список курсов с фильтрацией
- [ ] `course_detail_screen.dart` — детали курса, модули, запись
- [ ] `quiz_screen.dart` — тестирование с таймером
- [ ] `course_progress_screen.dart` — прогресс прохождения

#### 4.2 Экраны событий
- [ ] `events_list_screen.dart` — список событий
- [ ] `event_detail_screen.dart` — детали, регистрация
- [ ] `events_calendar_screen.dart` — календарь Flutter Calendar

#### 4.3 Карта
- [ ] `map_screen.dart` — интерактивная карта с `flutter_map`
- [ ] Маркеры пунктов переработки
- [ ] Фильтрация по типам отходов
- [ ] Геолокация пользователя

#### 4.4 Геймификация
- [ ] `achievements_screen.dart` — достижения, прогресс
- [ ] `challenges_screen.dart` — активные челленджи
- [ ] `leaderboard_screen.dart` — таблица лидеров

#### 4.5 Провайдеры
- [ ] `EducationProvider` — state для курсов
- [ ] `EventsProvider` — state для событий
- [ ] `MapProvider` — state для карты
- [ ] `GamificationProvider` — state для достижений/челленджей

### Фаза 5: Доработка Backend (1-2 недели)

#### 5.1 Notifications
- [ ] Push-уведомления (Firebase Cloud Messaging)
- [ ] Email-уведомления (Nodemailer)
- [ ] Контроллер и routes для уведомлений

#### 5.2 Organizations
- [ ] CRUD для организаций
- [ ] Верификация организаций модераторами
- [ ] Связь с событиями и профилями

#### 5.3 Admin Panel
- [ ] Endpoint для статистики
- [ ] Управление пользователями
- [ ] Модерация контента (dashboard)

#### 5.4 Расширенное тестирование
- [ ] Unit тесты для всех новых контроллеров
- [ ] Integration тесты для всех модулей
- [ ] E2E тесты основных flow

### Фаза 6: Mobile (iOS/Android) (3-4 недели)

#### 6.1 Нативная сборка
- [ ] iOS build и тестирование на реальном устройстве
- [ ] Android build и APK
- [ ] Адаптация UI для мобильных размеров

#### 6.2 Мобильные фичи
- [ ] Камера для аватаров и фото
- [ ] Геолокация для событий и карты
- [ ] Push-уведомления
- [ ] Оффлайн режим (кеширование данных)

#### 6.3 Оптимизация
- [ ] Ленивая загрузка изображений
- [ ] Кеширование API запросов
- [ ] Оптимизация размера приложения

### Фаза 7: Production Deployment (1-2 недели)

#### 7.1 Backend Deployment
- [ ] VPS/Cloud сервер (AWS, DigitalOcean, Yandex Cloud)
- [ ] MongoDB Atlas (managed database)
- [ ] SSL сертификат (Let's Encrypt)
- [ ] CI/CD для автоматического деплоя

#### 7.2 Frontend Deployment
- [ ] Web hosting (Vercel, Netlify, Firebase Hosting)
- [ ] iOS App Store submission
- [ ] Android Google Play submission

#### 7.3 Мониторинг и аналитика
- [ ] Error tracking (Sentry)
- [ ] Analytics (Google Analytics, Yandex Metrica)
- [ ] Performance monitoring
- [ ] Logs aggregation (ELK Stack или Cloud Logging)

### Фаза 8: Пост-релиз (Ongoing)

- [ ] Сбор отзывов пользователей
- [ ] Исправление багов
- [ ] Новые фичи по запросам
- [ ] A/B тестирование
- [ ] SEO оптимизация
- [ ] Маркетинг и PR

---

## 📊 Метрики проекта

### Кодовая база

| Компонент | Файлов | Строк кода (примерно) |
|-----------|--------|------------------------|
| Backend | 50+ | ~5000+ |
| Frontend | 60+ | ~4000+ |
| Тесты | 10+ | ~1500+ |
| Документация | 15+ | ~3000+ |
| **ИТОГО** | **135+** | **~13500+** |

### API Coverage

- **Всего endpoints**: ~54
- **Защищённых (auth required)**: ~40
- **Публичных**: ~14
- **Admin/Moderator only**: ~12

### Test Coverage

- **Backend unit tests**: 17 тестов, ~70% coverage
- **Backend integration tests**: 15 тестов
- **Frontend tests**: 15+ тестов, ~60% coverage

---

## 🛠️ Инструменты разработки

### Локальная разработка

```bash
# Запуск всего стека
make dev

# Только backend
make up

# Только frontend
make frontend

# Тесты
make test
```

### Docker

```bash
# Сборка и запуск
docker-compose up -d

# Просмотр логов
docker-compose logs -f backend

# Перезапуск
docker-compose restart

# Остановка
docker-compose down
```

### MongoDB

```bash
# Подключение к MongoDB shell
make db-shell

# Backup базы данных
make db-backup

# Восстановление
make db-restore
```

### Seed данные

```bash
cd backend

# Создать админа
node scripts/createAdmin.js

# Создать тестовых пользователей
node scripts/createTestUsers.js

# Добавить новости
node scripts/seedNews.js
```

---

## 📚 Дополнительная документация

| Документ | Описание |
|----------|----------|
| [README.md](./README.md) | Общая информация и быстрый старт |
| [TESTING.md](./TESTING.md) | Полное руководство по тестированию |
| [CI_CD_SETUP.md](./CI_CD_SETUP.md) | Настройка CI/CD |
| [CHANGES_SUMMARY.md](./CHANGES_SUMMARY.md) | История изменений |
| [PHASE3_SUMMARY.md](./PHASE3_SUMMARY.md) | Отчёт по Фазе 3 |
| [NEWS_IMPLEMENTATION_SUMMARY.md](./NEWS_IMPLEMENTATION_SUMMARY.md) | Реализация модуля новостей |
| [CREDENTIALS.md](./CREDENTIALS.md) | Доступы и учётные данные |

---

## 🤝 Контрибьюторы

- Backend разработка
- Frontend разработка (Flutter)
- UI/UX дизайн (Figma)
- Тестирование
- Документация

---

## 📞 Контакты и поддержка

Для вопросов и предложений:
- GitHub Issues: [создать issue](https://github.com/YOUR_USERNAME/ecodrug/issues)
- Email: support@ecodrug.ru (TODO)

---

## 📄 Лицензия

MIT License

---

**Дата создания**: 4 декабря 2025  
**Последнее обновление**: 4 декабря 2025  
**Автор**: EcoDrug Development Team




