#!/bin/bash

echo "🔌 Проверка подключенного iPhone..."
echo ""

cd /Users/vladimir/Projects/ecodrug/frontend

# Показать доступные устройства
flutter devices

echo ""
echo "📱 Запуск приложения на iPhone..."
echo ""

# Запустить на первом доступном iOS устройстве
flutter run -d ios

echo ""
echo "✅ Приложение установлено на iPhone!"

