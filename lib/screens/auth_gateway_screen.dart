import 'package:flutter/material.dart';
import '../auth/auth_repository.dart';
import 'email_login_screen.dart';

class AuthGatewayScreen extends StatelessWidget {
  const AuthGatewayScreen({super.key, required this.authRepo});
  final AuthRepository authRepo;

  @override
  Widget build(BuildContext context) {
    // ---- АДАПТИВНЫЕ РАЗМЕРЫ/ОТСТУПЫ ----
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    // ширина кнопок: 70% экрана, но в пределах
    final btnWidth = (w * 0.4).clamp(100.0, 320.0);

    // высота мишки и величина её подъёма (вверх)
    final bearHeight = (h * 0.25).clamp(100.0, 220.0);
    final bearLift = (h * 0.08).clamp(50.0, 200.0); // насколько поднять вверх

    // вертикальные зазоры
    final gapAfterBear = (h * 0.02).clamp(10.0, 28.0);
    final gapBetweenBtn = (h * 0.04).clamp(10.0, 100.0);
    final gapBottom = (h * 0.03).clamp(16.0, 28.0);

    // высота нижней «дуги»
    final arcHeight = (h * 0.36).clamp(240.0, 340.0);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFC9F8D9)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ----- МИШКА (адаптивная высота + подъём) -----
                    Transform.translate(
                      offset: Offset(0, -bearLift), // ↑ поднимаем адаптивно
                      child: SizedBox(
                        height: bearHeight,          // адаптивная высота
                        child: Image.asset(
                          'assets/images/bear.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.pets, size: 120),
                        ),
                      ),
                    ),

                    SizedBox(height: gapAfterBear),

                    // ----- КНОПКА 1 (адаптивная ширина) -----
                    SizedBox(
                      width: btnWidth,
                      child: _PillButton(
                        text: 'Вход по email',
                        height: 44,
                        textStyle: const TextStyle(fontSize: 16),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  EmailLoginScreen(authRepo: authRepo),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: gapBetweenBtn),

                    // ----- КНОПКА 2 (адаптивная ширина) -----
                    SizedBox(
                      width: btnWidth,
                      child: _PillButton(
                        text: 'Вход по VC ID',
                        height: 44,
                        textStyle: const TextStyle(fontSize: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('VC ID будет позже')),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: gapBottom),
                  ],
                ),
              ),
            ),
          ),

          // ----- НИЖНЯЯ ДУГА (овальная, не блокирует тапы) -----
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 40,
                    left: -60,
                    right: -60,
                    child: IgnorePointer(
                      ignoring: true,
                      child: ClipOval(
                        child: Container(
                          width: w + 100,
                          height: arcHeight, // адаптивная «плоскость» дуги
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 90,
                    child: Column(
                      children: [
                        Text('У вас нет аккаунта?',
                            style: TextStyle(fontSize: 20)),
                        SizedBox(height: 6),
                        TextButton(
                          onPressed: null, // TODO: открыть экран регистрации
                          child: Text(
                            'Регистрация',
                            style: TextStyle(
                                color: Color(0xFFB87963), fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------
// Пилюльная кнопка (высота/шрифт можно задавать)
// -------------------------
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.text,
    required this.onTap,
    this.height = 52,
    this.textStyle,
  });

  final String text;
  final VoidCallback onTap;
  final double height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.25),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.2,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
