# План реализации модуля "Экофильмы"

## 📋 Статус: Отложено на потом

## 🎯 Цель
Реализовать просмотр образовательных экофильмов в приложении

## 📦 Что нужно сделать

### Backend (3-4 часа)

#### 1. Создать модель Film
**Файл:** `backend/models/Film.js`

```javascript
{
  title: String (required, max 200 chars),
  description: String (required, max 1000 chars),
  thumbnail: String (URL картинки),
  videoUrl: String (YouTube ID или путь к файлу),
  videoType: String (enum: ['youtube', 'vimeo', 'direct']),
  duration: Number (минуты),
  category: String (enum: recycling, energy, etc.),
  published: Boolean,
  views: Number
}
```

#### 2. Создать API контроллер
**Файл:** `backend/controllers/educationController.js`

- `getAllFilms()` - GET /api/education/films
- `getFilmById()` - GET /api/education/films/:id
- `createFilm()` - POST /api/education/films (moderator/admin)
- `updateFilm()` - PUT /api/education/films/:id
- `deleteFilm()` - DELETE /api/education/films/:id

#### 3. Добавить роуты
**Файл:** `backend/routes/education.js`

```javascript
router.get('/films', getAllFilms);
router.get('/films/:id', getFilmById);
router.post('/films', protect, authorize('moderator', 'admin'), createFilm);
```

#### 4. Создать скрипт seed
**Файл:** `backend/scripts/seedFilms.js`

Добавить тестовые фильмы с YouTube ID

### Frontend (2-3 часа)

#### 1. Добавить метод в EducationService
**Файл:** `frontend/lib/services/education_service.dart`

```dart
Future<List<dynamic>> getFilms() async { ... }
Future<Film> getFilmById(String id) async { ... }
```

#### 2. Обновить FilmListScreen
**Файл:** `frontend/lib/screens/education/film_list_screen.dart`

- Загружать фильмы с backend
- Показывать список
- Навигация на экран просмотра

#### 3. Создать экран просмотра фильма
**Файл:** `frontend/lib/screens/education/film_player_screen.dart`

- Показывать видео плеер
- Информацию о фильме
- Счетчик просмотров

#### 4. Добавить пакеты
**Файл:** `frontend/pubspec.yaml`

```yaml
dependencies:
  youtube_player_flutter: ^8.1.2  # Для YouTube
  # ИЛИ
  video_player: ^2.8.0           # Для прямых ссылок
  chewie: ^1.7.0
```

### Решения для хостинга видео

#### ⭐ Вариант 1: YouTube (РЕКОМЕНДУЮ)
**Плюсы:**
- ✅ Бесплатно
- ✅ Не нагружает сервер
- ✅ Автоматическое масштабирование
- ✅ Субтитры, качество - все автоматом

**Минусы:**
- ❌ Зависимость от YouTube
- ❌ Нужен YouTube канал

**Как:**
1. Создать YouTube канал "ЭкоДруг"
2. Загрузить видео
3. В admin-панели модератор вставляет YouTube ID
4. Приложение показывает видео через YouTube Player

#### Вариант 2: Загрузка файлов на сервер
**Плюсы:**
- ✅ Полный контроль

**Минусы:**
- ❌ Огромная нагрузка на сервер (1 видео = 100-500 МБ)
- ❌ Медленная загрузка для пользователей
- ❌ Дорого (нужен CDN от $50/месяц)
- ❌ Нужна транскодировка

**Нужен middleware:**
**Файл:** `backend/middleware/videoUpload.js`
- Multer для видео файлов
- Лимит 500 МБ
- Форматы: mp4, avi, mov, mkv, webm

#### ⭐ Вариант 3: Гибридный (ОПТИМАЛЬНО)
- Основные видео на YouTube
- Эксклюзивный контент - загрузка файлов
- Модератор выбирает способ

## 📊 Оценка трудозатрат
- Backend: 3-4 часа
- Frontend: 2-3 часа
- Тестирование: 1 час
- **ИТОГО: 6-8 часов**

## 🚀 Приоритет
**НИЗКИЙ** - сначала доделать:
1. Карта
2. Экопоходы
3. Gamification
4. Admin Panel

## 📝 Примечания
- UI уже готов (FilmListScreen)
- Сейчас хардкод с 3 фильмами
- Backend API нужно создать с нуля
- Рекомендуется использовать YouTube для MVP






