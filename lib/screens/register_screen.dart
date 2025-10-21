import 'package:flutter/material.dart';
import '../auth/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.authRepo});
  final AuthRepository authRepo; // пока не используем, но пригодится позже

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _login = TextEditingController();   // телефон или email
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _onSubmit() async {
    // TODO: сюда подключим POST /auth/register, когда будет бэкенд
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Регистрация: заглушка (mock)')),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Мятный фон (слегка светлее, чем на логине — как в макете)
          Container(color: const Color(0xFFC9F8D9)),

          // Контент
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ОБЛАЧКО С ТЕКСТОМ — твоя картинка
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/bubble.png',
                          width: 320,
                          fit: BoxFit.contain,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Друг, введи\nданные, пожалуйста!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Белая карточка с полями
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _login,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Телефон или email',
                              isDense: true,
                              border: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _password,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: 'Пароль',
                              isDense: true,
                              border: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 1.2),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _loading ? null : _onSubmit,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: const BorderSide(
                                      color: Colors.black, width: 2),
                                ),
                                elevation: 6,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                                  : const Text('Продолжить'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Мишка снизу — твоя картинка
          Positioned(
            bottom: -6,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bear_bottom.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
