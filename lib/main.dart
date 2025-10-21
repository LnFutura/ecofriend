import 'package:flutter/material.dart';
import 'auth/auth_repository.dart';
import 'screens/auth_gateway_screen.dart';
import 'screens/home_screen.dart';

void main() {
  final authRepo = provideAuthRepository(); // mock сейчас включён
  runApp(EcoFriendApp(authRepo: authRepo));
}

class EcoFriendApp extends StatelessWidget {
  const EcoFriendApp({super.key, required this.authRepo});
  final AuthRepository authRepo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЭкоДруг',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        fontFamily: 'Neucha',
      ),
      routes: {
        '/': (ctx) => AuthGatewayScreen(authRepo: authRepo),
        '/home': (ctx) => const HomeScreen(),
      },
    );
  }
}
