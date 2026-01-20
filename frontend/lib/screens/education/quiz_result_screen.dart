import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/education_service.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int earnedPoints;
  final String courseId;
  final String quizId;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.earnedPoints,
    required this.courseId,
    required this.quizId,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.loadProfile();
      
      // Отправить результаты на backend и обновить профиль
      final percentage = (widget.score / widget.totalQuestions * 100).round();
      if (percentage >= 70) { // Если тест пройден
        try {
          final educationService = EducationService();
          await educationService.completeCourse(widget.courseId);
          print('Course completed! Points added.');
          // Обновить профиль после начисления баллов
          await profileProvider.loadProfile();
        } catch (e) {
          print('Error completing course: $e');
          // Не показываем ошибку пользователю, чтобы не портить впечатление
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleWidth = size.width / 375;
    final scaleHeight = size.height / 812;

    final percentage = (widget.score / widget.totalQuestions * 100).round();
    final isPassed = percentage >= 70;

    return Scaffold(
      body: Stack(
        children: [
          // ========== ФОН ==========
          Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFBC9CEA),
          ),

          // ========== ЛАПКА МЕДВЕДЯ НИЖНЯЯ ПРАВАЯ ==========
          Positioned(
            left: 78 * scaleWidth,
            bottom: -50 * scaleHeight,
            child: Transform.rotate(
              angle: (-31.25 - 30) * 3.14159 / 180,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/icons/Эко Друг/bear-pawprint 7.png',
                  width: 325 * scaleWidth,
                  height: 325 * scaleHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 325 * scaleWidth,
                      height: 325 * scaleHeight,
                    );
                  },
                ),
              ),
            ),
          ),

          // ========== ОСНОВНОЙ КОНТЕНТ ==========
          SafeArea(
            child: Stack(
              children: [
                // ========== ЛАПКА МЕДВЕДЯ ВЕРХНЯЯ ЛЕВАЯ ==========
                Positioned(
                  left: -55 * scaleWidth,
                  top: -4 * scaleHeight,
                  child: Transform.rotate(
                    angle: 14.69 * 3.14159 / 180,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'assets/icons/Эко Друг/bear-pawprint 7.png',
                        width: 217.64 * scaleWidth,
                        height: 217.64 * scaleHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: 217.64 * scaleWidth,
                            height: 217.64 * scaleHeight,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    // ========== ШАПКА ==========
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        34 * scaleWidth,
                        16 * scaleHeight,
                        34 * scaleWidth,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Аватар с кнопкой настроек
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Consumer2<ProfileProvider, AuthProvider>(
                                builder: (context, profileProvider, authProvider, _) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/profile');
                                    },
                                    child: Container(
                                      width: 78 * scaleWidth,
                                      height: 101 * scaleHeight,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFF141414),
                                          width: 3,
                                        ),
                                        color: const Color(0xFF7FD17F),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: profileProvider.profile?.avatar != null
                                            ? Image.network(
                                                '${ApiConstants.serverUrl}${profileProvider.profile!.avatar}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return _buildAvatarPlaceholder(
                                                    profileProvider.profile?.fullName ??
                                                        authProvider.user?.username ??
                                                        'User',
                                                  );
                                                },
                                              )
                                            : _buildAvatarPlaceholder(
                                                profileProvider.profile?.fullName ??
                                                    authProvider.user?.username ??
                                                    'User',
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: -15 * scaleWidth,
                                bottom: -13 * scaleHeight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/profile');
                                  },
                                  child: Container(
                                    width: 40 * scaleWidth,
                                    height: 40 * scaleHeight,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBC9CEA),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF181818),
                                        width: 3,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.settings,
                                        size: 22 * scaleWidth,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30 * scaleHeight),

                    // ========== РЕЗУЛЬТАТЫ ==========
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 34 * scaleWidth,
                          right: 34 * scaleWidth,
                          bottom: 100 * scaleHeight, // Отступ для навигации
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20 * scaleHeight),
                            
                            // Заголовок
                            Text(
                              isPassed ? 'Отлично!' : 'Попробуйте еще раз',
                              style: TextStyle(
                                fontFamily: 'Neucha',
                                fontSize: 40 * scaleWidth,
                                height: 44 / 40,
                                letterSpacing: 0.06 * 40 * scaleWidth,
                                color: const Color(0xFF111111),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 40 * scaleHeight),

                            // Контейнер с результатами
                            Container(
                              padding: EdgeInsets.all(30 * scaleWidth),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xFF181818),
                                  width: 4,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Правильных ответов
                                  Text(
                                    'Правильных ответов:',
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 22 * scaleWidth,
                                      letterSpacing: 0.06 * 22 * scaleWidth,
                                      color: const Color(0xFF111111),
                                    ),
                                  ),
                                  SizedBox(height: 10 * scaleHeight),
                                  Text(
                                    '${widget.score}/${widget.totalQuestions}',
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 48 * scaleWidth,
                                      fontWeight: FontWeight.bold,
                                      color: isPassed
                                          ? const Color(0xFF53C25A)
                                          : const Color(0xFFED8D8C),
                                    ),
                                  ),

                                  SizedBox(height: 20 * scaleHeight),

                                  // Процент
                                  Text(
                                    '$percentage%',
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 36 * scaleWidth,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),

                                  SizedBox(height: 30 * scaleHeight),

                                  // Начислено баллов
                                  if (isPassed) ...[
                                    Text(
                                      'Начислено баллов:',
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 20 * scaleWidth,
                                        letterSpacing: 0.06 * 20 * scaleWidth,
                                        color: const Color(0xFF111111),
                                      ),
                                    ),
                                    SizedBox(height: 10 * scaleHeight),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 30 * scaleWidth,
                                          color: const Color(0xFFFAD188),
                                        ),
                                        SizedBox(width: 8 * scaleWidth),
                                        Text(
                                          '+${widget.earnedPoints}',
                                          style: TextStyle(
                                            fontFamily: 'Neucha',
                                            fontSize: 32 * scaleWidth,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFAD188),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            SizedBox(height: 40 * scaleHeight),

                            // Кнопка "Пройти повторно" (если не прошел)
                            if (!isPassed)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                    '/quiz',
                                    arguments: {
                                      'courseId': widget.courseId,
                                      'quizId': widget.quizId, // Передаем реальный quizId
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 60 * scaleHeight,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAD188),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF181818),
                                      width: 4,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Пройти повторно',
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 24 * scaleWidth,
                                        letterSpacing: 0.06 * 24 * scaleWidth,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            if (!isPassed) SizedBox(height: 15 * scaleHeight),

                            // Кнопка "Вернуться к курсам"
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/courses/basic' ||
                                      route.settings.name == '/courses/additional' ||
                                      route.isFirst,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 60 * scaleHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF53C25A),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF181818),
                                    width: 4,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Вернуться к курсам',
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 24 * scaleWidth,
                                      letterSpacing: 0.06 * 24 * scaleWidth,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ========== НИЖНЯЯ НАВИГАЦИЯ ==========
                    _buildBottomNavigationBar(scaleWidth, scaleHeight),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    String initials = '';
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = name.substring(0, 1).toUpperCase();
      }
    } else {
      initials = '?';
    }

    return Container(
      color: const Color(0xFF7FD17F),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(double scaleWidth, double scaleHeight) {
    return Container(
      height: 90 * scaleHeight,
      padding: EdgeInsets.symmetric(horizontal: 19 * scaleWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavIcon(
            'assets/icons/Эко Друг/экопоходы.svg',
            const Color(0xFF53C25A),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/eco-hikes');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/обучение.svg',
            const Color(0xFFBC9CEA),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/education');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/новости.svg',
            const Color(0xFFED8D8C),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/news');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/карта.svg',
            const Color(0xFFFAD188),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/map');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(
    String svgPath,
    Color backgroundColor,
    double scaleWidth,
    double scaleHeight, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70 * scaleWidth,
        height: 70 * scaleHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => Icon(
              Icons.help_outline,
              size: 35 * scaleWidth,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

