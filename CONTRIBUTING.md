# Contributing to Financial App

Thank you for your interest in contributing to the CIE Exam Financial Application! This guide will help you get started.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Git Workflow](#git-workflow)
- [Gitignore Guidelines](#gitignore-guidelines)
- [Code Style](#code-style)
- [Commit Messages](#commit-messages)
- [Pull Requests](#pull-requests)

---

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Git
- Supabase account
- Android Studio / Xcode (optional, for native development)

### Setup Instructions

1. **Fork the repository**
   ```bash
   # On GitHub, click "Fork"
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/MAD-Cie.git
   cd MAD-Cie
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/Darshanh20/MAD-Cie.git
   git fetch upstream
   ```

4. **Create your feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Install dependencies**
   ```bash
   flutter pub get
   ```

6. **Set up environment**
   ```bash
   # Copy the example env file
   cp .env.example .env
   
   # Edit .env with your Supabase credentials
   nano .env
   ```

7. **Run the app**
   ```bash
   flutter run
   ```

---

## Git Workflow

### Branch Naming Convention

```
feature/short-description       # New features
bugfix/issue-number            # Bug fixes
hotfix/urgent-fix              # Critical fixes
docs/documentation-update       # Documentation
refactor/code-improvement       # Code refactoring
test/test-addition             # Test additions
```

### Example Branches

```bash
# Feature branch
git checkout -b feature/budget-notifications

# Bug fix branch
git checkout -b bugfix/transaction-date-display

# Documentation branch
git checkout -b docs/api-documentation
```

### Keeping Your Fork Updated

```bash
# Fetch from upstream
git fetch upstream

# Rebase your branch
git rebase upstream/main

# Or merge (alternative)
git merge upstream/main
```

---

## Gitignore Guidelines

### What Should Be Ignored

✅ **Always ignore:**

- `.env` files with secrets
- API keys and credentials
- Private keys (*.pem, *.key)
- IDE configuration (`.idea/`, `.vscode/`)
- Build artifacts (`/build/`, `/android/.gradle/`)
- Dependencies (`pubspec.lock`, `/Pods/`, `node_modules/`)
- OS files (`.DS_Store`, `Thumbs.db`)
- Log files (`.log`, `debug.log`)
- Database files (`.db`, `.sqlite`)

### What Should NOT Be Ignored

✅ **Always commit:**

- `.gitignore` itself
- `.env.example` (template only)
- `.gitattributes`
- Source code (`.dart`, `.swift`, `.kt`)
- Configuration examples
- Documentation files
- GitHub workflows (`.github/workflows/`)
- IDE config templates (`.vscode/settings.json`)

### Adding Secrets

If you accidentally commit secrets:

```bash
# Remove from git history
git rm --cached .env
git commit --amend --no-edit
git push -f origin your-branch

# Regenerate any exposed keys immediately!
```

---

## Code Style

### Dart/Flutter Code Style

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.

```dart
// ✅ Good
class UserProfile {
  final String id;
  final String fullName;
  
  const UserProfile({
    required this.id,
    required this.fullName,
  });
}

// ❌ Bad
class userProfile {
  var id;
  var fullName;
}
```

### Formatting

```bash
# Format all Dart files
dart format .

# Analyze code
dart analyze

# Run with Flutter analyze
flutter analyze
```

### Naming Conventions

- **Classes**: PascalCase (`UserProfile`, `TransactionHistory`)
- **Variables/Functions**: camelCase (`userId`, `getUserProfile()`)
- **Constants**: camelCase (`maxRetries = 3`)
- **Private members**: prefix with `_` (`_privateVariable`)
- **Files**: snake_case (`user_profile.dart`)

---

## Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Test additions/modifications
- `chore`: Build process, dependencies
- `perf`: Performance improvements

### Scope

```
feat(auth): add login validation
fix(transactions): filter by date range
docs(setup): update installation guide
```

### Subject

- Use imperative mood: "add" not "added"
- Don't capitalize first letter
- No period at the end
- Max 50 characters

### Body

- Explain what and why, not how
- Wrap at 72 characters
- Separated from subject by blank line

### Examples

```bash
git commit -m "feat(budget): add budget alert notifications

- Implement notification logic
- Add budget exceeded alert
- Email notifications on approach to limit

Closes #123"
```

```bash
git commit -m "fix(transactions): resolve date filtering bug

Date range filtering was not working correctly
for transactions. Fixed by using proper date
comparison logic.

Fixes #456"
```

---

## Pull Requests

### Before Submitting

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Test your changes**
   ```bash
   flutter test
   flutter run
   ```

3. **Run code analysis**
   ```bash
   dart analyze
   dart format .
   ```

4. **Check your commits**
   ```bash
   git log upstream/main..HEAD
   ```

### PR Title Format

```
[TYPE] Brief description of changes

Examples:
[FEATURE] Add budget notification system
[BUG] Fix transaction date filtering
[DOCS] Update API documentation
[REFACTOR] Improve transaction service
```

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Changes
- Change 1
- Change 2
- Change 3

## Related Issues
Closes #issue-number

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how to test these changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
```

### PR Review Process

1. Maintainers will review your PR
2. Address any requested changes
3. Keep PR updated with main branch
4. Once approved, maintainer will merge

```bash
# Pushing changes after review
git add .
git commit --amend
git push -f origin your-branch
```

---

## Development Guidelines

### Flutter Best Practices

- Use StatefulWidget only when needed
- Prefer const constructors
- Use proper error handling
- Add meaningful comments
- Keep functions small and focused

### Security

- Never commit API keys or secrets
- Use `.env.example` for template
- Review code for sensitive data
- Use secure storage for credentials
- Validate all user inputs

### Performance

- Avoid rebuilds of large widgets
- Use const where possible
- Implement proper pagination
- Cache expensive operations
- Profile your app

### Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/models/user_model_test.dart

# Generate coverage report
flutter test --coverage
```

---

## Common Issues

### "Permission denied" when pushing

```bash
# Check remote URL
git remote -v

# Update SSH key or use HTTPS
git remote set-url origin https://github.com/username/repo.git
```

### Merge conflicts

```bash
# Pull latest changes
git fetch upstream
git rebase upstream/main

# Resolve conflicts in your editor
# Then continue
git add .
git rebase --continue
```

### Accidentally committed secrets

```bash
# Remove from history
git log --oneline  # Find the commit
git reset HEAD^    # Undo last commit
git rm --cached .env
git commit -m "Remove .env file"
```

---

## Resources

- [Dart Documentation](https://dart.dev/guides)
- [Flutter Documentation](https://flutter.dev/docs)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Git Workflow](https://git-scm.com/book/en/v2)
- [GitHub Help](https://docs.github.com/en)

---

## Questions?

- Open an issue for bugs
- Discuss features in discussions
- Check existing issues first
- Be respectful and constructive

---

Thank you for contributing! 🎉
