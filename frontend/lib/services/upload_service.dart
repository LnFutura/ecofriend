import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/constants.dart';
import 'storage_service.dart';

class UploadService {
  final String baseUrl = ApiConstants.baseUrl;

  /// Выбрать фото из галереи
  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      return await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Сделать фото камерой
  Future<XFile?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      return await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      throw Exception('Failed to take photo: $e');
    }
  }

  /// Загрузить аватар на сервер
  Future<String> uploadAvatar(XFile image) async {
    try {
      final token = StorageService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Not authenticated');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/avatar'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Для Flutter Web используем bytes
      var bytes = await image.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        bytes,
        filename: image.name,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['avatar'] ?? '';
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Upload failed');
      }
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  /// Удалить аватар
  Future<void> deleteAvatar() async {
    try {
      final token = StorageService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/profile/avatar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Delete failed');
      }
    } catch (e) {
      throw Exception('Failed to delete avatar: $e');
    }
  }
}

