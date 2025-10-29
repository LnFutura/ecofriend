class Profile {
  final String id;
  final String userId;
  final String? fullName;
  final String? avatar;
  final String? bio;
  final Location? location;
  final int points;
  final int level;
  final List<String> achievements;
  final List<String> completedCourses;
  final List<String> attendedEvents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.userId,
    this.fullName,
    this.avatar,
    this.bio,
    this.location,
    this.points = 0,
    this.level = 1,
    this.achievements = const [],
    this.completedCourses = const [],
    this.attendedEvents = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] is String ? json['user'] : json['user']?['_id'] ?? '',
      fullName: json['fullName'],
      avatar: json['avatar'],
      bio: json['bio'],
      location: json['location'] != null 
          ? Location.fromJson(json['location']) 
          : null,
      points: json['points'] ?? 0,
      level: json['level'] ?? 1,
      achievements: json['achievements'] != null
          ? List<String>.from(json['achievements'].map((x) => x is String ? x : x['_id']))
          : [],
      completedCourses: json['completedCourses'] != null
          ? List<String>.from(json['completedCourses'].map((x) => x is String ? x : x['_id']))
          : [],
      attendedEvents: json['attendedEvents'] != null
          ? List<String>.from(json['attendedEvents'].map((x) => x is String ? x : x['_id']))
          : [],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'fullName': fullName,
      'avatar': avatar,
      'bio': bio,
      'location': location?.toJson(),
      'points': points,
      'level': level,
      'achievements': achievements,
      'completedCourses': completedCourses,
      'attendedEvents': attendedEvents,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? avatar,
    String? bio,
    Location? location,
    int? points,
    int? level,
    List<String>? achievements,
    List<String>? completedCourses,
    List<String>? attendedEvents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      points: points ?? this.points,
      level: level ?? this.level,
      achievements: achievements ?? this.achievements,
      completedCourses: completedCourses ?? this.completedCourses,
      attendedEvents: attendedEvents ?? this.attendedEvents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Location {
  final String? city;
  final String? country;
  final List<double>? coordinates; // [longitude, latitude]

  Location({
    this.city,
    this.country,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      country: json['country'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'coordinates': coordinates,
    };
  }
}

