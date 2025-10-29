class Event {
  final String id;
  final String title;
  final String description;
  final String type;
  final String organizerId;
  final String? organizerName;
  final DateTime date;
  final DateTime? endDate;
  final EventLocation? location;
  final bool isOnline;
  final String? onlineLink;
  final int? capacity;
  final List<String> registered;
  final List<String> attendees;
  final String? thumbnail;
  final List<String> tags;
  final String status;
  final int points;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.organizerId,
    this.organizerName,
    required this.date,
    this.endDate,
    this.location,
    required this.isOnline,
    this.onlineLink,
    this.capacity,
    required this.registered,
    required this.attendees,
    this.thumbnail,
    required this.tags,
    required this.status,
    required this.points,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      organizerId: json['organizer'] is String 
          ? json['organizer'] 
          : json['organizer']['_id'],
      organizerName: json['organizer'] is Map 
          ? json['organizer']['username'] 
          : null,
      date: DateTime.parse(json['date']),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : null,
      location: json['location'] != null 
          ? EventLocation.fromJson(json['location']) 
          : null,
      isOnline: json['isOnline'] ?? false,
      onlineLink: json['onlineLink'],
      capacity: json['capacity'],
      registered: List<String>.from(json['registered'] ?? []),
      attendees: List<String>.from(json['attendees'] ?? []),
      thumbnail: json['thumbnail'],
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? 'pending',
      points: json['points'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  int get registeredCount => registered.length;
  bool get isFull => capacity != null && registered.length >= capacity!;
  bool get isPast => DateTime.now().isAfter(endDate ?? date);
  bool get isUpcoming => DateTime.now().isBefore(date);
  bool get isApproved => status == 'approved';
}

class EventLocation {
  final String? address;
  final String? city;
  final String? country;
  final List<double>? coordinates; // [longitude, latitude]

  EventLocation({
    this.address,
    this.city,
    this.country,
    this.coordinates,
  });

  factory EventLocation.fromJson(Map<String, dynamic> json) {
    return EventLocation(
      address: json['address'],
      city: json['city'],
      country: json['country'],
      coordinates: json['coordinates'] != null 
          ? List<double>.from(json['coordinates']) 
          : null,
    );
  }
}

