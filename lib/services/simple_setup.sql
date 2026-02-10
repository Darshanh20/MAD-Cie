-- ==================== USERS TABLE (Simple Email/Password) ====================
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  profile_image TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ==================== ACCOUNTS TABLE ====================
CREATE TABLE IF NOT EXISTS accounts (
  id VARCHAR(50) PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  account_name VARCHAR(255) NOT NULL,
  account_type VARCHAR(50) NOT NULL, -- checking, savings, credit_card, investment
  balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',
  bank_name VARCHAR(255),
  account_number VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create indexes for accounts
CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_account_type ON accounts(account_type);

-- ==================== CATEGORIES TABLE ====================
CREATE TABLE IF NOT EXISTS categories (
  id VARCHAR(50) PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  icon VARCHAR(10) DEFAULT '📝',
  color VARCHAR(10) DEFAULT '#6366F1',
  type VARCHAR(50) NOT NULL DEFAULT 'expense', -- income or expense
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for categories
CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_type ON categories(type);

-- ==================== TRANSACTIONS TABLE ====================
CREATE TABLE IF NOT EXISTS transactions (
  id VARCHAR(50) PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  account_id VARCHAR(50) NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  category_id VARCHAR(50) REFERENCES categories(id) ON DELETE SET NULL,
  amount DECIMAL(12, 2) NOT NULL,
  type VARCHAR(50) NOT NULL DEFAULT 'expense', -- income or expense
  description VARCHAR(255),
  status VARCHAR(50) NOT NULL DEFAULT 'completed', -- pending, completed, cancelled
  transaction_date DATE DEFAULT CURRENT_DATE,
  payment_method VARCHAR(100),
  notes TEXT,
  attachment_url TEXT,
  is_recurring BOOLEAN DEFAULT false,
  recurring_frequency VARCHAR(50), -- daily, weekly, monthly, yearly
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create indexes for transactions
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_transaction_date ON transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);

-- ==================== BUDGETS TABLE ====================
CREATE TABLE IF NOT EXISTS budgets (
  id VARCHAR(50) PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id VARCHAR(50) NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  limit_amount DECIMAL(12, 2) NOT NULL,
  spent DECIMAL(12, 2) DEFAULT 0,
  period VARCHAR(50) NOT NULL DEFAULT 'monthly', -- monthly, quarterly, yearly
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active', -- active, inactive, expired
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

-- Create indexes for budgets
CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category_id ON budgets(category_id);

-- ==================== VIEWS FOR ANALYTICS ====================

-- Monthly spending summary by category
CREATE MATERIALIZED VIEW IF NOT EXISTS monthly_spending AS
SELECT
  user_id,
  category_id,
  DATE_TRUNC('month', transaction_date)::DATE as month,
  SUM(amount) as total_amount,
  COUNT(*) as transaction_count
FROM transactions
WHERE type = 'expense'
GROUP BY user_id, category_id, DATE_TRUNC('month', transaction_date);

-- Daily balance tracking
CREATE MATERIALIZED VIEW IF NOT EXISTS daily_balance AS
SELECT
  user_id,
  account_id,
  transaction_date,
  SUM(CASE WHEN type = 'income' THEN amount ELSE -amount END) as daily_change
FROM transactions
GROUP BY user_id, account_id, transaction_date;

-- User financial summary
CREATE MATERIALIZED VIEW IF NOT EXISTS user_summary AS
SELECT
  u.id,
  u.email,
  u.full_name,
  COUNT(DISTINCT a.id) as total_accounts,
  COALESCE(SUM(a.balance), 0) as total_balance,
  COUNT(DISTINCT t.id) as total_transactions
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id AND a.is_active = true
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.email, u.full_name;
