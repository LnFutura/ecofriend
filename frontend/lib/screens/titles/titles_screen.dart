import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class TitlesScreen extends StatefulWidget {
  const TitlesScreen({super.key});

  @override
  State<TitlesScreen> createState() => _TitlesScreenState();
}

class _TitlesScreenState extends State<TitlesScreen> {
  // Список званий в правильном порядке
  final List<Map<String, String>> _titles = [
    {'title': 'Рыбовой', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/rybovoi1.png'},
    {'title': 'Сурикант', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/syrikant2.png'},
    {'title': 'Младший\nлосенант', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/mllosenant3.png'},
    {'title': 'Лосенант', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/losenant4.png'},
    {'title': 'Старший\nлосенант', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/stlosenant5.png'},
    {'title': 'Капибатан', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/kapibatan6.png'},
    {'title': 'Бобёр', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/bober7.png'},
    {'title': 'Подпавлин\nник', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/podpavlinik8.png'},
    {'title': 'Павлинник', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/pavlinik9.png'},
    {'title': 'Генерал\nБобёр', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/gbober10.png'},
    {'title': 'Генерал\nЛосенант', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/glosenant11.png'},
    {'title': 'Генерал\nПавлинник', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/gpavlinik12.png'},
    {'title': 'Мамонаршл', 'iconPath': 'assets/icons/Эко Друг/achivementscreen/звания/mamonarshl13.png'},
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
            color: const Color(0xFF87DEA8), // Зелёный фон
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

                    SizedBox(height: 45 * scaleHeight),

                    // ========== КОНТЕНТ ==========
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20 * scaleWidth),
                          child: Column(
                            children: [
                              // Сетка званий
                              _buildTitlesGrid(scaleWidth, scaleHeight),
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
          // Левая колонка: email + Звания
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
                'Звания',
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 32 * scaleWidth,
                  color: const Color(0xFF111111),
                  letterSpacing: 0.08 * 32 * scaleWidth,
                ),
              ),
            ],
          ),

          // Аватар с иконкой звезды
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
                        color: const Color(0xFF87DEA8),
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

              // Иконка звезды сверху справа
              Positioned(
                top: -12 * scaleHeight,
                right: -12 * scaleWidth,
                child: SizedBox(
                  width: 36 * scaleWidth,
                  height: 36 * scaleHeight,
                  child: Image.asset(
                    'assets/icons/Эко Друг/achivementscreen/звания/avstar.png',
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
                      color: const Color(0xFF309F37),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF141414),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 22 * scaleWidth,
                      color: const Color(0xFF141414),
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

  Widget _buildTitlesGrid(double scaleWidth, double scaleHeight) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10 * scaleWidth,
        mainAxisSpacing: 10 * scaleHeight,
        childAspectRatio: 0.7,
      ),
      itemCount: _titles.length,
      itemBuilder: (context, index) {
        final title = _titles[index];
        // Лосенант (index 3) имеет красный цвет
        final isLosenant = index == 3;
        return _buildTitleItem(
          title['title']!,
          title['iconPath']!,
          scaleWidth,
          scaleHeight,
          textColor: isLosenant ? const Color(0xFF700000) : const Color(0xFF031900),
        );
      },
    );
  }

  Widget _buildTitleItem(String title, String iconPath, double scaleWidth, double scaleHeight, {Color textColor = const Color(0xFF031900)}) {
    return Column(
      children: [
        // Иконка
        SizedBox(
          width: 60 * scaleWidth,
          height: 60 * scaleWidth,
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFF336C41),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        SizedBox(height: 6 * scaleHeight),

        // Название
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Neucha',
            fontSize: 14 * scaleWidth,
            color: textColor,
            height: 1.2,
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
      color: const Color(0xFF87DEA8),
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
