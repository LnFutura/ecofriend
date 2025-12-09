import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/theme.dart';
import '../../widgets/decorative/bear_mascot.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  // TODO: Раскомментировать когда добавим поле username в UI
  // final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // TODO: Раскомментировать когда добавим поле "Подтвердите пароль" в UI
  // final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showButton = false; // Показывать кнопку только если заполнено хотя бы одно поле
  String _cloudText = 'Друг, введи\nданные,\nпожалуйста!'; // Текст в облаке меняется после успешной проверки
  DateTime? _lastAttemptTime; // Для rate limiting

  @override
  void initState() {
    super.initState();
    // Слушаем изменения в полях
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    // Проверяем валидность полей, а не только наличие текста
    final emailValid = Validators.validateEmail(_emailController.text) == null;
    final passwordValid = Validators.validatePassword(_passwordController.text) == null;
    final shouldShow = emailValid && passwordValid;
    
    if (shouldShow != _showButton) {
      setState(() {
        _showButton = shouldShow;
      });
    }
  }

  // Генерация случайного username в формате user_XXXXXXXX
  String _generateRandomUsername() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final randomPart = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    return 'user_$randomPart';
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFields);
    _passwordController.removeListener(_checkFields);
    _emailController.dispose();
    // _usernameController.dispose(); // TODO: Раскомментировать когда добавим поле
    _passwordController.dispose();
    // _confirmPasswordController.dispose(); // TODO: Раскомментировать когда добавим поле
    super.dispose();
  }

  Future<void> _handleRegister() async {
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

    // Меняем текст в облаке на "Добро пожаловать!"
    setState(() {
      _cloudText = 'Добро пожаловать!';
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Генерируем случайный username
    final email = _emailController.text.trim();
    final username = _generateRandomUsername();
    
    final success = await authProvider.register(
      email: email,
      username: username,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/profile');
    } else {
      // Если ошибка, возвращаем исходный текст
      setState(() {
        _cloudText = 'Друг, введи\nданные,\nпожалуйста!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Ошибка регистрации'),
          backgroundColor: Colors.red,
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
            // Медведь внизу экрана (вне SafeArea, чтобы мог выходить за края)
            Positioned(
              bottom: -80 * scaleHeight, // Опускаем ниже, чтобы убрать отступ от края
              left: (screenWidth - 380 * scaleWidth) / 2, // Центрируем
              child: BearMascot(
                size: 380 * scaleWidth,
                withBag: false,
              ),
            ),
            
            // Перевернутое облако с текстом (над медведем)
            Positioned(
              bottom: 230 * scaleHeight,
              left: (screenWidth - 350 * scaleWidth) / 2,
              child: SizedBox(
                width: 350 * scaleWidth,
                height: 260 * scaleHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Эко Друг/Облако_перевернутое.png',
                      width: 350 * scaleWidth,
                      height: 260 * scaleHeight,
                      fit: BoxFit.contain,
                    ),
                    // Текст поверх облака (полностью центрирован)
                    Padding(
                      padding: EdgeInsets.only(bottom: 30 * scaleHeight), // Немного сдвигаем вверх от центра
                      child: Text(
                        _cloudText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Neucha',
                          fontSize: 24 * scaleWidth, // Уменьшил с 26 до 24
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0F0F0F),
                          letterSpacing: 1.8,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ],
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
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                children: [
                        SizedBox(height: 50 * scaleHeight),
                        
                        // Карточка с полями ввода и кнопкой (сверху)
                        Container(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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

                              // Разделитель
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
                                      child: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.black.withOpacity(0.54),
                                          size: 16 * scaleWidth,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        visualDensity: VisualDensity.compact,
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
                              
                              SizedBox(height: 20 * scaleHeight), // Увеличили отступ с 12 до 20

                              // Кнопка "Продолжить" внутри формы (появляется только при заполнении)
                              if (_showButton) ...[
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                                    return GestureDetector(
                                      onTap: authProvider.isLoading ? null : _handleRegister,
                                      child: Container(
                                        width: 150 * scaleWidth,
                                        height: 45 * scaleHeight,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFF141414),
                                            width: 4 * scaleWidth, // Увеличили толщину рамки с 3 до 4
                                          ),
                                          borderRadius: BorderRadius.circular(50 * scaleWidth), // Увеличили радиус с 40 до 50 для более плавного скругления
                                        ),
                                        child: Center(
                                          child: authProvider.isLoading
                                              ? SizedBox(
                                                  width: 20 * scaleWidth,
                                                  height: 20 * scaleHeight,
                                                  child: const CircularProgressIndicator(
                                                    color: AppTheme.primaryGreen,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Text(
                                                  'Продолжить',
                                                  style: TextStyle(
                                                    fontFamily: 'Neucha',
                                                    fontSize: 18 * scaleWidth,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                        ),
                                      ),
                      );
                    },
                  ),
                                SizedBox(height: 10 * scaleHeight), // Отступ снизу теперь в массиве
                              ],
                            ],
                          ),
                        ),
                        
                        // Пустое пространство (облако и медведь теперь в Positioned виджетах)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Кнопка "Назад" в левом верхнем углу
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
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

