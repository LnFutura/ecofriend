import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/decorative/bear_mascot.dart';

/// Начальный экран (Welcome Screen) как в дизайне Figma
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Пропорции из Figma (390x844)
    final scaleWidth = screenWidth / 390;
    final scaleHeight = screenHeight / 844;
    
    return Scaffold(
      body: Container(
        color: AppTheme.screenGreen,
        child: Stack(
          children: [
            // Белый овал внизу - простой и адаптивный
            Positioned(
              left: -screenWidth * 0.3,
              bottom: -screenHeight * 0.32, // Поднимаем немного выше
              child: Container(
                width: screenWidth * 1.6,
                height: screenHeight * 0.55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(800, 400), // Более закругленные края
                    topRight: Radius.elliptical(800, 400),
                  ),
                ),
              ),
            ),
            
            // Контент
            SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight - MediaQuery.of(context).padding.top,
                  child: Column(
                    children: [
                      SizedBox(height: 73 * scaleHeight),
                      
                      // Медведь с мешком (размеры из Figma)
                      BearMascot(
                        size: 218 * scaleWidth,
                        withBag: true,
                      ),
                      
                      SizedBox(height: 60 * scaleHeight), // Уменьшил отступ с 100 до 60
                      
                      // Кнопка "Вход по email" с тенью (точные размеры из Figma)
                      _buildShadowButton(
                        text: 'Вход по email',
                        scaleWidth: scaleWidth,
                        scaleHeight: scaleHeight,
                        onTap: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                      ),
                      
                      SizedBox(height: 47 * scaleHeight),
                      
                      // Кнопка "Вход по VC ID" с тенью
                      _buildShadowButton(
                        text: 'Вход по VC ID',
                        scaleWidth: scaleWidth,
                        scaleHeight: scaleHeight,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Вход через VC ID будет реализован позже'),
                            ),
                          );
                        },
                      ),
                      
                      const Spacer(),
                      
                      // Текст "У вас нет аккаунта?"
                      Text(
                        'У вас нет аккаунта?',
                        style: TextStyle(
                          fontFamily: 'Neucha',
                          fontSize: 30 * scaleWidth,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 2.4,
                        ),
                      ),
                      
                      SizedBox(height: 15 * scaleHeight),
                      
                      // Ссылка "Регистрация" (коричневый цвет #B87963)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 25 * scaleWidth,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB87963),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 50 * scaleHeight),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Вспомогательный метод для кнопок с тенью (точные размеры из Figma)
  Widget _buildShadowButton({
    required String text,
    required double scaleWidth,
    required double scaleHeight,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Черная тень (Rectangle 3/6 - тень)
        Container(
          width: 221 * scaleWidth,
          height: 67 * scaleHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 3 * scaleWidth),
            borderRadius: BorderRadius.circular(40 * scaleWidth),
          ),
        ),
        // Белая кнопка со смещением (Rectangle 3/7 - основная)
        Positioned(
          left: -2 * scaleWidth,
          top: -4 * scaleHeight,
          child: Container(
            width: 220 * scaleWidth,
            height: 67 * scaleHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3 * scaleWidth),
              borderRadius: BorderRadius.circular(40 * scaleWidth),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(40 * scaleWidth),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Neucha',
                      fontSize: 30 * scaleWidth,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: 2.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

