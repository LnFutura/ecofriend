import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

// Модель экопохода
class EcoHike {
  final String id;
  final String title;
  final String date;
  final String time;
  final String meetingPoint;
  final String shortDescription;
  final String fullDescription;
  final List<String> participantAvatars;
  final int participantsCount;
  final String telegramLink;
  final String mapLink;
  bool isGoing;

  EcoHike({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.meetingPoint,
    required this.shortDescription,
    required this.fullDescription,
    required this.participantAvatars,
    required this.participantsCount,
    required this.telegramLink,
    required this.mapLink,
    this.isGoing = false,
  });
}

class EcoHikesScreen extends StatefulWidget {
  const EcoHikesScreen({super.key});

  @override
  State<EcoHikesScreen> createState() => _EcoHikesScreenState();
}

class _EcoHikesScreenState extends State<EcoHikesScreen> {
  // Моковые данные экопоходов
  final List<EcoHike> _hikes = [
    EcoHike(
      id: '1',
      title: 'Посёлок Заходское',
      date: '10.11',
      time: '9:00',
      meetingPoint: 'от Финляндского вокзала',
      shortDescription: 'Собрать мусор, почистить территорию',
      fullDescription: 'Задачи: собрать мусор, почистить территорию у озера.\n\nПо сути некая тусовка у озера, но с благой целью, с собой нужно взять покушать, чай и мешки для мусора.',
      participantAvatars: [],
      participantsCount: 8,
      telegramLink: 'https://t.me/ecohike1',
      mapLink: 'https://yandex.ru/maps',
      isGoing: true,
    ),
    EcoHike(
      id: '2',
      title: 'Набережная Смоленки',
      date: '10.11',
      time: '10:00',
      meetingPoint: 'от м. Приморская',
      shortDescription: 'Собрать мусор, расчистить завалы деревьев',
      fullDescription: 'Задачи: собрать мусор на набережной, расчистить завалы упавших деревьев после шторма.\n\nС собой взять перчатки и хорошее настроение!',
      participantAvatars: [],
      participantsCount: 7,
      telegramLink: 'https://t.me/ecohike2',
      mapLink: 'https://yandex.ru/maps',
      isGoing: false,
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
            color: const Color(0xFF7FD17F), // Зеленый фон как на скриншоте
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
                          'Экопоходы',
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

                    // ========== СПИСОК ЭКОПОХОДОВ ==========
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20 * scaleWidth),
                        child: ListView.builder(
                          itemCount: _hikes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16 * scaleHeight),
                              child: _buildHikeCard(_hikes[index], scaleWidth, scaleHeight),
                            );
                          },
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

              // Шестеренка
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
                      color: const Color(0xFF7FD17F),
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

  Widget _buildHikeCard(EcoHike hike, double scaleWidth, double scaleHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EcoHikeDetailScreen(
              hike: hike,
              onToggleGoing: (isGoing) {
                setState(() {
                  hike.isGoing = isGoing;
                });
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF181818),
            width: 3,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16 * scaleWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Дата и чекбокс
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hike.date,
                    style: TextStyle(
                      fontFamily: 'Neucha',
                      fontSize: 24 * scaleWidth,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111111),
                    ),
                  ),
                  _buildGoingToggle(hike, scaleWidth, scaleHeight),
                ],
              ),

              SizedBox(height: 12 * scaleHeight),

              // Название
              Text(
                hike.title,
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 22 * scaleWidth,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111111),
                ),
              ),

              SizedBox(height: 8 * scaleHeight),

              // Описание
              Text(
                '${hike.date}.24 в ${hike.time} ${hike.meetingPoint}',
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 16 * scaleWidth,
                  color: const Color(0xFF252525),
                ),
              ),
              Text(
                hike.shortDescription,
                style: TextStyle(
                  fontFamily: 'Neucha',
                  fontSize: 16 * scaleWidth,
                  color: const Color(0xFF252525),
                ),
              ),

              SizedBox(height: 16 * scaleHeight),

              // Участники
              Row(
                children: [
                  // Аватарки участников (заглушки)
                  ...List.generate(
                    4,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 4 * scaleWidth),
                      width: 32 * scaleWidth,
                      height: 32 * scaleWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 18 * scaleWidth,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 8 * scaleWidth),
                  Text(
                    'Идут ${hike.participantsCount} человек',
                    style: TextStyle(
                      fontFamily: 'Neucha',
                      fontSize: 14 * scaleWidth,
                      color: const Color(0xFF53C25A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoingToggle(EcoHike hike, double scaleWidth, double scaleHeight) {
    return GestureDetector(
      onTap: () {
        setState(() {
          hike.isGoing = !hike.isGoing;
        });
      },
      child: Row(
        children: [
          Text(
            hike.isGoing ? 'Пойду' : 'Не пойду',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 16 * scaleWidth,
              color: hike.isGoing ? const Color(0xFF53C25A) : const Color(0xFF888888),
            ),
          ),
          SizedBox(width: 8 * scaleWidth),
          Container(
            width: 28 * scaleWidth,
            height: 28 * scaleWidth,
            decoration: BoxDecoration(
              color: hike.isGoing ? const Color(0xFF53C25A) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF181818),
                width: 2,
              ),
            ),
            child: hike.isGoing
                ? Icon(
                    Icons.check,
                    size: 18 * scaleWidth,
                    color: Colors.white,
                  )
                : null,
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
            isActive: true,
            onTap: () {
              // Текущий экран
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
    bool isActive = false,
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

// ========== ДЕТАЛЬНЫЙ ЭКРАН ЭКОПОХОДА ==========
class EcoHikeDetailScreen extends StatefulWidget {
  final EcoHike hike;
  final Function(bool) onToggleGoing;

  const EcoHikeDetailScreen({
    super.key,
    required this.hike,
    required this.onToggleGoing,
  });

  @override
  State<EcoHikeDetailScreen> createState() => _EcoHikeDetailScreenState();
}

class _EcoHikeDetailScreenState extends State<EcoHikeDetailScreen> {
  late bool _isGoing;

  @override
  void initState() {
    super.initState();
    _isGoing = widget.hike.isGoing;
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
            color: const Color(0xFF7FD17F),
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
                          'Экопоходы',
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

                    // ========== КАРТОЧКА ДЕТАЛИ ==========
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20 * scaleWidth),
                        child: _buildDetailCard(scaleWidth, scaleHeight),
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

              // Шестеренка
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
                      color: const Color(0xFF7FD17F),
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

  Widget _buildDetailCard(double scaleWidth, double scaleHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Кнопка назад (над карточкой)
        GestureDetector(
          onTap: () {
            widget.onToggleGoing(_isGoing);
            Navigator.pop(context);
          },
          child: Container(
            width: 40 * scaleWidth,
            height: 40 * scaleHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF181818),
                width: 3,
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 24 * scaleWidth,
              color: const Color(0xFF181818),
            ),
          ),
        ),

        SizedBox(height: 12 * scaleHeight),

        // Карточка
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0xFF181818),
                width: 3,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20 * scaleWidth),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Дата и чекбокс
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.hike.date,
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 24 * scaleWidth,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111111),
                          ),
                        ),
                        _buildGoingToggle(scaleWidth, scaleHeight),
                      ],
                    ),

                    SizedBox(height: 16 * scaleHeight),

                    // Название
                    Text(
                      widget.hike.title,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 24 * scaleWidth,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111111),
                      ),
                    ),

                    SizedBox(height: 12 * scaleHeight),

                    // Время и место
                    Text(
                      '${widget.hike.date}.24 в ${widget.hike.time} ${widget.hike.meetingPoint}',
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 16 * scaleWidth,
                        color: const Color(0xFF252525),
                      ),
                    ),

                    SizedBox(height: 16 * scaleHeight),

                    // Полное описание
                    Text(
                      widget.hike.fullDescription,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 16 * scaleWidth,
                        color: const Color(0xFF252525),
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 24 * scaleHeight),

                    // Участники
                    Row(
                      children: [
                        // Аватарки участников (заглушки)
                        ...List.generate(
                          4,
                          (index) => Container(
                            margin: EdgeInsets.only(right: 4 * scaleWidth),
                            width: 36 * scaleWidth,
                            height: 36 * scaleWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 20 * scaleWidth,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8 * scaleHeight),

                    Text(
                      'Идут ${widget.hike.participantsCount} человек',
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 16 * scaleWidth,
                        color: const Color(0xFF53C25A),
                      ),
                    ),

                    // Капитаны (заглушка)
                    Text(
                      '+ Капитаны',
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 14 * scaleWidth,
                        color: const Color(0xFF888888),
                      ),
                    ),

                    SizedBox(height: 24 * scaleHeight),

                    // Кнопки Чат и Карта
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          'Чат встречи',
                          'assets/icons/Эко Друг/telegram 1.png',
                          const Color(0xFF3DB5E5),
                          scaleWidth,
                          scaleHeight,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Телеграм чат в разработке')),
                            );
                          },
                        ),
                        _buildActionButton(
                          'Карта',
                          'assets/icons/Эко Друг/mapMark.png',
                          const Color(0xFF53C25A),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoingToggle(double scaleWidth, double scaleHeight) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isGoing = !_isGoing;
        });
      },
      child: Row(
        children: [
          Text(
            _isGoing ? 'Пойду' : 'Не пойду',
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 16 * scaleWidth,
              color: _isGoing ? const Color(0xFF53C25A) : const Color(0xFF888888),
            ),
          ),
          SizedBox(width: 8 * scaleWidth),
          Container(
            width: 28 * scaleWidth,
            height: 28 * scaleWidth,
            decoration: BoxDecoration(
              color: _isGoing ? const Color(0xFF53C25A) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF181818),
                width: 2,
              ),
            ),
            child: _isGoing
                ? Icon(
                    Icons.check,
                    size: 18 * scaleWidth,
                    color: Colors.white,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    String iconPath,
    Color iconBgColor,
    double scaleWidth,
    double scaleHeight, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Neucha',
              fontSize: 16 * scaleWidth,
              color: const Color(0xFF111111),
            ),
          ),
          SizedBox(width: 8 * scaleWidth),
          Container(
            width: 40 * scaleWidth,
            height: 40 * scaleWidth,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF181818),
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(iconPath.contains('telegram') ? 8 * scaleWidth : 6 * scaleWidth),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
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
            isActive: true,
            onTap: () {
              widget.onToggleGoing(_isGoing);
              Navigator.pop(context);
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
    bool isActive = false,
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
