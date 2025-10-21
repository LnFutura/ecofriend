import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// true → работаем без сервера (mock), false → реальный backend
const bool kUseMock = true;

/// Заполни, когда подключишь backend
const String kBaseUrl = 'https://YOUR_BACKEND_BASE_URL';

abstract class AuthRepository {
  Future<String> login({required String email, required String password});
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<String> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return 'MOCK_JWT_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class HttpAuthRepository implements AuthRepository {
  const HttpAuthRepository();

  @override
  Future<String> login({required String email, required String password}) async {
    final url = Uri.parse('$kBaseUrl/api/auth/login');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return (json['token'] ?? '') as String;
    }

    throw Exception('Login failed: HTTP ${resp.statusCode}');
  }
}

AuthRepository provideAuthRepository() {
  if (kUseMock) return MockAuthRepository();
  return const HttpAuthRepository();
}
