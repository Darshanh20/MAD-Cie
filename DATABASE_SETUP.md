# Database Setup Guide

## Critical: Deploy Database Schema

The `lib/services/supabase_setup.sql` file contains all necessary SQL to create your database structure.

### Step 1: Access Supabase SQL Editor

1. Go to: https://app.supabase.com/
2. Login with your account
3. Select project: `cie_exam`
4. Click **"SQL Editor"** in left sidebar
5. Click **"New Query"**

### Step 2: Copy & Paste SQL

1. Open file: `lib/services/supabase_setup.sql`
2. Select all content (Ctrl+A)
3. Copy (Ctrl+C)
4. Paste in Supabase SQL Editor (Ctrl+V)
5. Click **"RUN"** button

### Step 3: Verify Tables

In Supabase Dashboard **Table Editor**, verify these tables exist:
- ✅ users (from Supabase Auth)
- ✅ accounts
- ✅ categories
- ✅ transactions
- ✅ budgets

For each table, verify **RLS Enabled** shows green checkmark.

## Database Tables

### accounts
- user_id (UUID) - Links to authenticated user
- name (VARCHAR) - Account name
- type (VARCHAR) - Account type (checking, savings, credit, investment)
- balance (NUMERIC) - Current balance
- currency (VARCHAR) - Currency code

### categories
- user_id (UUID) - User's custom categories
- name (VARCHAR) - Category name
- emoji (VARCHAR) - Visual icon
- color (VARCHAR) - Color hex code
- type (VARCHAR) - Income or expense

### transactions
- account_id (UUID) - Which account
- category_id (UUID) - Transaction category
- amount (NUMERIC) - Amount
- type (VARCHAR) - Income or expense
- date (DATE) - Transaction date
- recurring (BOOLEAN) - Is recurring?

### budgets
- user_id (UUID) - User's budget
- category_id (UUID) - Category to track
- limit_amount (NUMERIC) - Budget limit
- month (VARCHAR) - Budget period
- spent (NUMERIC) - Amount spent

## Row Level Security (RLS)

All tables have RLS enabled with policies that ensure:
- Users can only access their own data
- Other users cannot see your transactions, accounts, or budgets
- Enforced at database level (maximum security)

## Troubleshooting

### "Table does not exist" Error

Make sure you ran the complete SQL from `supabase_setup.sql` in the Supabase SQL Editor.

### "Permission denied" Error

Verify:
1. RLS is **Enabled** on table
2. You're logged in with the account that owns the data
3. Policies are correctly set up in Supabase → Database → Policies

### Connection Timeout

Check:
1. Internet connection is working
2. Supabase project is active (not paused)
3. Credentials in main.dart are correct

## Quick Reference

| Operation | Location |
|-----------|----------|
| Deploy SQL | Supabase → SQL Editor → New Query |
| View Tables | Supabase → Table Editor |
| Check RLS | Supabase → Table Editor → RLS Enabled column |
| View Policies | Supabase → Database → Policies |
| Real-time | Supabase → Database → Replication |

## Next Steps

Once tables are created:
1. Run `flutter run`
2. Test sign up/login
3. Create test accounts
4. Add transactions
5. Verify data persists

✨ See [QUICK_SETUP.md](QUICK_SETUP.md) for complete setup instructions!
