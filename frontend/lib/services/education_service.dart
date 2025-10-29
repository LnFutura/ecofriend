import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/course.dart';
import 'storage_service.dart';

class EducationService {

  // Получить все курсы
  Future<List<Course>> getCourses({String? category, String? level}) async {
    try {
      String url = '${AppConstants.apiBaseUrl}/education/courses';
      
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (level != null) queryParams['level'] = level;
      
      if (queryParams.isNotEmpty) {
        url += '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coursesJson = data['data'];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Не удалось загрузить курсы');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить конкретный курс
  Future<Course> getCourseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Course.fromJson(data['data']);
      } else {
        throw Exception('Курс не найден');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Записаться на курс
  Future<Map<String, dynamic>> enrollCourse(String courseId) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$courseId/enroll'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Не удалось записаться на курс');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Завершить курс
  Future<Map<String, dynamic>> completeCourse(String courseId) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$courseId/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Не удалось завершить курс');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить тест курса
  Future<Map<String, dynamic>> getCourseQuiz(String courseId) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$courseId/quiz'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Тест не найден');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Отправить ответы на тест
  Future<Map<String, dynamic>> submitQuiz(String courseId, List answers) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$courseId/quiz/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Ошибка при проверке ответов');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Добавить отзыв
  Future<void> addReview(String courseId, int rating, String? comment) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/education/courses/$courseId/review'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Не удалось добавить отзыв');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }
}

