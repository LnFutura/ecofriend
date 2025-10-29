import 'package:flutter/foundation.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();
  
  List<News> _newsList = [];
  News? _selectedNews;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filters
  String? _categoryFilter;
  String? _statusFilter = 'approved'; // По умолчанию только одобренные

  List<News> get newsList => _newsList;
  News? get selectedNews => _selectedNews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get categoryFilter => _categoryFilter;
  String? get statusFilter => _statusFilter;

  // Загрузить список новостей
  Future<void> fetchNews({String? category, String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _newsList = await _newsService.getNews(
        category: category ?? _categoryFilter,
        status: status ?? _statusFilter,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Загрузить конкретную новость по ID
  Future<void> fetchNewsById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedNews = await _newsService.getNewsById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Лайкнуть новость
  Future<bool> likeNews(String newsId) async {
    try {
      await _newsService.likeNews(newsId);
      
      // Перезагружаем новость для получения обновленных данных
      if (_selectedNews?.id == newsId) {
        await fetchNewsById(newsId);
      }
      
      // Также обновляем список
      await fetchNews();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Добавить комментарий
  Future<bool> addComment(String newsId, String text) async {
    try {
      await _newsService.addComment(newsId, text);
      
      // Перезагружаем новость чтобы получить обновленные комментарии
      await fetchNewsById(newsId);
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Установить фильтр по категории
  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    fetchNews();
  }

  // Установить фильтр по статусу
  void setStatusFilter(String? status) {
    _statusFilter = status;
    fetchNews();
  }

  // Очистить ошибку
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Очистить выбранную новость
  void clearSelectedNews() {
    _selectedNews = null;
    notifyListeners();
  }
}

