import 'package:flutter/material.dart';
import '../auth/auth_repository.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key, required this.authRepo});
  final AuthRepository authRepo;

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _onLogin() async {
    setState(() => _loading = true);
    final token = await widget.authRepo.login(
      email: _email.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home', arguments: token);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cardWidth = (w * 0.60).clamp(280.0, 280.0);
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF7DD3A9)),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ОБЛАКО + ТЕКСТ (центр гарантирован)
                      Transform.translate(
                        offset: const Offset(-12, -6), // сместить облако целиком (влево/вверх)
                        child: SizedBox(
                          width: 300,   // ширина облака
                          height: 250,  // высота облака (подгони 160–200)
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/images/bubble_rotated.png',
                                fit: BoxFit.contain,
                              ),
                              Positioned.fill(
                                child: Align(
                                alignment: const Alignment(0.20, 0.20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Text(
                                    'Друг, введи\n данные,\nпожалуйста!',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 58),


                      // БЕЛАЯ КАРТОЧКА С ПОЛЯМИ (кнопки внутри БОЛЬШЕ НЕТ)
                      SizedBox(
                        width: cardWidth,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Телефон или email',
                                isDense: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                hintText: 'Пароль',
                                isDense: true,
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),


                      // ← КНОПКА ПОД ОКНОМ ВВОДА (вынесена из карточки)
                      const SizedBox(height: 58),
                      SizedBox(
                        width: 170,
                        height: 48,
                        child: FilledButton(
                          onPressed: _loading ? null : _onLogin,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                              side: const BorderSide(color: Colors.black, width: 3),
                            ),
                            elevation: 6,
                          ),
                          child: _loading
                              ? const SizedBox(
                              width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Войти', style: TextStyle(fontSize: 20),),
                        ),
                      ),

                      const SizedBox(height: 56),

                      // Ссылка "Регистрация" (оставлена без изменений)
                      TextButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (_) => RegisterScreen(authRepo: widget.authRepo)),
                          // );
                        },
                        child: const Text('Регистрация' , style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
