import 'package:flutter/material.dart';

class FinancialInsightsScreen extends StatefulWidget {
  final String userId;

  const FinancialInsightsScreen({super.key, required this.userId});

  @override
  State<FinancialInsightsScreen> createState() =>
      _FinancialInsightsScreenState();
}

class _FinancialInsightsScreenState extends State<FinancialInsightsScreen>
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
          'Financial Insights',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Month Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const Text(
                    'February 2024',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
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
                Tab(text: 'Summary'),
                Tab(text: 'Analysis'),
                Tab(text: 'Comparison'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildAnalysisTab(),
                _buildComparisonTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Key Metrics
        const Text(
          'Key Metrics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Total Income',
                amount: '\$4,500.00',
                icon: Icons.arrow_upward,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Total Expenses',
                amount: '\$2,150.25',
                icon: Icons.arrow_downward,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Net Savings',
                amount: '\$2,349.75',
                icon: Icons.savings,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Avg. Daily Spend',
                amount: '\$71.68',
                icon: Icons.calendar_today,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Income Breakdown
        const Text(
          'Income Sources',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSourceItem('💰 Salary', '\$3,500.00', 0.78),
        const SizedBox(height: 8),
        _buildSourceItem('💼 Freelance', '\$750.00', 0.17),
        const SizedBox(height: 8),
        _buildSourceItem('🎁 Bonus', '\$250.00', 0.05),
        const SizedBox(height: 24),

        // Expense Breakdown
        const Text(
          'Expense Distribution',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSourceItem('🍔 Food & Dining', '\$450.00', 0.21),
        const SizedBox(height: 8),
        _buildSourceItem('🚗 Transportation', '\$320.00', 0.15),
        const SizedBox(height: 8),
        _buildSourceItem('🎮 Entertainment', '\$280.00', 0.13),
        const SizedBox(height: 8),
        _buildSourceItem('💳 Shopping', '\$600.00', 0.28),
        const SizedBox(height: 8),
        _buildSourceItem('🏠 Housing', '\$400.00', 0.18),
        const SizedBox(height: 8),
        _buildSourceItem('🏥 Healthcare', '\$100.00', 0.05),
      ],
    );
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Spending Patterns',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Spending Trend',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBarChart('Mon', 85, 150),
                  _buildBarChart('Tue', 120, 150),
                  _buildBarChart('Wed', 100, 150),
                  _buildBarChart('Thu', 95, 150),
                  _buildBarChart('Fri', 140, 150),
                  _buildBarChart('Sat', 110, 150),
                  _buildBarChart('Sun', 90, 150),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Top Transactions
        const Text(
          'Largest Transactions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTransactionTile('💳 Rent Payment', '-\$1,200.00', '2024-02-01'),
        const SizedBox(height: 8),
        _buildTransactionTile('🛍️ Amazon Purchase', '-\$325.00', '2024-02-15'),
        const SizedBox(height: 8),
        _buildTransactionTile('💰 Salary Deposit', '+\$3,500.00', '2024-02-01'),
        const SizedBox(height: 24),

        // Insights
        const Text(
          'AI Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          'You spent 15% more on food & dining compared to last month.',
          Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildInsightCard(
          'Your budget utilization is healthy at 43% this month.',
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildInsightCard(
          'You exceeded your entertainment budget. Consider adjusting your limits.',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildComparisonTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Month-over-Month Comparison',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildComparisonItem(label: 'February', income: 4500, expense: 2150.25),
        const SizedBox(height: 12),
        _buildComparisonItem(label: 'January', income: 4200, expense: 1980),
        const SizedBox(height: 12),
        _buildComparisonItem(label: 'December', income: 4500, expense: 2450.75),
        const SizedBox(height: 24),

        // Trends
        const Text(
          'Trends',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTrendItem('Income', '+5% from last month', Colors.green),
        const SizedBox(height: 8),
        _buildTrendItem('Expenses', '+8.6% from last month', Colors.red),
        const SizedBox(height: 8),
        _buildTrendItem('Savings', '+1.8% from last month', Colors.blue),
        const SizedBox(height: 24),

        // Category Comparison
        const Text(
          'Top Categories (Month-to-Month)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildCategoryComparison('Food & Dining', 450, 400),
        const SizedBox(height: 8),
        _buildCategoryComparison('Transportation', 320, 280),
        const SizedBox(height: 8),
        _buildCategoryComparison('Entertainment', 280, 200),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
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
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String source, String amount, double percentage) {
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
              Text(source, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            minHeight: 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String day, double height, double maxHeight) {
    return Column(
      children: [
        Container(
          width: 30,
          height: (height / maxHeight) * 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(day, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildTransactionTile(String title, String amount, String date) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                date,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: amount.contains('-') ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem({
    required String label,
    required double income,
    required double expense,
  }) {
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${income.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expenses',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${expense.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Savings',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${(income - expense).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String label, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: [
              Icon(
                change.startsWith('+')
                    ? Icons.trending_up
                    : Icons.trending_down,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryComparison(
    String category,
    double current,
    double previous,
  ) {
    double difference = current - previous;
    bool isIncrease = difference > 0;

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Feb vs Jan',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${current.toStringAsFixed(0)}'),
                  Text(
                    '\$${difference.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isIncrease ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                isIncrease ? Icons.trending_up : Icons.trending_down,
                color: isIncrease ? Colors.red : Colors.green,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
