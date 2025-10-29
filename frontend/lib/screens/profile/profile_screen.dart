import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/loading_indicator.dart';

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
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await authProvider.logout();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Выйти'),
                  ],
                ),
              ),
            ],
          ),
        ],
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
              : RefreshIndicator(
                  onRefresh: _loadProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Profile header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                backgroundImage: _profile?.avatar != null
                                    ? NetworkImage(_profile!.avatar!)
                                    : null,
                                child: _profile?.avatar == null
                                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _profile?.fullName ?? authProvider.user?.username ?? 'Пользователь',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${authProvider.user?.username ?? ""}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (_profile?.bio != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _profile!.bio!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Stats
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StatItem(
                                icon: Icons.star,
                                label: 'Баллы',
                                value: _profile?.points.toString() ?? '0',
                                color: Colors.amber,
                              ),
                              _StatItem(
                                icon: Icons.trending_up,
                                label: 'Уровень',
                                value: _profile?.level.toString() ?? '1',
                                color: Colors.green,
                              ),
                              _StatItem(
                                icon: Icons.emoji_events,
                                label: 'Достижения',
                                value: _profile?.achievements.length.toString() ?? '0',
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),

                        const Divider(),

                        // Menu items
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Редактировать профиль'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // TODO: Navigate to edit profile (Фаза 4)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Доступно в Фазе 4')),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.emoji_events),
                          title: const Text('Мои достижения'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // TODO: Navigate to achievements (Фаза 6)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Доступно в Фазе 6')),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text('Пройденные курсы'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // TODO: Navigate to completed courses (Фаза 4)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Доступно в Фазе 4')),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.leaderboard),
                          title: const Text('Таблица лидеров'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // TODO: Navigate to leaderboard (Фаза 4)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Доступно в Фазе 4')),
                            );
                          },
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

