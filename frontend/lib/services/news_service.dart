import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/news.dart';
import 'storage_service.dart';

class NewsService {
  // Получить все новости
  Future<List<News>> getNews({String? category, String? status}) async {
    try {
      String url = '${AppConstants.apiBaseUrl}/news';
      
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (status != null) queryParams['status'] = status;
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List newsJson = data['data'];
        return newsJson.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Не удалось загрузить новости');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить конкретную новость
  Future<News> getNewsById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/news/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return News.fromJson(data['data']);
      } else {
        throw Exception('Новость не найдена');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Лайкнуть/убрать лайк
  Future<void> toggleLike(String newsId) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/news/$newsId/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Не удалось поставить лайк');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Добавить комментарий
  Future<void> addComment(String newsId, String text) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/news/$newsId/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'text': text}),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Не удалось добавить комментарий');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }
}

