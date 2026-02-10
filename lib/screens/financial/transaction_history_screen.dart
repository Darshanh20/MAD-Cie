import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String userId;

  const TransactionHistoryScreen({super.key, required this.userId});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  String _sortBy = 'Date';
  final List<String> filterOptions = ['All', 'Income', 'Expense', 'Transfer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Filter menu
            },
            icon: const Icon(Icons.filter_list, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter Chips
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterOptions.map((option) {
                    bool isSelected = _selectedFilter == option;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedFilter = option);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.deepPurple.shade100,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Search and Sort
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.tune, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grouped by Date Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildTransactionGroup('Today', [
                    _TransactionItemData(
                      icon: '🍔',
                      title: 'McDonald\'s',
                      category: 'Food & Dining',
                      amount: '-\$12.50',
                      isExpense: true,
                      time: '2:30 PM',
                    ),
                    _TransactionItemData(
                      icon: '⛽',
                      title: 'Shell Gas Station',
                      category: 'Transportation',
                      amount: '-\$45.00',
                      isExpense: true,
                      time: '10:15 AM',
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildTransactionGroup('Yesterday', [
                    _TransactionItemData(
                      icon: '💰',
                      title: 'Salary Deposit',
                      category: 'Income',
                      amount: '+\$3,500.00',
                      isExpense: false,
                      time: '9:00 AM',
                    ),
                    _TransactionItemData(
                      icon: '🏠',
                      title: 'Rent Payment',
                      category: 'Housing',
                      amount: '-\$1,200.00',
                      isExpense: true,
                      time: '8:00 AM',
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildTransactionGroup('This Week', [
                    _TransactionItemData(
                      icon: '🎮',
                      title: 'Steam',
                      category: 'Entertainment',
                      amount: '-\$49.99',
                      isExpense: true,
                      time: '3:45 PM',
                    ),
                    _TransactionItemData(
                      icon: '🛍️',
                      title: 'Amazon',
                      category: 'Shopping',
                      amount: '-\$125.00',
                      isExpense: true,
                      time: '1:20 PM',
                    ),
                    _TransactionItemData(
                      icon: '💳',
                      title: 'Credit Card Payment',
                      category: 'Payments',
                      amount: '-\$2,000.00',
                      isExpense: true,
                      time: '11:00 AM',
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildTransactionGroup('Last Month', [
                    _TransactionItemData(
                      icon: '🏥',
                      title: 'Medical Clinic',
                      category: 'Healthcare',
                      amount: '-\$150.00',
                      isExpense: true,
                      time: '2:15 PM',
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionGroup(
    String title,
    List<_TransactionItemData> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((entry) {
          int idx = entry.key;
          _TransactionItemData item = entry.value;
          bool isLast = idx == items.length - 1;

          return Column(
            children: [
              _buildTransactionItemWidget(item),
              if (!isLast) const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionItemWidget(_TransactionItemData item) {
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
            child: Text(item.icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  item.category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: item.isExpense ? Colors.red : Colors.green,
                ),
              ),
              Text(
                item.time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionItemData {
  final String icon;
  final String title;
  final String category;
  final String amount;
  final bool isExpense;
  final String time;

  _TransactionItemData({
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.time,
  });
}
