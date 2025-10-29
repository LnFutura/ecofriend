import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Register new user
  Future<AuthResponse> register({
    required String email,
    required String username,
    required String password,
    String role = 'user',
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'email': email,
          'username': username,
          'password': password,
          'role': role,
        },
        includeAuth: false,
      );

      final token = response['token'] as String;
      final user = User.fromJson(response['user']);

      // Save token and user ID to storage
      await StorageService.saveToken(token);
      await StorageService.saveUserId(user.id);

      return AuthResponse(
        token: token,
        user: user,
        message: response['message'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      final token = response['token'] as String;
      final user = User.fromJson(response['user']);

      // Save token and user ID to storage
      await StorageService.saveToken(token);
      await StorageService.saveUserId(user.id);

      return AuthResponse(
        token: token,
        user: user,
        message: response['message'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      return User.fromJson(response['user']);
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeUserId();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final token = StorageService.getToken();
    return token != null && token.isNotEmpty;
  }

  // Get stored token
  String? getToken() {
    return StorageService.getToken();
  }
}

class AuthResponse {
  final String token;
  final User user;
  final String? message;

  AuthResponse({
    required this.token,
    required this.user,
    this.message,
  });
}

