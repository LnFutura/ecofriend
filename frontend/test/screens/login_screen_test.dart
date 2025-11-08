import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecodrug_frontend/providers/auth_provider.dart';
import 'package:ecodrug_frontend/screens/auth/login_screen.dart';

void main() {
  group('Login Screen - Widget Tests', () {
    testWidgets('Widget: Login screen displays all required UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
            ],
            child: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify cloud bubble with text is present
      expect(find.text('Друг, введи\nданные,\nпожалуйста!'), findsOneWidget);

      // Verify email and password fields exist
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Телефон или email'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);

      // Verify password visibility toggle icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Verify login button
      expect(find.text('Войти'), findsOneWidget);

      // Verify registration link
      expect(find.text('Регистрация'), findsOneWidget);

      // Verify back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Widget: Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
            ],
            child: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially password should be hidden (visibility_off icon)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap the visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Now password should be visible (visibility icon)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Back to hidden
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}

