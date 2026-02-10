import 'package:flutter/material.dart';

class FinancialDashboard extends StatefulWidget {
  final String userId;

  const FinancialDashboard({super.key, required this.userId});

  @override
  State<FinancialDashboard> createState() => _FinancialDashboardState();
}

class _FinancialDashboardState extends State<FinancialDashboard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
            // Account Summary Cards
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: 3, // Number of accounts
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AccountCard(
                      accountName: [
                        'Business Account',
                        'Savings',
                        'Credit Card',
                      ][index],
                      balance: [5250.50, 12300.00, 2500.00][index],
                      accountType: ['Checking', 'Savings', 'Credit'][index],
                      isActive: index != 2,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Page Indicators
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
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
            ),
            const SizedBox(height: 24),

            // Quick Stats Section
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
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.arrow_upward,
                          iconColor: Colors.green,
                          label: 'Income',
                          amount: '\$4,500.00',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.arrow_downward,
                          iconColor: Colors.red,
                          label: 'Expenses',
                          amount: '\$2,150.25',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Expense by Category Section
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
                  CategoryExpenseItem(
                    icon: '🍔',
                    category: 'Food & Dining',
                    amount: '\$450.00',
                    percentage: 35,
                  ),
                  const SizedBox(height: 8),
                  CategoryExpenseItem(
                    icon: '🚗',
                    category: 'Transportation',
                    amount: '\$320.00',
                    percentage: 25,
                  ),
                  const SizedBox(height: 8),
                  CategoryExpenseItem(
                    icon: '🎮',
                    category: 'Entertainment',
                    amount: '\$280.00',
                    percentage: 22,
                  ),
                  const SizedBox(height: 8),
                  CategoryExpenseItem(
                    icon: '💳',
                    category: 'Shopping',
                    amount: '\$150.00',
                    percentage: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
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
                  TransactionItem(
                    icon: '🍔',
                    title: 'McDonald\'s',
                    subtitle: 'Food & Dining',
                    amount: '-\$12.50',
                    isExpense: true,
                    date: 'Today',
                  ),
                  const SizedBox(height: 8),
                  TransactionItem(
                    icon: '💰',
                    title: 'Salary Deposit',
                    subtitle: 'Income',
                    amount: '+\$3,500.00',
                    isExpense: false,
                    date: 'Yesterday',
                  ),
                  const SizedBox(height: 8),
                  TransactionItem(
                    icon: '⛽',
                    title: 'Gas Station',
                    subtitle: 'Transportation',
                    amount: '-\$45.00',
                    isExpense: true,
                    date: '2 days ago',
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
