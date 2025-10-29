class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String type;
  final AchievementCondition condition;
  final int points;
  final String rarity;
  final DateTime createdAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.condition,
    required this.points,
    required this.rarity,
    required this.createdAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'] ?? '🏆',
      type: json['type'],
      condition: AchievementCondition.fromJson(json['condition']),
      points: json['points'] ?? 0,
      rarity: json['rarity'] ?? 'common',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type,
      'condition': condition.toJson(),
      'points': points,
      'rarity': rarity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class AchievementCondition {
  final String type;
  final int value;

  AchievementCondition({
    required this.type,
    required this.value,
  });

  factory AchievementCondition.fromJson(Map<String, dynamic> json) {
    return AchievementCondition(
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

