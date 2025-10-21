import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenArg = ModalRoute.of(context)?.settings.arguments;
    final token = tokenArg is String ? tokenArg : null;

    return Scaffold(
      appBar: AppBar(title: const Text('ЭкоДруг')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Добро пожаловать в ЭкоДруг 🌿'),
            if (token != null) ...[
              const SizedBox(height: 12),
              const Text('Токен (mock):'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  token,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
