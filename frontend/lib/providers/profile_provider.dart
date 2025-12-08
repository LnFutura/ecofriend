import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile.dart';
import '../models/user.dart';
import '../services/profile_service.dart';
import '../services/upload_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final UploadService _uploadService = UploadService();

  Profile? _profile;
  User? _user;
  bool _isLoading = false;
  bool _isUpLoading = false;
  String? _errorMessage;

  Profile? get profile => _profile;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUpLoading;
  String? get errorMessage => _errorMessage;

  /// Очистить сообщение об ошибке
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Сбросить весь state провайдера
  void reset() {
    _profile = null;
    _user = null;
    _isLoading = false;
    _isUpLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Загрузить профиль текущего пользователя
  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileService.getMyProfile();
      _errorMessage = null; // Явно очищаем ошибку после успешной загрузки
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновить имя пользователя
  Future<bool> updateName(String fullName) async {
    try {
      _profile = await _profileService.updateProfile(fullName: fullName);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Загрузить аватар
  Future<bool> uploadAvatar(XFile image) async {
    _isUpLoading = true;
    notifyListeners();

    try {
      final avatarUrl = await _uploadService.uploadAvatar(image);

      // Обновить профиль с новым аватаром
      _profile = _profile?.copyWith(avatar: avatarUrl);

      _isUpLoading = false;
      notifyListeners();
      
      // Перезагрузить профиль с сервера для получения актуальных данных
      await loadProfile();
      
      return true;
    } catch (e) {
      _isUpLoading = false;
      notifyListeners();
      // НЕ устанавливаем _errorMessage здесь, чтобы не блокировать экран
      // Ошибка будет обработана в UI через SnackBar
      rethrow; // Пробрасываем ошибку наверх
    }
  }

  /// Удалить аватар
  Future<bool> deleteAvatar() async {
    try {
      await _uploadService.deleteAvatar();
      _profile = _profile?.copyWith(avatar: null);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Показать диалог выбора источника фото
  Future<void> showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.blue),
                  title: const Text('Выбрать из галереи'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final image = await _uploadService.pickImageFromGallery();
                    if (image != null) {
                      try {
                        await uploadAvatar(image);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Фото успешно загружено'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка загрузки фото: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.green),
                  title: const Text('Сделать фото'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final image = await _uploadService.pickImageFromCamera();
                    if (image != null) {
                      try {
                        await uploadAvatar(image);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Фото успешно загружено'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка загрузки фото: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                if (_profile?.avatar != null && _profile!.avatar!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      'Удалить фото',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final success = await deleteAvatar();
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Фото удалено'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Отмена'),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Получить текст достижений на основе данных профиля (простой текст)
  String getAchievementText() {
    if (_profile == null) return '';

    final coursesCount = _profile!.completedCourses.length;
    final eventsCount = _profile!.attendedEvents.length;

    if (coursesCount == 0 && eventsCount == 0) {
      return 'Начни свой экопуть!\nПройди первый курс или\nучаствуй в событии.';
    }

    String text = 'Вы ';
    if (coursesCount > 0) {
      text += 'прошли $coursesCount ${_getCoursesWord(coursesCount)}';
    }
    if (eventsCount > 0) {
      if (coursesCount > 0) text += ' и\n';
      text += 'поучаствовали в $eventsCount ${_getEventsWord(eventsCount)}';
    }

    return text;
  }

  /// Проверить есть ли достижения (для отображения форматированного текста)
  bool hasAchievements() {
    if (_profile == null) return false;
    return _profile!.completedCourses.isNotEmpty || _profile!.attendedEvents.isNotEmpty;
  }

  /// Склонение слова "курс"
  String _getCoursesWord(int count) {
    final n = count % 100;
    final n1 = count % 10;
    if (n >= 11 && n <= 19) return 'курсов';
    if (n1 == 1) return 'курс';
    if (n1 >= 2 && n1 <= 4) return 'курса';
    return 'курсов';
  }

  /// Склонение слова "экопоход"
  String _getEventsWord(int count) {
    final n = count % 100;
    final n1 = count % 10;
    if (n >= 11 && n <= 19) return 'экопоходах';
    if (n1 == 1) return 'экопоходе';
    if (n1 >= 2 && n1 <= 4) return 'экопоходах';
    return 'экопоходах';
  }

  /// Очистить профиль (при выходе)
  void clearProfile() {
    _profile = null;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}

