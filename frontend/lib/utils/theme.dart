import 'package:flutter/material.dart';

class AppTheme {
  // ============ Цвета из Figma ============
  
  // Зелёные оттенки (основная тема, события, звания)
  static const Color lightGreen = Color(0xFFB3F9C6);       // Светло-зелёный пастельный
  static const Color brightGreen = Color(0xFF38D45B);      // Яркий зелёный
  static const Color darkGreen = Color(0xFF016F19);        // Тёмно-зелёный
  static const Color mediumDarkGreen = Color(0xFF228036);  // Средне-тёмный
  static const Color primaryGreen = Color(0xFF03AA28);     // Основной зелёный
  static const Color mintGreen = Color(0xFF87DEA8);        // Мятный
  
  // Красные/Оранжевые оттенки (новости, акценты)
  static const Color lightRed = Color(0xFFF07B6E);         // Коралловый
  static const Color primaryRed = Color(0xFFF0503F);       // Красный
  static const Color darkRed = Color(0xFF920F01);          // Тёмно-красный
  static const Color brownRed = Color(0xFFA9382C);         // Красно-коричневый
  static const Color pinkRed = Color(0xFFED8D8C);          // Розовато-красный
  
  // Фиолетовые оттенки (обучение, курсы, достижения)
  static const Color primaryPurple = Color(0xFFBC9CEA);    // Лиловый
  
  // Оранжево-жёлтые оттенки (карта)
  static const Color primaryOrange = Color(0xFFFAD188);    // Персиковый
  
  // Голубые оттенки (профиль)
  static const Color primaryBlue = Color(0xFF65C6E9);      // Голубой
  
  // Базовые цвета
  static const Color backgroundColor = Color(0xFFFFFDF9);  // Почти белый
  static const Color textDark = Color(0xFF1C1C1C);         // Почти чёрный
  static const Color textLight = Color(0xFF757575);        // Серый для вторичного текста
  static const Color textWhite = Color(0xFFFFFFFF);        // Белый
  
  // Цвета экранов (для фонов)
  static const Color screenGreen = lightGreen;             // Главная, события, звания
  static const Color screenPurple = primaryPurple;         // Обучение, курсы, достижения
  static const Color screenRed = lightRed;                 // Новости
  static const Color screenOrange = primaryOrange;         // Карта
  static const Color screenBlue = primaryBlue;             // Профиль
  
  // Дополнительные цвета для совместимости
  static const Color successGreen = primaryGreen;
  static const Color errorRed = primaryRed;
  static const Color warningYellow = primaryOrange;
  static const Color infoBlue = primaryBlue;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Neucha',  // Рукописный шрифт из Figma
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: primaryOrange,
        surface: Colors.white,
        background: backgroundColor,
        error: errorRed,
      ),
      
      // App Bar Theme - прозрачный как в Figma
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),
      
      // Text Theme с шрифтом Neucha
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),
      
      // Button Theme - овальные кнопки как в Figma
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: textDark,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Овальные кнопки
            side: const BorderSide(color: textDark, width: 2),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Neucha',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Input Decoration Theme - поля ввода как в Figma
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: textDark, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: textDark, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: textDark, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: const TextStyle(
          fontFamily: 'Neucha',
          color: textDark,
        ),
      ),
      
      // Card Theme - карточки с обводкой как в Figma
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: textDark, width: 2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: textDark,
        unselectedItemColor: textDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Neucha',
          fontSize: 10,
        ),
      ),
    );
  }
  
  // Вспомогательные методы для декоративных элементов
  
  /// Создаёт декоративный фон с следами лап (как в Figma)
  static BoxDecoration createPawPrintBackground(Color backgroundColor) {
    return BoxDecoration(
      color: backgroundColor,
      // TODO: Добавить SVG паттерн со следами лап
    );
  }
  
  /// Создаёт стиль для облака с текстом (речевой пузырь)
  static BoxDecoration createCloudBubble() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: textDark, width: 2),
    );
  }
}

