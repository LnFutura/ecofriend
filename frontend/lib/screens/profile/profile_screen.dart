import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile/avatar_widget.dart';
import '../../utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Загрузить профиль при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      // Сбросить весь state провайдера перед загрузкой
      profileProvider.reset();
      profileProvider.loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleWidth = size.width / 375;
    final scaleHeight = size.height / 812;

    return Scaffold(
      body: Consumer2<ProfileProvider, AuthProvider>(
        builder: (context, profileProvider, authProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ошибка загрузки профиля',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => profileProvider.loadProfile(),
                    child: Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final profile = profileProvider.profile;
          if (profile == null) {
            return const Center(child: Text('Профиль не найден'));
          }

          // Получить email из authProvider
          final email = authProvider.user?.email ?? 'user@example.com';
          final displayName = profile.fullName ?? authProvider.user?.username ?? 'Пользователь';

          return Stack(
            children: [
              // Фон
              Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  color: Color(0xFF65C6E9), // Цвет из Figma
                ),
              ),
              
              // Нижняя правая лапка (за пределами SafeArea, чтобы не обрезалась)
              Positioned(
                left: 78 * scaleWidth,
                bottom: -50 * scaleHeight, // Используем bottom вместо top для точного позиционирования
                child: Transform.rotate(
                  angle: (-31.25 - 30) * 3.14159 / 180,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/icons/Эко Друг/bear-pawprint 7.png',
                      width: 325 * scaleWidth,
                      height: 325 * scaleHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Основной контент с SafeArea
              SafeArea(
                child: Stack(
                  children: [
                    // Декоративные лапки медведя на фоне
                    // Лапка 9 (левая верхняя)
                    Positioned(
                      left: -55 * scaleWidth,
                      top: -4 * scaleHeight,
                      child: Transform.rotate(
                        angle: 14.69 * 3.14159 / 180, // конвертация в радианы
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            'assets/icons/Эко Друг/bear-pawprint 7.png',
                            width: 217.64 * scaleWidth,
                            height: 217.64 * scaleHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  
                  // Основной контент
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20 * scaleWidth,
                        right: 20 * scaleWidth,
                        top: 20 * scaleHeight,
                        bottom: 100 * scaleHeight, // Отступ для нижней панели
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Шапка: Имя + Email слева, Аватар справа
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 16 * scaleWidth), // Увеличен отступ слева
                              // Имя и Email
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 32 * scaleWidth, // Увеличен размер
                                        fontWeight: FontWeight.normal, // Убрано жирное выделение
                                        color: const Color(0xFF111111),
                                      ),
                                    ),
                                    SizedBox(height: 8 * scaleHeight),
                                    Text(
                                      email,
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 20 * scaleWidth, // Увеличен размер
                                        color: const Color(0xFF252525),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(width: 12 * scaleWidth),
                              
                              // Аватар (узкий но широкий прямоугольник)
                              AvatarWidget(
                                avatarUrl: profile.avatar,
                                displayName: displayName,
                                width: 90 * scaleWidth,  // Увеличена ширина
                                height: 101 * scaleHeight, // Высота прежняя
                                onEditTap: () {
                                  profileProvider.showImageSourceDialog(context);
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 24 * scaleHeight),

                          // Кнопки редактирования с карандашиком рядом
                          _buildEditButtonWithIcon(
                            context,
                            'Изменить имя',
                            scaleWidth,
                            scaleHeight,
                            onTap: () => _showEditNameDialog(context, profileProvider, displayName),
                          ),

                          SizedBox(height: 20 * scaleHeight),

                          _buildEditButtonWithIcon(
                            context,
                            'Изменить почту',
                            scaleWidth,
                            scaleHeight,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Функция в разработке')),
                              );
                            },
                          ),

                          SizedBox(height: 20 * scaleHeight),

                          _buildEditButtonWithIcon(
                            context,
                            'Изменить пароль',
                            scaleWidth,
                            scaleHeight,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Функция в разработке')),
                              );
                            },
                          ),

                          SizedBox(height: 32 * scaleHeight),

                          // Текст достижений с форматированием (увеличен отступ слева)
                          Padding(
                            padding: EdgeInsets.only(left: 18 * scaleWidth), // Увеличен отступ слева
                            child: Container(
                              width: size.width - 58 * scaleWidth, // Растянуть на всю ширину с учетом padding
                              child: profileProvider.hasAchievements()
                                  ? RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Neucha',
                                          fontSize: 18 * scaleWidth, // Увеличен размер
                                          color: const Color(0xFF252525),
                                          height: 1.1,
                                          letterSpacing: 0.08 * 18 * scaleWidth,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Вы прошли все '),
                                          TextSpan(
                                            text: 'основные и\nдополнительные',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(text: ' курсы и\nпоучаствовали в '),
                                          TextSpan(
                                            text: '3 экопоходах',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      profileProvider.getAchievementText(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 18 * scaleWidth,
                                        color: const Color(0xFF252525),
                                        height: 1.1,
                                        letterSpacing: 0.08 * 18 * scaleWidth,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 32 * scaleHeight),

                          // Кнопки "Достижения" и "Звания" друг под другом с иконками справа
                          _buildVerticalButtonWithIcon(
                            context,
                            'Достижения',
                            const Color(0xFFBC9CEA), // Фиолетовый из Figma
                            'assets/icons/Эко Друг/profilestudyicon.png', // Правильная иконка
                            196 * scaleWidth, // Ширина Достижений
                            scaleWidth,
                            scaleHeight,
                            onTap: () {
                              // Пока не кликабельно
                            },
                          ),

                          SizedBox(height: 24 * scaleHeight),

                          _buildVerticalButtonWithIcon(
                            context,
                            'Звания',
                            const Color(0xFF53C25A), // Зеленый из Figma
                            'assets/icons/Эко Друг/profilesmalliconstar.png', // Правильная иконка
                            134 * scaleWidth, // Ширина Званий (меньше чем Достижения)
                            scaleWidth,
                            scaleHeight,
                            onTap: () {
                              // Пока не кликабельно
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Нижняя панель навигации (вынесена за пределы SafeArea)
            Positioned(
              bottom: 40 * scaleHeight, // Увеличен отступ от низа экрана
              left: 0,
              right: 0,
              child: _buildBottomNavigationBar(scaleWidth, scaleHeight),
            ),
          ],
          );
        },
      ),
    );
  }

  /// Кнопка редактирования с карандашиком рядом (с двойной границей как в Figma)
  Widget _buildEditButtonWithIcon(
    BuildContext context,
    String text,
    double scaleWidth,
    double scaleHeight, {
    required VoidCallback onTap,
  }) {
    // Разная ширина для первой кнопки
    final bool isFirstButton = text == 'Изменить имя';
    final buttonWidth = isFirstButton ? 174 * scaleWidth : 192 * scaleWidth; // Первая кнопка уже
    
    return Row(
      children: [
        // Кнопка с двойной границей (фиолетовая тень + голубая кнопка)
        Container(
          width: buttonWidth,
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                // Фиолетовая тень (задний слой)
                Positioned(
                  left: 2 * scaleWidth,
                  top: 2 * scaleHeight,
                  child: Container(
                    width: buttonWidth,
                    height: 42 * scaleHeight, // Уменьшена высота
                    decoration: BoxDecoration(
                      color: const Color(0xFFBC9CEA), // Фиолетовый
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF181818), width: 3),
                    ),
                  ),
                ),
                // Голубая кнопка (передний слой)
                Container(
                  width: buttonWidth,
                  height: 42 * scaleHeight, // Уменьшена высота
                  decoration: BoxDecoration(
                    color: const Color(0xFF41BBE8), // Голубой
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF181818), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 20 * scaleWidth,
                        color: const Color(0xFF111111),
                        letterSpacing: 0.06 * 20 * scaleWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16 * scaleWidth),
        // Карандашик
        Image.asset(
          'assets/icons/Эко Друг/pen 1.png',
          width: 26 * scaleWidth,
          height: 26 * scaleHeight,
        ),
      ],
    );
  }

  /// Кнопка с иконкой справа (Достижения/Звания) с двойной границей
  Widget _buildVerticalButtonWithIcon(
    BuildContext context,
    String text,
    Color color,
    String iconPath,
    double buttonWidth, // Ширина как параметр
    double scaleWidth,
    double scaleHeight, {
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        // Кнопка с двойной границей (черная тень + цветная кнопка)
        Container(
          width: buttonWidth, // Используем переданную ширину
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                // Черная тень (задний слой)
                Positioned(
                  left: 2 * scaleWidth,
                  top: 2 * scaleHeight,
                  child: Container(
                    width: buttonWidth,
                    height: 54 * scaleHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF181818), // Черный
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                // Цветная кнопка (передний слой)
                Container(
                  width: buttonWidth,
                  height: 54 * scaleHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF181818), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Neucha',
                        fontSize: 24 * scaleWidth,
                        color: const Color(0xFF111111),
                        letterSpacing: 0.06 * 24 * scaleWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16 * scaleWidth),
        // Иконка справа БЕЗ двойной границы (только цветная иконка)
        Container(
          width: 54 * scaleWidth,
          height: 54 * scaleHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            // border убран
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Теперь равен основному
            child: Image.asset(
              iconPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  /// Нижняя панель навигации (4 кнопки)
  Widget _buildBottomNavigationBar(double scaleWidth, double scaleHeight) {
    return Container(
      height: 90 * scaleHeight, // Увеличена высота под новый размер иконок
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleWidth, vertical: 10 * scaleHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(
            'assets/icons/Эко Друг/экопоходы.svg',
            const Color(0xFF6FCF6F), // Яркий зеленый
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
            const Color(0xFFA77FC7), // Яркий фиолетовый
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/courses');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/новости.svg',
            const Color(0xFFEF7C6F), // Яркий красно-оранжевый
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/news');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/карта.svg',
            const Color(0xFFFFD166), // Яркий желтый
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

  /// Иконка навигации с цветным фоном (БЕЗ двойной обводки)
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
          // border убран
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Теперь равен основному
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Диалог для изменения имени
  void _showEditNameDialog(BuildContext context, ProfileProvider provider, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить имя'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите новое имя',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != currentName) {
                final success = await provider.updateName(newName);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Имя успешно изменено'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage ?? 'Ошибка изменения имени'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
