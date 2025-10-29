class RecyclingPoint {
  final String id;
  final String name;
  final List<String> type;
  final String address;
  final String city;
  final String country;
  final PointCoordinates coordinates;
  final String? workingHours;
  final String? phone;
  final String? website;
  final String? description;
  final List<String> photos;
  final String? addedById;
  final String? addedByName;
  final bool verified;
  final double rating;
  final List<PointReview> reviews;
  final DateTime createdAt;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.country,
    required this.coordinates,
    this.workingHours,
    this.phone,
    this.website,
    this.description,
    required this.photos,
    this.addedById,
    this.addedByName,
    required this.verified,
    required this.rating,
    required this.reviews,
    required this.createdAt,
  });

  factory RecyclingPoint.fromJson(Map<String, dynamic> json) {
    return RecyclingPoint(
      id: json['_id'],
      name: json['name'],
      type: List<String>.from(json['type'] ?? []),
      address: json['address'],
      city: json['city'],
      country: json['country'] ?? 'Россия',
      coordinates: PointCoordinates.fromJson(json['coordinates']),
      workingHours: json['workingHours'],
      phone: json['phone'],
      website: json['website'],
      description: json['description'],
      photos: List<String>.from(json['photos'] ?? []),
      addedById: json['addedBy'] is String 
          ? json['addedBy'] 
          : json['addedBy']?['_id'],
      addedByName: json['addedBy'] is Map 
          ? json['addedBy']['username'] 
          : null,
      verified: json['verified'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: (json['reviews'] as List?)
          ?.map((r) => PointReview.fromJson(r))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  int get reviewCount => reviews.length;
  String get typeString => type.join(', ');
}

class PointCoordinates {
  final String type;
  final List<double> coordinates; // [longitude, latitude]

  PointCoordinates({
    required this.type,
    required this.coordinates,
  });

  factory PointCoordinates.fromJson(Map<String, dynamic> json) {
    return PointCoordinates(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  double get longitude => coordinates[0];
  double get latitude => coordinates[1];
}

class PointReview {
  final String userId;
  final String? username;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  PointReview({
    required this.userId,
    this.username,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory PointReview.fromJson(Map<String, dynamic> json) {
    return PointReview(
      userId: json['user'] is String ? json['user'] : json['user']['_id'],
      username: json['user'] is Map ? json['user']['username'] : null,
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

