import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/education_provider.dart';

class AdditionalCoursesScreen extends StatefulWidget {
  const AdditionalCoursesScreen({super.key});

  @override
  State<AdditionalCoursesScreen> createState() => _AdditionalCoursesScreenState();
}

class _AdditionalCoursesScreenState extends State<AdditionalCoursesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
      // Загружаем курсы категории 'general' для дополнительных курсов
      Provider.of<EducationProvider>(context, listen: false).fetchCourses(category: 'general');
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
                          Padding(
                            padding: EdgeInsets.only(top: 22 * scaleHeight),
                            child: Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return Text(
                                  auth.user?.email ?? 'user@example.com',
                                  style: TextStyle(
                                    fontFamily: 'Neucha',
                                    fontSize: 20 * scaleWidth,
                                    height: 22 / 20,
                                    letterSpacing: 0.08 * 20 * scaleWidth,
                                    color: const Color(0xFFF0F0F0),
                                  ),
                                );
                              },
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

                    // ========== ЗАГОЛОВОК "ДОП. КУРСЫ" ==========
                    Padding(
                      padding: EdgeInsets.only(left: 34 * scaleWidth),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Доп. курсы',
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 40 * scaleWidth,
                            height: 44 / 40,
                            letterSpacing: 0.06 * 40 * scaleWidth,
                            color: const Color(0xFF111111),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20 * scaleHeight),

                    // ========== СПИСОК КУРСОВ ==========
                    Expanded(
                      child: Consumer2<EducationProvider, ProfileProvider>(
                        builder: (context, eduProvider, profileProvider, child) {
                          if (eduProvider.isLoading && eduProvider.courses.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          if (eduProvider.courses.isEmpty) {
                            return Center(
                              child: Text(
                                'Дополнительные курсы пока не добавлены',
                                style: TextStyle(
                                  fontFamily: 'Neucha',
                                  fontSize: 18 * scaleWidth,
                                  color: const Color(0xFF111111),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: 34 * scaleWidth,
                              right: 34 * scaleWidth,
                              bottom: 20 * scaleHeight,
                            ),
                            itemCount: eduProvider.courses.length,
                            itemBuilder: (context, index) {
                              final course = eduProvider.courses[index];
                              final isCompleted = profileProvider.profile?.completedCourses
                                      ?.contains(course.id) ??
                                  false;

                              return Padding(
                                padding: EdgeInsets.only(bottom: 18 * scaleHeight),
                                child: _buildCourseCard(
                                  course,
                                  index + 1,
                                  isCompleted,
                                  scaleWidth,
                                  scaleHeight,
                                ),
                              );
                            },
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

  Widget _buildCourseCard(
    dynamic course,
    int number,
    bool isCompleted,
    double scaleWidth,
    double scaleHeight,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/course-detail',
          arguments: course.id,
        );
      },
      child: IntrinsicHeight(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 100 * scaleHeight, // Минимальная высота
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFF181818),
              width: 4,
            ),
          ),
          child: Stack(
            children: [
              // Верхняя и нижняя части 50/50
              Column(
                children: [
                  // Верхняя часть - название (50%)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 16 * scaleWidth,
                        right: 95 * scaleWidth, // Отступ для иконки 70+25
                        top: 12 * scaleHeight,
                        bottom: 8 * scaleHeight,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          course.title,
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 20 * scaleWidth,
                            height: 22 / 20,
                            letterSpacing: 0.06 * 20 * scaleWidth,
                            color: const Color(0xFF111111),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Линия
                  Container(
                    height: 2,
                    color: const Color(0xFF181818),
                  ),
                  // Нижняя часть - описание (50%)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 16 * scaleWidth,
                        right: 95 * scaleWidth, // Отступ для иконки 70+25
                        top: 8 * scaleHeight,
                        bottom: 12 * scaleHeight,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          course.description,
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 14 * scaleWidth,
                            height: 16 / 14,
                            letterSpacing: 0.06 * 14 * scaleWidth,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            // Иконка Play наложенная на линию (немного уже и выше)
            Positioned(
              right: 16 * scaleWidth,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 70 * scaleWidth, // Ширина уменьшена с 90 до 70
                  height: 40 * scaleHeight, // Высота увеличена с 30 до 40
                  decoration: BoxDecoration(
                    color: const Color(0xFFBC9CEA),
                    borderRadius: BorderRadius.circular(12), // Пропорционально увеличен
                    border: Border.all(
                      color: const Color(0xFF181818),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 28 * scaleWidth, // Увеличил размер иконки
                    color: Colors.white,
                  ),
                ),
              ),
            ),
              // Галочка (если курс пройден)
              if (isCompleted)
                Positioned(
                  top: 10 * scaleHeight,
                  right: 10 * scaleWidth,
                  child: Container(
                    width: 30 * scaleWidth,
                    height: 30 * scaleHeight,
                    decoration: const BoxDecoration(
                      color: Color(0xFF53C25A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20 * scaleWidth,
                    ),
                  ),
                ),
            ],
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

