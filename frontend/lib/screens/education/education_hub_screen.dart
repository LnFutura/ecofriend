import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class EducationHubScreen extends StatefulWidget {
  const EducationHubScreen({super.key});

  @override
  State<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends State<EducationHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
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

                    // ========== ЗАГОЛОВОК "ОБУЧЕНИЕ" ==========
                    Padding(
                      padding: EdgeInsets.only(left: 34 * scaleWidth),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Обучение',
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

                    SizedBox(height: 30 * scaleHeight),

                    // ========== ТРИ КНОПКИ ==========
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 34 * scaleWidth),
                        child: Column(
                          children: [
                            _buildCategoryButton(
                              'Основные курсы',
                              'Обучение заботе о природе',
                              'assets/icons/Эко Друг/diplafs.png',
                              () {
                                Navigator.of(context).pushNamed('/courses/basic');
                              },
                              scaleWidth,
                              scaleHeight,
                            ),
                            
                            SizedBox(height: 20 * scaleHeight),
                            
                            _buildCategoryButton(
                              'Доп. курсы',
                              'Особенности борьбы за экологию',
                              'assets/icons/Эко Друг/graduate.png',
                              () {
                                Navigator.of(context).pushNamed('/courses/additional');
                              },
                              scaleWidth,
                              scaleHeight,
                            ),
                            
                            SizedBox(height: 20 * scaleHeight),
                            
                            _buildCategoryButton(
                              'Экофильмы',
                              'Свалки и прочие беды современного мира',
                              'assets/icons/Эко Друг/Play.png',
                              () {
                                Navigator.of(context).pushNamed('/films');
                              },
                              scaleWidth,
                              scaleHeight,
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

  Widget _buildCategoryButton(
    String title,
    String subtitle,
    String iconPath,
    VoidCallback onTap,
    double scaleWidth,
    double scaleHeight,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120 * scaleHeight, // Фиксированная высота
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
                      right: 80 * scaleWidth, // Отступ для иконки
                      top: 12 * scaleHeight,
                      bottom: 8 * scaleHeight,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Neucha',
                          fontSize: 22 * scaleWidth,
                          height: 24 / 22,
                          letterSpacing: 0.06 * 22 * scaleWidth,
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
                      right: 80 * scaleWidth, // Отступ для иконки
                      top: 8 * scaleHeight,
                      bottom: 12 * scaleHeight,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Neucha',
                          fontSize: 14 * scaleWidth,
                          height: 16 / 14,
                          letterSpacing: 0.06 * 14 * scaleWidth,
                          color: const Color(0xFF666666),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Иконка наложенная на линию (БЕЗ круга)
            Positioned(
              right: 16 * scaleWidth,
              top: (120 * scaleHeight - 60 * scaleHeight) / 2, // Центр по высоте
              child: Container(
                width: 60 * scaleWidth,
                height: 60 * scaleHeight,
                child: iconPath.endsWith('.svg')
                    ? SvgPicture.asset(
                        iconPath,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        iconPath,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
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
            onTap: () {},
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

