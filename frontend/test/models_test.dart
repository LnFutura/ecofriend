import 'package:flutter_test/flutter_test.dart';
import 'package:ecodrug_frontend/models/user.dart';
import 'package:ecodrug_frontend/models/profile.dart';
import 'package:ecodrug_frontend/models/course.dart';
import 'package:ecodrug_frontend/models/news.dart';
import 'package:ecodrug_frontend/models/event.dart';

void main() {
  group('User Model Tests', () {
    test('User.fromJson should parse JSON correctly', () {
      final json = {
        '_id': '123',
        'email': 'test@example.com',
        'username': 'testuser',
        'role': 'user',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.username, 'testuser');
      expect(user.role, 'user');
    });

    test('User.toJson should create correct JSON', () {
      final user = User(
        id: '123',
        email: 'test@example.com',
        username: 'testuser',
        role: 'user',
      );

      final json = user.toJson();

      expect(json['_id'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['username'], 'testuser');
      expect(json['role'], 'user');
    });
  });

  group('Profile Model Tests', () {
    test('Profile.fromJson should parse JSON correctly', () {
      final json = {
        '_id': 'profile123',
        'userId': 'user123',
        'fullName': 'John Doe',
        'points': 150,
        'level': 3,
        'achievements': [],
        'completedCourses': [],
        'registeredEvents': [],
      };

      final profile = Profile.fromJson(json);

      expect(profile.id, 'profile123');
      expect(profile.userId, 'user123');
      expect(profile.fullName, 'John Doe');
      expect(profile.points, 150);
      expect(profile.level, 3);
    });
  });

  group('Course Model Tests', () {
    test('Course.fromJson should parse JSON correctly', () {
      final json = {
        '_id': 'course123',
        'title': 'Recycling Basics',
        'description': 'Learn recycling',
        'category': 'recycling',
        'difficulty': 'beginner',
        'points': 50,
        'estimatedTime': '30 min',
        'isPublished': true,
        'modules': [],
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final course = Course.fromJson(json);

      expect(course.id, 'course123');
      expect(course.title, 'Recycling Basics');
      expect(course.category, 'recycling');
      expect(course.difficulty, 'beginner');
      expect(course.points, 50);
    });
  });

  group('News Model Tests', () {
    test('News.fromJson should parse JSON correctly', () {
      final json = {
        '_id': 'news123',
        'title': 'Eco News',
        'content': 'Important eco news',
        'category': 'events',
        'tags': ['ecology', 'news'],
        'author': {
          '_id': 'user123',
          'username': 'author',
        },
        'status': 'approved',
        'likes': 10,
        'views': 100,
        'imageUrl': 'https://example.com/image.jpg',
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final news = News.fromJson(json);

      expect(news.id, 'news123');
      expect(news.title, 'Eco News');
      expect(news.content, 'Important eco news');
      expect(news.likes, 10);
      expect(news.views, 100);
    });
  });

  group('Event Model Tests', () {
    test('Event.fromJson should parse JSON correctly', () {
      final json = {
        '_id': 'event123',
        'title': 'Park Cleanup',
        'description': 'Join us for cleanup',
        'type': 'cleanup',
        'startDate': '2024-06-01T10:00:00.000Z',
        'endDate': '2024-06-01T14:00:00.000Z',
        'location': {
          'address': 'Central Park',
          'city': 'Moscow',
        },
        'organizer': {
          '_id': 'org123',
          'username': 'EcoOrg',
        },
        'maxParticipants': 50,
        'currentParticipants': 25,
        'points': 30,
        'status': 'upcoming',
        'createdAt': '2024-01-01T00:00:00.000Z',
      };

      final event = Event.fromJson(json);

      expect(event.id, 'event123');
      expect(event.title, 'Park Cleanup');
      expect(event.type, 'cleanup');
      expect(event.maxParticipants, 50);
      expect(event.currentParticipants, 25);
      expect(event.points, 30);
    });
  });
}

