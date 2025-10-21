import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// Импорты из нашего приложения
import 'package:ecofriend/main.dart';           // замени your_project_name на name из pubspec.yaml
import 'package:ecofriend/auth/auth_repository.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Используем мок-репозиторий, чтобы не дергать сеть
    final app = EcoFriendApp(authRepo: MockAuthRepository());

    await tester.pumpWidget(app);

    // Проверим, что заголовок бренда виден
    expect(find.text('ЭкоДруг'), findsOneWidget);

    // Поля Email/Пароль отображаются
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
