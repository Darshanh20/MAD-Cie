import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/financial/dashboard_screen.dart';
import '../screens/financial/transaction_history_screen.dart';
import '../screens/financial/expense_tracker_screen.dart';
import '../screens/financial/budget_screen.dart';
import '../screens/financial/insights_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String financialDashboard = '/financial-dashboard';
  static const String transactions = '/transactions';
  static const String expenseTracker = '/expense-tracker';
  static const String budgets = '/budgets';
  static const String insights = '/insights';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case financialDashboard:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => FinancialDashboard(userId: userId ?? 'user'),
        );
      case transactions:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TransactionHistoryScreen(userId: userId ?? 'user'),
        );
      case expenseTracker:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ExpenseTrackerScreen(userId: userId ?? 'user'),
        );
      case budgets:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BudgetScreen(userId: userId ?? 'user'),
        );
      case insights:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => FinancialInsightsScreen(userId: userId ?? 'user'),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
