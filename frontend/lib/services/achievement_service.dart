import 'api_service.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  final ApiService _api = ApiService();

  /// Получить все достижения с информацией о статусе разблокировки
  Future<List<Map<String, dynamic>>> getAchievementsStatus() async {
    try {
      final response = await _api.get('/achievements/status');
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error getting achievements status: $e');
      return [];
    }
  }

  /// Получить только мои достижения
  Future<List<Map<String, dynamic>>> getMyAchievements() async {
    try {
      final response = await _api.get('/achievements/my');
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error getting my achievements: $e');
      return [];
    }
  }

  /// Получить все достижения (публичный список)
  Future<List<Map<String, dynamic>>> getAllAchievements() async {
    try {
      final response = await _api.get('/achievements', includeAuth: false);
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error getting all achievements: $e');
      return [];
    }
  }

  /// Получить все звания с информацией о статусе разблокировки
  Future<List<Map<String, dynamic>>> getTitlesStatus() async {
    try {
      final response = await _api.get('/achievements/titles/status');
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      print('Error getting titles status: $e');
      return [];
    }
  }
}
