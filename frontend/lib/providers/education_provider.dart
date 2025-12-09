import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../models/quiz.dart';
import '../services/education_service.dart';

class EducationProvider with ChangeNotifier {
  final EducationService _educationService = EducationService();

  List<Course> _courses = [];
  Course? _currentCourse;
  Quiz? _currentQuiz;
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  Course? get currentCourse => _currentCourse;
  Quiz? get currentQuiz => _currentQuiz;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Получить все курсы
  Future<void> fetchCourses({String? category, String? level}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _educationService.getCourses(
        category: category,
        level: level,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Получить детали конкретного курса
  Future<void> fetchCourseDetails(String courseId) async {
    print('EducationProvider: Fetching course with ID: $courseId');
    _isLoading = true;
    _error = null;
    _currentCourse = null; // Очищаем предыдущий курс
    notifyListeners();

    try {
      _currentCourse = await _educationService.getCourseById(courseId);
      print('EducationProvider: Loaded course: ${_currentCourse?.title}');
      print('EducationProvider: Course quiz: ${_currentCourse?.quiz}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('EducationProvider: Error loading course: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Получить тест по ID
  Future<void> fetchQuizById(String quizId) async {
    _isLoading = true;
    _error = null;
    _currentQuiz = null;
    notifyListeners();

    try {
      final quizData = await _educationService.getQuizById(quizId);
      _currentQuiz = Quiz.fromJson(quizData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Записаться на курс
  Future<bool> enrollCourse(String courseId) async {
    try {
      await _educationService.enrollCourse(courseId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Завершить курс
  Future<Map<String, dynamic>?> completeCourse(String courseId) async {
    try {
      final result = await _educationService.completeCourse(courseId);
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}

