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

Cursor Rules находятся в `.cursor/rules/` (8 файлов):
1. **project-structure.mdc** - Общая архитектура, 11 модулей, технологии (всегда применяется)
2. **backend-conventions.mdc** - MVC pattern, организация backend кода
3. **frontend-conventions.mdc** - Flutter/Dart конвенции, Provider, структура
4. **security-guidelines.mdc** - JWT, bcrypt, валидация, CORS (всегда применяется)
5. **api-design.mdc** - REST API эндпоинты, форматы запросов/ответов
6. **testing-guidelines.mdc** - Jest, Flutter tests, manual checklist
7. **deployment-guide.mdc** - Деплой на Railway/Netlify, MongoDB Atlas, CI/CD
8. **data-models.mdc** - Детальные схемы для всех 11 модулей

## Начало работы

Откройте эту папку в Cursor и начните создание проекта. Cursor автоматически использует правила из `.cursor/rules/`.

