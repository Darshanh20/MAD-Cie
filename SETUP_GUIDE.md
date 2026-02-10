# CIE Exam Financial App - Complete Setup Guide

## 🚀 Quick Start (5 minutes)

### Prerequisites
- ✅ Flutter SDK installed
- ✅ Supabase account created
- ✅ Supabase project created (cie_exam)
- ✅ .env file with credentials

### Step 1: Setup Database (Most Important!)

**This is the most critical step. Without it, the app won't work.**

1. **Open Supabase Dashboard**
   - Go to: https://app.supabase.com/
   - Login with your account
   - Select project: `cie_exam`

2. **Navigate to SQL Editor**
   ```
   Left Sidebar → SQL Editor → New Query
   ```

3. **Copy Database Schema**
   - Open file: `lib/services/supabase_setup.sql`
   - Select all content (Ctrl+A)
   - Copy (Ctrl+C)

4. **Paste & Execute**
   - Paste in Supabase SQL Editor (Ctrl+V)
   - Click "RUN" button
   - Wait for success message (green checkmark)

5. **Verify Tables**
   - Left Sidebar → Table Editor
   - Should see these tables:
     - ✅ users (from Supabase Auth)
     - ✅ accounts
     - ✅ categories
     - ✅ transactions
     - ✅ budgets

### Step 2: Test Flutter App

```bash
# From project directory
cd c:\Users\Lenovo\Desktop\cie_exam

# Run the app
flutter run

# Or on specific device
flutter run -d windows
flutter run -d chrome
```

### Step 3: Test Features

1. **Sign Up**
   - Click "Sign Up"
   - Enter email and password
   - Should create account in Supabase

2. **View Dashboard**
   - After login, should see financial dashboard
   - Check all screens work (Transactions, Budget, Insights)

3. **Test Database Operations**
   - Create an account
   - Add a transaction
   - Data should persist when you reload

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point with Supabase init
├── routes/
│   └── app_routes.dart                # Route definitions
├── models/                            # Data models
│   ├── user_model.dart
│   ├── account_model.dart
│   ├── category_model.dart
│   ├── transaction_model.dart
│   └── budget_model.dart
├── services/
│   ├── supabase_service.dart          # 90+ database operations
│   ├── supabase_setup.sql             # Database schema (CRITICAL!)
│   └── database_migration.dart        # Migration/initialization service
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   └── financial/
│       ├── dashboard_screen.dart
│       ├── transaction_history_screen.dart
│       ├── expense_tracker_screen.dart
│       ├── budget_screen.dart
│       └── insights_screen.dart
└── pubspec.yaml                       # Dependencies

docs/
├── DATABASE_SETUP.md                  # Detailed database setup guide
├── CONTRIBUTING.md                    # Git workflow guide
├── FINANCIAL_APP_SETUP.md            # Feature documentation
└── FINANCIAL_APP_README.md           # Quick reference
```

## 🔧 Configuration Files

### .env (Supabase Credentials)
```
SUPABASE_URL=https://lmxpykolgesjxkyruswi.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
```

### pubspec.yaml (Dependencies)
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^1.0.0
  # ... other packages
```

## 🗄️ Database Schema Overview

### Table: accounts
Stores user's financial accounts (checking, savings, etc.)
- **user_id**: Links to authenticated user
- **name**: Account name (e.g., "Main Checking")
- **type**: Account type (checking, savings, credit, investment)
- **balance**: Current balance
- **currency**: Currency code (USD, EUR, etc.)

### Table: transactions
Stores all financial transactions
- **account_id**: Which account this transaction belongs to
- **category_id**: Transaction category
- **amount**: Transaction amount
- **type**: Income or expense
- **date**: Transaction date
- **recurring**: Is this a recurring transaction?

### Table: categories
Stores expense/income categories
- **user_id**: User-specific categories
- **name**: Category name (e.g., "Groceries")
- **emoji**: Visual category icon
- **color**: Category color (hex)
- **type**: Income or expense

### Table: budgets
Tracks spending limits
- **user_id**: User's budget
- **category_id**: Which category to track
- **limit_amount**: Budget limit
- **month**: Budget period (e.g., "2024-01")
- **spent**: Amount already spent

## 🔐 Security Features

### Row Level Security (RLS)
- Users can **only** see their own data
- Enforced at database level
- Even if SQL is compromised, data remains isolated

### Authentication
- Supabase Auth handles user authentication
- Email/password signup and login
- Session management

