import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/recycling_point.dart';
import 'storage_service.dart';

class MapService {
  // Получить все пункты
  Future<List<RecyclingPoint>> getAllPoints({String? city, String? type}) async {
    try {
      String url = '${AppConstants.apiBaseUrl}/recycling-points';
      
      final queryParams = <String, String>{};
      if (city != null) queryParams['city'] = city;
      if (type != null) queryParams['type'] = type;
      
      if (queryParams.isNotEmpty) {
        url += '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List pointsJson = data['data'];
        return pointsJson.map((json) => RecyclingPoint.fromJson(json)).toList();
      } else {
        throw Exception('Не удалось загрузить пункты');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить ближайшие пункты
  Future<List<RecyclingPoint>> getNearbyPoints({
    required double lat,
    required double lng,
    int? radius,
    String? type,
  }) async {
    try {
      String url = '${AppConstants.apiBaseUrl}/recycling-points/nearby?lat=$lat&lng=$lng';
      
      if (radius != null) url += '&radius=$radius';
      if (type != null) url += '&type=$type';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List pointsJson = data['data'];
        return pointsJson.map((json) => RecyclingPoint.fromJson(json)).toList();
      } else {
        throw Exception('Не удалось загрузить ближайшие пункты');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Получить конкретный пункт
  Future<RecyclingPoint> getPointById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/recycling-points/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RecyclingPoint.fromJson(data['data']);
      } else {
        throw Exception('Пункт не найден');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Добавить отзыв
  Future<void> addReview(String pointId, int rating, String? comment) async {
    try {
      final token = StorageService.getToken();
      if (token == null) throw Exception('Необходима авторизация');

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/recycling-points/$pointId/review'),
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

  // Получить типы отходов
  Future<List<Map<String, String>>> getWasteTypes() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/recycling-points/types'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, String>>.from(
          (data['data'] as List).map((item) => Map<String, String>.from(item))
        );
      } else {
        throw Exception('Не удалось загрузить типы');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }
}

