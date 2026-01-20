import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/education_provider.dart';
import '../../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  final String courseId;
  final String quizId;

  const QuizScreen({
    super.key,
    required this.courseId,
    required this.quizId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  Map<int, bool> _answeredCorrectly = {};
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
      _loadQuiz();
    });
  }

  Future<void> _loadQuiz() async {
    try {
      await Provider.of<EducationProvider>(context, listen: false)
          .fetchQuizById(widget.quizId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка загрузки теста'),
            backgroundColor: Color(0xFFED8D8C),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _selectAnswer(String answer, String correctAnswer) {
    print('=== ANSWER DEBUG ===');
    print('User selected: "$answer"');
    print('Correct answer: "$correctAnswer"');
    print('Are they equal? ${answer == correctAnswer}');
    print('User answer length: ${answer.length}');
    print('Correct answer length: ${correctAnswer.length}');
    print('==================');
    
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
      _answeredCorrectly[_currentQuestionIndex] = answer == correctAnswer;
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showResult = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final correctAnswers = _answeredCorrectly.values.where((correct) => correct).length;
    final educationProvider = Provider.of<EducationProvider>(context, listen: false);
    final totalQuestions = educationProvider.currentQuiz?.questions.length ?? 0;
    final earnedPoints = (correctAnswers / totalQuestions * 100).round();

    Navigator.of(context).pushReplacementNamed(
      '/quiz-result',
      arguments: {
        'score': correctAnswers,
        'total': totalQuestions,
        'points': earnedPoints,
        'courseId': widget.courseId,
        'quizId': widget.quizId, // Передаем quizId
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleWidth = size.width / 375;
    final scaleHeight = size.height / 812;

    return Consumer<EducationProvider>(
      builder: (context, educationProvider, child) {
        // Если данные загружаются или ошибка
        if (educationProvider.isLoading || educationProvider.currentQuiz == null) {
          return Scaffold(
            body: Container(
              color: const Color(0xFFBC9CEA),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        final quiz = educationProvider.currentQuiz!;
        final questions = quiz.questions;
        
        if (questions.isEmpty) {
          return Scaffold(
            body: Container(
              color: const Color(0xFFBC9CEA),
              child: const Center(
                child: Text(
                  'Нет вопросов в тесте',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        }

        final currentQuestion = questions[_currentQuestionIndex];
        final userAnswer = _userAnswers[_currentQuestionIndex];

        return _buildQuizContent(
          context,
          size,
          scaleWidth,
          scaleHeight,
          currentQuestion,
          userAnswer,
          questions.length,
        );
      },
    );
  }

  Widget _buildQuizContent(
    BuildContext context,
    Size size,
    double scaleWidth,
    double scaleHeight,
    Question currentQuestion,
    String? userAnswer,
    int totalQuestions,
  ) {

    return Scaffold(
      body: Stack(
        children: [
          // ========== ФОН ==========
          Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFBC9CEA),
          ),

          // ========== ЛАПКА МЕДВЕДЯ НИЖНЯЯ ПРАВАЯ ==========
          Positioned(
            left: 78 * scaleWidth,
            bottom: -50 * scaleHeight,
            child: Transform.rotate(
              angle: (-31.25 - 30) * 3.14159 / 180,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/icons/Эко Друг/bear-pawprint 7.png',
                  width: 325 * scaleWidth,
                  height: 325 * scaleHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 325 * scaleWidth,
                      height: 325 * scaleHeight,
                    );
                  },
                ),
              ),
            ),
          ),

          // ========== ОСНОВНОЙ КОНТЕНТ ==========
          SafeArea(
            child: Stack(
              children: [
                // ========== ЛАПКА МЕДВЕДЯ ВЕРХНЯЯ ЛЕВАЯ ==========
                Positioned(
                  left: -55 * scaleWidth,
                  top: -4 * scaleHeight,
                  child: Transform.rotate(
                    angle: 14.69 * 3.14159 / 180,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'assets/icons/Эко Друг/bear-pawprint 7.png',
                        width: 217.64 * scaleWidth,
                        height: 217.64 * scaleHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: 217.64 * scaleWidth,
                            height: 217.64 * scaleHeight,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    // ========== ШАПКА ==========
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        34 * scaleWidth,
                        16 * scaleHeight,
                        34 * scaleWidth,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Кнопка назад
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50 * scaleWidth,
                              height: 50 * scaleHeight,
                              margin: EdgeInsets.only(top: 16 * scaleHeight),
                              decoration: BoxDecoration(
                                color: const Color(0xFF181818),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24 * scaleWidth,
                              ),
                            ),
                          ),

                          // Аватар с кнопкой настроек
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Consumer2<ProfileProvider, AuthProvider>(
                                builder: (context, profileProvider, authProvider, _) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/profile');
                                    },
                                    child: Container(
                                      width: 78 * scaleWidth,
                                      height: 101 * scaleHeight,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFF141414),
                                          width: 3,
                                        ),
                                        color: const Color(0xFF7FD17F),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: profileProvider.profile?.avatar != null
                                            ? Image.network(
                                                '${ApiConstants.serverUrl}${profileProvider.profile!.avatar}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return _buildAvatarPlaceholder(
                                                    profileProvider.profile?.fullName ??
                                                        authProvider.user?.username ??
                                                        'User',
                                                  );
                                                },
                                              )
                                            : _buildAvatarPlaceholder(
                                                profileProvider.profile?.fullName ??
                                                    authProvider.user?.username ??
                                                    'User',
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: -15 * scaleWidth,
                                bottom: -13 * scaleHeight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/profile');
                                  },
                                  child: Container(
                                    width: 40 * scaleWidth,
                                    height: 40 * scaleHeight,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBC9CEA),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF181818),
                                        width: 3,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.settings,
                                        size: 22 * scaleWidth,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10 * scaleHeight),

                    // ========== ЗАГОЛОВОК "ТЕСТ" ==========
                    Padding(
                      padding: EdgeInsets.only(left: 34 * scaleWidth),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Тест',
                          style: TextStyle(
                            fontFamily: 'Neucha',
                            fontSize: 40 * scaleWidth,
                            height: 44 / 40,
                            letterSpacing: 0.06 * 40 * scaleWidth,
                            color: const Color(0xFF111111),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20 * scaleHeight),

                    // ========== КОНТЕНТ ТЕСТА ==========
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 34 * scaleWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Номер вопроса
                              Text(
                                '${_currentQuestionIndex + 1}',
                                style: TextStyle(
                                  fontFamily: 'Neucha',
                                  fontSize: 32 * scaleWidth,
                                  color: const Color(0xFF111111),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 10 * scaleHeight),

                              // Вопрос
                              Text(
                                currentQuestion.question,
                                style: TextStyle(
                                  fontFamily: 'Neucha',
                                  fontSize: 20 * scaleWidth,
                                  height: 22 / 20,
                                  letterSpacing: 0.06 * 20 * scaleWidth,
                                  color: const Color(0xFF111111),
                                ),
                              ),

                              SizedBox(height: 20 * scaleHeight),

                              // Варианты ответов
                              ...                              List.generate(
                                currentQuestion.options.length,
                                (index) {
                                  final option = currentQuestion.options[index];
                                  final isSelected = userAnswer == option;
                                  final isCorrectOption = option == currentQuestion.correctAnswer; // Правильность ЭТОГО варианта
                                  final isUserAnswerCorrect = userAnswer == currentQuestion.correctAnswer; // Правильность выбора пользователя
                                  
                                  Color buttonColor = const Color(0xFFF8F8F8);
                                  if (_showResult && isSelected) {
                                    buttonColor = isUserAnswerCorrect 
                                        ? const Color(0xFF53C25A) 
                                        : const Color(0xFFED8D8C);
                                  } else if (isSelected) {
                                    buttonColor = const Color(0xFFD3D3D3); // Серый цвет для выбора
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 12 * scaleHeight),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: _showResult ? null : () => _selectAnswer(option, currentQuestion.correctAnswer),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20 * scaleWidth,
                                                vertical: 14 * scaleHeight,
                                              ),
                                              decoration: BoxDecoration(
                                                color: buttonColor,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(0xFF181818),
                                                  width: 3,
                                                ),
                                              ),
                                              child: Text(
                                                option,
                                                style: TextStyle(
                                                  fontFamily: 'Neucha',
                                                  fontSize: 18 * scaleWidth,
                                                  letterSpacing: 0.06 * 18 * scaleWidth,
                                                  color: isSelected && _showResult
                                                      ? Colors.white
                                                      : const Color(0xFF111111),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: 30 * scaleHeight),

                              // Кнопка "Ответить" или "Следующий"
                              if (userAnswer != null)
                                GestureDetector(
                                  onTap: () {
                                    if (_showResult) {
                                      _nextQuestion(totalQuestions);
                                    } else {
                                      setState(() {
                                        _showResult = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 60 * scaleHeight,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF53C25A),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF181818),
                                        width: 4,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _showResult 
                                            ? (_currentQuestionIndex < totalQuestions - 1 
                                                ? 'Следующий вопрос' 
                                                : 'Завершить тест')
                                            : 'Ответить',
                                        style: TextStyle(
                                          fontFamily: 'Neucha',
                                          fontSize: 24 * scaleWidth,
                                          letterSpacing: 0.06 * 24 * scaleWidth,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ========== НИЖНЯЯ НАВИГАЦИЯ ==========
                    _buildBottomNavigationBar(scaleWidth, scaleHeight),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    String initials = '';
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = name.substring(0, 1).toUpperCase();
      }
    } else {
      initials = '?';
    }

    return Container(
      color: const Color(0xFF7FD17F),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(double scaleWidth, double scaleHeight) {
    return Container(
      height: 90 * scaleHeight,
      padding: EdgeInsets.symmetric(horizontal: 19 * scaleWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavIcon(
            'assets/icons/Эко Друг/экопоходы.svg',
            const Color(0xFF53C25A),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/eco-hikes');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/обучение.svg',
            const Color(0xFFBC9CEA),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/education');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/новости.svg',
            const Color(0xFFED8D8C),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/news');
            },
          ),
          _buildNavIcon(
            'assets/icons/Эко Друг/карта.svg',
            const Color(0xFFFAD188),
            scaleWidth,
            scaleHeight,
            onTap: () {
              Navigator.of(context).pushNamed('/map');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(
    String svgPath,
    Color backgroundColor,
    double scaleWidth,
    double scaleHeight, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70 * scaleWidth,
        height: 70 * scaleHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => Icon(
              Icons.help_outline,
              size: 35 * scaleWidth,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

