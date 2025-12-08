import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/profile/avatar_widget.dart';
import '../../utils/theme.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleWidth = size.width / 390;
    final scaleHeight = size.height / 844;

    return Scaffold(
      body: Stack(
        children: [
          // ========== ФОН ==========
          Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFED8D8C),
          ),

          // ========== ЛАПКА МЕДВЕДЯ ВЕРХНЯЯ ЛЕВАЯ ==========
          Positioned(
            left: -48 * scaleWidth,
            top: 2 * scaleHeight,
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

          // ========== ЛАПКА МЕДВЕДЯ НИЖНЯЯ ПРАВАЯ ==========
          Positioned(
            left: 97 * scaleWidth,
            top: 507 * scaleHeight,
            child: Transform.rotate(
              angle: -31.25 * 3.14159 / 180,
              child: Opacity(
                opacity: 0.2,
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
            child: Column(
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
                      // Email пользователя
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

                      // ========== АВАТАР + КНОПКА НАСТРОЕК ==========
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Используем готовый AvatarWidget
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
                                            '${profileProvider.profile!.avatar}',
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

                          // Кнопка настроек (шестеренка) - переход в профиль
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
                                  color: const Color(0xFFE57F7E),
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

                // ========== ЗАГОЛОВОК "НОВОСТИ" ==========
                Padding(
                  padding: EdgeInsets.only(left: 34 * scaleWidth),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Новости',
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

                // ========== ЛЕНТА НОВОСТЕЙ ==========
                Expanded(
                  child: Consumer<NewsProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      if (provider.newsList.isEmpty) {
                        return Center(
                          child: Text(
                            'Новостей пока нет',
                            style: TextStyle(
                              fontFamily: 'Neucha',
                              fontSize: 18 * scaleWidth,
                              color: const Color(0xFF111111),
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          // Список новостей
                          ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              left: 13 * scaleWidth,
                              right: 13 * scaleWidth,
                              bottom: 120 * scaleHeight,
                            ),
                            itemCount: provider.newsList.length,
                            itemBuilder: (context, index) {
                              final news = provider.newsList[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20 * scaleHeight),
                                child: _NewsCard(
                                  news: news,
                                  scaleWidth: scaleWidth,
                                  scaleHeight: scaleHeight,
                                ),
                              );
                            },
                          ),

                          // ========== ИНДИКАТОР ПРОКРУТКИ (ФУНКЦИОНАЛЬНЫЙ) ==========
                          if (provider.newsList.length > 2)
                            Positioned(
                              left: 176 * scaleWidth,
                              bottom: 100 * scaleHeight,
                              child: _ScrollIndicator(
                                scaleWidth: scaleWidth,
                                scaleHeight: scaleHeight,
                                onScrollUp: () {
                                  _scrollController.animateTo(
                                    _scrollController.offset - 200,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                onScrollDown: () {
                                  _scrollController.animateTo(
                                    _scrollController.offset + 200,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                // ========== НИЖНЯЯ НАВИГАЦИЯ ==========
                _buildBottomNavigationBar(scaleWidth, scaleHeight),
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
              Navigator.of(context).pushNamed('/courses');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/новости.svg',
            const Color(0xFFE57F7E),
            scaleWidth,
            scaleHeight,
            onTap: () {},
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

// ========== КАРТОЧКА НОВОСТИ ==========
class _NewsCard extends StatelessWidget {
  final dynamic news;
  final double scaleWidth;
  final double scaleHeight;

  const _NewsCard({
    required this.news,
    required this.scaleWidth,
    required this.scaleHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cityTag = news.tags.isNotEmpty ? news.tags[0] : '';
    final hasExcerpt = news.excerpt != null && news.excerpt!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/news-detail',
          arguments: news.id,
        );
      },
      child: Container(
        height: 214 * scaleHeight,
        padding: EdgeInsets.all(16 * scaleWidth),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF181818),
            width: 4,
          ),
        ),
        child: Row(
          children: [
            // ТЕКСТ СЛЕВА
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (cityTag.isNotEmpty)
                    Text(
                      'В $cityTag',
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 18 * scaleWidth,
                        height: 20 / 18,
                        letterSpacing: 0.06 * 18 * scaleWidth,
                        color: const Color(0xFFFF3C3A),
                      ),
                    ),
                  SizedBox(height: 8 * scaleHeight),
                  Text(
                    news.title,
                    style: TextStyle(
                      fontFamily: 'Neucha',
                      fontSize: 18 * scaleWidth,
                      height: 20 / 18,
                      letterSpacing: 0.06 * 18 * scaleWidth,
                      color: const Color(0xFF222222),
                    ),
                    maxLines: hasExcerpt ? 3 : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasExcerpt) ...[
                    const Spacer(),
                    Text(
                      news.excerpt!,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 16 * scaleWidth,
                        height: 18 / 16,
                        letterSpacing: 0.06 * 16 * scaleWidth,
                        color: const Color(0xFFFF3C3A),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16 * scaleWidth),
            
            // ИЗОБРАЖЕНИЕ СПРАВА
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: news.thumbnail != null
                  ? Image.network(
                      news.thumbnail!,
                      width: 151 * scaleWidth,
                      height: 171 * scaleHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholderImage();
                      },
                    )
                  : _placeholderImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 151 * scaleWidth,
      height: 171 * scaleHeight,
      color: Colors.grey[300],
      child: Icon(
        Icons.image,
        size: 50 * scaleWidth,
        color: Colors.grey[500],
      ),
    );
  }
}

// ========== ФУНКЦИОНАЛЬНЫЙ СКРОЛЛЕР ==========
class _ScrollIndicator extends StatelessWidget {
  final double scaleWidth;
  final double scaleHeight;
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;

  const _ScrollIndicator({
    required this.scaleWidth,
    required this.scaleHeight,
    required this.onScrollUp,
    required this.onScrollDown,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -180 * 3.14159 / 180,
      child: Container(
        width: 38 * scaleWidth,
        height: 57 * scaleHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: const Color(0xFF181818),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Стрелка вверх
            GestureDetector(
              onTap: onScrollUp,
              child: Transform.rotate(
                angle: 90 * 3.14159 / 180,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16 * scaleWidth,
                  color: const Color(0xFFE57F7E),
                ),
              ),
            ),
            // Стрелка вниз
            GestureDetector(
              onTap: onScrollDown,
              child: Transform.rotate(
                angle: 90 * 3.14159 / 180,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16 * scaleWidth,
                  color: const Color(0xFFE57F7E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
