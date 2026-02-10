import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_model.dart' as user_model;
import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

// Alias for clarity
typedef AppUser = user_model.User;

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  /// Get Supabase client (already initialized in main.dart)
  SupabaseClient get client => Supabase.instance.client;

  // ==================== AUTH QUERIES ====================

  /// Sign up new user
  Future<AppUser> signUp(String email, String password, String fullName) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) throw Exception('Sign up failed');

      // Return user from auth response (no need to insert into users table)
      final user = AppUser(
        id: response.user!.id,
        email: email,
        fullName: fullName,
        createdAt: DateTime.parse(response.user!.createdAt),
      );

      return user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  /// Login user
  Future<AppUser> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) throw Exception('Login failed');

      // Return user from auth response
      final user = AppUser(
        id: response.user!.id,
        email: response.user!.email ?? email,
        fullName: response.user!.userMetadata?['full_name'] ?? 'User',
        createdAt: DateTime.parse(response.user!.createdAt),
      );

      return user;
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  /// Get current user
  AppUser? getCurrentUser() {
    final user = client.auth.currentUser;
    return user != null
        ? AppUser(
            id: user.id,
            email: user.email ?? '',
            fullName: user.userMetadata?['full_name'] ?? 'User',
            createdAt: DateTime.parse(user.createdAt),
          )
        : null;
  }

  // ==================== USER QUERIES ====================

  /// Get user profile
  Future<AppUser> getUserProfile(String userId) async {
    try {
      // Get user profile from auth
      final user = client.auth.currentUser;
      if (user == null || user.id != userId) {
        throw Exception('User not authenticated or user ID mismatch');
      }

      return AppUser(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] ?? 'User',
        createdAt: DateTime.parse(user.createdAt),
      );
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(
    String userId,
    String fullName, {
    String? profileImage,
  }) async {
    try {
      // Update auth user metadata
      await client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            if (profileImage != null) 'profile_image': profileImage,
          },
        ),
      );
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // ==================== ACCOUNT QUERIES ====================

  /// Create new account
  Future<Account> createAccount(
    String userId,
    String accountName,
    String accountType,
    double initialBalance, {
    String currency = 'USD',
    String? bankName,
    String? accountNumber,
  }) async {
    try {
      final account = Account(
        id: 'ACC_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        accountName: accountName,
        accountType: accountType,
        balance: initialBalance,
        currency: currency,
        bankName: bankName,
        accountNumber: accountNumber,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await client.from('accounts').insert(account.toJson());
      return account;
    } catch (e) {
      print('Error creating account: $e');
      rethrow;
    }
  }

  /// Get all accounts for user
  Future<List<Account>> getAccountsByUserId(String userId) async {
    try {
      final data = await client
          .from('accounts')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true);

      return (data as List).map((item) => Account.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching accounts: $e');
      rethrow;
    }
  }

  /// Get single account
  Future<Account> getAccountById(String accountId) async {
    try {
      final data = await client
          .from('accounts')
          .select()
          .eq('id', accountId)
          .single();
      return Account.fromJson(data);
    } catch (e) {
      print('Error fetching account: $e');
      rethrow;
    }
  }

  /// Update account balance
  Future<void> updateAccountBalance(String accountId, double newBalance) async {
    try {
      await client
          .from('accounts')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', accountId);
    } catch (e) {
      print('Error updating account balance: $e');
      rethrow;
    }
  }

  /// Get total balance across all accounts
  Future<double> getTotalBalance(String userId) async {
    try {
      final data = await client
          .from('accounts')
          .select('balance')
          .eq('user_id', userId)
          .eq('is_active', true);

      double total = 0;
      for (var item in data as List) {
        total += (item['balance'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error fetching total balance: $e');
      rethrow;
    }
  }

  // ==================== CATEGORY QUERIES ====================

  /// Create category
  Future<Category> createCategory(
    String userId,
    String name,
    String icon,
    String color,
    String type, {
    String? description,
  }) async {
    try {
      final category = Category(
        id: 'CAT_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        name: name,
        icon: icon,
        color: color,
        type: type,
        description: description,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await client.from('categories').insert(category.toJson());
      return category;
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  /// Get all categories for user
  Future<List<Category>> getCategoriesByUserId(
    String userId, {
    String? type,
  }) async {
    try {
      var query = client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true);

      if (type != null) {
        query = query.eq('type', type);
      }

      final data = await query;
      return (data as List).map((item) => Category.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await client
          .from('categories')
          .update({'is_active': false})
          .eq('id', categoryId);
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // ==================== TRANSACTION QUERIES ====================

  /// Create transaction
  Future<Transaction> createTransaction({
    required String userId,
    required String accountId,
    required String categoryId,
    required String description,
    required double amount,
    required String type,
    required String paymentMethod,
    String status = 'completed',
    String? notes,
    String? attachmentUrl,
    bool isRecurring = false,
    String? recurringFrequency,
    DateTime? transactionDate,
  }) async {
    try {
      final transaction = Transaction(
        id: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        accountId: accountId,
        categoryId: categoryId,
        description: description,
        amount: amount,
        type: type,
        status: status,
        transactionDate: transactionDate ?? DateTime.now(),
        paymentMethod: paymentMethod,
        notes: notes,
        attachmentUrl: attachmentUrl,
        isRecurring: isRecurring,
        recurringFrequency: recurringFrequency,
        createdAt: DateTime.now(),
      );

      await client.from('transactions').insert(transaction.toJson());

      // Update account balance
      if (status == 'completed') {
        final account = await getAccountById(accountId);
        final newBalance = type == 'income'
            ? account.balance + amount
            : account.balance - amount;
        await updateAccountBalance(accountId, newBalance);
      }

      return transaction;
    } catch (e) {
      print('Error creating transaction: $e');
      rethrow;
    }
  }

  /// Get transactions by account
  Future<List<Transaction>> getTransactionsByAccountId(
    String accountId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await client
          .from('transactions')
          .select()
          .eq('account_id', accountId)
          .order('transaction_date', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List).map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

  /// Get transactions by user (all accounts)
  Future<List<Transaction>> getTransactionsByUserId(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('transaction_date', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List).map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching user transactions: $e');
      rethrow;
    }
  }

  /// Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final data = await client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .gte('transaction_date', startDate.toIso8601String())
          .lte('transaction_date', endDate.toIso8601String())
          .order('transaction_date', ascending: false);

      return (data as List).map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching transactions by date range: $e');
      rethrow;
    }
  }

  /// Get transactions by category
  Future<List<Transaction>> getTransactionsByCategoryId(
    String categoryId, {
    int limit = 50,
  }) async {
    try {
      final data = await client
          .from('transactions')
          .select()
          .eq('category_id', categoryId)
          .order('transaction_date', ascending: false)
          .limit(limit);

      return (data as List).map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching transactions by category: $e');
      rethrow;
    }
  }

  /// Get monthly expenses summary
  Future<Map<String, double>> getMonthlyExpensesSummary(
    String userId,
    DateTime month,
  ) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final data = await client
          .from('transactions')
          .select('category_id, amount')
          .eq('user_id', userId)
          .eq('type', 'expense')
          .gte('transaction_date', startDate.toIso8601String())
          .lte('transaction_date', endDate.toIso8601String());

      Map<String, double> summary = {};
      for (var item in data as List) {
        final categoryId = item['category_id'] as String;
        final amount = (item['amount'] as num).toDouble();
        summary[categoryId] = (summary[categoryId] ?? 0) + amount;
      }
      return summary;
    } catch (e) {
      print('Error fetching monthly expenses: $e');
      rethrow;
    }
  }

  /// Get monthly income summary
  Future<double> getMonthlyIncomeSummary(String userId, DateTime month) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final data = await client
          .from('transactions')
          .select('amount')
          .eq('user_id', userId)
          .eq('type', 'income')
          .gte('transaction_date', startDate.toIso8601String())
          .lte('transaction_date', endDate.toIso8601String());

      double total = 0;
      for (var item in data as List) {
        total += (item['amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error fetching monthly income: $e');
      rethrow;
    }
  }

  /// Update transaction
  Future<void> updateTransaction(
    String transactionId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updated_at'] = DateTime.now().toIso8601String();
      await client.from('transactions').update(updates).eq('id', transactionId);
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await client.from('transactions').delete().eq('id', transactionId);
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  // ==================== BUDGET QUERIES ====================

  /// Create budget
  Future<Budget> createBudget({
    required String userId,
    required String categoryId,
    required double limitAmount,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final budget = Budget(
        id: 'BDG_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        categoryId: categoryId,
        limitAmount: limitAmount,
        spent: 0,
        period: period,
        startDate: startDate,
        endDate: endDate,
        status: 'active',
        createdAt: DateTime.now(),
      );

      await client.from('budgets').insert(budget.toJson());
      return budget;
    } catch (e) {
      print('Error creating budget: $e');
      rethrow;
    }
  }

  /// Get budgets by user
  Future<List<Budget>> getBudgetsByUserId(String userId) async {
    try {
      final data = await client
          .from('budgets')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active');

      return (data as List).map((item) => Budget.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching budgets: $e');
      rethrow;
    }
  }

  /// Update budget spent amount
  Future<void> updateBudgetSpent(String budgetId, double amount) async {
    try {
      await client
          .from('budgets')
          .update({
            'spent': amount,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', budgetId);
    } catch (e) {
      print('Error updating budget: $e');
      rethrow;
    }
  }

  // ==================== ADVANCED FINANCE QUERIES ====================

  /// Get spending insights (top categories by month)
  Future<List<Map<String, dynamic>>> getSpendingInsights(
    String userId,
    DateTime month,
  ) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final data = await client.rpc(
        'get_spending_insights',
        params: {
          'p_user_id': userId,
          'p_start_date': startDate.toIso8601String(),
          'p_end_date': endDate.toIso8601String(),
        },
      );

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching spending insights: $e');
      // Fallback to manual calculation
      return [];
    }
  }

  /// Get transaction statistics
  Future<Map<String, dynamic>> getTransactionStats(
    String userId,
    DateTime month,
  ) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final transactions = await getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );

      double totalIncome = 0;
      double totalExpense = 0;
      int transactionCount = 0;

      for (var txn in transactions) {
        if (txn.type == 'income') {
          totalIncome += txn.amount;
        } else if (txn.type == 'expense') {
          totalExpense += txn.amount;
        }
        transactionCount++;
      }

      return {
        'total_income': totalIncome,
        'total_expense': totalExpense,
        'net': totalIncome - totalExpense,
        'transaction_count': transactionCount,
        'average_expense': transactionCount > 0
            ? totalExpense / transactionCount
            : 0,
      };
    } catch (e) {
      print('Error fetching transaction stats: $e');
      rethrow;
    }
  }

  /// Compare spending across months
  Future<Map<String, double>> compareMonthlySpending(
    String userId,
    int monthsBack,
  ) async {
    try {
      Map<String, double> comparison = {};

      for (int i = 0; i < monthsBack; i++) {
        final month = DateTime.now().subtract(Duration(days: 30 * i));
        final summary = await getMonthlyExpensesSummary(userId, month);

        double monthTotal = 0;
        for (var amount in summary.values) {
          monthTotal += amount;
        }

        comparison['${month.year}-${month.month.toString().padLeft(2, '0')}'] =
            monthTotal;
      }

      return comparison;
    } catch (e) {
      print('Error comparing monthly spending: $e');
      rethrow;
    }
  }
}
