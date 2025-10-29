class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000/api');
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  // App Configuration
  static const String appName = 'ЭкоДруг';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int leaderboardPageSize = 50;
  
  // Points Configuration
  static const int pointsPerCourse = 100;
  static const int pointsPerEvent = 50;
  static const int pointsPerNews = 10;
  
  // Map Configuration
  static const double defaultLatitude = 55.7558; // Moscow
  static const double defaultLongitude = 37.6173;
  static const double defaultZoom = 10.0;
  static const double nearbyRadius = 5000; // 5km in meters
}

