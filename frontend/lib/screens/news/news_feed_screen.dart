import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/news_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/theme.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  Future<void> _refreshNews() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchNews();
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
            color: const Color(0xFFED8D8C),
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

                    // ========== ЛЕНТА НОВОСТЕЙ (ОБЫЧНЫЙ СКРОЛЛ С PULL-TO-REFRESH) ==========
                    Expanded(
                      child: Consumer<NewsProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading && provider.newsList.isEmpty) {
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

                          // RefreshIndicator для pull-to-refresh
                          return RefreshIndicator(
                            onRefresh: _refreshNews,
                            color: const Color(0xFF181818),
                            backgroundColor: Colors.white,
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                left: 13 * scaleWidth,
                                right: 13 * scaleWidth,
                                bottom: 20 * scaleHeight,
                              ),
                              itemCount: provider.newsList.length,
                              itemBuilder: (context, index) {
                                final news = provider.newsList[index];
                                
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 18 * scaleHeight,
                                  ),
                                  child: _NewsCard(
                                    news: news,
                                    scaleWidth: scaleWidth,
                                    scaleHeight: scaleHeight,
                                  ),
                                );
                              },
                            ),
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

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF181818),
          width: 4,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ТЕКСТ СЛЕВА
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14 * scaleWidth,
                  vertical: 14 * scaleHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    if (cityTag.isNotEmpty) SizedBox(height: 4 * scaleHeight),
                    Text(
                      news.title,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 16 * scaleWidth,
                        height: 20 / 16,
                        letterSpacing: 0.06 * 16 * scaleWidth,
                        color: const Color(0xFF222222),
                      ),
                      maxLines: hasExcerpt ? 4 : 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasExcerpt) ...[
                      SizedBox(height: 8 * scaleHeight),
                      Text(
                        news.excerpt!,
                        style: TextStyle(
                          fontFamily: 'Neucha',
                          fontSize: 14 * scaleWidth,
                          height: 16 / 14,
                          letterSpacing: 0.06 * 14 * scaleWidth,
                          color: const Color(0xFFFF3C3A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // ИЗОБРАЖЕНИЕ СПРАВА
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(21),
                bottomRight: Radius.circular(21),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: news.thumbnail != null
                  ? Image.network(
                      news.thumbnail!,
                      width: 130 * scaleWidth,
                      fit: BoxFit.cover,
                      cacheWidth: 260, // Кэширование для производительности
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 130 * scaleWidth,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
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
      width: 130 * scaleWidth,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 40 * scaleWidth,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
