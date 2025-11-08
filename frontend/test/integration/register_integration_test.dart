import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecodrug_frontend/providers/auth_provider.dart';
import 'package:ecodrug_frontend/screens/auth/register_screen.dart';

void main() {
  group('Register Screen - Integration Tests', () {
    testWidgets('Integration: Successful registration flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
            ],
            child: const RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state - no button visible
      expect(find.text('Продолжить'), findsNothing);

      // Verify initial cloud text
      expect(find.text('Друг, введи\nданные,\nпожалуйста!'), findsOneWidget);

      // Find email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      // Enter registration data - сначала email
      await tester.enterText(emailField, 'newuser@test.com');
      await tester.pumpAndSettle();

      // Button should NOT appear yet (нужен еще и пароль)
      expect(find.text('Продолжить'), findsNothing);

      // Теперь вводим пароль
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Button should appear after both fields are valid
      expect(find.text('Продолжить'), findsOneWidget);

      // Tap register button
      final registerButton = find.text('Продолжить');
      await tester.tap(registerButton);
      await tester.pump();

      // Wait for API call
      await tester.pump(const Duration(seconds: 2));

      // Note: Cloud text change to "Добро пожаловать!" happens during submission
      // Full verification requires backend to be running
    });
  });
}

