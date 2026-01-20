import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    
    // Инициализация WebView контроллера
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Скрыть шапку сайта после загрузки
            _hideHeader();
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://recyclemap.ru/'));
    
    // Загрузить профиль
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  // Скрыть шапку сайта recyclemap.ru
  void _hideHeader() {
    _controller.runJavaScript('''
      (function() {
        // Скрыть header/navbar
        var header = document.querySelector('header');
        if (header) header.style.display = 'none';
        
        var navbar = document.querySelector('.navbar');
        if (navbar) navbar.style.display = 'none';
        
        var nav = document.querySelector('nav');
        if (nav) nav.style.display = 'none';
        
        // Попробовать найти элементы по классам recyclemap
        var topBar = document.querySelector('.top-bar');
        if (topBar) topBar.style.display = 'none';
        
        var headerContainer = document.querySelector('.header-container');
        if (headerContainer) headerContainer.style.display = 'none';
        
        // Скрыть элементы с логотипом
        var logo = document.querySelector('.logo');
        if (logo) logo.style.display = 'none';
        
        // Скрыть меню-бургер
        var burger = document.querySelector('.burger-menu');
        if (burger) burger.style.display = 'none';
        
        // Попытка найти контейнер с шапкой по общим селекторам
        var selectors = [
          '[class*="header"]',
          '[class*="Header"]', 
          '[class*="navbar"]',
          '[class*="Navbar"]',
          '[class*="top-bar"]',
          '[class*="topbar"]',
          '.MuiAppBar-root',
          '#header',
          '#navbar'
        ];
        
        selectors.forEach(function(sel) {
          try {
            var elements = document.querySelectorAll(sel);
            elements.forEach(function(el) {
              // Проверяем, что это действительно шапка (находится вверху)
              var rect = el.getBoundingClientRect();
              if (rect.top <= 100 && rect.height < 150) {
                el.style.display = 'none';
              }
            });
          } catch(e) {}
        });
        
        // Убрать отступ сверху у основного контента
        var main = document.querySelector('main');
        if (main) main.style.marginTop = '0';
        
        var mapContainer = document.querySelector('.map-container');
        if (mapContainer) mapContainer.style.marginTop = '0';
        
        document.body.style.paddingTop = '0';
        document.body.style.marginTop = '0';
      })();
    ''');
  }

  // Увеличить масштаб
  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.2).clamp(0.5, 3.0);
    });
    _controller.runJavaScript(
      'document.body.style.zoom = ${_zoomLevel.toStringAsFixed(2)};'
    );
  }

  // Уменьшить масштаб
  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.2).clamp(0.5, 3.0);
    });
    _controller.runJavaScript(
      'document.body.style.zoom = ${_zoomLevel.toStringAsFixed(2)};'
    );
  }

  // Сброс масштаба (двойной тап)
  void _resetZoom() {
    setState(() {
      _zoomLevel = _zoomLevel == 1.0 ? 1.5 : 1.0;
    });
    _controller.runJavaScript(
      'document.body.style.zoom = ${_zoomLevel.toStringAsFixed(2)};'
    );
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
            color: const Color(0xFFFAD188), // Желтый цвет для карты
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
                                      color: const Color(0xFFFAD188),
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
                    ),

                    SizedBox(height: 20 * scaleHeight),

                    // ========== WEBVIEW С КАРТОЙ ==========
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 34 * scaleWidth,
                          right: 34 * scaleWidth,
                          bottom: 0,
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onDoubleTap: _resetZoom,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: const Color(0xFF181818),
                                    width: 4,
                                  ),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21),
                                  child: WebViewWidget(
                                    controller: _controller,
                                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                      Factory<VerticalDragGestureRecognizer>(
                                        () => VerticalDragGestureRecognizer(),
                                      ),
                                      Factory<HorizontalDragGestureRecognizer>(
                                        () => HorizontalDragGestureRecognizer(),
                                      ),
                                      Factory<ScaleGestureRecognizer>(
                                        () => ScaleGestureRecognizer(),
                                      ),
                                      Factory<TapGestureRecognizer>(
                                        () => TapGestureRecognizer(),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ),
                            
                            // Кнопки управления масштабом
                            Positioned(
                              right: 16 * scaleWidth,
                              bottom: 16 * scaleHeight,
                              child: Column(
                                children: [
                                  // Кнопка Zoom In
                                  GestureDetector(
                                    onTap: _zoomIn,
                                    child: Container(
                                      width: 50 * scaleWidth,
                                      height: 50 * scaleHeight,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFAD188),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF181818),
                                          width: 3,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 30 * scaleWidth,
                                        color: const Color(0xFF181818),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10 * scaleHeight),
                                  // Кнопка Zoom Out
                                  GestureDetector(
                                    onTap: _zoomOut,
                                    child: Container(
                                      width: 50 * scaleWidth,
                                      height: 50 * scaleHeight,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFAD188),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF181818),
                                          width: 3,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 30 * scaleWidth,
                                        color: const Color(0xFF181818),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Индикатор загрузки
                            if (_isLoading)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Color(0xFFFAD188),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Загрузка карты...',
                                        style: TextStyle(
                                          fontFamily: 'Neucha',
                                          fontSize: 16 * scaleWidth,
                                          color: const Color(0xFF111111),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10 * scaleHeight),

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
              // Текущий экран
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
    double scaleHeight,
    {required VoidCallback onTap}
  ) {
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
            child: iconPath.endsWith('.svg')
                ? SvgPicture.asset(
                    iconPath,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    iconPath,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
