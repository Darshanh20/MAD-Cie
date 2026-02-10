import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/financial/financial_app_container.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String financialApp = '/financial-app';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case financialApp:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => FinancialAppContainer(userId: userId ?? 'user'),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
