import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

// Модель достижения
class Achievement {
  final String id;
  final String title;
  final String iconPath;
  final bool isUnlocked;
  final String? description;

  Achievement({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.isUnlocked,
    this.description,
  });
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  // Моковые данные - Учёные степени
  // Типы квадратов: purple, red, green
  final List<Map<String, dynamic>> _degrees = [
    {
      'id': '1',
      'title': 'Суслент',
      'iconPath': null, // Пустой квадрат
      'isSvg': false,
      'type': 'purple',
      'isUnlocked': true,
    },
    {
      'id': '2',
      'title': 'Барсукавр',
      'iconPath': 'assets/icons/Эко Друг/achivementscreen/diploma 5.png',
      'isSvg': false,
      'type': 'purple',
      'isUnlocked': true,
    },
    {
      'id': '3',
      'title': 'Моржистр',
      'iconPath': 'assets/icons/Эко Друг/achivementscreen/graduation-hat 3.png',
      'isSvg': false,
      'type': 'red',
      'isUnlocked': false,
    },
    {
      'id': '4',
      'title': 'Кандидат\nлосеологических наук',
      'iconPath': 'assets/icons/Эко Друг/achivementscreen/ed.png',
      'isSvg': false,
      'type': 'green',
      'isUnlocked': false,
    },
    {
      'id': '5',
      'title': 'Доктор\nлосеологических наук',
      'iconPath': 'assets/icons/Эко Друг/achivementscreen/lab.svg',
      'isSvg': true,
      'type': 'green',
      'isUnlocked': false,
    },
  ];

  // Моковые данные - Премии
  final List<Achievement> _awards = [
    Achievement(
      id: '6',
      title: 'Премия\nзайца',
      iconPath: 'assets/icons/Эко Друг/achivementscreen/Rectangle 252.png',
      isUnlocked: true,
    ),
    Achievement(
      id: '7',
      title: 'Премия\nкабана',
      iconPath: 'assets/icons/Эко Друг/achivementscreen/Rectangle 253.png',
      isUnlocked: true,
    ),
    Achievement(
      id: '8',
      title: 'Премия\nмедведя',
      iconPath: 'assets/icons/Эко Друг/achivementscreen/Rectangle 254.png',
      isUnlocked: true,
    ),
    Achievement(
      id: '9',
      title: 'Носорогиевская\nпремия',
      iconPath: 'assets/icons/Эко Друг/achivementscreen/Rectangle 255.png',
      isUnlocked: true,
    ),
  ];

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
            color: const Color(0xFFBC9CEA), // Фиолетовый фон
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
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
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
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    // ========== ШАПКА ==========
                    _buildHeader(scaleWidth, scaleHeight),

                    SizedBox(height: 8 * scaleHeight),

                    // ========== ЗАГОЛОВОК ==========
                    Padding(
                      padding: EdgeInsets.only(left: 34 * scaleWidth),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Достижения',
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 32 * scaleWidth,
                            color: const Color(0xFF111111),
                            letterSpacing: 0.08 * 32 * scaleWidth,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16 * scaleHeight),

                    // ========== КОНТЕНТ ==========
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20 * scaleWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Секция "Учёные степени"
                              _buildDegreesSection(scaleWidth, scaleHeight),

                              SizedBox(height: 20 * scaleHeight),

                              // Секция "Премии"
                              _buildAwardsSection(scaleWidth, scaleHeight),

