import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/education_provider.dart';
import 'providers/news_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/courses/courses_screen.dart';
import 'screens/news/news_feed_screen.dart';
import 'screens/news/news_detail_screen.dart';
import 'services/storage_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.init();
  
  runApp(const EcoDrugApp());
}

class EcoDrugApp extends StatelessWidget {
  const EcoDrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => EducationProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthCheckScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/courses': (context) => const CoursesScreen(),
          '/news': (context) => const NewsFeedScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle routes with parameters
          if (settings.name == '/news-detail') {
            final newsId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => NewsDetailScreen(newsId: newsId),
            );
          }
          return null;
        },
      ),
    );
  }
}

// Check authentication status and route accordingly
class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          // Navigate to home if authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/home');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // Navigate to login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

