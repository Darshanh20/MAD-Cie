# CIE Exam - Financial Management App 💰

A beautiful, feature-rich Flutter app for managing your personal finances with real-time Supabase backend.

![Flutter](https://img.shields.io/badge/Flutter-v3.0+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-v3.0+-green?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-orange?logo=supabase)

---

## 🎯 Features

- ✅ **User Authentication**: Simple email/password signup and login
- ✅ **Account Management**: Create and manage multiple bank accounts
- ✅ **Transaction Tracking**: Record income and expense transactions
- ✅ **Expense Categories**: Organize spending by custom categories
- ✅ **Budget Planning**: Set monthly/quarterly/yearly budget limits
- ✅ **Financial Dashboard**: Real-time overview of accounts and spending
- ✅ **Analytics & Insights**: Visual charts and spending analysis
- ✅ **Cross-Platform**: Works on Android, iOS, Web, macOS, Windows, Linux

---

## 📋 Prerequisites

### Required
- **Flutter SDK** (v3.0+) - [Download](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (comes with Flutter)
- **Supabase Account** - [Create Free](https://supabase.com)

### Optional
- **Android Studio** - For Android
- **Xcode** - For iOS (macOS only)
- **Visual Studio** - For Windows

---

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/cie_exam.git
cd cie_exam
```

### 2. Set Up Supabase

1. **Create Project**
   - Go to [Supabase Dashboard](https://app.supabase.com)
   - Click "New Project"
   - Enter name, password, region
   - Wait 2-3 minutes for setup

2. **Get Credentials**
   - Go to Settings → API
   - Copy **Project URL** and **Anon Key**

3. **Create `.env` File**
   ```env
   SUPABASE_URL=https://xxxxx.supabase.co
   SUPABASE_ANON_KEY=your_anon_key_here
   ```

4. **Initialize Database**
   - Open Supabase → SQL Editor
   - Create new query
   - Paste contents of `lib/services/supabase_setup.sql`
   - Click Run

5. **Apply Migration**
   ```sql
   -- Drop old auth policies
   DROP POLICY IF EXISTS "Users can view their own profile" ON users;
   DROP POLICY IF EXISTS "Users can update their own profile" ON users;
   DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
   
   -- Add password column
   ALTER TABLE users ADD COLUMN password VARCHAR(255) NOT NULL DEFAULT '';
   
   -- Disable RLS for simple auth
   ALTER TABLE users DISABLE ROW LEVEL SECURITY;
   ALTER TABLE accounts DISABLE ROW LEVEL SECURITY;
   ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
   ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;
   ALTER TABLE budgets DISABLE ROW LEVEL SECURITY;
   
   -- Create index for login
   CREATE INDEX IF NOT EXISTS idx_users_email_password ON users(email, password);
   ```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run App

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

**Windows:**
```bash
flutter run -d windows
```

---

## 📱 Usage

### Sign Up
1. Launch app → Click "Sign Up"
2. Enter email, password, full name
3. Click "Create Account"

### Add Account
1. Go to Dashboard
2. Click "Add Account"
3. Fill account details
4. Click "Save"

### Record Transaction
1. Go to Transactions tab
2. Click "+" button
3. Fill amount, type, category, description
4. Click "Save"

### Set Budget
1. Go to Budget tab
2. Click "Add Budget"
3. Select category and limit amount
4. Click "Save"

### View Insights
1. Go to Insights tab
2. See spending charts and analysis

---

## 🗄️ Database Schema

| Table | Purpose |
|-------|---------|
| users | User accounts with email/password |
| accounts | Bank accounts |
| transactions | Income/expense records |
| categories | Transaction categories |
| budgets | Budget limits |

---

## 🔐 Authentication

**Current**: Simple email/password stored in database

**For Production**:
- Hash passwords with bcrypt
- Add email verification
- Implement password reset
- Or use Supabase built-in Auth

---

## 🛠️ Troubleshooting

**"Invalid API key"**
- Check `.env` has correct SUPABASE_ANON_KEY

**"Cannot connect to database"**
- Verify SUPABASE_URL is correct
- Check internet connection

**"Table doesn't exist"**
- Run SQL setup in Supabase SQL Editor

**"Login fails"**
- Verify password column exists
- Check user exists in database

---

## 📂 Project Structure

```
cie_exam/
├── lib/
│   ├── main.dart
│   ├── routes/app_routes.dart
│   ├── models/ (user, account, transaction, category, budget)
│   ├── screens/
│   │   ├── auth/ (login, signup)
│   │   └── financial/ (dashboard, transactions, budgets, insights)
│   └── services/supabase_service.dart
├── pubspec.yaml
├── .env (create this)
└── README.md
```

---

## 📦 Key Dependencies

- **supabase_flutter** - Backend
- **fl_chart** - Charts
- **intl** - Date formatting

---

## 📄 License

MIT License

---

## 📞 Support

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Docs](https://flutter.dev/docs)

---

**Version**: 1.0 | **Status**: ✅ Ready to Use
