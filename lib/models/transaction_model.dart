class Transaction {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final String description;
  final double amount;
  final String type; // income, expense, transfer
  final String status; // pending, completed, failed
  final DateTime transactionDate;
  final String paymentMethod; // cash, card, transfer, check
  final String? notes;
  final String? attachmentUrl;
  final bool isRecurring;
  final String? recurringFrequency; // daily, weekly, monthly, yearly
  final DateTime createdAt;
  final DateTime? updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.type,
    required this.status,
    required this.transactionDate,
    required this.paymentMethod,
    this.notes,
    this.attachmentUrl,
    required this.isRecurring,
    this.recurringFrequency,
    required this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      accountId: json['account_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? 'expense',
      status: json['status'] ?? 'completed',
      transactionDate: DateTime.parse(
        json['transaction_date'] ?? DateTime.now().toString(),
      ),
      paymentMethod: json['payment_method'] ?? 'card',
      notes: json['notes'],
      attachmentUrl: json['attachment_url'],
      isRecurring: json['is_recurring'] ?? false,
      recurringFrequency: json['recurring_frequency'],
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
      'account_id': accountId,
      'category_id': categoryId,
      'description': description,
      'amount': amount,
      'type': type,
      'status': status,
      'transaction_date': transactionDate.toIso8601String(),
      'payment_method': paymentMethod,
      'notes': notes,
      'attachment_url': attachmentUrl,
      'is_recurring': isRecurring,
      'recurring_frequency': recurringFrequency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
