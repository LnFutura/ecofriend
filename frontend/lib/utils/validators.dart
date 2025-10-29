class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email обязателен';
    }
    
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    
    return null;
  }
  
  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Имя пользователя обязательно';
    }
    
    if (value.length < 3) {
      return 'Имя пользователя должно содержать минимум 3 символа';
    }
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Используйте только буквы, цифры и подчеркивание';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль обязателен';
    }
    
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    
    if (value != password) {
      return 'Пароли не совпадают';
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, [String fieldName = 'Поле']) {
    if (value == null || value.isEmpty) {
      return '$fieldName обязательно';
    }
    return null;
  }
  
  // Max length validation
  static String? validateMaxLength(String? value, int maxLength, [String fieldName = 'Поле']) {
    if (value != null && value.length > maxLength) {
      return '$fieldName не может превышать $maxLength символов';
    }
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Введите корректный URL';
    }
    
    return null;
  }
}

