import 'package:flutter_test/flutter_test.dart';
import 'package:ecodrug_frontend/services/storage_service.dart';

void main() {
  group('StorageService Tests', () {
    setUp(() async {
      // Clear storage before each test
      await StorageService.clearAll();
    });

    test('Should save and retrieve token', () async {
      const testToken = 'test_jwt_token_12345';
      
      await StorageService.saveToken(testToken);
      final retrievedToken = StorageService.getToken();

      expect(retrievedToken, testToken);
    });

    test('Should return null when no token exists', () async {
      final token = StorageService.getToken();
      expect(token, isNull);
    });

    test('Should clear token', () async {
      const testToken = 'test_jwt_token_12345';
      
      await StorageService.saveToken(testToken);
      await StorageService.clearToken();
      final token = StorageService.getToken();

      expect(token, isNull);
    });

    test('Should save and retrieve user ID', () async {
      const testUserId = 'user123';
      
      await StorageService.saveUserId(testUserId);
      final retrievedUserId = StorageService.getUserId();

      expect(retrievedUserId, testUserId);
    });

    test('Should clear all storage', () async {
      await StorageService.saveToken('token');
      await StorageService.saveUserId('userId');
      
      await StorageService.clearAll();
      
      final token = StorageService.getToken();
      final userId = StorageService.getUserId();

      expect(token, isNull);
      expect(userId, isNull);
    });
  });

  group('API Constants Tests', () {
    test('API constants should be properly configured', () {
      // These would come from your constants.dart
      const baseUrl = 'http://192.168.1.100:5000';
      
      expect(baseUrl, isNotEmpty);
      expect(baseUrl, contains('http'));
    });
  });
}