                              SizedBox(height: 20 * scaleHeight),
                            ],
                          ),
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

  Widget _buildHeader(double scaleWidth, double scaleHeight) {
    return Padding(
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
                    color: const Color(0xFF252525),
                  ),
                );
              },
            ),
          ),

          // Аватар с иконкой шапочки выпускника
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
                        color: const Color(0xFFBC9CEA),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: profileProvider.profile?.avatar != null
                            ? Image.network(
                                '${ApiConstants.serverUrl}${profileProvider.profile!.avatar}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAvatarPlaceholder(
                                    profileProvider.profile?.fullName ?? authProvider.user?.email ?? ''
                                  );
                                },
                              )
                            : _buildAvatarPlaceholder(
                                profileProvider.profile?.fullName ?? authProvider.user?.email ?? ''
                              ),
                      ),
                    ),
                  );
                },
              ),

              // Иконка шапочки выпускника сверху справа
              Positioned(
                top: -12 * scaleHeight,
                right: -12 * scaleWidth,
                child: Container(
                  width: 36 * scaleWidth,
                  height: 36 * scaleHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF141414),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4 * scaleWidth),
                    child: Image.asset(
                      'assets/icons/Эко Друг/achivementscreen/graduation-hat 3.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Шестеренка снизу справа
              Positioned(
                bottom: -8 * scaleHeight,
                right: -8 * scaleWidth,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                  child: Container(
                    width: 40 * scaleWidth,
                    height: 40 * scaleHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBC9CEA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF141414),
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
    );
  }

  Widget _buildDegreesSection(double scaleWidth, double scaleHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции
        Padding(
          padding: EdgeInsets.only(left: 14 * scaleWidth),
          child: Text(
            'Учёные степени',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 24 * scaleWidth,
              color: const Color(0xFF111111),
              letterSpacing: 0.08 * 24 * scaleWidth,
            ),
          ),
        ),

        SizedBox(height: 16 * scaleHeight),

        // Первый ряд - 3 достижения
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _degrees.take(3).map((degree) {
            return _buildDegreeItem(degree, scaleWidth, scaleHeight);
          }).toList(),
        ),

        SizedBox(height: 20 * scaleHeight),

        // Второй ряд - 2 достижения
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _degrees.skip(3).map((degree) {
            return _buildDegreeItem(degree, scaleWidth, scaleHeight, isLarge: true);
          }).toList(),
        ),
      ],
    );
  }

  // Получить цвета для типа квадрата
  Map<String, Color> _getColorsForType(String type) {
    switch (type) {
      case 'purple':
        return {
          'shadow': const Color(0xFF76006E),
          'background': const Color(0xFFA783DB),
          'border': const Color(0xFF76006E),
        };
      case 'red':
        return {
          'shadow': const Color(0xFF76006E),
          'background': const Color(0xFF9F3030),
          'border': const Color(0xFF700000),
        };
      case 'green':
        return {
          'shadow': const Color(0xFF0D3A18),
          'background': const Color(0xFF336C41),
          'border': const Color(0xFF0D3A18),
        };
      default:
        return {
          'shadow': const Color(0xFF76006E),
          'background': const Color(0xFFA783DB),
          'border': const Color(0xFF76006E),
        };
    }
  }

  Widget _buildDegreeItem(Map<String, dynamic> degree, double scaleWidth, double scaleHeight, {bool isLarge = false}) {
    final boxSize = 54 * scaleWidth;
    final colors = _getColorsForType(degree['type'] as String);
    final String? iconPath = degree['iconPath'] as String?;
    final bool isSvg = degree['isSvg'] as bool? ?? false;
    final String title = degree['title'] as String;
    
    return Column(
      children: [
        // Двойной квадрат с тенью
        SizedBox(
          width: boxSize + 4 * scaleWidth,
          height: boxSize + 4 * scaleHeight,
          child: Stack(
            children: [
              // Тень (задний квадрат)
              Positioned(
                left: 2 * scaleWidth,
                top: 2 * scaleHeight,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: colors['shadow'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Основной квадрат
              Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  color: colors['background'],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors['border']!,
                    width: 3,
                  ),
                ),
                child: iconPath != null
                    ? Padding(
                        padding: EdgeInsets.all(8 * scaleWidth),
                        child: isSvg
                            ? SvgPicture.asset(
                                iconPath,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                iconPath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const SizedBox(),
                              ),
                      )
                    : null, // Пустой квадрат для Суслента
              ),
            ],
          ),
        ),

        SizedBox(height: 8 * scaleHeight),

        // Название
        SizedBox(
          width: isLarge ? 100 * scaleWidth : 70 * scaleWidth,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 14 * scaleWidth,
              color: const Color(0xFF111111),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAwardsSection(double scaleWidth, double scaleHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * scaleWidth),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0FA), // Светло-фиолетовый/белый
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF181818),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          // Заголовок
          Text(
            'Премии',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 24 * scaleWidth,
              color: const Color(0xFF111111),
              letterSpacing: 0.08 * 24 * scaleWidth,
            ),
          ),

          SizedBox(height: 20 * scaleHeight),

          // Ряд с премиями
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _awards.map((award) {
              return _buildAwardItem(award, scaleWidth, scaleHeight);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardItem(Achievement award, double scaleWidth, double scaleHeight) {
    return Column(
      children: [
        // Иконка
        Container(
          width: 55 * scaleWidth,
          height: 55 * scaleWidth,
          decoration: BoxDecoration(
            color: const Color(0xFF53C25A), // Зелёный фон
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              award.iconPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.emoji_events,
                size: 30 * scaleWidth,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: 8 * scaleHeight),

        // Название
        SizedBox(
          width: 70 * scaleWidth,
          child: Text(
            award.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 12 * scaleWidth,
              color: const Color(0xFF111111),
              height: 1.2,
            ),
          ),
        ),
      ],
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
      color: const Color(0xFFBC9CEA),
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
    String iconPath,
    Color bgColor,
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
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.expand(
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
