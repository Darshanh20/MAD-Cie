# 🚀 QUICK SETUP CHECKLIST

## Phase 1: Database Setup (CRITICAL - DO THIS FIRST!)

### 1.1 Open Supabase Dashboard
- [ ] Open: https://app.supabase.com/
- [ ] Login with your Supabase account
- [ ] Select project: `cie_exam`

### 1.2 Access SQL Editor
- [ ] Click **"SQL Editor"** in left sidebar
- [ ] Click **"New Query"** button
- [ ] You should see a blank SQL editor

### 1.3 Copy Database Schema
- [ ] Open file: `lib/services/supabase_setup.sql`
- [ ] Select all content: **Ctrl+A** (Windows/Linux) or **Cmd+A** (Mac)
- [ ] Copy: **Ctrl+C** (Windows/Linux) or **Cmd+C** (Mac)

### 1.4 Paste & Run
- [ ] Click in the Supabase SQL Editor
- [ ] Paste: **Ctrl+V** (Windows/Linux) or **Cmd+V** (Mac)
- [ ] Click **"RUN"** button (large blue button)
- [ ] Wait for the query to complete (should see green SUCCESS message)
- [ ] Check console for any errors (should see none)

### 1.5 Verify Tables Created
- [ ] Click **"Table Editor"** in left sidebar
- [ ] You should see these tables in the list:
  - [ ] accounts
  - [ ] categories
  - [ ] transactions
  - [ ] budgets
  - [ ] users (from Supabase Auth)

### 1.6 Verify RLS Enabled
- [ ] Click on **"accounts"** table
- [ ] Scroll to the right
- [ ] Look for **"RLS Enabled?"** column
- [ ] Should show **"Enabled"** with green checkmark
- [ ] Repeat for: categories, transactions, budgets

**✅ IF YOU SEE GREEN CHECKMARKS ON ALL - DATABASE IS SETUP CORRECTLY!**

---

## Phase 2: Run the Flutter App

### 2.1 Open Terminal
- [ ] Open Command Prompt or PowerShell
- [ ] Navigate to project folder:
  ```
  cd c:\Users\Lenovo\Desktop\cie_exam
  ```

### 2.2 Install Dependencies
- [ ] Run command:
  ```bash
  flutter pub get
  ```
- [ ] Wait for "Got dependencies!" message

### 2.3 Run the App
- [ ] Choose your platform:
  ```bash
  # For Windows
  flutter run -d windows
  
  # For Web/Chrome
  flutter run -d chrome
  ```
- [ ] Wait for app to compile and launch
- [ ] App should show a splash screen, then login screen

### 2.4 Check Console
- [ ] Look for these messages in console:
  ```
  ✅ Supabase initialized successfully
  ✅ Database migration service initialized  
  ✅ Database connection successful
  ```
- [ ] If you see these, database connection works!

---

## Phase 3: Test App Features

### 3.1 Test Sign Up
- [ ] Click **"Sign Up"** link on login screen
- [ ] Enter email: `test@example.com` (or any email)
- [ ] Enter password: `Password123!`
- [ ] Click **"Sign Up"** button
- [ ] Should navigate to **Dashboard** (if successful)
- [ ] **OR** you might see login screen (account created, now you login)

### 3.2 Test Login
- [ ] On login screen, enter email used above
- [ ] Enter password used above
- [ ] Click **"Login"** button
- [ ] Should navigate to **Dashboard**

### 3.3 Test Dashboard
- [ ] You should see:
  - [ ] Account summary card
  - [ ] Navigation at bottom (Transactions, Budget, Insights)
  - [ ] Recent transactions list (might be empty initially)

### 3.4 Create Test Data
- [ ] Look for "Add Account" or "+" button
- [ ] Create an account (name it "Test Account")
- [ ] Look for "Add Transaction" button
- [ ] Add a test transaction (amount: $50, category: "Groceries", type: "Expense")
- [ ] Transaction should appear in the list

### 3.5 Test All Screens
- [ ] Click **"Transactions"** in bottom navigation
  - [ ] Should see your added transaction
  - [ ] Should be grouped by date
  
- [ ] Click **"Expenses"** in bottom navigation
  - [ ] Should show expense breakdown by category
  - [ ] "Groceries" should show $50
  
- [ ] Click **"Budget"** in bottom navigation
  - [ ] Should have budget tracking
  
- [ ] Click **"Insights"** in bottom navigation
  - [ ] Should show financial analytics

---

## Phase 4: Troubleshooting

### ❌ Issue: "Table does not exist" error

**Cause**: SQL schema wasn't executed in Supabase

**Solution**:
1. Go back to Phase 1
2. Make sure you see all 5 tables in Table Editor
3. Run the SQL again if tables are missing

### ❌ Issue: "Permission denied" error

**Cause**: RLS is blocking access (maybe not enabled or policy wrong)

**Solution**:
1. Verify RLS is **Enabled** on all tables
2. Go to **Policies** section in Supabase
3. Verify policies exist for SELECT, INSERT, UPDATE, DELETE

### ❌ Issue: "Connection timeout" error

**Cause**: Supabase credentials wrong or network issue

**Solution**:
1. Check `.env` file has correct URL and anon key
2. Verify internet connection works
3. Check Supabase status: https://status.supabase.com

### ❌ Issue: Compilation errors in Flutter

**Cause**: Dependencies not installed

**Solution**:
1. Run: `flutter pub get`
2. Run: `flutter clean`
3. Run: `flutter pub get` again

### ❌ Issue: "App won't launch" or blank screen

**Cause**: Initialization failed

**Solution**:
1. Check console for error messages
2. Look for "❌" messages about database
3. Go back to Phase 1 and verify database setup
4. Check .env file has credentials

---

## 📋 Complete Verification Checklist

### Database
- [ ] All 5 tables created (accounts, categories, transactions, budgets, users)
- [ ] RLS enabled on all tables
- [ ] No error messages in SQL Editor
- [ ] Can see tables in Table Editor

### App Installation
- [ ] Flutter dependencies installed
- [ ] App compiles without errors
- [ ] App launches and shows login screen

### Database Connection
- [ ] Console shows "✅ Database connection successful"
- [ ] Can sign up with new email/password
- [ ] Can login with created credentials

### Features
- [ ] Dashboard displays correctly
- [ ] Can create accounts
- [ ] Can add transactions
- [ ] Transactions show in list
- [ ] All screens are accessible
- [ ] Data persists when you restart app

---

## 🎯 Success Criteria

✅ Database fully set up in Supabase
✅ App compiles and runs
✅ Can sign up and login
✅ Can create accounts
✅ Can add transactions
✅ Dashboard shows data
✅ All screens work
✅ Data persists

**If all boxes above are checked, you have a fully working financial management app! 🎉**

---

## 📞 Quick Support

| Issue | Solution |
|-------|----------|
| Tables don't exist | Run SQL again in Supabase SQL Editor |
| Permission errors | Check RLS is enabled on tables |
| Connection errors | Verify .env credentials and internet |
| App won't launch | Check console for error messages |
| Features don't work | Check database tables are created |

---

## ⏱️ Estimated Time

- Phase 1 (Database): 5 minutes
- Phase 2 (Run App): 3 minutes
- Phase 3 (Test): 5 minutes
- **Total: ~13 minutes** to have a fully working app!

---

**You've got this! Follow each step and you'll have a production-ready financial app. 🚀**
