class Course {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final String level;
  final int duration; // в минутах
  final int points;
  final String? thumbnail;
  final String authorId;
  final String? authorName;
  final List<CourseModule> modules;
  final String? quizId;
  final bool published;
  final int enrolledCount;
  final double rating;
  final List<CourseReview> reviews;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.level,
    required this.duration,
    required this.points,
    this.thumbnail,
    required this.authorId,
    this.authorName,
    required this.modules,
    this.quizId,
    required this.published,
    required this.enrolledCount,
    required this.rating,
    required this.reviews,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      level: json['level'] ?? 'beginner',
      duration: json['duration'] ?? 30,
      points: json['points'] ?? 0,
      thumbnail: json['thumbnail'],
      authorId: json['author'] != null 
          ? (json['author'] is String ? json['author'] : json['author']['_id'] ?? '')
          : '',
      authorName: json['author'] != null && json['author'] is Map 
          ? json['author']['username'] 
          : null,
      modules: (json['modules'] as List?)
          ?.map((m) => CourseModule.fromJson(m))
          .toList() ?? [],
      quizId: json['quiz'],
      published: json['published'] ?? false,
      enrolledCount: json['enrolledCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: (json['reviews'] as List?)
          ?.map((r) => CourseReview.fromJson(r))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class CourseModule {
  final String title;
  final String content;
  final int order;
  final String? videoUrl;
  final List<String> resources;

  CourseModule({
    required this.title,
    required this.content,
    required this.order,
    this.videoUrl,
    required this.resources,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      title: json['title'],
      content: json['content'],
      order: json['order'],
      videoUrl: json['videoUrl'],
      resources: List<String>.from(json['resources'] ?? []),
    );
  }
}

class CourseReview {
  final String userId;
  final String? username;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  CourseReview({
    required this.userId,
    this.username,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    return CourseReview(
      userId: json['user'] != null
          ? (json['user'] is String ? json['user'] : json['user']['_id'] ?? '')
          : '',
      username: json['user'] != null && json['user'] is Map 
          ? json['user']['username'] 
          : null,
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

