import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecodrug_frontend/providers/auth_provider.dart';
import 'package:ecodrug_frontend/screens/auth/login_screen.dart';

void main() {
  group('EcoDrug App Widget Tests', () {
    testWidgets('App should initialize and show login screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
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

      // Verify that login screen elements are present
      expect(find.text('Вход'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('Login screen has email and password fields', (WidgetTester tester) async {
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

      // Should find text fields for email and password
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeast(2));
    });

    testWidgets('Login screen has login button', (WidgetTester tester) async {
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

      // Should find elevated button for login
      expect(find.byType(ElevatedButton), findsWidgets);
    });
  });

  group('Validators Tests', () {
    test('Email validator should validate correct emails', () {
      // Test email validation logic
      final validEmails = [
        'test@example.com',
        'user123@domain.ru',
        'name.surname@company.co.uk',
      ];

      for (final email in validEmails) {
        final isValid = _isValidEmail(email);
        expect(isValid, true, reason: '$email should be valid');
      }
    });

    test('Email validator should reject invalid emails', () {
      final invalidEmails = [
        'notanemail',
        '@domain.com',
        'user@',
        'user @domain.com',
      ];

      for (final email in invalidEmails) {
        final isValid = _isValidEmail(email);
        expect(isValid, false, reason: '$email should be invalid');
      }
    });
  });
}

// Helper function for email validation
bool _isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
