# SaveSmart - A Digital Piggy Bank for Financial Wellness

SaveSmart is a comprehensive mobile application designed to enhance financial literacy and promote healthy saving behaviors among young adults and university students.

## Features

- **Authentication**: Email/Password and Google Sign-In with email verification
- **Savings Goals**: Create, track, and manage multiple savings goals with visual progress indicators
- **Expense Tracking**: Record and categorize transactions with real-time sync
- **Financial Tips**: Educational content on budgeting, savings, and student finance
- **Profile Management**: User profiles with progress tracking and statistics
- **Responsive Design**: Works on phones of all sizes with landscape support

## Architecture

The app follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/                    # Core utilities, constants, widgets
├── features/                # Feature modules
│   ├── auth/               # Authentication
│   ├── goals/              # Savings goals
│   ├── transactions/       # Expense tracking
│   ├── tips/               # Financial tips
│   └── profile/            # User profile
└── main.dart               # App entry point
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Firebase project configured
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase (firebase_options.dart included)
4. Run `flutter run`

### Running Tests
```bash
flutter test                 # Run all tests
flutter test --coverage      # With coverage
```

## Dependencies

**Core**: firebase_core, firebase_auth, cloud_firestore, google_sign_in  
**State Management**: flutter_bloc, equatable  
**Utilities**: shared_preferences, get_it, intl, dartz

## Building
```bash
flutter build apk --release      # Android APK
flutter build appbundle          # Android Bundle
```

## Known Limitations
- Limited offline support
- USD only
- Basic analytics

## License
Educational project for Mobile Application Development course.
