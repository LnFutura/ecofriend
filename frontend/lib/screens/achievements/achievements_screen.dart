import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  
  List<Map<String, dynamic>> _degrees = [];
  List<Map<String, dynamic>> _awards = [];
  bool _isLoading = true;

  // Маппинг кодов на локальные иконки (пока нет CDN)
  final Map<String, String> _iconPaths = {
    'suslet': 'assets/icons/Эко Друг/achivementscreen/звания/Суслент.png',
    'barsukavr': 'assets/icons/Эко Друг/achivementscreen/звания/Барсукавр.png',
    'morzhist': 'assets/icons/Эко Друг/achivementscreen/звания/Моржистр.png',
    'kandidat': 'assets/icons/Эко Друг/achivementscreen/звания/Кандидат лосеологических наук.png',
    'doktor': 'assets/icons/Эко Друг/achivementscreen/звания/Доктор лосеологических наук.png',
    'rabbit': 'assets/icons/Эко Друг/achivementscreen/звания/rabbit.png',
    'boar': 'assets/icons/Эко Друг/achivementscreen/звания/Премия кабана.png',
    'bear': 'assets/icons/Эко Друг/achivementscreen/звания/Премия медведя.png',
    'rhino': 'assets/icons/Эко Друг/achivementscreen/звания/Носорогиевская премия.png',
  };

  // Маппинг кодов на colorType
  final Map<String, String> _colorTypes = {
    'suslet': 'purple',
    'barsukavr': 'purple',
    'morzhist': 'red',
    'kandidat': 'green',
    'doktor': 'green',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
      _loadAchievements();
    });
  }

  Future<void> _loadAchievements() async {
    try {
      final achievements = await _achievementService.getAchievementsStatus();
      
      final degrees = <Map<String, dynamic>>[];
      final awards = <Map<String, dynamic>>[];

      for (final a in achievements) {
        final code = a['code'] as String? ?? '';
        final item = {
          'id': a['_id'] ?? '',
          'code': code,
          'title': _formatTitle(a['name'] as String? ?? ''),
          'iconPath': _iconPaths[code] ?? '',
          'type': _colorTypes[code] ?? 'purple',
          'isUnlocked': a['isUnlocked'] ?? false,
        };

        if (a['type'] == 'degree') {
          degrees.add(item);
        } else if (a['type'] == 'award') {
          awards.add(item);
        }
      }

      setState(() {
        _degrees = degrees;
        _awards = awards;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading achievements: $e');
      // Fallback на моковые данные
      _loadMockData();
    }
  }

  void _loadMockData() {
    setState(() {
      _degrees = [
        {'id': '1', 'code': 'suslet', 'title': 'Суслент', 'iconPath': _iconPaths['suslet']!, 'type': 'purple', 'isUnlocked': true},
        {'id': '2', 'code': 'barsukavr', 'title': 'Барсукавр', 'iconPath': _iconPaths['barsukavr']!, 'type': 'purple', 'isUnlocked': false},
        {'id': '3', 'code': 'morzhist', 'title': 'Моржистр', 'iconPath': _iconPaths['morzhist']!, 'type': 'red', 'isUnlocked': false},
        {'id': '4', 'code': 'kandidat', 'title': 'Кандидат\nлосеологических наук', 'iconPath': _iconPaths['kandidat']!, 'type': 'green', 'isUnlocked': false},
        {'id': '5', 'code': 'doktor', 'title': 'Доктор\nлосеологических наук', 'iconPath': _iconPaths['doktor']!, 'type': 'green', 'isUnlocked': false},
      ];
      _awards = [
        {'id': '6', 'code': 'rabbit', 'title': 'Премия\nзайца', 'iconPath': _iconPaths['rabbit']!, 'isUnlocked': false},
        {'id': '7', 'code': 'boar', 'title': 'Премия\nкабана', 'iconPath': _iconPaths['boar']!, 'isUnlocked': false},
        {'id': '8', 'code': 'bear', 'title': 'Премия\nмедведя', 'iconPath': _iconPaths['bear']!, 'isUnlocked': false},
        {'id': '9', 'code': 'rhino', 'title': 'Носорогиевская\nпремия', 'iconPath': _iconPaths['rhino']!, 'isUnlocked': false},
      ];
      _isLoading = false;
    });
  }

  String _formatTitle(String name) {
    // Добавляем переносы для длинных названий
    if (name == 'Кандидат лосеологических наук') {
      return 'Кандидат\nлосеологических наук';
    }
    if (name == 'Доктор лосеологических наук') {
      return 'Доктор\nлосеологических наук';
    }
    if (name == 'Премия зайца') return 'Премия\nзайца';
    if (name == 'Премия кабана') return 'Премия\nкабана';
    if (name == 'Премия медведя') return 'Премия\nмедведя';
    if (name == 'Носорогиевская премия') return 'Носорогиевская\nпремия';
    return name;
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
                    // ========== ШАПКА с ЗАГОЛОВКОМ ==========
                    _buildHeader(scaleWidth, scaleHeight),

                    SizedBox(height: 16 * scaleHeight),

                    // ========== КОНТЕНТ ==========
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Секция "Учёные степени" с padding
                            if (_isLoading)
                              Padding(
                                padding: EdgeInsets.all(40 * scaleWidth),
                                child: const Center(child: CircularProgressIndicator()),
                              )
                            else ...[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20 * scaleWidth),
                                child: _buildDegreesSection(scaleWidth, scaleHeight),
                              ),

                              SizedBox(height: 20 * scaleHeight),

                              // Секция "Премии" без бокового padding
                              _buildAwardsSection(scaleWidth, scaleHeight),

                              SizedBox(height: 20 * scaleHeight),
                            ],
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
          // Левая колонка: email + Достижения
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16 * scaleHeight),
              Consumer<AuthProvider>(
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
              SizedBox(height: 8 * scaleHeight),
              Text(
                'Достижения',
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 32 * scaleWidth,
                  color: const Color(0xFF111111),
                  letterSpacing: 0.08 * 32 * scaleWidth,
                ),
              ),
            ],
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
                child: SizedBox(
                  width: 36 * scaleWidth,
                  height: 36 * scaleHeight,
                  child: Image.asset(
                    'assets/icons/Эко Друг/profilestudyicon.png',
                    fit: BoxFit.contain,
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
        Center(
          child: Text(
            'Учёные степени',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 28 * scaleWidth,
              color: const Color(0xFF111111),
              letterSpacing: 0.08 * 28 * scaleWidth,
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
    final iconSize = 60 * scaleWidth;
    final String? iconPath = degree['iconPath'] as String?;
    final String title = degree['title'] as String;
    final String type = degree['type'] as String;
    final bool isUnlocked = degree['isUnlocked'] as bool? ?? false;
    
    // Цвет текста зависит от типа (серый для заблокированных)
    Color textColor;
    if (!isUnlocked) {
      textColor = const Color(0xFF888888);
    } else {
      switch (type) {
        case 'red':
          textColor = const Color(0xFF9F3030);
          break;
        case 'green':
          textColor = const Color(0xFF0D3A18);
          break;
        default:
          textColor = const Color(0xFF111111);
      }
    }
    
    // Виджет иконки
    Widget iconWidget = iconPath != null && iconPath.isNotEmpty
        ? Image.asset(
            iconPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          )
        : const SizedBox();
    
    // Применяем grayscale фильтр для заблокированных
    if (!isUnlocked) {
      iconWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: iconWidget,
      );
    }
    
    return Column(
      children: [
        // Иконка во весь размер (уже содержит рамку)
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: iconWidget,
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
              fontSize: 16 * scaleWidth,
              color: textColor,
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
      padding: EdgeInsets.symmetric(horizontal: 16 * scaleWidth, vertical: 20 * scaleHeight),
      decoration: BoxDecoration(
        color: const Color(0xFF336C41), // Зелёный фон
        border: Border.symmetric(
          horizontal: BorderSide(
            color: const Color(0xFFD5E6AD),
            width: 3,
          ),
        ),
      ),
      child: Column(
        children: [
          // Заголовок
          Text(
            'Премии',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 28 * scaleWidth,
              color: const Color(0xFFD5E6AD),
              letterSpacing: 0.08 * 28 * scaleWidth,
            ),
          ),

          SizedBox(height: 20 * scaleHeight),

          // Ряд с премиями
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _awards.map((award) {
              return _buildAwardItem(award as Map<String, dynamic>, scaleWidth, scaleHeight);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardItem(Map<String, dynamic> award, double scaleWidth, double scaleHeight) {
    final String iconPath = award['iconPath'] as String? ?? '';
    final String title = award['title'] as String? ?? '';
    final bool isUnlocked = award['isUnlocked'] as bool? ?? false;
    
    // Виджет иконки
    Widget iconWidget = iconPath.isNotEmpty
        ? Image.asset(
            iconPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox(),
          )
        : const SizedBox();
    
    // Применяем grayscale фильтр для заблокированных
    if (!isUnlocked) {
      iconWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: iconWidget,
      );
    }
    
    return Column(
      children: [
        // Иконка (PNG уже содержит круг)
        SizedBox(
          width: 55 * scaleWidth,
          height: 55 * scaleWidth,
          child: iconWidget,
        ),

        SizedBox(height: 8 * scaleHeight),

        // Название
        SizedBox(
          width: 80 * scaleWidth,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 14 * scaleWidth,
              color: isUnlocked ? const Color(0xFFD5E6AD) : const Color(0xFF888888),
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
