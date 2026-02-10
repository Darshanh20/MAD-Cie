# Database Setup Guide

This guide explains how to set up your Supabase database for the CIE Exam Financial Application.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Database Structure](#database-structure)
3. [Setup Steps](#setup-steps)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)

## Quick Start

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project: `cie_exam`
3. Navigate to **SQL Editor**
4. Copy and paste all SQL from `lib/services/supabase_setup.sql`
5. Click **Run** to execute
6. Verify tables are created in the **Table Editor**

## Database Structure

### Tables Created

| Table | Purpose | Columns |
|-------|---------|---------|
| `users` | User authentication & profiles | id, email, fullName, profileImage, createdAt, updatedAt |
| `accounts` | Financial accounts (checking, savings, etc.) | id, userId, name, type, balance, currency, bankName, createdAt |
| `categories` | Expense/Income categories | id, userId, name, emoji, color, type, createdAt |
| `transactions` | Individual transactions | id, accountId, categoryId, amount, description, type, date, recurring, attachments |
| `budgets` | Budget tracking | id, userId, categoryId, limitAmount, month, spent, createdAt |

### Database Features

✅ **Row Level Security (RLS)** - Users can only access their own data
✅ **Real-time Subscriptions** - Live updates for transactions, accounts, budgets, categories
✅ **Indexes** - Optimized queries for fast lookups
✅ **Views** - Pre-built analytical views
✅ **Functions** - Stored procedures for complex operations

## Setup Steps

### Step 1: Access Supabase SQL Editor

```
1. Go to https://app.supabase.com
2. Login with your Supabase account
3. Select "cie_exam" project
4. Click "SQL Editor" in left sidebar
5. Click "New Query" button
```

### Step 2: Copy SQL Schema

The complete database schema is in: `lib/services/supabase_setup.sql`

**Option A: Copy All at Once (Recommended)**
```
1. Open lib/services/supabase_setup.sql
2. Select all content (Ctrl+A or Cmd+A)
3. Copy (Ctrl+C or Cmd+C)
4. Paste into Supabase SQL Editor
5. Click "Run" button
```

**Option B: Run Step by Step** (if Option A fails)
See the breakdown below.

### Step 3: Verify Execution

After running the SQL, you should see:
- ✅ No error messages
- ✅ "SUCCESS" indicator (green checkmark)
- ✅ All queries executed

### Step 4: Check Table Creation

In Supabase Dashboard:
```
1. Click "Table Editor" in left sidebar
2. Verify these tables exist:
   - users
   - accounts
   - categories
   - transactions
   - budgets
3. Click on each table to verify columns
```

## SQL Setup Details

### Users Table (Auto-created by Supabase Auth)

```sql
-- Users table is automatically created by Supabase Auth
-- It has the following structure:
-- id (UUID, primary key)
-- email (text, unique)
-- encrypted_password (text)
-- email_confirmed_at (timestamp)
-- invited_at (timestamp)
-- confirmation_token (text)
-- confirmation_sent_at (timestamp)
-- recovery_token (text)
-- recovery_sent_at (timestamp)
-- email_change (text)
-- email_change_token_new (text)
-- email_change_token_current (text)
-- email_change_confirm_token_new (text)
-- recovery_token_new (text)
-- last_sign_in_at (timestamp)
-- raw_app_meta_data (jsonb)
-- raw_user_meta_data (jsonb)
-- is_super_admin (boolean)
-- created_at (timestamp)
-- updated_at (timestamp)
-- phone (text, unique)
-- phone_confirmed_at (timestamp)
-- phone_change (text)
-- phone_change_token (text)
-- phone_change_sent_at (timestamp)
-- confirmed_at (timestamp)
-- email_change_token_sent_at (timestamp)
-- is_sso_user (boolean)
-- deleted_at (timestamp)
```

### Accounts Table

```sql
CREATE TABLE IF NOT EXISTS accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  type VARCHAR NOT NULL DEFAULT 'checking',
  balance NUMERIC DEFAULT 0,
  currency VARCHAR DEFAULT 'USD',
  bank_name VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for user lookups
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_type ON accounts(type);

-- Enable RLS
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own accounts
CREATE POLICY "Users can view own accounts"
  ON accounts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create accounts"
  ON accounts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own accounts"
  ON accounts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own accounts"
  ON accounts FOR DELETE
  USING (auth.uid() = user_id);
```

### Categories Table

```sql
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  emoji VARCHAR DEFAULT '📝',
  color VARCHAR DEFAULT '#6366F1',
  type VARCHAR NOT NULL DEFAULT 'expense',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for user lookups
CREATE INDEX idx_categories_user_id ON categories(user_id);
CREATE INDEX idx_categories_type ON categories(type);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own categories"
  ON categories FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create categories"
  ON categories FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own categories"
  ON categories FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own categories"
  ON categories FOR DELETE
  USING (auth.uid() = user_id);
```

### Transactions Table

```sql
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  amount NUMERIC NOT NULL,
  description VARCHAR,
  type VARCHAR NOT NULL DEFAULT 'expense',
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  recurring BOOLEAN DEFAULT FALSE,
  attachments TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for fast queries
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
CREATE INDEX idx_transactions_date ON transactions(date);
CREATE INDEX idx_transactions_type ON transactions(type);

-- Enable RLS
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own transactions"
  ON transactions FOR SELECT
  USING (
    account_id IN (
      SELECT id FROM accounts 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create transactions"
  ON transactions FOR INSERT
  WITH CHECK (
    account_id IN (
      SELECT id FROM accounts 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own transactions"
  ON transactions FOR UPDATE
  USING (
    account_id IN (
      SELECT id FROM accounts 
      WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own transactions"
  ON transactions FOR DELETE
  USING (
    account_id IN (
      SELECT id FROM accounts 
      WHERE user_id = auth.uid()
    )
  );
```

### Budgets Table

```sql
CREATE TABLE IF NOT EXISTS budgets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  limit_amount NUMERIC NOT NULL,
  month VARCHAR NOT NULL,
  spent NUMERIC DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_category_id ON budgets(category_id);
CREATE INDEX idx_budgets_month ON budgets(month);

-- Enable RLS
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own budgets"
  ON budgets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create budgets"
  ON budgets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own budgets"
  ON budgets FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own budgets"
  ON budgets FOR DELETE
  USING (auth.uid() = user_id);
```

## Verification

### Check 1: Verify Tables Exist

```bash
# In Supabase → Table Editor, verify these tables are listed:
- users (from Supabase Auth)
- accounts
- categories
- transactions
- budgets
```

### Check 2: Verify RLS is Enabled

In Supabase Dashboard:
```
1. Table Editor → Select "accounts"
2. Scroll right to see "RLS Enabled?" column
3. Should show "Enabled" with green checkmark
4. Repeat for: categories, transactions, budgets
```

### Check 3: Test Database Connection

When you run the Flutter app:
```
1. App will show splash screen with "Testing database..."
2. Should see console log: "✅ Database connection successful"
3. App will navigate to login screen
```

If you see "⚠️ Database connection failed":
- Check that all tables were created
- Verify RLS policies are enabled
- Check that Supabase credentials in main.dart are correct

### Check 4: Test Authentication

In the app:
```
1. Click "Sign Up" button
2. Enter email and password
3. Should create user in auth.users table
4. Should navigate to dashboard
```

## Troubleshooting

### Issue: "Table does not exist" error

**Solution:**
1. Verify all SQL was executed successfully (check for error messages)
2. In Supabase Table Editor, manually create tables using the SQL above
3. Ensure RLS is enabled on each table
4. Verify you're running complete SQL from `supabase_setup.sql`

### Issue: "Permission denied" or RLS errors

**Solution:**
1. Verify RLS policies were created successfully
2. Check that user_id in data matches authenticated user ID
3. In Supabase Dashboard → Policies, verify policies exist on each table
4. Try disabling RLS temporarily to test (not recommended for production)

### Issue: Real-time subscriptions not working

**Solution:**
1. Verify realtime is enabled in Supabase → Database → Replication
2. Check that you're subscribed to correct tables: transactions, accounts, budgets, categories
3. Ensure RLS policies aren't blocking subscriptions
4. Check browser console for subscription errors

### Issue: Connection timeout

**Solution:**
1. Verify Supabase URL is correct: `https://lmxpykolgesjxkyruswi.supabase.co`
2. Verify anon key is correct and starts with `eyJ...`
3. Check your internet connection
4. Verify Supabase project is active (not paused)
5. Check Supabase status page: https://status.supabase.com

### Issue: Duplicate migrations or table already exists

**Solution:**
```sql
-- To drop all tables and start fresh:
DROP TABLE IF EXISTS budgets CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;

-- Then re-run the complete SQL from supabase_setup.sql
```

## Manual Table Creation

If copying the entire SQL fails, create tables individually:

### Step 1: Create Accounts Table

```sql
CREATE TABLE accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  type VARCHAR NOT NULL DEFAULT 'checking',
  balance NUMERIC DEFAULT 0,
  currency VARCHAR DEFAULT 'USD',
  bank_name VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_accounts_user_id ON accounts(user_id);
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts SET REPLICA IDENTITY FULL;

CREATE POLICY "users_view_own_accounts" ON accounts
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "users_create_accounts" ON accounts
  FOR INSERT WITH CHECK (auth.uid() = user_id);
Create POLICY "users_update_own_accounts" ON accounts
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "users_delete_own_accounts" ON accounts
  FOR DELETE USING (auth.uid() = user_id);
```

### Step 2: Create Categories Table

```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  emoji VARCHAR DEFAULT '📝',
  color VARCHAR DEFAULT '#6366F1',
  type VARCHAR NOT NULL DEFAULT 'expense',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categories_user_id ON categories(user_id);
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories SET REPLICA IDENTITY FULL;

CREATE POLICY "users_view_own_categories" ON categories
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "users_create_categories" ON categories
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "users_update_own_categories" ON categories
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "users_delete_own_categories" ON categories
  FOR DELETE USING (auth.uid() = user_id);
```

### Step 3: Create Transactions Table

```sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  amount NUMERIC NOT NULL,
  description VARCHAR,
  type VARCHAR NOT NULL DEFAULT 'expense',
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  recurring BOOLEAN DEFAULT FALSE,
  attachments TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
CREATE INDEX idx_transactions_date ON transactions(date);
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions SET REPLICA IDENTITY FULL;

CREATE POLICY "users_view_own_transactions" ON transactions
  FOR SELECT USING (
    account_id IN (
      SELECT id FROM accounts WHERE user_id = auth.uid()
    )
  );
CREATE POLICY "users_create_transactions" ON transactions
  FOR INSERT WITH CHECK (
    account_id IN (
      SELECT id FROM accounts WHERE user_id = auth.uid()
    )
  );
CREATE POLICY "users_update_own_transactions" ON transactions
  FOR UPDATE USING (
    account_id IN (
      SELECT id FROM accounts WHERE user_id = auth.uid()
    )
  );
CREATE POLICY "users_delete_own_transactions" ON transactions
  FOR DELETE USING (
    account_id IN (
      SELECT id FROM accounts WHERE user_id = auth.uid()
    )
  );
```

### Step 4: Create Budgets Table

```sql
CREATE TABLE budgets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  limit_amount NUMERIC NOT NULL,
  month VARCHAR NOT NULL,
  spent NUMERIC DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_month ON budgets(month);
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets SET REPLICA IDENTITY FULL;

CREATE POLICY "users_view_own_budgets" ON budgets
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "users_create_budgets" ON budgets
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "users_update_own_budgets" ON budgets
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "users_delete_own_budgets" ON budgets
  FOR DELETE USING (auth.uid() = user_id);
```

## Next Steps

After database is set up:

1. ✅ Database tables created and RLS enabled
2. 🔄 Test login/signup in Flutter app
3. 🔄 Create test accounts and transactions
4. 🔄 Verify real-time subscriptions work
5. 🔄 Test budget and expense tracking features

## Support

If you encounter issues:

1. Check [Supabase Docs](https://supabase.com/docs)
2. Review console logs in Flutter app (check print statements)
3. Check Supabase Dashboard → Database → SQL Editor for query errors
4. Verify Supabase project status at https://status.supabase.com
