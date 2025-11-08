import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // Переменная для показа/скрытия пароля
  DateTime? _lastAttemptTime; // Для rate limiting

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Rate limiting: проверка на слишком частые попытки
    if (_lastAttemptTime != null) {
      final timeSinceLastAttempt = DateTime.now().difference(_lastAttemptTime!);
      if (timeSinceLastAttempt < Duration(seconds: 2)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Подождите ${2 - timeSinceLastAttempt.inSeconds} сек. перед следующей попыткой'),
            backgroundColor: AppTheme.errorRed,
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }
    }
    
    _lastAttemptTime = DateTime.now();
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Используем общее сообщение для защиты от timing attack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Неверный email или пароль'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Пропорции из Figma (390x844)
    final scaleWidth = screenWidth / 390;
    final scaleHeight = screenHeight / 844;
    
    return Scaffold(
      body: Container(
        color: AppTheme.screenGreen,
        child: Stack(
          children: [
            // Лапка на фоне (bear-pawprint 7)
            Positioned(
              left: 115 * scaleWidth,
              bottom: 10 * scaleHeight, // Минимальный отступ от низа 10px
              child: Transform.rotate(
                angle: (23.34 - 25) * 3.14159 / 180, // 23.34 - 25 = -1.66 градуса (поворот влево еще на 10°)
                child: Opacity(
                  opacity: 0.75, // Увеличил прозрачность с 0.65 до 0.75 (еще ярче)
                  child: Image.asset(
                    'assets/icons/Эко Друг/bear-pawprint 7.png',
                    width: 220.95 * scaleWidth,
                    height: 220.95 * scaleHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            // Основной контент
            SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  height: screenHeight - MediaQuery.of(context).padding.top,
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        // SVG Облако с текстом (Мысль)
                        Positioned(
                          left: 7 * scaleWidth,
                          top: 23 * scaleHeight,
                          child: SizedBox(
                            width: 333 * scaleWidth,
                            height: 267 * scaleHeight,
                            child: Stack(
                              children: [
                                // SVG облако
                                SvgPicture.asset(
                                  'assets/icons/Эко Друг/Мысль.svg',
                                  width: 333 * scaleWidth,
                                  height: 267 * scaleHeight,
                                  fit: BoxFit.contain,
                                ),
                                // Текст поверх облака (центрированный)
                                Positioned(
                                  left: 60 * scaleWidth,
                                  top: 100 * scaleHeight,
                                  child: SizedBox(
                                    width: 220 * scaleWidth,
                                    height: 100 * scaleHeight,
                                    child: Center(
                                      child: Text(
                                        'Друг, введи\nданные,\nпожалуйста!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Neucha',
                                          fontSize: 25 * scaleWidth,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF0F0F0F),
                                          letterSpacing: 2.0,
                                          height: 1.12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Карточка с полями ввода (Group 4 + Rectangle 8)
                        Positioned(
                          left: 52 * scaleWidth,
                          top: 358 * scaleHeight,
                          child: Container(
                            width: 299 * scaleWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20 * scaleWidth,
                              vertical: 20 * scaleHeight,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30 * scaleWidth),
                              border: Border.all(
                                color: const Color(0xFF141414),
                                width: 3 * scaleWidth,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Email field
                                SizedBox(
                                  height: 35 * scaleHeight,
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Телефон или email',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 20 * scaleWidth,
                                        color: Colors.black.withOpacity(0.54),
                                        letterSpacing: 1.6,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 20 * scaleWidth,
                                      color: Colors.black,
                                      letterSpacing: 1.6,
                                    ),
                                    validator: Validators.validateEmail,
                                  ),
                                ),
                                
                                SizedBox(height: 8 * scaleHeight),
                                
                                // Разделитель (Vector 3)
                                Container(
                                  width: 222.5 * scaleWidth,
                                  height: 1,
                                  color: const Color(0xFF141414),
                                ),
                                
                                SizedBox(height: 8 * scaleHeight),
                                
                                // Password field
                                SizedBox(
                                  height: 35 * scaleHeight,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Пароль',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Neucha',
                                        fontSize: 20 * scaleWidth,
                                        color: Colors.black.withOpacity(0.54),
                                        letterSpacing: 1.6,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      // Иконка для показа/скрытия пароля
                                      suffixIcon: SizedBox(
                                        width: 24 * scaleWidth,
                                        height: 24 * scaleHeight,
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                              color: Colors.black.withOpacity(0.54),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                            padding: EdgeInsets.zero,
                                            iconSize: 16 * scaleWidth,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Neucha',
                                      fontSize: 20 * scaleWidth,
                                      color: Colors.black,
                                      letterSpacing: 1.6,
                                    ),
                                    validator: Validators.validatePassword,
                                  ),
                                ),
                                
                                SizedBox(height: 8 * scaleHeight),
                                
                                // Разделитель под полем пароля
                                Container(
                                  width: 222.5 * scaleWidth,
                                  height: 1,
                                  color: const Color(0xFF141414),
                                ),
                                
                                SizedBox(height: 12 * scaleHeight), // Увеличил отступ от разделителя до края карточки
                              ],
                            ),
                          ),
                        ),
                        
                        // Кнопка "Войти" с тенью (Group 4)
                        Positioned(
                          left: 108 * scaleWidth,
                          top: 560 * scaleHeight, // Поднял с 585 до 560
                          child: Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return GestureDetector(
                                onTap: authProvider.isLoading ? null : _handleLogin,
                                child: Stack(
                                  children: [
                                    // Черная тень (Rectangle 6)
                                    Positioned(
                                      left: 1.86 * scaleWidth,
                                      top: 3.56 * scaleHeight,
                                      child: Container(
                                        width: 205.14 * scaleWidth,
                                        height: 59.66 * scaleHeight,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(40 * scaleWidth),
                                          border: Border.all(
                                            color: const Color(0xFF141414),
                                            width: 3 * scaleWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Белая кнопка (Rectangle 7)
                                    Container(
                                      width: 204.22 * scaleWidth,
                                      height: 59.66 * scaleHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40 * scaleWidth),
                                        border: Border.all(
                                          color: const Color(0xFF141414),
                                          width: 3 * scaleWidth,
                                        ),
                                      ),
                                      child: Center(
                                        child: authProvider.isLoading
                                            ? SizedBox(
                                                width: 20 * scaleWidth,
                                                height: 20 * scaleWidth,
                                                child: const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Text(
                                                'Войти',
                                                style: TextStyle(
                                                  fontFamily: 'Neucha',
                                                  fontSize: 26 * scaleWidth,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  letterSpacing: 2.08,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Ссылка "Регистрация"
                        Positioned(
                          left: 141 * scaleWidth,
                          top: 670 * scaleHeight, // Поднял с 701 до 670
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/register');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Регистрация',
                              style: TextStyle(
                                fontFamily: 'Neucha',
                                fontSize: 25 * scaleWidth,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF228036),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Кнопка "Назад" в правом верхнем углу
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.textDark, width: 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textDark,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
