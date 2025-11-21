# SaveSmart: A Digital Piggy Bank for Empowering Financial Wellness in Young Adults

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-Educational-green?style=for-the-badge)

**A comprehensive mobile application designed to enhance financial literacy and promote healthy saving behaviors among young adults and university students.**

[Features](#features) • [Architecture](#architecture) • [Setup](#setup-instructions) • [Demo](#demo-video) • [Team](#team-members)

</div>

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Setup Instructions](#setup-instructions)
- [Database Design](#database-design)
- [Firebase Security Rules](#firebase-security-rules)
- [Testing](#testing)
- [Building & Deployment](#building--deployment)
- [Demo Video](#demo-video)
- [Known Limitations & Future Work](#known-limitations--future-work)
- [Team Members & Contributions](#team-members--contributions)
- [License](#license)

---

## 🎯 Project Overview

SaveSmart addresses the critical need for financial literacy among young adults (18-24 years) by providing an intuitive, educational, and engaging platform for money management. Research shows that only 14.5% of university students can correctly answer basic financial literacy questions, highlighting the urgent need for accessible financial education tools.

### Problem Statement
Despite widespread access to digital financial tools, young adults struggle with fundamental financial management skills. Existing applications either overwhelm users with complex features or lack the educational components necessary to build lasting financial competency.

### Solution
SaveSmart combines practical money management tools with targeted financial education, specifically designed to meet young adults where they are in their financial journey.

---

## ✨ Features

### 🔐 Authentication & Security
- **Dual Authentication Methods**: Email/Password and Google Sign-In
- **Email Verification**: Secure account activation with OTP
- **Input Validation**: Comprehensive validation for all user inputs
- **Password Security**: Minimum 6 characters with secure Firebase storage
- **Session Management**: Persistent authentication state with SharedPreferences

### 💰 Savings Goals Management
- **Goal Creation**: Set personalized savings targets with custom amounts and deadlines
- **Visual Progress Tracking**: Circular progress indicators showing goal completion
- **Multiple Goals**: Manage unlimited savings goals simultaneously
- **Real-time Updates**: Instant synchronization with Firebase Firestore
- **Goal Analytics**: Track total saved, goals achieved, and days saving

### 📊 Expense Tracking & Transactions
- **Transaction Recording**: Add income and expense transactions
- **Categorization**: Organize transactions by category (Food, Transport, Shopping, etc.)
- **Real-time Sync**: All transactions instantly synced to Firebase
- **Transaction History**: View complete transaction history with date formatting
- **Dashboard Overview**: See recent transactions on the main dashboard

### 📚 Financial Education
- **Weekly Financial Tips**: Curated financial advice updated weekly
- **Educational Articles**: Content on budgeting strategies, savings techniques, and student finance
- **Visual Learning**: Image-based tip cards for better engagement
- **Categories**: 
  - Weekly Financial Tips
  - Savings Strategies
  - Budgeting Strategies
  - Student Finance Tips

### 👤 Profile & Settings
- **User Profile**: Display user information (name, email, avatar)
- **Progress Statistics**: 
  - Total amount saved
  - Number of goals achieved
  - Days actively saving
- **Notification Management**: Toggle notifications on/off with Firestore persistence
- **Secure Logout**: Complete session termination

### 🎨 User Experience
- **Responsive Design**: Works flawlessly on phones from 5.5″ to 6.7″+
- **Landscape Support**: Full landscape mode compatibility without pixel overflow
- **Material Design**: Following Material Design 3 guidelines
- **Color Accessibility**: 4.5:1 contrast ratio for WCAG AA compliance
- **Smooth Navigation**: Seamless page transitions with proper back-stack management
- **Loading States**: Visual feedback during data operations

---

## 🏗️ Architecture

SaveSmart follows **Clean Architecture** principles with **BLoC (Business Logic Component)** pattern for state management, ensuring separation of concerns, testability, and maintainability.

### Project Structure

```
lib/
├── core/                           # Core functionality & shared utilities
│   ├── di/                         # Dependency Injection (GetIt)
│   │   └── injection_container.dart
│   ├── error/                      # Error handling
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── services/                   # Core services
│   │   └── notification_service.dart
│   ├── usecase/                    # Base use case
│   │   └── usecase.dart
│   ├── utils/                      # Constants, validators, helpers
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   └── date_formatter.dart
│   └── widgets/                    # Reusable widgets
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_indicator.dart
│
├── features/                       # Feature modules (Clean Architecture)
│   │
│   ├── auth/                       # Authentication Feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_email.dart
│   │   │       ├── sign_in_with_google.dart
│   │   │       ├── sign_up_with_email.dart
│   │   │       ├── sign_out.dart
│   │   │       └── get_current_user.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           ├── welcome_page.dart
│   │           ├── login_page.dart
│   │           └── register_page.dart
│   │
│   ├── goals/                      # Savings Goals Feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── goals_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── savings_goal_model.dart
│   │   │   └── repositories/
│   │   │       └── goals_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── savings_goal.dart
│   │   │   └── repositories/
│   │   │       └── goals_repository.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── goals_page.dart
│   │
│   ├── transactions/               # Expense Tracking Feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── transaction_model.dart
│   │   │   └── repositories/
│   │   │       └── transactions_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── transaction.dart
│   │   │   └── repositories/
│   │   │       └── transactions_repository.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── transactions_page.dart
│   │
│   ├── home/                       # Dashboard/Home Feature
│   │   └── presentation/
│   │       └── pages/
│   │           ├── home_page.dart
│   │           └── dashboard_page.dart
│   │
│   ├── tips/                       # Financial Tips Feature
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── tips_repository.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── tips_page.dart
│   │
│   ├── profile/                    # User Profile Feature
│   │   └── presentation/
│   │       └── pages/
│   │           └── profile_page.dart
│   │
│   └── savings/                    # Savings Overview Feature
│       └── presentation/
│           └── pages/
│               └── savings_page.dart
│
├── firebase_options.dart           # Firebase configuration
└── main.dart                       # Application entry point
```

### Architectural Layers

#### 1. **Presentation Layer**
- **Responsibility**: UI and user interaction
- **Components**: 
  - Pages/Screens
  - BLoC for state management
  - Widgets
- **Technologies**: Flutter widgets, flutter_bloc

#### 2. **Domain Layer**
- **Responsibility**: Business logic and rules
- **Components**:
  - Entities (pure Dart classes)
  - Repository interfaces
  - Use cases
- **Technologies**: Pure Dart (no framework dependencies)

#### 3. **Data Layer**
- **Responsibility**: Data sources and repository implementations
- **Components**:
  - Models (with JSON serialization)
  - Remote data sources (Firebase)
  - Repository implementations
- **Technologies**: Firebase Auth, Cloud Firestore

### State Management: BLoC Pattern

SaveSmart uses the **BLoC (Business Logic Component)** pattern for predictable, testable state management:

- **Events**: User actions (e.g., SignInRequested, CreateGoalRequested)
- **States**: UI states (e.g., Loading, Success, Error)
- **BLoCs**: Business logic processors that transform events into states

**Benefits**:
- ✅ Separation of business logic from UI
- ✅ Testable and maintainable code
- ✅ Predictable state changes
- ✅ Easy debugging with BLoC observer

### Dependency Injection

Using **GetIt** for dependency injection:
- Singleton services (Firebase, repositories)
- Factory instances (BLoCs, use cases)
- Centralized dependency management

---

## 🛠️ Technology Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.9.2+ | Cross-platform UI framework |
| **Dart** | 3.9.2+ | Programming language |
| **flutter_bloc** | 8.1.6 | State management |
| **equatable** | 2.0.7 | Value equality |
| **intl** | 0.19.0 | Internationalization & date formatting |

### Backend & Database
| Technology | Version | Purpose |
|------------|---------|---------|
| **Firebase Core** | 3.6.0 | Firebase initialization |
| **Firebase Auth** | 5.3.1 | User authentication |
| **Cloud Firestore** | 5.4.4 | NoSQL cloud database |
| **Google Sign-In** | 6.2.2 | Google OAuth authentication |

### Utilities
| Technology | Version | Purpose |
|------------|---------|---------|
| **get_it** | 8.0.2 | Dependency injection |
| **shared_preferences** | 2.3.3 | Local storage for preferences |
| **dartz** | 0.10.1 | Functional programming (Either, Option) |
| **mailer** | 6.1.2 | Email notifications (OTP) |
| **flutter_svg** | 2.0.14 | SVG image support |

### Development & Testing
| Technology | Version | Purpose |
|------------|---------|---------|
| **flutter_lints** | 5.0.0 | Dart linting rules |
| **flutter_test** | SDK | Widget testing |
| **bloc_test** | 9.1.7 | BLoC testing utilities |
| **mocktail** | 1.0.4 | Mocking for unit tests |

---

## 🚀 Setup Instructions

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.9.2 or higher
  ```bash
  flutter --version
  ```
- **Dart SDK**: Version 3.9.2 or higher (comes with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Git**: For version control
- **Android Studio** (for Android development) or **Xcode** (for iOS development)
- **Firebase Account**: For backend services

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/levishimwe/savesmart.git
cd savesmart
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Firebase Configuration

The Firebase configuration is already included in the project (`firebase_options.dart`), but if you need to connect to your own Firebase project:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and/or iOS app to your Firebase project
3. Download `google-services.json` (Android) and place in `android/app/`
4. Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
5. Run Firebase CLI to generate configuration:
   ```bash
   flutterfire configure
   ```

#### 4. Firebase Firestore Setup

1. Enable **Firestore Database** in your Firebase console
2. Create the following collections:
   - `users`
   - `goals`
   - `transactions`
   - `tips`
3. Deploy security rules (see [Firebase Security Rules](#firebase-security-rules) section)

#### 5. Firebase Authentication Setup

Enable the following authentication methods in Firebase Console:
- Email/Password
- Google Sign-In

#### 6. Run the Application

##### On Android Emulator/Device
```bash
flutter run
```

##### On iOS Simulator/Device (macOS only)
```bash
flutter run -d ios
```

##### On Physical Device
1. Enable Developer Mode on your device
2. Connect via USB
3. Run:
   ```bash
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

#### 7. Verify Installation

After running the app:
1. ✅ App launches without errors
2. ✅ You can navigate to the Welcome page
3. ✅ Registration with email works
4. ✅ Google Sign-In works
5. ✅ You can create a savings goal

### Troubleshooting

#### Common Issues

**Issue**: `flutter: command not found`
- **Solution**: Add Flutter to your PATH:
  ```bash
  export PATH="$PATH:`pwd`/flutter/bin"
  ```

**Issue**: Firebase configuration errors
- **Solution**: Run `flutterfire configure` and select your Firebase project

**Issue**: Google Sign-In not working
- **Solution**: Ensure SHA-1 fingerprint is added to Firebase console:
  ```bash
  cd android
  ./gradlew signingReport
  ```

**Issue**: Build failures on Android
- **Solution**: Check Gradle version compatibility in `android/build.gradle`

---

## 🗄️ Database Design

### Entity-Relationship Diagram (ERD)

```
┌─────────────────────────┐
│       USERS             │
├─────────────────────────┤
│ PK: uid (String)        │
│ email (String)          │
│ displayName (String)    │
│ photoURL (String?)      │
│ createdAt (Timestamp)   │
│ notificationsEnabled    │
│    (Boolean)            │
└─────────────────────────┘
           │
           │ 1:N
           ├──────────────────────┐
           │                      │
           ▼                      ▼
┌─────────────────────────┐  ┌──────────────────────────┐
│       GOALS             │  │    TRANSACTIONS          │
├─────────────────────────┤  ├──────────────────────────┤
│ PK: goalId (String)     │  │ PK: transactionId (Str)  │
│ FK: userId (String)     │  │ FK: userId (String)      │
│ name (String)           │  │ description (String)     │
│ targetAmount (double)   │  │ amount (double)          │
│ currentAmount (double)  │  │ type (String)            │
│ deadline (Timestamp)    │  │   - income/expense       │
│ createdAt (Timestamp)   │  │ category (String)        │
│ isCompleted (Boolean)   │  │ date (Timestamp)         │
└─────────────────────────┘  └──────────────────────────┘

           ┌──────────────────────────┐
           │        TIPS              │
           ├──────────────────────────┤
           │ PK: tipId (String)       │
           │ title (String)           │
           │ description (String)     │
           │ category (String)        │
           │ imageUrl (String)        │
           │ createdAt (Timestamp)    │
           └──────────────────────────┘
```

### Firestore Collections

#### 1. **users** Collection
```json
{
  "uid": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoURL": "https://...",
  "createdAt": "2024-01-15T10:30:00Z",
  "notificationsEnabled": true
}
```

**Fields**:
- `uid` (String, Primary Key): Firebase Auth UID
- `email` (String): User's email address
- `displayName` (String): User's full name
- `photoURL` (String, Optional): Profile picture URL
- `createdAt` (Timestamp): Account creation date
- `notificationsEnabled` (Boolean): Notification preference

**Indexes**: Automatic on `uid`

#### 2. **goals** Collection
```json
{
  "goalId": "goal456",
  "userId": "user123",
  "name": "Emergency Fund",
  "targetAmount": 5000.00,
  "currentAmount": 1250.00,
  "deadline": "2024-12-31T23:59:59Z",
  "createdAt": "2024-01-15T10:30:00Z",
  "isCompleted": false
}
```

**Fields**:
- `goalId` (String, Primary Key): Auto-generated document ID
- `userId` (String, Foreign Key): Reference to users collection
- `name` (String): Goal name/description
- `targetAmount` (Double): Target savings amount
- `currentAmount` (Double): Current saved amount
- `deadline` (Timestamp): Goal deadline
- `createdAt` (Timestamp): Goal creation date
- `isCompleted` (Boolean): Completion status

**Indexes**: 
- Composite index on `userId` + `createdAt` (descending)
- Single field index on `userId`

#### 3. **transactions** Collection
```json
{
  "transactionId": "trans789",
  "userId": "user123",
  "description": "Grocery shopping",
  "amount": 75.50,
  "type": "expense",
  "category": "Food",
  "date": "2024-01-20T14:30:00Z"
}
```

**Fields**:
- `transactionId` (String, Primary Key): Auto-generated document ID
- `userId` (String, Foreign Key): Reference to users collection
- `description` (String): Transaction description
- `amount` (Double): Transaction amount
- `type` (String): "income" or "expense"
- `category` (String): Category (Food, Transport, Shopping, etc.)
- `date` (Timestamp): Transaction date

**Indexes**:
- Composite index on `userId` + `date` (descending)
- Single field index on `userId`

#### 4. **tips** Collection
```json
{
  "tipId": "tip001",
  "title": "Weekly Financial Tip",
  "description": "Save 20% of your income...",
  "category": "Savings",
  "imageUrl": "assets/images/weekly--financial.jpg",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

**Fields**:
- `tipId` (String, Primary Key): Auto-generated document ID
- `title` (String): Tip title
- `description` (String): Tip content
- `category` (String): Tip category
- `imageUrl` (String): Image path/URL
- `createdAt` (Timestamp): Creation date

**Indexes**: Single field index on `category`

### Relationships

- **One-to-Many**: `users` → `goals` (One user has many goals)
- **One-to-Many**: `users` → `transactions` (One user has many transactions)
- **No direct relationship**: `tips` are global (read by all users)

### Database Constraints

- All `userId` foreign keys enforce referential integrity via security rules
- `targetAmount` and `currentAmount` must be >= 0
- `deadline` must be a future date
- `type` field in transactions must be either "income" or "expense"

---

## 🔒 Firebase Security Rules

SaveSmart implements comprehensive Firestore security rules to protect user data and prevent unauthorized access.

### Security Rules Overview

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the resource
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection - users can only read/write their own data
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Goals collection - users can only access their own goals
    match /goals/{goalId} {
      allow read: if isAuthenticated() && 
                     resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
    }
    
    // Transactions collection - users can only access their own transactions
    match /transactions/{transactionId} {
      allow read: if isAuthenticated() && 
                     resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
    }
    
    // Tips collection - all authenticated users can read, only admins can write
    match /tips/{tipId} {
      allow read: if isAuthenticated();
      allow write: if false; // Only admins can manage tips (via Firebase Console)
    }
  }
}
```

### Security Principles

#### 1. **Authentication Required**
- All operations require user authentication
- Anonymous access is blocked
- Firebase Auth tokens are validated on every request

#### 2. **User Data Isolation**
- Users can only access their own data
- `userId` field enforces ownership
- Cross-user data access is prevented

#### 3. **Principle of Least Privilege**
- Users have minimal necessary permissions
- Tips are read-only for users
- Admin operations restricted to Firebase Console

#### 4. **Data Validation**
- `userId` field must match authenticated user
- Foreign key relationships enforced
- Prevents data tampering

### Deploying Security Rules

```bash
# Deploy rules to Firebase
firebase deploy --only firestore:rules

# Test rules locally
firebase emulators:start --only firestore
```

### Testing Security Rules

```bash
# Using Firebase emulators
firebase emulators:exec --only firestore "flutter test test/firestore_rules_test.dart"
```

---

## 🧪 Testing

SaveSmart implements comprehensive testing strategies including widget tests and unit tests to ensure code quality and reliability.

### Test Coverage

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

```
test/
├── core/
│   └── utils/
│       └── validators_test.dart       # Input validation tests
├── widgets/
│   └── custom_button_test.dart        # Widget tests
└── features/
    └── goals/
        └── domain/
            └── entities/
                └── savings_goal_test.dart  # Unit tests
```

### Widget Tests

#### Example: Custom Button Widget Test
```dart
// test/widgets/custom_button_test.dart
testWidgets('CustomButton displays text and responds to tap', (tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomButton(
          text: 'Test Button',
          onPressed: () => tapped = true,
        ),
      ),
    ),
  );

  // Verify button is displayed
  expect(find.text('Test Button'), findsOneWidget);

  // Tap the button
  await tester.tap(find.byType(CustomButton));
  await tester.pump();

  // Verify callback was triggered
  expect(tapped, true);
});
```

### Unit Tests

#### Example: Validators Test
```dart
// test/core/utils/validators_test.dart
test('validateEmail returns error for invalid email', () {
  expect(Validators.validateEmail('invalid'), 'Please enter a valid email');
  expect(Validators.validateEmail('test@test.com'), null);
});

test('validatePassword returns error for short password', () {
  expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
  expect(Validators.validatePassword('123456'), null);
});
```

### Running Specific Tests

```bash
# Run a specific test file
flutter test test/core/utils/validators_test.dart

# Run tests matching a pattern
flutter test --name="CustomButton"

# Run tests with verbose output
flutter test --verbose
```

### Test Results

Current test coverage: **≥ 50%** (meeting rubric requirements)

- ✅ Widget test: `custom_button_test.dart`
- ✅ Unit test 1: `validators_test.dart`
- ✅ Unit test 2: `savings_goal_test.dart`

### Code Quality Tools

```bash
# Run Dart analyzer (0 issues required)
flutter analyze

# Format code
dart format lib/ test/

# Check for linting issues
flutter analyze
```

**Analysis Result**: ✅ 0 issues (screenshot included in project report)

---

## 📦 Building & Deployment

### Development Build

```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d <device-id>

# Hot reload enabled automatically in debug mode
# Press 'r' to hot reload
# Press 'R' to hot restart
```

### Release Build

#### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk

# Build APK with split per ABI (smaller file size)
flutter build apk --split-per-abi
```

#### Android App Bundle (AAB)

```bash
# Build App Bundle for Play Store
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS Build (macOS only)

```bash
# Build iOS release
flutter build ios --release

# Build IPA for distribution
flutter build ipa
```

### Build Configuration

#### Android (`android/app/build.gradle.kts`)
```kotlin
android {
    compileSdk = 34
    defaultConfig {
        applicationId = "com.savesmart.app"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

### Code Signing

#### Android
1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore ~/savesmart-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias savesmart
   ```
2. Configure `android/key.properties`
3. Update `android/app/build.gradle.kts` with signing config

#### iOS
1. Configure signing in Xcode
2. Select development team
3. Enable automatic signing

### Distribution

#### Google Play Store
1. Build AAB: `flutter build appbundle`
2. Upload to Google Play Console
3. Complete store listing
4. Submit for review

#### Apple App Store
1. Build IPA: `flutter build ipa`
2. Upload via Xcode or Transporter app
3. Complete App Store Connect listing
4. Submit for review

### Performance Optimization

```bash
# Analyze app size
flutter build apk --analyze-size

# Profile app performance
flutter run --profile

# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
```

---

## 🎥 Demo Video

### Video Requirements
- **Duration**: 10-15 minutes
- **Format**: Single continuous recording
- **Device**: Physical Android phone (release APK)
- **Quality**: ≥ 1080p video, clear audio

### Demo Content Checklist

#### 1. ✅ Cold Start Launch
- Show app icon on phone
- Tap to launch from scratch
- Display splash screen and loading

#### 2. ✅ Authentication Flow
- **Register**: Create new account with email/password
- Show email verification (OTP)
- **Logout**: Complete sign-out
- **Login**: Sign in with existing credentials
- **Google Sign-In**: Demonstrate Google OAuth

#### 3. ✅ Screen Navigation
- Visit every screen in the app:
  - Welcome Page
  - Login/Register Pages
  - Dashboard/Home Page
  - Goals Page
  - Transactions Page
  - Tips Page
  - Profile Page
- Rotate device to landscape mode once per screen
- Demonstrate no pixel overflow

#### 4. ✅ CRUD Operations (with Firebase Console visible)
- **Create**: Add a new savings goal
- **Read**: View goals list and details
- **Update**: Modify an existing goal
- **Delete**: Remove a goal
- Show Firebase Console updating in real-time

#### 5. ✅ State Management
- Trigger a state change that affects two widgets simultaneously
- Example: Create transaction → Updates dashboard stats + transaction list

#### 6. ✅ SharedPreferences
- Change notification toggle setting
- Close and restart the app
- Show setting persisted

#### 7. ✅ Validation & Error Handling
- Trigger input validation errors:
  - Empty email field
  - Invalid email format
  - Short password
- Show polite error messages (Toast/SnackBar)

### Team Member Presentations

Each team member presents a specific feature:

| Member | Feature Demonstrated |
|--------|---------------------|
| **Ishimwe Levis** | UI/UX Design, Profile Page, Tips Page |
| **Singa Ewing** | Authentication Flow, Firebase Security |
| **Josephine Duba Kanu** | Goals Management, CRUD Operations |
| **Benitha Iradukunda** | Transactions, Dashboard Analytics |
| **Henriette Utatsineza** | State Management, SharedPreferences |

### Recording Setup

**Equipment**:
- Physical Android device (no emulators)
- Screen recording app (AZ Screen Recorder, Mobizen)
- OR: Connect via USB and use `scrcpy` with OBS Studio

**Lighting & Audio**:
- Well-lit environment
- Clear microphone (no echo/hum)
- Steady camera (tripod recommended)

**Editing**:
- Single continuous recording (no cuts)
- No speed-ups
- Camera steady throughout

### Video Submission

**File Format**: MP4, MOV, or AVI  
**Upload**: YouTube (unlisted) or Google Drive (shared link)  
**Link**: Include in project report PDF

---

## ⚠️ Known Limitations & Future Work

### Current Limitations

#### 1. **Offline Support**
- **Limitation**: Limited offline functionality; requires internet connection for most features
- **Impact**: Users cannot access or modify data without internet
- **Future Work**: Implement local caching with SQLite and sync when online

#### 2. **Currency Support**
- **Limitation**: Only supports USD currency
- **Impact**: Not suitable for international users
- **Future Work**: Add multi-currency support with exchange rates API

#### 3. **Analytics**
- **Limitation**: Basic analytics; no detailed spending insights
- **Impact**: Users lack comprehensive financial insights
- **Future Work**: Add charts, graphs, spending trends, and category breakdowns

#### 4. **Payment Integration**
- **Limitation**: No integration with real bank accounts or payment systems
- **Impact**: Manual entry of all transactions
- **Future Work**: Integrate with Plaid or similar APIs for automatic transaction import

#### 5. **Social Features**
- **Limitation**: No social sharing or collaborative goals
- **Impact**: Missed engagement opportunities
- **Future Work**: Add social features like shared goals, leaderboards, and challenges

#### 6. **Notification System**
- **Limitation**: Basic notification toggle; no push notifications implemented
- **Impact**: Users miss goal deadlines or savings reminders
- **Future Work**: Implement Firebase Cloud Messaging for push notifications

#### 7. **Goal Categories**
- **Limitation**: No categorization of savings goals
- **Impact**: Difficult to organize multiple goals
- **Future Work**: Add goal categories (Emergency Fund, Vacation, Education, etc.)

#### 8. **Budget Planning**
- **Limitation**: No monthly budget setting or tracking
- **Impact**: Users cannot plan spending limits
- **Future Work**: Add budget creation with alerts when approaching limits

### Future Enhancements

#### Phase 1 (Next 3 months)
- [ ] Implement push notifications
- [ ] Add offline support with local database
- [ ] Create detailed analytics dashboard with charts
- [ ] Multi-currency support

#### Phase 2 (6 months)
- [ ] Bank account integration (Plaid API)
- [ ] Budget planning and tracking
- [ ] Goal categories and templates
- [ ] Dark mode theme

#### Phase 3 (12 months)
- [ ] Social features and challenges
- [ ] AI-powered financial advice
- [ ] Investment tracking
- [ ] Bill reminders and automatic payments

### Performance Considerations

- **App Size**: Current APK ~50MB (can be optimized with code splitting)
- **Load Time**: Average 2-3 seconds initial load (can be improved with lazy loading)
- **Memory Usage**: ~150MB RAM (acceptable for modern devices)

---

## 👥 Team Members & Contributions

### Group Number: 5

| Name | Role | Contributions | Attendance |
|------|------|--------------|------------|
| **SINGA Ewing** | Project Lead & Backend Developer | - Part A: Secondary Research<br>- Firebase setup & configuration<br>- Firestore security rules<br>- Authentication implementation<br>- Backend architecture design<br>- Git commits: 25+ | October 5, 2025 |
| **Josephine Duba Kanu** | User Research Lead & Frontend Developer | - Part B: User Research & Interviews<br>- Goals feature implementation<br>- CRUD operations<br>- UI component development<br>- Git commits: 20+ | October 5, 2025 |
| **Benitha Iradukunda** | User Research Analyst & Frontend Developer | - Part B: User Research & Data Analysis<br>- Transactions feature<br>- Dashboard implementation<br>- Analytics widgets<br>- Git commits: 20+ | October 5, 2025 |
| **Henriette Utatsineza** | User Research Coordinator & QA Engineer | - Part B: User Research & Documentation<br>- State management implementation<br>- SharedPreferences integration<br>- Testing & quality assurance<br>- Git commits: 18+ | October 5, 2025 |
| **Ishimwe Levis** | UI/UX Designer & Frontend Developer | - Part C: Figma Prototype & Design<br>- UI implementation (Profile, Tips, Dashboard pages)<br>- Responsive design<br>- Image asset integration<br>- Backend support<br>- Git commits: 30+ | October 5, 2025 |

### Contribution Distribution

Total commits: **113+**  
Contribution balance: **Equitable** (all members 15-30% range)

### GitHub Repository

**Repository**: [https://github.com/levishimwe/savesmart](https://github.com/levishimwe/savesmart)  
**Access**: Public  
**Branch Strategy**: Feature branches merged to `main`

### Collaboration Tools

- **Version Control**: Git & GitHub
- **Communication**: WhatsApp, Discord
- **Project Management**: Trello board
- **Design**: Figma
- **Documentation**: Google Docs, Markdown

---

## 📄 License

This project is an educational submission for the **Mobile Application Development** course at the African Leadership University (ALU).

**Course**: Mobile Application Development  
**Instructor**: [Instructor Name]  
**Term**: Trimester 3, 2025  
**Institution**: African Leadership University

### Academic Integrity

This project was developed in accordance with ALU's academic integrity policies:
- All code is original work by team members
- AI assistance (GitHub Copilot, ChatGPT) used for <40% of code generation
- AI usage disclosed in methodology section
- All external resources properly cited
- No plagiarism or unauthorized collaboration

### Usage Rights

This project is intended for educational and portfolio purposes only. Redistribution or commercial use is not permitted without explicit permission from all team members.

---

## 📞 Contact & Support

For questions, feedback, or collaboration opportunities:

**Team Email**: group5.savesmart@student.alueducation.com

**Individual Contacts**:
- Ishimwe Levis: [l.ishimwe@alustudent.com](mailto:l.ishimwe@alustudent.com)
- Singa Ewing: [e.singa@alustudent.com](mailto:e.singa@alustudent.com)
- Josephine Duba Kanu: [j.kanu@alustudent.com](mailto:j.kanu@alustudent.com)
- Benitha Iradukunda: [b.iradukunda@alustudent.com](mailto:b.iradukunda@alustudent.com)
- Henriette Utatsineza: [h.utatsineza@alustudent.com](mailto:h.utatsineza@alustudent.com)

---

## 🙏 Acknowledgments

- **Firebase Team**: For excellent backend infrastructure
- **Flutter Team**: For the amazing cross-platform framework
- **ALU Faculty**: For guidance and support throughout the course
- **User Research Participants**: For valuable feedback and insights
- **Open Source Community**: For libraries and tools that made this project possible

---

## 📚 References

1. P. A. Rodríguez-Correa, "Financial literacy among young college students: Advancements and future directions," F1000Research, vol. 14, p. 113, Aug. 2025.

2. K. Goyal and S. Kumar, "An investigation of the determinants of financial literacy," Journal of Education for Business, vol. 96, no. 5, pp. 277–284, 2021.

3. "Why Millennials, Gen Z Are Likely to Use Mobile Banking," CNBC Select.

4. S. Constable, "When Tested, Most Students Lack Financial Literacy, New Study Finds," Forbes, May 27, 2024.

5. Flutter Documentation: https://docs.flutter.dev/

6. Firebase Documentation: https://firebase.google.com/docs

7. BLoC Pattern Documentation: https://bloclibrary.dev/

---

<div align="center">

**SaveSmart** - Empowering Financial Wellness, One Goal at a Time 💰

Made with ❤️ by Group 5 | African Leadership University | 2025

[⬆ Back to Top](#savesmart-a-digital-piggy-bank-for-empowering-financial-wellness-in-young-adults)

</div>
