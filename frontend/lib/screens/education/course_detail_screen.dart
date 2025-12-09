import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/education_provider.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    print('CourseDetailScreen: Loading course with ID: ${widget.courseId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
      Provider.of<EducationProvider>(context, listen: false).fetchCourseDetails(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleWidth = size.width / 375;
    final scaleHeight = size.height / 812;

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Кнопка назад
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50 * scaleWidth,
                              height: 50 * scaleHeight,
                              margin: EdgeInsets.only(top: 16 * scaleHeight),
                              decoration: BoxDecoration(
                                color: const Color(0xFF181818),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24 * scaleWidth,
                              ),
                            ),
                          ),

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

                    SizedBox(height: 10 * scaleHeight),

                    // ========== КОНТЕНТ КУРСА ==========
                    Expanded(
                      child: Consumer<EducationProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          final course = provider.currentCourse;

                          if (course == null) {
                            return Center(
                              child: Text(
                                'Курс не найден',
                                style: TextStyle(
                                  fontFamily: 'Neucha',
                                  fontSize: 18 * scaleWidth,
                                  color: const Color(0xFF111111),
                                ),
                              ),
                            );
                          }

                          // Отладка: проверяем quiz
                          print('=== COURSE DEBUG ===');
                          print('Course title: ${course.title}');
                          print('Course quiz: ${course.quiz}');
                          print('Course quizId: ${course.quizId}');
                          print('==================');

                          return Column(
                            children: [
                              // Заголовок курса
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 34 * scaleWidth),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    course.title,
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 32 * scaleWidth,
                                      height: 35 / 32,
                                      letterSpacing: 0.06 * 32 * scaleWidth,
                                      color: const Color(0xFF111111),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20 * scaleHeight),

                              // Текст курса (scrollable)
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 34 * scaleWidth),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      course.content ?? course.description,
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 18 * scaleWidth,
                                        height: 22 / 18,
                                        letterSpacing: 0.06 * 18 * scaleWidth,
                                        color: const Color(0xFF111111),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20 * scaleHeight),

                              // Кнопка "Пройти тест"
                              if (course.quiz != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 34 * scaleWidth),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        '/quiz',
                                        arguments: {
                                          'courseId': course.id,
                                          'quizId': course.quiz,
                                        },
                                      );
                                    },
                                    child: Container(
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
                                          'Пройти тест',
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
                                ),

                              SizedBox(height: 10 * scaleHeight),
                            ],
                          );
                        },
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экопоходы в разработке')),
              );
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Карта в разработке')),
              );
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

