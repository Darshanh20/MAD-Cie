# Financial Application - Complete Setup Guide

A comprehensive Flutter financial management application with Supabase backend integration. Manage accounts, track transactions, set budgets, and gain financial insights.

## 📁 Project Structure

```
lib/
├── models/                           # Data models
│   ├── user_model.dart              # User profile/authentication
│   ├── account_model.dart           # Bank/financial accounts
│   ├── category_model.dart          # Expense/income categories
│   ├── transaction_model.dart       # Individual transactions
│   └── budget_model.dart            # Budget tracking
│
├── services/                         # Backend services
│   ├── supabase_service.dart        # Supabase client & all queries
│   └── supabase_setup.sql           # Database schema & functions
│
├── screens/
│   ├── auth/                         # Authentication screens
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   └── financial/                    # Financial app screens
│       ├── dashboard_screen.dart     # Overview & summary
│       ├── transaction_history_screen.dart
│       ├── expense_tracker_screen.dart
│       ├── budget_screen.dart
│       └── insights_screen.dart      # Analytics & insights
│
├── widgets/                          # Reusable widgets
├── routes/
│   └── app_routes.dart              # Navigation routing
├── constants/                        # App constants
├── main.dart                         # App entry point
│
└── SUPABASE_QUERIES.md              # Detailed queries documentation
```

## 🚀 Features

### Dashboard
- Account summary with multiple accounts
- Quick stats (income, expenses, net savings)
- Top spending categories visualization
- Recent transactions list
- Financial goals tracking

### Transaction Management
- Comprehensive transaction history
- Grouped by date
- Filter by type (income, expense, transfer)
- Search functionality
- Detailed transaction details with time stamps

### Expense Tracking
- Category-wise expense breakdown
- Daily, weekly, and monthly views
- Progress indicators
- Expense trends

### Budget Management
- Set budgets by category
- Track spending against limits
- Budget alerts (warnings/exceeded)
- Monthly budget trends
- Budget overview

### Financial Insights
- Monthly vs monthly comparison
- Spending patterns analysis
- Top transactions
- AI-powered insights
- Transaction statistics
- Income vs expense analysis

## 🛠️ Supabase Setup

### 1. Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Copy your project URL and anon key

### 2. Run Database Setup
1. Go to SQL Editor in Supabase dashboard
2. Create new query
3. Copy entire content from `lib/services/supabase_setup.sql`
4. Execute all SQL commands

This will create:
- 5 main tables (users, accounts, categories, transactions, budgets)
- RLS (Row Level Security) policies
- Database views for analytics
- PostgreSQL functions for complex queries
- Indexes for performance

### 3. Environment Configuration
Create a `.env` file in project root:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

Or update in `main.dart`:
```dart
await SupabaseService().initialize(
  'https://your-project.supabase.co',
  'your-anon-key',
);
```

## 📦 Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  charts_flutter: ^0.12.0  # For charts
```

Install:
```bash
flutter pub get
```

## 🔐 Authentication

### Sign Up
```dart
await SupabaseService().signUp(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'John Doe',
);
```

### Login
```dart
final user = await SupabaseService().login(
  email: 'user@example.com',
  password: 'password123',
);
```

### Logout
```dart
await SupabaseService().logout();
```

## 💼 Account Management

### Create Account
```dart
final account = await SupabaseService().createAccount(
  userId: 'user-uuid',
  accountName: 'Checking Account',
  accountType: 'checking',
  initialBalance: 5000.00,
  currency: 'USD',
);
```

### Get All Accounts
```dart
final accounts = await SupabaseService().getAccountsByUserId('user-uuid');
```

### Get Total Balance
```dart
final balance = await SupabaseService().getTotalBalance('user-uuid');
```

## 💳 Transaction Operations

### Add Transaction
```dart
final transaction = await SupabaseService().createTransaction(
  userId: 'user-uuid',
  accountId: 'account-id',
  categoryId: 'category-id',
  description: 'Grocery Shopping',
  amount: 125.50,
  type: 'expense',
  paymentMethod: 'card',
);
```

### Get Transactions
```dart
// By account
final txns = await SupabaseService()
  .getTransactionsByAccountId('account-id');

// By user (all accounts)
final txns = await SupabaseService()
  .getTransactionsByUserId('user-uuid');

// By date range
final txns = await SupabaseService()
  .getTransactionsByDateRange(
    'user-uuid',
    DateTime(2024, 2, 1),
    DateTime(2024, 2, 29),
  );

// Monthly summary
final summary = await SupabaseService()
  .getMonthlyExpensesSummary('user-uuid', DateTime.now());
