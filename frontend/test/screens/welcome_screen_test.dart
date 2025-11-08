import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecodrug_frontend/screens/welcome_screen.dart';
import 'package:ecodrug_frontend/widgets/decorative/bear_mascot.dart';

void main() {
  group('Welcome Screen - Smoke Tests', () {
    testWidgets('Smoke: Welcome screen displays correctly', (WidgetTester tester) async {
      // Set a larger screen size to prevent overflow in tests
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify bear mascot is visible
      expect(find.byType(BearMascot), findsOneWidget);

      // Verify main buttons
      expect(find.text('Вход по email'), findsOneWidget);
      expect(find.text('Вход по VC ID'), findsOneWidget);

      // Verify registration text and link
      expect(find.text('У вас нет аккаунта?'), findsOneWidget);
      expect(find.text('Регистрация'), findsOneWidget);

      // Reset to default size
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Smoke: Login button is tappable', (WidgetTester tester) async {
      // Set a larger screen size to prevent overflow
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: const WelcomeScreen(),
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.text('Вход по email');
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('Login Screen'), findsOneWidget);

      // Reset to default size
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