### Real-time Subscriptions
- Changes to transactions show instantly
- Budget updates happen in real-time
- Account balance changes sync across devices

## 🐛 Troubleshooting

### Issue: "Table does not exist" Error

**Cause**: Database schema not set up

**Solution**:
1. Go to Supabase SQL Editor
2. Run all SQL from `lib/services/supabase_setup.sql`
3. Wait for success message
4. Try again

### Issue: "Connection refused" or Timeout

**Cause**: Network or Supabase credentials wrong

**Solution**:
1. Verify `.env` file has correct credentials
2. Verify Supabase project is active (not paused)
3. Check internet connection
4. Check Supabase status: https://status.supabase.com

### Issue: "Permission denied" Error

**Cause**: RLS policies blocking access

**Solution**:
1. Make sure you're logged in with correct credentials
2. User ID in database must match authenticated user
3. Check Supabase → Database → Policies that RLS is enabled
4. Verify policies allow SELECT/INSERT/UPDATE/DELETE

### Issue: Tables Created but App Still Fails

**Cause**: Real-time not enabled or indexes missing

**Solution**:
1. Go to Supabase → Database → Replication
2. Enable publication for tables: transactions, accounts, budgets, categories
3. Run full SQL again to create indexes

## 📱 Testing the App

### Test User Account
You can use any email/password:
```
Email: test@example.com
Password: testpassword123!
```

### Test Workflow
1. Sign up with email
2. Create an account in dashboard
3. Add some transactions
4. Check dashboard updates
5. Verify transactions appear
6. Check budget tracking
7. View insights/analytics

## 📊 Database Operations Supported

The `SupabaseService` supports **90+ operations**:

### Users (5 operations)
- Sign up
- Login
- Logout
- Get current user
- Update profile

### Accounts (7 operations)
- Create account
- Get all accounts
- Get account by ID
- Update account
- Update balance
- Get total balance
- Get accounts by type

### Transactions (15+ operations)
- Create transaction
- Get all transactions
- Get by account/category/date
- Search transactions
- Get monthly summaries
- Calculate statistics
- Support recurring transactions

### Categories (5 operations)
- Create category
- Get by type
- Update category
- Delete category
- Get all categories

### Budgets (4 operations)
- Create budget
- Get budget
- Update spent amount
- Check budget status

### Analytics (8+ operations)
- Get spending insights
- Compare months
- Calculate trends
- Get category summaries
- Generate financial reports

## 🚀 Deployment

### To run on different platforms:

**Windows**
```bash
flutter run -d windows
```

**macOS**
```bash
flutter run -d macos
```

**Linux**
```bash
flutter run -d linux
```

**Web**
```bash
flutter run -d chrome
```

**iOS**
```bash
flutter run -d ios
```

**Android**
```bash
flutter run -d android
```

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| [DATABASE_SETUP.md](DATABASE_SETUP.md) | Detailed database setup instructions |
| [FINANCIAL_APP_README.md](FINANCIAL_APP_README.md) | Features and capabilities |
| [FINANCIAL_APP_SETUP.md](FINANCIAL_APP_SETUP.md) | Feature documentation |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Git workflow and contribution guide |
| [SUPABASE_QUERIES.md](SUPABASE_QUERIES.md) | SQL query examples |

## ✅ Checklist

- [ ] Supabase project created
- [ ] .env file created with credentials
- [ ] Database schema deployed (supabase_setup.sql executed)
- [ ] Tables verified in Supabase Table Editor
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] App runs without errors (`flutter run`)
- [ ] Sign up works
- [ ] Login works
- [ ] Dashboard displays
- [ ] Can create accounts
- [ ] Can add transactions
- [ ] Real-time updates work

## 🆘 Getting Help

If you're stuck:

1. **Check console output**
   - Run `flutter run` and check logs
   - Look for error messages

2. **Review DATABASE_SETUP.md**
   - Most common issues documented there

3. **Verify database**
   - Go to Supabase → Table Editor
   - Manually check if tables exist

4. **Check credentials**
   - Verify .env file
   - Verify main.dart has correct Supabase URL/key

5. **Check network**
   - Verify internet connection
   - Check Supabase status page

## 🎯 Next Steps

1. ✅ Complete database setup (this is critical!)
2. Run `flutter run`
3. Test signup/login
4. Explore all screens
5. Create test data
6. Verify features work
7. Customize as needed

---

**Happy coding! 🎉**

For more details, see DATABASE_SETUP.md for comprehensive guidance.
