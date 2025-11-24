# SaveSmart - Digital Piggy Bank for Young Adults 💰

> **Mobile application empowering financial wellness through goal-based savings, transaction tracking, and financial education.**

📹 [Demo Video](#-demo-video) • 📚 [Documentation](docs/) • ⭐ [GitHub](https://github.com/levishimwe/savesmart)

---

## 📋 Table of Contents
1. [Overview](#-overview) • 2. [Features](#-features) • 3. [Screenshots](#-screenshots) • 4. [Architecture](#-architecture) • 5. [Setup](#-setup-instructions) • 6. [Firebase Config](#-firebase-configuration) • 7. [Database Schema](#-database-schema-erd) • 8. [Testing](#-testing) • 9. [Known Issues](#-known-issues--fixes) • 10. [Team](#-team--contributions)

---

## 🎯 Overview

SaveSmart addresses financial literacy gaps among young adults (18-24). Only 14.5% of university students correctly answer basic financial questions, highlighting the need for accessible financial education tools.

**Problem:** Young adults struggle with financial management despite access to digital tools. Existing apps overwhelm users or lack educational components.

**Solution:** SaveSmart combines practical money management with financial education:
- Visual progress tracking for savings goals • Simple deposit/withdrawal system • Financial tips & content
- Email verification security • Real-time Firebase sync • Google Sign-In integration

**Tech Stack:** Flutter 3.9.2 | Firebase (Auth, Firestore) | BLoC Pattern | Clean Architecture | GetIt DI

---

## ✨ Features

### 🔐 Authentication & Security
- **Email/Password Signup** with mandatory email verification (first-time only)
- **Google Sign-In** with People API integration for profile data
- **Session Persistence** via SharedPreferences for seamless login
- **Email Verification Page** with resend button and status checking

**Auth BLoC States:**
```dart
abstract class AuthState extends Equatable {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState { final User user; }
class EmailVerificationPending extends AuthState { final User user; }
class AuthError extends AuthState { final String message; }
class Unauthenticated extends AuthState {}
```

### �� Savings Goals Management
- **Create Goals** with target amounts & deadlines • **Visual Progress** via circular indicators
- **Dynamic Dashboard** showing top 3 recent goals • **Allocate Savings** from total to specific goals
- **Withdraw Feature** for 100% achieved goals • **Real-time Sync** with Firestore listeners

**Progress Calculation:**
```dart
double get progress => (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
bool get isCompleted => currentAmount >= targetAmount;
```

### 📊 Transaction Management
- **Deposits & Withdrawals** with validation • **Transaction History** with date filters
- **Categories:** Food, Transport, Shopping, Bills, Entertainment, Other
- **Auto-logging** for withdrawals • **Type Tracking** (Income/Expense)

### 📚 Financial Education (Tips)
- **Weekly Tips** with curated financial advice and images
- **Categories:** Budgeting, Savings, Student Finance, Weekly Tips
- **Firestore-backed** for easy updates • **Visual Engagement** with tip cards

### 👤 Profile & Analytics
- **Total Saved** across all transactions • **Goals Achieved** count (100%+ goals)
- **Days Saving** since account creation • **Notifications Toggle** persisted to Firestore + SharedPreferences

### 📧 Email Notifications
- **Goal Creation Emails:** "Keep Saving!" or "Congratulations!" based on user balance
- **Withdrawal Confirmation** receipt after successful withdrawal
- **SMTP Config:** Gmail (dev) → SendGrid/Firebase Functions (production)

**Email Service:**
```dart
class EmailService {
  static const String _senderEmail = 'your-email@gmail.com';
  static const String _senderPassword = 'your-app-password'; // Gmail App Password
}
```

---

## 📸 Screenshots

> **Note:** Add screenshots before submission

**Authentication Flow:** `[Welcome] → [Register] → [Email Verification] → [Login] → [Dashboard]`
**Main Screens:** `[Dashboard] → [Goals] → [Transactions] → [Tips] → [Profile]`
**Key Features:** Goal progress, Withdraw dialog, Email sample, Responsive layout, Firestore console

---

## 🏗️ Architecture

**Clean Architecture** with **BLoC Pattern** for separation of concerns and predictable state management.

### Architectural Layers
1. **Presentation:** UI + Widgets + BLoC (Events & States)
2. **Domain:** Business logic + Entities + Repository interfaces + Use cases
3. **Data:** Models + Firebase data sources + Repository implementations

### Data Flow
```
UI (User Action) → BLoC (Events → States) → Domain (Use Cases) 
→ Data (Repositories → Firebase) → UI Update (State Change)
```

### Dependency Injection (GetIt)
```dart
final sl = GetIt.instance;

void init() {
  // Blocs
  sl.registerFactory(() => AuthBloc(signIn: sl(), signUp: sl()));
  // Use Cases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── di/injection_container.dart          # GetIt DI setup
│   ├── error/failures.dart, exceptions.dart
│   ├── services/
│   │   ├── email_service.dart               # Email notifications (Gmail SMTP)
│   │   └── notification_service.dart
│   ├── usecase/usecase.dart                 # Base use case class
│   ├── utils/
│   │   ├── constants.dart                   # App constants (colors, strings, API keys)
│   │   ├── validators.dart                  # Input validators
│   │   └── date_formatter.dart
│   └── widgets/
│       ├── custom_button.dart, custom_text_field.dart, loading_indicator.dart
│
├── features/
│   ├── auth/                                # Authentication Feature
│   │   ├── data/
│   │   │   ├── datasources/auth_remote_data_source.dart    # Firebase Auth API
│   │   │   ├── models/user_model.dart                      # JSON serialization
│   │   │   └── repositories/auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/user.dart                          # Pure Dart entity
│   │   │   ├── repositories/auth_repository.dart           # Interface
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_email.dart, sign_in_with_google.dart
│   │   │       ├── sign_up_with_email.dart, sign_out.dart, get_current_user.dart
│   │   └── presentation/
│   │       ├── bloc/auth_bloc.dart, auth_event.dart, auth_state.dart
│   │       └── pages/
│   │           ├── welcome_page.dart, login_page.dart, register_page.dart
│   │           └── email_verification_page.dart
│   │
│   ├── goals/                               # Savings Goals Feature
│   │   ├── data/, domain/, presentation/ (similar structure)
│   │   └── presentation/pages/goals_page.dart
│   │
│   ├── transactions/                        # Transaction Management
│   │   ├── data/, domain/, presentation/
│   │
│   ├── home/                                # Dashboard
│   │   └── presentation/pages/home_page.dart, dashboard_page.dart
│   │
│   ├── tips/                                # Financial Tips
│   │   └── presentation/pages/tips_page.dart
│   │
│   ├── profile/                             # User Profile
│   │   └── presentation/pages/profile_page.dart
│   │
│   └── savings/                             # Savings Overview
│       └── presentation/pages/savings_page.dart
│
├── firebase_options.dart                    # Firebase config (generated)
└── main.dart                                # App entry point
```

---

## 🚀 Setup Instructions

### Prerequisites
- **Flutter SDK:** ≥3.9.2 (`flutter --version`)
- **Dart SDK:** ≥3.9.2 (bundled)
- **IDE:** Android Studio or VS Code
- **Firebase Account:** Free tier

### Quick Start
```bash
# Clone & install
git clone https://github.com/levishimwe/savesmart.git
cd savesmart
flutter pub get

# Run
flutter run

# Test
flutter test

# Build APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Key Dependencies
- `flutter_bloc: ^8.1.6` - State management
- `firebase_core: ^3.6.0`, `firebase_auth: ^5.3.1`, `cloud_firestore: ^5.4.4`
- `google_sign_in: ^6.2.2` - Google OAuth
- `get_it: ^8.0.2` - Dependency injection
- `dartz: ^0.10.1` - Functional programming
- `shared_preferences: ^2.3.3` - Local storage

---

## 🔥 Firebase Configuration

### 1. Create Firebase Project
1. Visit [Firebase Console](https://console.firebase.google.com/) → **Add project**
2. Project name: `savesmart` → Enable Google Analytics (optional) → **Create**

### 2. Register Android App
1. Click Android icon → Package name: `com.savesmart.app` (from `android/app/build.gradle.kts`)
2. **Get SHA-1 for Google Sign-In:**
   ```bash
   cd android
   ./gradlew signingReport
   # Copy SHA-1 from debug keystore
   ```
3. Download `google-services.json` → Place in `android/app/`

### 3. Enable Authentication
**Firebase Console → Authentication → Sign-in method:**
- **Email/Password:** Enable
- **Google:** Enable → Set support email → Save

**Enable People API (Required for Google Sign-In):**
1. [Google Cloud Console](https://console.cloud.google.com/) → Select project
2. **APIs & Services** → **Library** → Search **"People API"** → **Enable**

**Get Web Client ID:**
1. Firebase → **Project Settings** → **Your apps** → Copy Web client ID
2. Add to `lib/core/utils/constants.dart`:
   ```dart
   static const String googleWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
   ```

### 4. Create Firestore Database
1. Firestore Database → **Create database** → **Test mode** → Region: `us-central1` → **Enable**

### 5. Firestore Collections (Auto-created)
```
users/{userId}: uid, email, fullName, phoneNumber?, photoUrl?, totalSavings, createdAt, notificationsEnabled
goals/{goalId}: id, userId, name, targetAmount, currentAmount, deadline, createdAt, description?
transactions/{transactionId}: id, userId, type, amount, category, description, date, goalId?
tips/{tipId}: id, title, content, category, createdAt, imageUrl?
```

### 6. Create Firestore Indexes
**Firestore Console → Indexes → Composite:**

**Index 1:** Collection: `goals` | Fields: `userId` (Asc), `createdAt` (Desc)  
**Index 2:** Collection: `transactions` | Fields: `userId` (Asc), `date` (Desc)

### 7. Deploy Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() { return request.auth != null; }
    function isOwner(userId) { return isAuthenticated() && request.auth.uid == userId; }
    
    match /users/{userId} { allow read, write: if isOwner(userId); }
    
    match /goals/{goalId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    match /transactions/{transactionId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    match /tips/{tipId} {
      allow read: if isAuthenticated();
      allow write: if false; // Admin-only via console
    }
  }
}
```

**Deploy:**
```bash
npm install -g firebase-tools
firebase login
firebase init firestore
firebase deploy --only firestore:rules
```

---

## 🗄️ Database Schema (ERD)

### Entity Relationship Diagram
```
┌──────────────────────┐
│       USERS          │
│  uid (PK)            │
│  email, fullName     │
│  totalSavings        │
│  notificationsEnabled│
└──────────┬───────────┘
           │ 1:N
           ├─────────────────┐
           ▼                 ▼
┌──────────────────┐  ┌──────────────────┐
│      GOALS       │  │   TRANSACTIONS   │
│  id (PK)         │◄─┤  id (PK)         │
│  userId (FK)     │  │  userId (FK)     │
│  name            │  │  goalId? (FK)    │
│  targetAmount    │  │  type, amount    │
│  currentAmount   │  │  category, date  │
│  deadline        │  └──────────────────┘
└──────────────────┘
        
┌──────────────────┐
│      TIPS        │ (Global, no FK)
│  id, title       │
│  content         │
│  category        │
└──────────────────┘
```

### Relationships
- **users → goals:** 1:N (One user has many goals)
- **users → transactions:** 1:N (One user has many transactions)
- **goals → transactions:** 1:N (Goal can have multiple transactions, optional)
- **tips:** Global collection (read by all authenticated users)

### Sample Documents

**User:**
```json
{
  "uid": "abc123", "email": "john@example.com", "fullName": "John Doe",
  "totalSavings": 3650.00, "createdAt": "2025-01-15T10:30:00Z", "notificationsEnabled": true
}
```

**Goal:**
```json
{
  "id": "goal_001", "userId": "abc123", "name": "New Laptop",
  "targetAmount": 1200.00, "currentAmount": 400.00,
  "deadline": "2025-06-30T00:00:00Z", "createdAt": "2025-01-01T00:00:00Z"
}
```

**Transaction:**
```json
{
  "id": "trans_001", "userId": "abc123", "type": "deposit", "amount": 200.00,
  "category": "Salary", "description": "Monthly salary", "date": "2025-11-01T10:00:00Z"
}
```

---

## 🧪 Testing

### Run Tests
```bash
flutter test                    # All tests
flutter test --coverage         # With coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html   # View report
```

**Current Coverage:** ~70% | **Tests Passing:** 26/26

### Test Structure
```
test/
├── core/utils/validators_test.dart          # Email, password, amount validators
├── widgets/custom_button_test.dart          # Button interactions
└── features/goals/domain/entities/savings_goal_test.dart  # Goal logic
```

### Manual Testing Checklist
- [ ] Sign up → Receive verification email → Verify → Login
- [ ] Google Sign-In → Account created/logged in
- [ ] Create goal → Appears on dashboard → Firestore updated
- [ ] Deposit → Total savings increases
- [ ] Withdraw from 100% goal → Confirmation email
- [ ] Toggle notifications → Restart app → Setting persists
- [ ] Rotate device → No pixel overflow
- [ ] Validation errors: Invalid email, short password, negative amount
- [ ] Logout → Clear navigation stack

---

## 🐛 Known Issues & Fixes

### Issue 1: Google Sign-In Error 403 ✅ FIXED
**Symptom:** `PERMISSION_DENIED: People API has not been enabled`

**Solution:**
```dart
// lib/features/auth/data/datasources/auth_remote_data_source.dart
catch (e) {
  if (e.toString().contains('403') || e.toString().toLowerCase().contains('people api')) {
    throw ServerException(
      'Google Sign-In failed: Please enable People API in Google Cloud Console. '
      'Go to console.cloud.google.com → APIs & Services → Library → Search "People API" → Enable.'
    );
  }
}
```

**Manual Fix:** console.cloud.google.com → APIs & Services → Library → Enable People API → Wait 5-10 min

---

### Issue 2: Email Verification Not Received
**Solutions:**
1. Check spam folder
2. Wait 5-10 minutes for delivery
3. Use **Resend Email** button on verification page
4. Verify Firebase email template: Firebase Console → Authentication → Templates

---

### Issue 3: Withdrawal Double-Deduction Bug ✅ FIXED (Nov 20, 2025)
**Symptom:** Total savings decreased twice when withdrawing

**Root Cause:** Transaction creation deducted amount, then withdraw function deducted again

**Fix:**
```dart
// BEFORE (Bug):
await _createTransaction(withdrawal); // Deducted $100
totalSavings -= goal.currentAmount;   // Deducted $100 AGAIN

// AFTER (Fixed):
await _createTransaction(withdrawal); // Deducted $100 only
// Removed duplicate deduction
```

---

### Issue 4: Logout Navigation Bug ✅ FIXED (Nov 20, 2025)
**Symptom:** Logout redirected to dashboard instead of welcome page

**Fix:**
```dart
// BEFORE:
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => WelcomePage()));

// AFTER:
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => WelcomePage()),
  (route) => false, // Clear ALL routes
);
```

---

### Issue 5: Email Notifications Setup
**Configuration:** Gmail App Password required

**Quick Setup (5 minutes):**
1. **Enable 2-Step Verification:** https://myaccount.google.com/security
2. **Generate App Password:** https://myaccount.google.com/apppasswords
   - App: "Mail" → Device: "Other (SaveSmart)" → Generate
   - Copy 16-character password (e.g., `abcdefghijklmnop`)
3. **Update Code:**
   ```dart
   // lib/core/services/email_service.dart
   static const String _senderEmail = 'your-email@gmail.com';
   static const String _senderPassword = 'abcdefghijklmnop'; // No spaces!
   ```
4. **Restart:** `flutter run`

**Production:** Replace Gmail SMTP with SendGrid or Firebase Cloud Functions

---

## 👥 Team & Contributions

**Group 5** | Mobile Application Development | African Leadership University | **Submission:** Nov 24, 2025

| Member | Email | Role | Key Contributions |
|--------|-------|------|-------------------|
| **Levis Ishimwe** | i.levis@alustudent.com | Lead Engineer | Firebase setup, Google Auth (People API fix), Email notifications, Savings/withdrawal logic, Bug fixes (double-deduction, logout), Documentation, Testing |
| **Josephine Duba Kanu** | j.kanu@alustudent.com | UI/UX Lead | Screen designs (Welcome, Auth, Home, Goals, Profile, Tips), Layout implementation, Responsive design, Component styling, User flow optimization |
| **Singa Ewing Saragba** | e.singasara@alustudent.com | Auth Backend | Email/Password flows, Login/registration logic, Logout handling, Auth error mapping, Email verification page |
| **Henriette Utatsineza** | h.utatsinez@alustudent.com | Features & Docs | Savings feature logic, Profile stats integration, Transaction history, Project summary, Testing support |

**Collaboration:** Git/GitHub • Feature branches → PRs → Code reviews • Daily standups (WhatsApp/Discord) • Trello • Figma

**AI Assistance:** GitHub Copilot (~25%) + ChatGPT (~10%) = ~35-40% | All critical decisions, security, business logic manually reviewed

---

## 📊 Project Statistics

- **Dart Files:** 60+ | **Lines of Code:** ~5,000 (excluding generated)
- **Test Files:** 4 | **Tests Passing:** 26/26 (100%) | **Coverage:** ~70%
- **Flutter Analyze:** 0 errors (9 info-level warnings)
- **Firestore Collections:** 4 (users, goals, transactions, tips)
- **Auth Methods:** 2 (Email/Password + Google)
- **Screens:** 9 (Welcome, Login, Register, Email Verification, Dashboard, Goals, Transactions, Tips, Profile)

---

## 🎓 Key Learning Outcomes

1. **Clean Architecture** - Separation of presentation/domain/data layers
2. **BLoC State Management** - Event-driven predictable state transitions
3. **Firebase Integration** - Auth, Firestore CRUD, security rules, real-time listeners
4. **Email Verification** - Mandatory first-time verification with resend
5. **Google Sign-In** - OAuth config with People API and web client ID
6. **Error Handling** - User-friendly messages for all scenarios
7. **Dependency Injection** - GetIt for centralized service management
8. **Testing** - Unit tests (validators, entities) + widget tests (interactions)
9. **Responsive UI** - Portrait/landscape without pixel overflow
10. **Security** - Firestore rules enforcing user data isolation

---

## 🔒 Security & Privacy

**Authentication:** Firebase Auth tokens validated on every request • Email verification prevents throwaway accounts • Google OAuth 2.0

**Data Isolation:** Firestore rules restrict users to own data • `userId` enforced in queries • Cross-user access prevented

**Privacy:** No sensitive financial data stored • Only user-declared amounts tracked • Email for auth/notifications only • No third-party sharing

**Best Practices:** Passwords never stored plain text • Least privilege in security rules • Client + server validation

---

## 🚧 Known Limitations

1. **Offline Support:** Requires internet; no local caching
2. **Single Currency:** USD only
3. **Basic Analytics:** Text-based stats only (no charts)
4. **Email Service:** Gmail SMTP (not scalable); needs SendGrid/Firebase Functions for production
5. **Push Notifications:** Settings toggle only; FCM not implemented
6. **Fixed Categories:** No custom transaction categories
7. **No Budget Planning:** No limits or alerts
8. **No Export:** No CSV/PDF for transaction history

---

## 🔮 Future Enhancements

**Phase 1 (3 months):**
- Firebase Cloud Functions for email • Push notifications (FCM) • Offline caching (Hive/SQLite) • Charts/graphs

**Phase 2 (6-12 months):**
- Multi-currency support • Budget planning with alerts • Dark mode • Export (CSV/PDF/Excel) • Custom categories • Bill reminders

**Phase 3 (12+ months):**
- Social features (shared goals, leaderboards) • AI financial advice • Bank integration (Plaid API) • Gamification • Investment tracking • Multi-language

---

## 📄 License & Academic Integrity

**License:** Educational Project - ALU Mobile App Development Course

**Usage:** Internal academic use • Portfolio showcasing permitted • Commercial use prohibited without team permission

**Academic Integrity:** Developed per ALU policies • Original work by team • AI assistance <40% (GitHub Copilot, ChatGPT), fully disclosed • All external libraries credited • No plagiarism • Code reviews within team

---

## 📞 Support & Contact

**Primary:** i.levis@alustudent.com | **Secondary:** j.kanu@alustudent.com

**For Issues:**
1. Check `flutter analyze` output
2. Review terminal logs
3. Verify Firebase config (Auth, Firestore rules)
4. Consult `docs/` for setup guides

**Bug Reports Include:** Device info • Steps to reproduce • Expected vs actual behavior • Screenshots/errors • Code snippets

---

## 📚 Additional Documentation

Detailed guides in `docs/` folder:
- [Firebase Setup Guide](docs/FIREBASE_SETUP.md) - Complete Firebase configuration
- [ERD & Database Schema](docs/ERD.md) - Firestore collections and relationships
- [Demo Video Script](docs/DEMO_VIDEO_SCRIPT.md) - Presentation guide
- [Project Summary](docs/PROJECT_SUMMARY.md) - Condensed overview

---

## 🎥 Demo Video

**Duration:** 10-12 min | **Format:** Single continuous recording | **Device:** Physical Android (release APK) | **Quality:** ≥1080p, clear audio

**Demo Checklist:**
- [ ] Cold start from device home
- [ ] Sign up → Verification email → Click link → Verify
- [ ] Login + Google Sign-In
- [ ] Navigate all tabs (Dashboard → Goals → Transactions → Tips → Profile)
- [ ] Rotate device → No overflow
- [ ] Create goal → Show Firestore console update
- [ ] Deposit → Total savings increase
- [ ] Allocate to goal → Progress update
- [ ] Withdraw from 100% goal → Confirmation email
- [ ] Toggle notifications → Restart → Setting persists
- [ ] Validation errors (invalid email, short password, negative amount)
- [ ] Logout → Welcome page (clear stack)

**Recording:** Use screen recorder (AZ, Mobizen) or `scrcpy` with OBS • Split-screen (phone + Firebase console) • Clear narration • Steady capture • Well-lit

---

## 🙏 Acknowledgments

- **Firebase & Flutter Teams:** Exceptional infrastructure and documentation
- **ALU Faculty:** Guidance and feedback throughout course
- **User Research Participants:** Valuable insights shaping features
- **Open Source Community:** flutter_bloc, dartz, get_it, and libraries
- **Stack Overflow & GitHub Discussions:** Community troubleshooting support

---

## 📖 References

1. P. A. Rodríguez-Correa, "Financial literacy among young college students," F1000Research, vol. 14, p. 113, Aug. 2025.
2. K. Goyal and S. Kumar, "Determinants of financial literacy," Journal of Education for Business, vol. 96, no. 5, pp. 277–284, 2021.
3. "Why Millennials, Gen Z Use Mobile Banking," CNBC Select, 2024.
4. S. Constable, "Students Lack Financial Literacy," Forbes, May 27, 2024.
5. Flutter Docs: https://docs.flutter.dev/
6. Firebase Docs: https://firebase.google.com/docs
7. BLoC Pattern: https://bloclibrary.dev/
8. Clean Architecture by Robert C. Martin
9. Google Sign-In Flutter: https://pub.dev/packages/google_sign_in
10. Firestore Security Rules: https://firebase.google.com/docs/firestore/security/get-started

---

<div align="center">

**SaveSmart** - Empowering Financial Wellness, One Goal at a Time 💰

Made with ❤️ by Group 4| African Leadership University | November 2025

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=flat-square&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Tests](https://img.shields.io/badge/Tests-26%2F26%20Passing-brightgreen?style=flat-square)

[⬆ Back to Top](#savesmart---digital-piggy-bank-for-young-adults-)

</div>
