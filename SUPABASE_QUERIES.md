# Supabase Queries for Financial Application

This document contains all the SQL queries and operations for the Financial App database.

## TABLE OF CONTENTS
1. [User Management](#user-management)
2. [Account Operations](#account-operations)
3. [Transaction Management](#transaction-management)
4. [Category Management](#category-management)
5. [Budget Management](#budget-management)
6. [Financial Analytics](#financial-analytics)
7. [Advanced Queries](#advanced-queries)

---

## USER MANAGEMENT

### Create User Account
```sql
-- Insert new user (called automatically after auth signup)
INSERT INTO users (id, email, full_name, created_at)
VALUES ('user-uuid', 'user@example.com', 'John Doe', NOW());
```

### Get User Profile
```sql
SELECT id, email, full_name, profile_image, created_at, updated_at
FROM users
WHERE id = 'user-uuid';
```

### Update User Profile
```sql
UPDATE users
SET full_name = 'Jane Doe',
    profile_image = 'https://...',
    updated_at = NOW()
WHERE id = 'user-uuid';
```

### Get User Account Summary
```sql
SELECT 
  u.id as user_id,
  u.full_name,
  COUNT(a.id) as total_accounts,
  COUNT(CASE WHEN a.is_active THEN 1 END) as active_accounts,
  SUM(CASE WHEN a.is_active THEN a.balance ELSE 0 END) as total_balance
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id
WHERE u.id = 'user-uuid'
GROUP BY u.id, u.full_name;
```

---

## ACCOUNT OPERATIONS

### Create New Account
```sql
INSERT INTO accounts (
  id, user_id, account_name, account_type, balance, 
  currency, bank_name, account_number, is_active, created_at
)
VALUES (
  'ACC_' || extract(epoch from NOW())::bigint,
  'user-uuid',
  'Business Account',
  'checking',
  5250.50,
  'USD',
  'Chase Bank',
  'XXXX-XXXX-1234',
  true,
  NOW()
);
```

### Get All User Accounts
```sql
SELECT *
FROM accounts
WHERE user_id = 'user-uuid' 
  AND is_active = true
ORDER BY created_at DESC;
```

### Get Single Account with Balance
```sql
SELECT id, account_name, account_type, balance, currency, bank_name
FROM accounts
WHERE id = 'account-id' AND user_id = 'user-uuid';
```

### Get Total Balance Across All Accounts
```sql
SELECT SUM(balance) as total_balance
FROM accounts
WHERE user_id = 'user-uuid' AND is_active = true;
```

### Get Account Balance by Type
```sql
SELECT 
  account_type,
  COUNT(*) as count,
  SUM(balance) as total_balance
FROM accounts
WHERE user_id = 'user-uuid' AND is_active = true
GROUP BY account_type;
```

### Update Account Balance
```sql
UPDATE accounts
SET balance = balance - 50.00,  -- Subtract 50 or add with +
    updated_at = NOW()
WHERE id = 'account-id' AND user_id = 'user-uuid';
```

### Deactivate Account
```sql
UPDATE accounts
SET is_active = false,
    updated_at = NOW()
WHERE id = 'account-id' AND user_id = 'user-uuid';
```

---

## TRANSACTION MANAGEMENT

### Create Transaction
```sql
INSERT INTO transactions (
  id, user_id, account_id, category_id, description, amount,
  type, status, transaction_date, payment_method, created_at
)
VALUES (
  'TXN_' || extract(epoch from NOW())::bigint,
  'user-uuid',
  'account-id',
  'category-id',
  'Grocery Shopping',
  125.50,
  'expense',  -- income, expense, transfer
  'completed',  -- pending, completed, failed
  NOW(),
  'card',  -- cash, card, transfer, check
  NOW()
);
```

### Get Transactions by Account
```sql
SELECT 
  t.*,
  c.name as category_name,
  c.icon,
  a.account_name
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts a ON t.account_id = a.id
WHERE t.account_id = 'account-id' AND t.user_id = 'user-uuid'
ORDER BY t.transaction_date DESC
LIMIT 50;
```

### Get All User Transactions with Details
```sql
SELECT 
  t.*,
  c.name as category_name,
  c.icon,
  a.account_name
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts a ON t.account_id = a.id
WHERE t.user_id = 'user-uuid'
ORDER BY t.transaction_date DESC
LIMIT 100 OFFSET 0;
```

### Get Transactions by Date Range
```sql
SELECT 
  t.*,
  c.name as category_name,
  a.account_name
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts a ON t.account_id = a.id
WHERE t.user_id = 'user-uuid'
  AND t.transaction_date >= '2024-02-01'::timestamp with time zone
  AND t.transaction_date <= '2024-02-29'::timestamp with time zone
  AND t.status = 'completed'
ORDER BY t.transaction_date DESC;
```

### Search Transactions
```sql
SELECT *
FROM transactions
WHERE user_id = 'user-uuid'
  AND (description ILIKE '%McDonald%' OR description ILIKE '%Gas%')
  AND status = 'completed'
ORDER BY transaction_date DESC;
```

### Get Transactions by Category
```sql
SELECT 
  t.*,
  c.name as category_name
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.category_id = 'category-id' AND t.user_id = 'user-uuid'
ORDER BY t.transaction_date DESC
LIMIT 50;
```

### Get Monthly Expenses Summary
```sql
SELECT 
  category_id,
  c.name as category_name,
  c.icon,
  SUM(amount) as total_amount,
  COUNT(*) as transaction_count
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 'user-uuid'
  AND t.type = 'expense'
  AND DATE_TRUNC('month', t.transaction_date) = DATE_TRUNC('month', NOW())
  AND t.status = 'completed'
GROUP BY t.category_id, c.name, c.icon
ORDER BY total_amount DESC;
```

### Get Monthly Income Summary
```sql
SELECT SUM(amount) as total_income
FROM transactions
WHERE user_id = 'user-uuid'
  AND type = 'income'
  AND DATE_TRUNC('month', transaction_date) = DATE_TRUNC('month', NOW())
  AND status = 'completed';
```

### Get Income vs Expenses for Current Month
```sql
SELECT 
  type,
  COUNT(*) as count,
  SUM(amount) as total
FROM transactions
WHERE user_id = 'user-uuid'
  AND DATE_TRUNC('month', transaction_date) = DATE_TRUNC('month', NOW())
  AND status = 'completed'
GROUP BY type;
```

### Get Last N Transactions
```sql
SELECT *
FROM transactions
WHERE user_id = 'user-uuid'
ORDER BY transaction_date DESC
LIMIT 10;
```

### Update Transaction
```sql
UPDATE transactions
SET description = 'Updated Description',
    amount = 150.00,
    status = 'completed',
    updated_at = NOW()
WHERE id = 'transaction-id' AND user_id = 'user-uuid';
```

### Delete Transaction
```sql
DELETE FROM transactions
WHERE id = 'transaction-id' AND user_id = 'user-uuid';
```

---

## CATEGORY MANAGEMENT

### Create Category
```sql
INSERT INTO categories (
  id, user_id, name, icon, color, type, description, is_active, created_at
)
VALUES (
  'CAT_' || extract(epoch from NOW())::bigint,
  'user-uuid',
  'Food & Dining',
  '🍔',
  '#FF6B6B',
  'expense',
  'Restaurants, groceries, food delivery',
  true,
  NOW()
);
```

### Get All Categories (by type)
```sql
-- Get all expense categories
SELECT *
FROM categories
WHERE user_id = 'user-uuid' 
  AND type = 'expense'
  AND is_active = true
ORDER BY name;

-- Get all income categories
SELECT *
FROM categories
WHERE user_id = 'user-uuid' 
  AND type = 'income'
  AND is_active = true
ORDER BY name;
```

### Get Category with Transaction Count
```sql
SELECT 
  c.*,
  COUNT(t.id) as transaction_count
FROM categories c
LEFT JOIN transactions t ON c.id = t.category_id
WHERE c.user_id = 'user-uuid' AND c.is_active = true
GROUP BY c.id
ORDER BY c.name;
```

### Update Category
```sql
UPDATE categories
SET name = 'Restaurant & Bars',
    icon = '🍽️',
    color = '#FF8C00'
WHERE id = 'category-id' AND user_id = 'user-uuid';
```

### Delete Category (Soft Delete)
```sql
UPDATE categories
SET is_active = false
WHERE id = 'category-id' AND user_id = 'user-uuid';
```

---

## BUDGET MANAGEMENT

### Create Budget
```sql
INSERT INTO budgets (
  id, user_id, category_id, limit_amount, spent,
  period, start_date, end_date, status, created_at
)
VALUES (
  'BDG_' || extract(epoch from NOW())::bigint,
  'user-uuid',
  'category-id',
  1000.00,
  0,
  'monthly',
  '2024-02-01'::date,
  '2024-02-29'::date,
  'active',
  NOW()
);
```

### Get User Budgets
```sql
SELECT 
  b.*,
  c.name as category_name,
  c.icon
FROM budgets b
INNER JOIN categories c ON b.category_id = c.id
WHERE b.user_id = 'user-uuid' AND b.status = 'active'
ORDER BY b.created_at DESC;
```

### Get Budget Status (Spending vs Limit)
```sql
SELECT * FROM get_budget_status('user-uuid');
```

### Check Budget Alerts (Over/Under Limit)
```sql
SELECT * FROM get_budget_status('user-uuid')
WHERE status IN ('exceeded', 'warning');
```

### Update Budget Spent Amount
```sql
UPDATE budgets
SET spent = spent + 50.00,
    updated_at = NOW()
WHERE id = 'budget-id' AND user_id = 'user-uuid';
```

### Check Specific Budget Status
```sql
SELECT 
  b.id,
  c.name,
  b.limit_amount,
  COALESCE(SUM(t.amount), 0) as spent,
  b.limit_amount - COALESCE(SUM(t.amount), 0) as remaining,
  ROUND((COALESCE(SUM(t.amount), 0) / b.limit_amount * 100), 2) as percentage_used
FROM budgets b
INNER JOIN categories c ON b.category_id = c.id
LEFT JOIN transactions t ON b.category_id = t.category_id 
  AND t.user_id = b.user_id
  AND t.transaction_date >= b.start_date
  AND t.transaction_date <= b.end_date
  AND t.type = 'expense'
WHERE b.id = 'budget-id'
GROUP BY b.id, c.name, b.limit_amount;
```

---

## FINANCIAL ANALYTICS

### Monthly Comparison (Income vs Expenses)
```sql
SELECT * FROM get_monthly_comparison('user-uuid', 3);
-- Returns last 3 months: month_year, total_income, total_expense, net_amount
```

### Spending Insights (Top Categories)
```sql
SELECT * FROM get_spending_insights(
  'user-uuid',
  '2024-02-01'::timestamp with time zone,
  '2024-02-29'::timestamp with time zone
);
```

### Monthly Breakdown by Type
```sql
SELECT 
  DATE_TRUNC('month', transaction_date)::date as month,
  type,
  COUNT(*) as count,
  SUM(amount) as total
FROM transactions
WHERE user_id = 'user-uuid' AND status = 'completed'
GROUP BY DATE_TRUNC('month', transaction_date), type
ORDER BY month DESC, type;
```

### Daily Spending Trend
```sql
SELECT 
  DATE(transaction_date) as day,
  COUNT(*) as transaction_count,
  SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as daily_expenses,
  SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as daily_income
FROM transactions
WHERE user_id = 'user-uuid'
  AND transaction_date >= CURRENT_DATE - INTERVAL '30 days'
  AND status = 'completed'
GROUP BY DATE(transaction_date)
ORDER BY day DESC;
```

### Top Spending Categories by Month
```sql
SELECT 
  c.name as category,
  c.icon,
  COUNT(*) as transaction_count,
  SUM(t.amount) as total_spent,
  ROUND((SUM(t.amount) / 
    (SELECT SUM(amount) FROM transactions 
     WHERE user_id = 'user-uuid' 
     AND type = 'expense'
     AND DATE_TRUNC('month', transaction_date) = DATE_TRUNC('month', NOW())) 
    * 100), 2) as percentage_of_total
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 'user-uuid'
  AND t.type = 'expense'
  AND DATE_TRUNC('month', t.transaction_date) = DATE_TRUNC('month', NOW())
  AND t.status = 'completed'
GROUP BY c.name, c.icon
ORDER BY total_spent DESC;
```

### Monthly Financial Summary
```sql
SELECT 
  DATE_TRUNC('month', transaction_date)::date as month,
  SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_income,
  SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_expenses,
  (SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) - 
   SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END)) as net_savings,
  COUNT(*) as transaction_count
FROM transactions
WHERE user_id = 'user-uuid' AND status = 'completed'
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month DESC;
```

---

## ADVANCED QUERIES

### Recurring Income/Expenses
```sql
SELECT 
  *,
  CASE 
    WHEN is_recurring THEN 'Yes - ' || recurring_frequency
    ELSE 'No'
  END as recurring_info
FROM transactions
WHERE user_id = 'user-uuid' AND is_recurring = true
ORDER BY transaction_date DESC;
```

### Payment Method Breakdown
```sql
SELECT 
  payment_method,
  COUNT(*) as count,
  SUM(amount) as total_amount
FROM transactions
WHERE user_id = 'user-uuid' AND status = 'completed'
GROUP BY payment_method
ORDER BY total_amount DESC;
```

### Largest Transactions (Top 10)
```sql
SELECT 
  t.id,
  t.description,
  t.amount,
  t.type,
  c.name as category,
  t.transaction_date
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 'user-uuid'
ORDER BY t.amount DESC
LIMIT 10;
```

### Average Daily Spending
```sql
SELECT 
  ROUND(AVG(daily_total)::numeric, 2) as average_daily_spending
FROM (
  SELECT 
    DATE(transaction_date) as day,
    SUM(amount) as daily_total
  FROM transactions
  WHERE user_id = 'user-uuid'
    AND type = 'expense'
    AND status = 'completed'
    AND transaction_date >= CURRENT_DATE - INTERVAL '30 days'
  GROUP BY DATE(transaction_date)
) as daily_spending;
```

### Account Balance History (Over Time)
```sql
SELECT 
  DATE(transaction_date) as date,
  account_id,
  (SELECT balance FROM accounts WHERE id = a.account_id) as current_balance,
  SUM(CASE WHEN type = 'income' THEN amount ELSE -amount END) as daily_change
FROM transactions a
WHERE account_id = 'account-id' AND status = 'completed'
GROUP BY DATE(transaction_date), account_id
ORDER BY date DESC
LIMIT 30;
```

### Pending Transactions
```sql
SELECT 
  t.*,
  c.name as category_name,
  a.account_name
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
INNER JOIN accounts a ON t.account_id = a.id
WHERE t.user_id = 'user-uuid' AND t.status = 'pending'
ORDER BY t.transaction_date;
```

### Category Spending Stats (Min, Max, Avg)
```sql
SELECT 
  c.name as category,
  COUNT(*) as count,
  MIN(t.amount) as min_transaction,
  MAX(t.amount) as max_transaction,
  ROUND(AVG(t.amount)::numeric, 2) as avg_transaction,
  SUM(t.amount) as total
FROM transactions t
INNER JOIN categories c ON t.category_id = c.id
WHERE t.user_id = 'user-uuid' AND t.type = 'expense'
GROUP BY c.name
ORDER BY total DESC;
```

---

## REAL-TIME SUBSCRIPTIONS

### Subscribe to Transaction Changes
```dart
supabase
  .from('transactions')
  .on(RealtimeListenTypes.all, actions: [
    RealtimeListenActions.insert,
    RealtimeListenActions.update,
    RealtimeListenActions.delete
  ], callback: (payload) {
    print('Transaction changed: ${payload.eventType}');
  })
  .subscribe();
```

### Subscribe to Account Balance Changes
```dart
supabase
  .from('accounts')
  .on(RealtimeListenTypes.all, actions: [
    RealtimeListenActions.update
  ], callback: (payload) {
    print('Account updated: ${payload.newRecord}');
  })
  .subscribe();
```

---

## INITIALIZATION & SETUP

### Initialize Supabase in Flutter
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );
  runApp(const MyApp());
}
```

### Environment Variables (.env)
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

---

## PERFORMANCE OPTIMIZATION

### Best Practices
1. Always include `user_id` in WHERE clause for security
2. Use LIMIT for frontend queries (pagination)
3. Index frequently queried columns (already done in schema)
4. Use OFFSET for pagination, not filtering all rows
5. Rely on PostgreSQL functions for complex calculations
6. Cache results client-side when appropriate

### Useful Indexes (Already Created)
```sql
-- Users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Accounts
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_is_active ON accounts(is_active);

-- Transactions
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);

-- Categories
CREATE INDEX idx_categories_user_id ON categories(user_id);
CREATE INDEX idx_categories_type ON categories(type);

-- Budgets
CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_start_date ON budgets(start_date);
```

---

## TROUBLESHOOTING

### RLS Policy Issues
If you get "new row violates row-level security policy":
- Ensure all inserts include the correct user_id
- Check that user is authenticated
- Verify RLS policies are properly set

### Query Performance
If queries are slow:
- Check explain plan: `EXPLAIN ANALYZE query_here;`
- Verify indexes are being used
- Consider adding more specific WHERE clauses
- Use pagination with LIMIT and OFFSET

### Transaction Issues
If balance updates fail:
- Use transactions for atomic operations
- Check account exists before updating
- Ensure amount calculations are correct

---

Last Updated: February 2024
