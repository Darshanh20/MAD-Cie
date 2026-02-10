import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'transaction_history_screen.dart';
import 'expense_tracker_screen.dart';
import 'budget_screen.dart';
import 'insights_screen.dart';
import '../../services/supabase_service.dart' as supabase_service;

class FinancialAppContainer extends StatefulWidget {
  final String userId;

  const FinancialAppContainer({super.key, required this.userId});

  @override
  State<FinancialAppContainer> createState() => _FinancialAppContainerState();
}

class _FinancialAppContainerState extends State<FinancialAppContainer> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  late final supabase_service.SupabaseService _supabaseService;

  @override
  void initState() {
    super.initState();
    _supabaseService = supabase_service.SupabaseService();

    _screens = [
      FinancialDashboard(userId: widget.userId),
      TransactionHistoryScreen(userId: widget.userId),
      ExpenseTrackerScreen(userId: widget.userId),
      BudgetScreen(userId: widget.userId),
      FinancialInsightsScreen(userId: widget.userId),
    ];
  }

  void _handleLogout() async {
    try {
      await _supabaseService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Budget'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Financial App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _handleLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
