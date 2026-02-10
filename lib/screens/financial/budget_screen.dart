import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final String userId;

  const BudgetScreen({super.key, required this.userId});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Budget Management',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Budget Overview
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Budget',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$5,000.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spent',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '\$2,150.25',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Remaining',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '\$2,849.75',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Percentage',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '43%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Budget Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetItem(
                    icon: '🍔',
                    category: 'Food & Dining',
                    spent: 450.00,
                    limit: 600.00,
                    status: 'ok',
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetItem(
                    icon: '🚗',
                    category: 'Transportation',
                    spent: 320.00,
                    limit: 400.00,
                    status: 'ok',
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetItem(
                    icon: '🎮',
                    category: 'Entertainment',
                    spent: 280.00,
                    limit: 250.00,
                    status: 'exceeded',
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetItem(
                    icon: '💳',
                    category: 'Shopping',
                    spent: 600.00,
                    limit: 800.00,
                    status: 'warning',
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetItem(
                    icon: '🏥',
                    category: 'Healthcare',
                    spent: 100.00,
                    limit: 500.00,
                    status: 'ok',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Monthly Trends
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Budget Trends (Last 3 Months)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTrendCard('February', 2150.25, 5000.00, 0.43),
                  const SizedBox(height: 8),
                  _buildTrendCard('January', 1980.00, 5000.00, 0.40),
                  const SizedBox(height: 8),
                  _buildTrendCard('December', 2450.75, 5000.00, 0.49),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new budget
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetItem({
    required String icon,
    required String category,
    required double spent,
    required double limit,
    required String status,
  }) {
    double percentage = spent / limit;
    Color statusColor = status == 'ok'
        ? Colors.green
        : status == 'warning'
        ? Colors.orange
        : Colors.red;

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
                      '\$${spent.toStringAsFixed(2)} / \$${limit.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage > 1 ? 1 : percentage,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(statusColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(
    String month,
    double spent,
    double limit,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(month, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '\$${spent.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            minHeight: 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% of monthly budget',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
