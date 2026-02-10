class Budget {
  final String id;
  final String userId;
  final String categoryId;
  final double limitAmount;
  final double spent;
  final String period; // monthly, yearly
  final DateTime startDate;
  final DateTime endDate;
  final String status; // active, inactive
  final DateTime createdAt;
  final DateTime? updatedAt;

  Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.limitAmount,
    required this.spent,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  double get remaining => limitAmount - spent;
  double get percentageUsed => (spent / limitAmount) * 100;

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      limitAmount: (json['limit_amount'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      period: json['period'] ?? 'monthly',
      startDate: DateTime.parse(
        json['start_date'] ?? DateTime.now().toString(),
      ),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'limit_amount': limitAmount,
      'spent': spent,
      'period': period,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
