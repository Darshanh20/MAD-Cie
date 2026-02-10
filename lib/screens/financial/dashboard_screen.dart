import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/account_model.dart';
import '../../models/transaction_model.dart';

class FinancialDashboard extends StatefulWidget {
  final String userId;

  const FinancialDashboard({super.key, required this.userId});

  @override
  State<FinancialDashboard> createState() => _FinancialDashboardState();
}

class _FinancialDashboardState extends State<FinancialDashboard> {
  late PageController _pageController;
  int _currentPage = 0;
  final SupabaseService _supabaseService = SupabaseService();

  late Future<List<Account>> _accountsFuture;
  late Future<List<Transaction>> _transactionsFuture;
  late Future<Map<String, dynamic>> _monthlyStatsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  void _loadData() {
    _accountsFuture = _supabaseService.getAccountsByUserId(widget.userId);
    _transactionsFuture = _supabaseService.getTransactionsByUserId(
      widget.userId,
      limit: 5,
    );
    _monthlyStatsFuture = _getMonthlyStats();
  }

  Future<Map<String, dynamic>> _getMonthlyStats() async {
    try {
      final transactions = await _supabaseService.getTransactionsByUserId(
        widget.userId,
      );

      final now = DateTime.now();

      double income = 0, expenses = 0;

      for (var tx in transactions) {
        if (tx.transactionDate.month == now.month &&
            tx.transactionDate.year == now.year) {
          if (tx.type == 'income') {
            income += tx.amount;
          } else {
            expenses += tx.amount;
          }
        }
      }

      return {'income': income, 'expenses': expenses};
    } catch (e) {
      print('Error calculating monthly stats: $e');
      return {'income': 0.0, 'expenses': 0.0};
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Financial Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Settings navigation
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Summary Cards - Real Data
            FutureBuilder<List<Account>>(
              future: _accountsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text('No accounts yet')),
                  );
                }

                final accounts = snapshot.data!;
                return SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AccountCard(
                          accountName: account.accountName,
                          balance: account.balance,
                          accountType: account.accountType,
                          isActive: account.isActive,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Page Indicators
            FutureBuilder<List<Account>>(
              future: _accountsFuture,
              builder: (context, snapshot) {
                final count = snapshot.data?.length ?? 0;
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      count,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Stats Section - Real Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This Month Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _monthlyStatsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                color: Colors.grey[200],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 80,
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        );
                      }

                      final stats =
                          snapshot.data ?? {'income': 0.0, 'expenses': 0.0};
                      return Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              icon: Icons.arrow_upward,
                              iconColor: Colors.green,
                              label: 'Income',
                              amount:
                                  '\$${(stats['income'] as double).toStringAsFixed(2)}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              icon: Icons.arrow_downward,
                              iconColor: Colors.red,
                              label: 'Expenses',
                              amount:
                                  '\$${(stats['expenses'] as double).toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Expense by Category Section - Real Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Spending Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Transaction>>(
                    future: _transactionsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: 100,
                          child: Center(child: Text('No spending data')),
                        );
                      }

                      // Group by category and sum
                      final Map<String, double> categoryTotals = {};
                      for (var tx in snapshot.data!) {
                        if (tx.type == 'expense') {
                          final cat = tx.categoryId ?? 'Uncategorized';
                          categoryTotals[cat] =
                              (categoryTotals[cat] ?? 0) + tx.amount;
                        }
                      }

                      final sortedCategories = categoryTotals.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value));

                      final total = categoryTotals.values.fold<double>(
                        0,
                        (a, b) => a + b,
                      );

                      return Column(
                        children: List.generate(
                          sortedCategories.length > 4
                              ? 4
                              : sortedCategories.length,
                          (index) {
                            final entry = sortedCategories[index];
                            final percentage =
                                (entry.value / (total > 0 ? total : 1) * 100)
                                    .toStringAsFixed(0);
                            return Column(
                              children: [
                                CategoryExpenseItem(
                                  icon: _getIconForCategory(entry.key),
                                  category: entry.key,
                                  amount: '\$${entry.value.toStringAsFixed(2)}',
                                  percentage: double.parse(percentage),
                                ),
                                if (index <
                                    (sortedCategories.length > 4
                                        ? 3
                                        : sortedCategories.length - 1))
                                  const SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions - Real Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/transactions');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Transaction>>(
                    future: _transactionsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: 100,
                          child: Center(child: Text('No transactions yet')),
                        );
                      }

                      final transactions = snapshot.data!;
                      return Column(
                        children: List.generate(transactions.length, (index) {
                          final tx = transactions[index];
                          final isExpense = tx.type == 'expense';
                          final amountStr = isExpense
                              ? '-\$${tx.amount.toStringAsFixed(2)}'
                              : '+\$${tx.amount.toStringAsFixed(2)}';

                          return Column(
                            children: [
                              TransactionItem(
                                icon: _getIconForCategory(tx.description ?? ''),
                                title: tx.description ?? 'Transaction',
                                subtitle: tx.categoryId ?? 'Uncategorized',
                                amount: amountStr,
                                isExpense: isExpense,
                                date: _formatDate(tx.transactionDate),
                              ),
                              if (index < transactions.length - 1)
                                const SizedBox(height: 8),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Financial Goals Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Financial Goals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GoalProgressCard(
                    title: 'Emergency Fund',
                    current: 5000,
                    target: 10000,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  GoalProgressCard(
                    title: 'Vacation Fund',
                    current: 2500,
                    target: 5000,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getIconForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('food') || lower.contains('restaurant')) return '🍔';
    if (lower.contains('transport') ||
        lower.contains('gas') ||
        lower.contains('car'))
      return '🚗';
    if (lower.contains('entertain') ||
        lower.contains('movie') ||
        lower.contains('game'))
      return '🎮';
    if (lower.contains('shop') || lower.contains('clothing')) return '💳';
    if (lower.contains('salary') || lower.contains('income')) return '💰';
    if (lower.contains('utility') || lower.contains('electricity')) return '⚡';
    if (lower.contains('health') || lower.contains('medical')) return '🏥';
    return '📝';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      final daysAgo = now.difference(date).inDays;
      if (daysAgo == 1) return '1 day ago';
      if (daysAgo < 30) return '$daysAgo days ago';
      return date.toString().split(' ')[0];
    }
  }
}

class AccountCard extends StatelessWidget {
  final String accountName;
  final double balance;
  final String accountType;
  final bool isActive;

  const AccountCard({
    super.key,
    required this.accountName,
    required this.balance,
    required this.accountType,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Colors.deepPurple.shade400, Colors.deepPurple.shade700]
              : [Colors.grey.shade400, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    accountType,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                accountName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CategoryExpenseItem extends StatelessWidget {
  final String icon;
  final String category;
  final String amount;
  final double percentage;

  const CategoryExpenseItem({
    super.key,
    required this.icon,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      amount,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              percentage > 50 ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isExpense;
  final String date;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isExpense,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GoalProgressCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final Color color;

  const GoalProgressCard({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (current / target) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${current.toStringAsFixed(2)} of \$${target.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