```

## 📊 Budget Management

### Create Budget
```dart
final budget = await SupabaseService().createBudget(
  userId: 'user-uuid',
  categoryId: 'category-id',
  limitAmount: 500.00,
  period: 'monthly',
  startDate: DateTime(2024, 2, 1),
  endDate: DateTime(2024, 2, 29),
);
```

### Get Budgets
```dart
final budgets = await SupabaseService().getBudgetsByUserId('user-uuid');
```

## 📈 Analytics & Insights

### Get Spending Insights
```dart
final insights = await SupabaseService().getSpendingInsights(
  'user-uuid',
  DateTime(2024, 2, 1),
  DateTime(2024, 2, 29),
);
```

### Compare Monthly Spending
```dart
final comparison = await SupabaseService()
  .compareMonthlySpending('user-uuid', 3); // Last 3 months
```

### Get Transaction Stats
```dart
final stats = await SupabaseService().getTransactionStats(
  'user-uuid',
  DateTime.now(),
);
// Returns: total_income, total_expense, net, transaction_count, average_expense
```

## 🎯 Route Navigation

### Available Routes
```dart
AppRoutes.login               // '/login'
AppRoutes.signup              // '/signup'
AppRoutes.home                // '/home'
AppRoutes.financialDashboard  // '/financial-dashboard'
AppRoutes.transactions        // '/transactions'
AppRoutes.expenseTracker      // '/expense-tracker'
AppRoutes.budgets             // '/budgets'
AppRoutes.insights            // '/insights'
```

### Navigation Examples
```dart
// Simple navigation
Navigator.pushNamed(context, AppRoutes.financialDashboard);

// Pass arguments
Navigator.pushNamed(
  context,
  AppRoutes.financialDashboard,
  arguments: 'user-uuid',
);

// Replace current route
Navigator.pushReplacementNamed(context, AppRoutes.financialDashboard);
```

## 🔍 Database Queries All Supported

### User Queries
- Get user profile
- Update profile
- User account summary

### Account Queries
- Create account
- Get all accounts
- Get single account
- Update balance
- Get total balance
- Get balance by type

### Transaction Queries
- Create transaction
- Get by account/user/category
- Get by date range
- Get monthly summaries
- Search transactions
- Update/delete transactions

### Budget Queries
- Create budget
- Get budgets
- Update budget
- Get budget status
- Budget alerts

### Analytics Queries
- Monthly comparison
- Spending insights (top categories)
- Transaction statistics
- Daily spending trends
- Category breakdown
- Payment method analysis
- Recurring transactions

See `SUPABASE_QUERIES.md` for complete SQL documentation.

## ⚙️ RLS Policies

All tables have Row Level Security enabled:
- Users can only access their own data
- All operations filtered by `user_id`
- SELECT, INSERT, UPDATE, DELETE policies set
- Automatic user_id injection on insert

## 📱 Running the App

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d web
```

## 🖼️ Screens Overview

### Dashboard Screen
Central hub showing:
- Multiple account cards (pageable)
- Income/Expense overview
- Top spending categories
- Recent transactions
- Financial goals

### Transaction History Screen
Detailed view of:
- Grouped transactions by date
- Filter options
- Search functionality
- Transaction details with icons

### Expense Tracker Screen
Three tabs:
- Categories: breakdown by category
- Daily: daily spending view
- Monthly: monthly trends

### Budget Screen
Monitor budgets with:
- Total budget overview
- Category-wise budgets
- Budget status indicators
- Monthly trends

### Insights Screen
Three analysis tabs:
- Summary: key metrics & sources
- Analysis: patterns & insights
- Comparison: month-to-month

## 🐛 Troubleshooting

### Common Issues

**Issue**: "new row violates row-level security policy"
- Ensure `user_id` matches authenticated user
- Check RLS policies are properly set

**Issue**: Slow queries
- Verify indexes exist
- Use pagination with LIMIT/OFFSET
- Check Supabase database logs

**Issue**: Real-time not working
- Enable real-time subscriptions in Supabase dashboard
- Ensure table is in publication
- Check network connection

## 📚 Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Plugin](https://github.com/supabase/supabase-flutter)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🔐 Security Best Practices

1. ✅ Never commit Supabase keys to version control
2. ✅ Use .env files with .gitignore
3. ✅ Enable RLS on all tables (done)
4. ✅ Validate all user inputs
5. ✅ Use HTTPS only
6. ✅ Keep dependencies updated
7. ✅ Implement proper authentication
8. ✅ Use service role key only on backend

## 📝 License

This project is open source and available under the MIT License.

---

**Created**: February 2024
**Updated**: February 2024
**Version**: 1.0.0

For questions or support, refer to the documentation and Supabase community forums.
