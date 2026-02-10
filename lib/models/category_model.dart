class Category {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;
  final String type; // income, expense
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '📁',
      color: json['color'] ?? '#000000',
      type: json['type'] ?? 'expense',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
