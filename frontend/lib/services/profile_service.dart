import '../models/profile.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  // Get profile by user ID
  Future<Profile> getProfile(String userId) async {
    try {
      final response = await _apiService.get('/profile/$userId');
      return Profile.fromJson(response['profile']);
    } catch (e) {
      rethrow;
    }
  }

  // Get current user's profile
  Future<Profile> getMyProfile() async {
    try {
      final response = await _apiService.get('/profile/me');
      return Profile.fromJson(response['profile']);
    } catch (e) {
      rethrow;
    }
  }

  // Update profile
  Future<Profile> updateProfile({
    String? fullName,
    String? bio,
    String? avatar,
    Location? location,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (fullName != null) body['fullName'] = fullName;
      if (bio != null) body['bio'] = bio;
      if (avatar != null) body['avatar'] = avatar;
      if (location != null) body['location'] = location.toJson();

      final response = await _apiService.put(
        '/profile',
        body: body,
      );

      return Profile.fromJson(response['profile']);
    } catch (e) {
      rethrow;
    }
  }

  // Add points
  Future<Map<String, dynamic>> addPoints(int points) async {
    try {
      final response = await _apiService.post(
        '/profile/points',
        body: {'points': points},
      );

      return {
        'points': response['points'],
        'level': response['level'],
        'message': response['message'],
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get leaderboard
  Future<LeaderboardResponse> getLeaderboard({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiService.get(
        '/profile/leaderboard',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
        includeAuth: false,
      );

      final leaderboard = (response['leaderboard'] as List)
          .map((item) => Profile.fromJson(item))
          .toList();

      return LeaderboardResponse(
        leaderboard: leaderboard,
        pagination: Pagination.fromJson(response['pagination']),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class LeaderboardResponse {
  final List<Profile> leaderboard;
  final Pagination pagination;

  LeaderboardResponse({
    required this.leaderboard,
    required this.pagination,
  });
}

class Pagination {
  final int total;
  final int page;
  final int pages;

  Pagination({
    required this.total,
    required this.page,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pages: json['pages'] ?? 1,
    );
  }
}

