import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../services/education_service.dart';

class EducationProvider with ChangeNotifier {
  final EducationService _educationService = EducationService();

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
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

