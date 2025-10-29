#!/bin/bash

echo "🔧 Настройка iOS разработки для EcoDrug..."
echo ""

# 1. Настроить Xcode
echo "1. Настройка Xcode..."
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 2. Принять лицензию
echo "2. Принятие лицензии Xcode..."
sudo xcodebuild -license accept

# 3. Первичная настройка
echo "3. Запуск первичной настройки Xcode..."
sudo xcodebuild -runFirstLaunch

# 4. Установить CocoaPods
echo "4. Установка CocoaPods..."
sudo gem install cocoapods

# 5. Настроить CocoaPods
echo "5. Настройка CocoaPods..."
pod setup

# 6. Установить pods для проекта
echo "6. Установка iOS зависимостей..."
cd /Users/vladimir/Projects/ecodrug/frontend/ios
pod install

echo ""
echo "✅ Настройка завершена!"
echo ""
echo "Теперь запустите приложение:"
echo "  cd /Users/vladimir/Projects/ecodrug/frontend"
echo "  flutter run"
echo ""

