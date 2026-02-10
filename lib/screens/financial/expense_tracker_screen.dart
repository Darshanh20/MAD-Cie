import 'package:flutter/material.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  final String userId;

  const ExpenseTrackerScreen({super.key, required this.userId});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Expense Tracker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SummaryCard(
                  title: 'This Month',
                  amount: '\$2,150.25',
                  subtitle: 'Total Expenses',
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SummarySmallCard(
                        title: 'Budget',
                        amount: '\$3,000.00',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummarySmallCard(
                        title: 'Remaining',
                        amount: '\$849.75',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.deepPurple,
              tabs: const [
                Tab(text: 'Categories'),
                Tab(text: 'Daily'),
                Tab(text: 'Monthly'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Categories Tab
                _buildCategoriesTab(),
                // Daily Tab
                _buildDailyTab(),
                // Monthly Tab
                _buildMonthlyTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCategoryTile('🍔', 'Food & Dining', '\$450.00', 0.45),
        const SizedBox(height: 12),
        _buildCategoryTile('🚗', 'Transportation', '\$320.00', 0.32),
        const SizedBox(height: 12),
        _buildCategoryTile('🎮', 'Entertainment', '\$280.00', 0.28),
        const SizedBox(height: 12),
        _buildCategoryTile('💳', 'Shopping', '\$150.00', 0.15),
        const SizedBox(height: 12),
        _buildCategoryTile('🏥', 'Healthcare', '\$95.00', 0.09),
        const SizedBox(height: 12),
        _buildCategoryTile('⚡', 'Utilities', '\$180.00', 0.18),
      ],
    );
  }

  Widget _buildDailyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDaySpending('Today', '\$57.50', [
          ('🍔 McDonald\'s', '-\$12.50'),
          ('⛽ Gas Station', '-\$45.00'),
        ]),
        const SizedBox(height: 12),
        _buildDaySpending('Yesterday', '\$125.00', [
          ('🛍️ Amazon', '-\$125.00'),
        ]),
        const SizedBox(height: 12),
        _buildDaySpending('2 Days Ago', '\$200.00', [
          ('🎮 Steam', '-\$49.99'),
          ('🍽️ Restaurant', '-\$85.00'),
          ('🏠 Groceries', '-\$65.01'),
        ]),
      ],
    );
  }

  Widget _buildMonthlyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMonthSpending('February', '\$2,150.25'),
        const SizedBox(height: 12),
        _buildMonthSpending('January', '\$1,980.00'),
        const SizedBox(height: 12),
        _buildMonthSpending('December', '\$2,450.75'),
        const SizedBox(height: 12),
        _buildMonthSpending('November', '\$1,875.50'),
      ],
    );
  }

  Widget _buildCategoryTile(
    String icon,
    String category,
    String amount,
    double percentage,
  ) {
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
                child: Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            minHeight: 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySpending(
    String day,
    String total,
    List<(String, String)> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                total,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.$1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    item.$2,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMonthSpending(String month, String total) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            total,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.color,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.trending_down, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class SummarySmallCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const SummarySmallCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
