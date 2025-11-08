import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecodrug_frontend/providers/auth_provider.dart';
import 'package:ecodrug_frontend/screens/auth/register_screen.dart';

void main() {
  group('Register Screen - Widget Tests', () {
    testWidgets('Widget: Continue button appears dynamically after typing', (WidgetTester tester) async {
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

      // Initially, "Продолжить" button should NOT be visible
      expect(find.text('Продолжить'), findsNothing);

      // Find email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      // Type ONLY in email field (валидный email)
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump(); // Trigger rebuild

      // Button should NOT appear (нужен еще и валидный пароль)
      expect(find.text('Продолжить'), findsNothing);

      // Now type valid password
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // NOW button SHOULD be visible (оба поля валидны)
      expect(find.text('Продолжить'), findsOneWidget);

      // Clear the password field
      await tester.enterText(passwordField, '');
      await tester.pump();

      // Button should disappear again
      expect(find.text('Продолжить'), findsNothing);

      // Enter short password (invalid)
      await tester.enterText(passwordField, '12345');
      await tester.pump();

      // Button should NOT appear (пароль слишком короткий)
      expect(find.text('Продолжить'), findsNothing);
    });

    testWidgets('Widget: Register screen has all required UI elements', (WidgetTester tester) async {
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

      // Verify cloud with text
      expect(find.text('Друг, введи\nданные,\nпожалуйста!'), findsOneWidget);

      // Verify form fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Телефон или email'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);

      // Verify password visibility toggle
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Verify back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify bear mascot is present
      // Note: BearMascot widget should be visible
    });
  });
}

