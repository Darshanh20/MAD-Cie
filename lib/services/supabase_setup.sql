-- ==================== USERS TABLE ====================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  profile_image TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Create index on users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Enable RLS for users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);


-- ==================== ACCOUNTS TABLE ====================
CREATE TABLE IF NOT EXISTS accounts (
  id VARCHAR(50) PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  account_name VARCHAR(255) NOT NULL,
  account_type VARCHAR(50) NOT NULL, -- checking, savings, credit_card, investment
  balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',
  bank_name VARCHAR(255),
  account_number VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for accounts
CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_account_type ON accounts(account_type);
CREATE INDEX IF NOT EXISTS idx_accounts_is_active ON accounts(is_active);
CREATE INDEX IF NOT EXISTS idx_accounts_created_at ON accounts(created_at);

-- Enable RLS for accounts table
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own accounts" ON accounts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own accounts" ON accounts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own accounts" ON accounts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own accounts" ON accounts
  FOR DELETE USING (auth.uid() = user_id);


-- ==================== CATEGORIES TABLE ====================
CREATE TABLE IF NOT EXISTS categories (
  id VARCHAR(50) PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  icon VARCHAR(50) NOT NULL, -- emoji or icon name
  color VARCHAR(7) NOT NULL, -- hex color
  type VARCHAR(20) NOT NULL, -- income, expense
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for categories
CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_type ON categories(type);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON categories(is_active);

-- Enable RLS for categories table
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own categories" ON categories
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own categories" ON categories
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own categories" ON categories
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own categories" ON categories
  FOR DELETE USING (auth.uid() = user_id);


-- ==================== TRANSACTIONS TABLE ====================
CREATE TABLE IF NOT EXISTS transactions (
  id VARCHAR(50) PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  account_id VARCHAR(50) NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  category_id VARCHAR(50) NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  description VARCHAR(255) NOT NULL,
  amount DECIMAL(15, 2) NOT NULL,
  type VARCHAR(20) NOT NULL, -- income, expense, transfer
  status VARCHAR(20) DEFAULT 'completed', -- pending, completed, failed
  transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
  payment_method VARCHAR(50) NOT NULL, -- cash, card, transfer, check
  notes TEXT,
  attachment_url TEXT,
  is_recurring BOOLEAN DEFAULT false,
  recurring_frequency VARCHAR(20), -- daily, weekly, monthly, yearly
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for transactions
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);
CREATE INDEX IF NOT EXISTS idx_transactions_transaction_date ON transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at);

-- Enable RLS for transactions table
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own transactions" ON transactions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions
  FOR DELETE USING (auth.uid() = user_id);


-- ==================== BUDGETS TABLE ====================
CREATE TABLE IF NOT EXISTS budgets (
  id VARCHAR(50) PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id VARCHAR(50) NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  limit_amount DECIMAL(15, 2) NOT NULL,
  spent DECIMAL(15, 2) DEFAULT 0,
  period VARCHAR(20) NOT NULL, -- monthly, yearly
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'active', -- active, inactive
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for budgets
CREATE INDEX IF NOT EXISTS idx_budgets_user_id ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category_id ON budgets(category_id);
CREATE INDEX IF NOT EXISTS idx_budgets_status ON budgets(status);
CREATE INDEX IF NOT EXISTS idx_budgets_start_date ON budgets(start_date);

-- Enable RLS for budgets table
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own budgets" ON budgets
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own budgets" ON budgets
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own budgets" ON budgets
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own budgets" ON budgets
  FOR DELETE USING (auth.uid() = user_id);


-- ==================== USEFUL VIEWS ====================

-- View for monthly spending by category
CREATE OR REPLACE VIEW monthly_spending_by_category AS
SELECT 
  user_id,
  DATE_TRUNC('month', transaction_date)::date as month,
  category_id,
  type,
  SUM(amount) as total_amount,
  COUNT(*) as transaction_count
FROM transactions
WHERE status = 'completed'
GROUP BY user_id, DATE_TRUNC('month', transaction_date), category_id, type;

-- View for daily balance by account
CREATE OR REPLACE VIEW daily_account_balance AS
SELECT 
  account_id,
  DATE(transaction_date) as transaction_day,
  SUM(CASE WHEN type = 'income' THEN amount ELSE -amount END) as daily_change,
  COUNT(*) as transaction_count
FROM transactions
WHERE status = 'completed'
GROUP BY account_id, DATE(transaction_date);

-- View for user account summary
CREATE OR REPLACE VIEW user_account_summary AS
SELECT 
  u.id as user_id,
  COUNT(a.id) as total_accounts,
  COUNT(CASE WHEN a.is_active THEN 1 END) as active_accounts,
  SUM(CASE WHEN a.is_active THEN a.balance ELSE 0 END) as total_balance,
  MAX(a.updated_at) as last_update
FROM users u
LEFT JOIN accounts a ON u.id = a.user_id
GROUP BY u.id;


-- ==================== DATABASE FUNCTIONS ====================

-- Function to get spending insights (RPC)
CREATE OR REPLACE FUNCTION get_spending_insights(
  p_user_id UUID,
  p_start_date TIMESTAMP WITH TIME ZONE,
  p_end_date TIMESTAMP WITH TIME ZONE
) RETURNS TABLE (
  category_id VARCHAR(50),
  category_name VARCHAR(100),
  category_icon VARCHAR(50),
  total_amount DECIMAL,
  transaction_count BIGINT,
  percentage_of_total NUMERIC
) AS $$
DECLARE
  v_total_expense DECIMAL;
BEGIN
  -- Get total expenses for the period
  SELECT COALESCE(SUM(amount), 0)
  INTO v_total_expense
  FROM transactions
  WHERE user_id = p_user_id
    AND type = 'expense'
    AND transaction_date >= p_start_date
    AND transaction_date <= p_end_date
    AND status = 'completed';

  -- Return spending breakdown by category
  RETURN QUERY
  SELECT 
    t.category_id,
    c.name,
    c.icon,
    SUM(t.amount)::DECIMAL as total_amount,
    COUNT(*)::BIGINT as transaction_count,
    CASE 
      WHEN v_total_expense > 0 THEN ROUND((SUM(t.amount) / v_total_expense * 100)::NUMERIC, 2)
      ELSE 0
    END as percentage_of_total
  FROM transactions t
  INNER JOIN categories c ON t.category_id = c.id
  WHERE t.user_id = p_user_id
    AND t.type = 'expense'
    AND t.transaction_date >= p_start_date
    AND t.transaction_date <= p_end_date
    AND t.status = 'completed'
  GROUP BY t.category_id, c.name, c.icon
  ORDER BY total_amount DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate monthly comparison
CREATE OR REPLACE FUNCTION get_monthly_comparison(
  p_user_id UUID,
  p_months_back INT
) RETURNS TABLE (
  month_year VARCHAR(7),
  total_income DECIMAL,
  total_expense DECIMAL,
  net_amount DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    TO_CHAR(DATE_TRUNC('month', t.transaction_date), 'YYYY-MM')::VARCHAR(7),
    COALESCE(SUM(CASE WHEN t.type = 'income' THEN t.amount ELSE 0 END), 0)::DECIMAL,
    COALESCE(SUM(CASE WHEN t.type = 'expense' THEN t.amount ELSE 0 END), 0)::DECIMAL,
    COALESCE(SUM(CASE WHEN t.type = 'income' THEN t.amount WHEN t.type = 'expense' THEN -t.amount ELSE 0 END), 0)::DECIMAL
  FROM transactions t
  WHERE t.user_id = p_user_id
    AND t.status = 'completed'
    AND t.transaction_date >= DATE_TRUNC('month', NOW() - (p_months_back || ' months')::INTERVAL)
  GROUP BY DATE_TRUNC('month', t.transaction_date)
  ORDER BY DATE_TRUNC('month', t.transaction_date) DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to get budget status
CREATE OR REPLACE FUNCTION get_budget_status(p_user_id UUID)
RETURNS TABLE (
  budget_id VARCHAR(50),
  category_name VARCHAR(100),
  limit_amount DECIMAL,
  spent DECIMAL,
  remaining DECIMAL,
  percentage_used NUMERIC,
  status VARCHAR(20)
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    b.id,
    c.name,
    b.limit_amount,
    COALESCE(
      (SELECT SUM(amount) FROM transactions 
       WHERE user_id = p_user_id 
         AND category_id = b.category_id 
         AND transaction_date >= b.start_date
         AND transaction_date <= b.end_date
         AND type = 'expense'
         AND status = 'completed'),
      0
    )::DECIMAL as spent_amount,
    (b.limit_amount - COALESCE(
      (SELECT SUM(amount) FROM transactions 
       WHERE user_id = p_user_id 
         AND category_id = b.category_id 
         AND transaction_date >= b.start_date
         AND transaction_date <= b.end_date
         AND type = 'expense'
         AND status = 'completed'),
      0
    ))::DECIMAL as remaining_amount,
    ROUND((COALESCE(
      (SELECT SUM(amount) FROM transactions 
       WHERE user_id = p_user_id 
         AND category_id = b.category_id 
         AND transaction_date >= b.start_date
         AND transaction_date <= b.end_date
         AND type = 'expense'
         AND status = 'completed'),
      0
    ) / b.limit_amount * 100)::NUMERIC, 2),
    CASE 
      WHEN COALESCE(
        (SELECT SUM(amount) FROM transactions 
         WHERE user_id = p_user_id 
           AND category_id = b.category_id 
           AND transaction_date >= b.start_date
           AND transaction_date <= b.end_date
           AND type = 'expense'
           AND status = 'completed'),
        0
      ) > b.limit_amount THEN 'exceeded'
      WHEN COALESCE(
        (SELECT SUM(amount) FROM transactions 
         WHERE user_id = p_user_id 
           AND category_id = b.category_id 
           AND transaction_date >= b.start_date
           AND transaction_date <= b.end_date
           AND type = 'expense'
           AND status = 'completed'),
        0
      ) > (b.limit_amount * 0.8) THEN 'warning'
      ELSE 'ok'
    END
  FROM budgets b
  INNER JOIN categories c ON b.category_id = c.id
  WHERE b.user_id = p_user_id AND b.status = 'active';
END;
$$ LANGUAGE plpgsql;

-- ==================== ENABLE REALTIME SUBSCRIPTIONS ====================
ALTER PUBLICATION supabase_realtime ADD TABLE transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE accounts;
ALTER PUBLICATION supabase_realtime ADD TABLE budgets;
ALTER PUBLICATION supabase_realtime ADD TABLE categories;

-- ==================== EXAMPLE QUERIES ====================

-- Get all transactions for a user with category info
-- SELECT t.*, c.name as category_name, c.icon, a.account_name
-- FROM transactions t
-- JOIN categories c ON t.category_id = c.id
-- JOIN accounts a ON t.account_id = a.id
-- WHERE t.user_id = 'user_uuid'
-- ORDER BY t.transaction_date DESC
-- LIMIT 50;

-- Get total balance across all accounts
-- SELECT SUM(balance) as total_balance
-- FROM accounts
-- WHERE user_id = 'user_uuid' AND is_active = true;

-- Get expenses by category for current month
-- SELECT c.id, c.name, c.icon, SUM(t.amount) as total
-- FROM transactions t
-- JOIN categories c ON t.category_id = c.id
-- WHERE t.user_id = 'user_uuid'
--   AND t.type = 'expense'
--   AND DATE_TRUNC('month', t.transaction_date) = DATE_TRUNC('month', NOW())
--   AND t.status = 'completed'
-- GROUP BY c.id, c.name, c.icon
-- ORDER BY total DESC;

-- Get spending comparison between two months
-- SELECT 
--   DATE_TRUNC('month', transaction_date)::date as month,
--   SUM(amount) as total_expenses
-- FROM transactions
-- WHERE user_id = 'user_uuid'
--   AND type = 'expense'
--   AND transaction_date >= DATE_TRUNC('month', NOW() - '2 months'::INTERVAL)
--   AND status = 'completed'
-- GROUP BY DATE_TRUNC('month', transaction_date)
-- ORDER BY month DESC;

-- Get budget alerts (budgets that are over limit)
-- SELECT * FROM get_budget_status('user_uuid')
-- WHERE percentage_used > 100;

-- Get monthly breakdown by type (income vs expense)
-- SELECT 
--   DATE_TRUNC('month', transaction_date)::date as month,
--   type,
--   SUM(amount) as total
-- FROM transactions
-- WHERE user_id = 'user_uuid' AND status = 'completed'
-- GROUP BY DATE_TRUNC('month', transaction_date), type
-- ORDER BY month DESC, type;
