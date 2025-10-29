class News {
  final String id;
  final String title;
  final String content;
  final String? excerpt;
  final String? thumbnail;
  final String category;
  final List<String> tags;
  final String authorId;
  final String? authorName;
  final String status;
  final DateTime? publishedAt;
  final int views;
  final List<String> likes;
  final List<NewsComment> comments;
  final DateTime createdAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    this.excerpt,
    this.thumbnail,
    required this.category,
    required this.tags,
    required this.authorId,
    this.authorName,
    required this.status,
    this.publishedAt,
    required this.views,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'],
      thumbnail: json['thumbnail'],
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      authorId: json['author'] != null
          ? (json['author'] is String ? json['author'] : json['author']['_id'] ?? '')
          : '',
      authorName: json['author'] != null && json['author'] is Map
          ? json['author']['username']
          : null,
      status: json['status'] ?? 'pending',
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : null,
      views: json['views'] ?? 0,
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List?)
          ?.map((c) => NewsComment.fromJson(c))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isApproved => status == 'approved';
  int get likesCount => likes.length;
  int get commentsCount => comments.length;
}

class NewsComment {
  final String userId;
  final String? username;
  final String text;
  final DateTime createdAt;

  NewsComment({
    required this.userId,
    this.username,
    required this.text,
    required this.createdAt,
  });

  factory NewsComment.fromJson(Map<String, dynamic> json) {
    return NewsComment(
      userId: json['user'] != null
          ? (json['user'] is String ? json['user'] : json['user']['_id'] ?? '')
          : '',
      username: json['user'] != null && json['user'] is Map
          ? json['user']['username']
          : null,
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

