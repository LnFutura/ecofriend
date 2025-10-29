#!/bin/bash

echo "🚀 Запуск EcoDrug на iPhone..."
echo ""

# 1. Установить pods (если еще не установлены)
echo "📦 Установка iOS зависимостей..."
cd /Users/vladimir/Projects/ecodrug/frontend/ios
pod install

# 2. Вернуться в папку проекта
cd /Users/vladimir/Projects/ecodrug/frontend

# 3. Проверить доступные устройства
echo ""
echo "📱 Доступные устройства:"
flutter devices

# 4. Запустить на iPhone
echo ""
echo "🚀 Запуск приложения..."
flutter run

echo ""
echo "✅ Готово!"

