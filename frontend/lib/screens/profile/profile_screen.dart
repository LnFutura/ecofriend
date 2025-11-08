import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../utils/theme.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/decorative/paw_prints_background.dart';
import '../../widgets/decorative/figma_button.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getMyProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Профиль - последняя вкладка (но в новом дизайне нет вкладки профиля)
        onTap: (index) {
          // Навигация между разделами
          switch (index) {
            case 0:
              // Экопоходы (События)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экопоходы - в разработке')),
              );
              break;
            case 1:
              // Обучение
              Navigator.of(context).pushNamed('/courses');
              break;
            case 2:
              // Новости
              Navigator.of(context).pushNamed('/news');
              break;
            case 3:
              // Карта
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Карта - в разработке')),
              );
              break;
          }
        },
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Загрузка профиля...')
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                )
              : PawPrintsBackground(
                  backgroundColor: AppTheme.screenBlue,
                  child: Column(
                    children: [
                      // Верхняя панель с заголовком, уведомлениями и кнопкой выхода
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ЭкоДруг',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Row(
                                children: [
                                  // Кнопка уведомлений
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.textDark, width: 2),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Уведомления - в разработке')),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Icon(
                                          Icons.notifications,
                                          color: AppTheme.textDark,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Кнопка "Выйти"
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppTheme.errorRed,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.textDark, width: 2),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          await authProvider.logout();
                                          if (!mounted) return;
                                          Navigator.of(context).pushReplacementNamed('/welcome');
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Основной контент с прокруткой
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadProfile,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                            
                            // Заголовок и email
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _profile?.fullName ?? authProvider.user?.username ?? 'Пользователь',
                                      style: Theme.of(context).textTheme.headlineLarge,
                                    ),
                                    Text(
                                      authProvider.user?.email ?? '',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                // Аватар с иконкой настроек
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.textDark,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: _profile?.avatar != null
                                            ? NetworkImage(_profile!.avatar!)
                                            : null,
                                        child: _profile?.avatar == null
                                            ? const Icon(Icons.person, size: 35)
                                            : null,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () async {
                                          await authProvider.logout();
                                          if (!mounted) return;
                                          Navigator.of(context).pushReplacementNamed('/welcome');
                                        },
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryPurple,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppTheme.textDark,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.settings,
                                            color: AppTheme.textDark,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Кнопки редактирования с иконками карандаша
                            _buildEditButton(
                              context,
                              'Изменить имя',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Редактирование имени - в разработке')),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildEditButton(
                              context,
                              'Изменить почту',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Редактирование почты - в разработке')),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildEditButton(
                              context,
                              'Изменить пароль',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Изменение пароля - в разработке')),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Текст и достижения
                            Text(
                              'Вы прошли все основные и\nдополнительные курсы и\nпоучаствовали в 3 экопоходах',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Кнопка достижений с иконкой
                            _buildIconButton(
                              context,
                              'Достижения',
                              Icons.emoji_events,
                              AppTheme.primaryPurple,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Экран достижений - в разработке')),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Кнопка званий с иконкой
                            _buildIconButton(
                              context,
                              'Звания',
                              Icons.star,
                              AppTheme.primaryGreen,
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Экран званий - в разработке')),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Вспомогательный виджет для кнопок редактирования с иконкой карандаша
  Widget _buildEditButton(BuildContext context, String text, VoidCallback onPressed) {
    return Row(
    children: [
      Expanded(
        child: FigmaButton(
          text: text,
          onPressed: onPressed,
        ),
      ),
      const SizedBox(width: 12),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.textDark, width: 2),
        ),
        child: const Icon(
          Icons.edit,
          color: AppTheme.textDark,
          size: 20,
        ),
      ),
    ],
    );
  }

  // Вспомогательный виджет для кнопок с иконками (Достижения, Звания)
  Widget _buildIconButton(
    BuildContext context,
    String text,
    IconData icon,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return Container(
    width: 200,
    height: 50,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppTheme.textDark, width: 2),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.textDark, size: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Neucha',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

