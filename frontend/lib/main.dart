import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/education_provider.dart';
import 'providers/news_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/courses/courses_screen.dart';
import 'screens/education/education_hub_screen.dart';
import 'screens/education/basic_courses_screen.dart';
import 'screens/education/additional_courses_screen.dart';
import 'screens/education/film_list_screen.dart';
import 'screens/education/course_detail_screen.dart';
import 'screens/education/quiz_screen.dart';
import 'screens/education/quiz_result_screen.dart';
import 'screens/news/news_feed_screen.dart';
import 'screens/news/news_detail_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/eco_hikes/eco_hikes_screen.dart';
import 'screens/achievements/achievements_screen.dart';
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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/courses': (context) => const CoursesScreen(),
          '/education': (context) => const EducationHubScreen(),
          '/courses/basic': (context) => const BasicCoursesScreen(),
          '/courses/additional': (context) => const AdditionalCoursesScreen(),
          '/films': (context) => const FilmListScreen(),
          '/news': (context) => const NewsFeedScreen(),
          '/map': (context) => const MapScreen(),
          '/eco-hikes': (context) => const EcoHikesScreen(),
          '/achievements': (context) => const AchievementsScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle routes with parameters
          if (settings.name == '/news-detail') {
            final newsId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => NewsDetailScreen(newsId: newsId),
            );
          }
          
          // Course detail route
          if (settings.name == '/course-detail') {
            final courseId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => CourseDetailScreen(courseId: courseId),
            );
          }
          
          // Quiz route
          if (settings.name == '/quiz') {
            final args = settings.arguments as Map<String, dynamic>;
            final courseId = args['courseId'] as String;
            final quizId = args['quizId'] as String;
            return MaterialPageRoute(
              builder: (context) => QuizScreen(
                courseId: courseId,
                quizId: quizId,
              ),
            );
          }
          
          // Quiz result route
          if (settings.name == '/quiz-result') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => QuizResultScreen(
                score: args['score'] as int,
                totalQuestions: args['total'] as int,
                earnedPoints: args['points'] as int,
                courseId: args['courseId'] as String,
                quizId: args['quizId'] as String,
              ),
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
          // Navigate to profile if authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/profile');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // Navigate to welcome screen if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/welcome');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

