class Account {
  final String id;
  final String userId;
  final String accountName;
  final String accountType; // checking, savings, credit_card, investment
  final double balance;
  final String currency;
  final String? bankName;
  final String? accountNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Account({
    required this.id,
    required this.userId,
    required this.accountName,
    required this.accountType,
    required this.balance,
    required this.currency,
    this.bankName,
    this.accountNumber,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      accountName: json['account_name'] ?? '',
      accountType: json['account_type'] ?? 'checking',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      isActive: json['is_active'] ?? true,
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
      'account_name': accountName,
      'account_type': accountType,
      'balance': balance,
      'currency': currency,
      'bank_name': bankName,
      'account_number': accountNumber,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
