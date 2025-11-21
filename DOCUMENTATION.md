# SaveSmart - Project Documentation

## Table of Contents
1. [Methodology](#methodology)
2. [AI Assistance Disclosure](#ai-assistance-disclosure)
3. [Development Timeline](#development-timeline)
4. [Design Decisions](#design-decisions)
5. [Challenges & Solutions](#challenges--solutions)
6. [Code Quality Standards](#code-quality-standards)

---

## Methodology

### Development Process

SaveSmart was developed following an **Agile methodology** with iterative development cycles:

#### Phase 1: Research & Planning (Week 1-2)
- **Secondary Research**: Literature review on financial literacy among young adults
- **User Research**: Conducted interviews with 20+ university students
- **Market Analysis**: Evaluated competitors (YNAB, Mint, Acorns, SmartyPig)
- **Requirements Gathering**: Defined core features based on user needs

#### Phase 2: Design (Week 3-4)
- **User Personas**: Created detailed personas based on research
- **User Journey Mapping**: Mapped user flows from onboarding to goal achievement
- **Wireframing**: Low-fidelity sketches for all screens
- **Prototype**: High-fidelity Figma prototype with complete user flows
- **Design System**: Established color palette, typography, and component library

#### Phase 3: Architecture Setup (Week 5)
- **Clean Architecture**: Organized code into presentation, domain, and data layers
- **BLoC Pattern**: Implemented state management with flutter_bloc
- **Dependency Injection**: Set up GetIt for service location
- **Firebase Configuration**: Connected Firebase Auth and Firestore

#### Phase 4: Feature Implementation (Week 6-10)
Sprint-based development with feature modules:
- **Sprint 1**: Authentication (Email/Password, Google Sign-In)
- **Sprint 2**: Savings Goals (CRUD operations)
- **Sprint 3**: Transactions & Dashboard
- **Sprint 4**: Tips & Profile pages
- **Sprint 5**: UI polish & responsive design

#### Phase 5: Testing & Quality Assurance (Week 11)
- **Unit Testing**: Core utilities and business logic
- **Widget Testing**: UI components and interactions
- **Integration Testing**: End-to-end user flows
- **Code Analysis**: Flutter analyze with 0 warnings
- **Manual Testing**: Device testing across different screen sizes

#### Phase 6: Documentation & Submission (Week 12)
- **README**: Comprehensive project documentation
- **Code Comments**: Inline documentation for complex logic
- **Demo Video**: 15-minute feature demonstration
- **Report**: Academic report following submission guidelines

---

## AI Assistance Disclosure

### AI Tools Used

In accordance with academic integrity requirements, we disclose the following AI assistance:

#### 1. **GitHub Copilot** (~25% of code)
**Usage**: Code completion and boilerplate generation
- Autocomplete for repetitive patterns (model classes, widget structures)
- Suggested method signatures and parameter types
- Generated basic CRUD operation templates

**Examples**:
```dart
// Copilot-suggested model class structure
class SavingsGoalModel extends SavingsGoal {
  const SavingsGoalModel({
    required super.id,
    required super.userId,
    required super.name,
    // ... Copilot completed remaining parameters
  });
}
```

**Human Review**: All suggestions reviewed, modified, and integrated manually

#### 2. **ChatGPT** (~10% of code)
**Usage**: Problem-solving and debugging assistance
- Debugging Firebase configuration issues
- Understanding complex BLoC state transitions
- Generating test case structures
- Explaining Dart language features

**Examples**:
- Query: "How to implement email verification with Firebase Auth in Flutter?"
- Query: "Best practices for Firestore security rules with user-owned data"
- Query: "How to test BLoC events and states with bloc_test package?"

**Human Review**: All ChatGPT responses adapted to project context

#### 3. **Stack Overflow / Documentation** (~5%)
**Usage**: Reference for specific API implementations
- Firebase Auth API documentation
- Flutter widget properties
- Dart language syntax

### AI Contribution Summary

| Source | Percentage | Usage Type |
|--------|-----------|------------|
| **Original Team Code** | **60%** | Core logic, UI design, business rules |
| **GitHub Copilot** | **25%** | Code completion, boilerplate |
| **ChatGPT** | **10%** | Problem-solving, debugging |
| **Documentation/SO** | **5%** | API reference |

**Total AI Assistance**: **~40%** (within academic guidelines)

### Human Contribution

All critical aspects developed entirely by team:
- ✅ Architecture decisions
- ✅ Business logic design
- ✅ UI/UX design (Figma prototypes)
- ✅ Feature requirements
- ✅ Database schema design
- ✅ Security rules logic
- ✅ Testing strategies
- ✅ Code reviews and refactoring

---

## Development Timeline

### Gantt Chart Overview

```
Week 1-2:   [Research & Planning        ]
Week 3-4:   [Design & Prototyping       ]
Week 5:     [Architecture Setup         ]
Week 6-7:   [Authentication Feature     ]
Week 8:     [Goals Feature              ]
Week 9:     [Transactions Feature       ]
Week 10:    [Tips & Profile Features    ]
Week 11:    [Testing & QA               ]
Week 12:    [Documentation & Submission ]
```

### Milestone Delivery

| Milestone | Date | Status |
|-----------|------|--------|
| Part A: Secondary Research | Week 2 | ✅ Completed |
| Part B: User Research | Week 4 | ✅ Completed |
| Part C: Figma Prototype | Week 4 | ✅ Completed |
| Firebase ERD | Week 5 | ✅ Completed |
| Authentication MVP | Week 7 | ✅ Completed |
| Core Features Complete | Week 10 | ✅ Completed |
| Testing Complete | Week 11 | ✅ Completed |
| Final Submission | Week 12 | ✅ Completed |

---

## Design Decisions

### 1. Architecture: Clean Architecture + BLoC

**Decision**: Use Clean Architecture with BLoC state management

**Rationale**:
- **Separation of Concerns**: Clear boundaries between layers
- **Testability**: Easy to unit test business logic independently
- **Scalability**: New features can be added without affecting existing code
- **Maintainability**: Code is organized and easy to navigate

**Alternatives Considered**:
- Provider (simpler but less structured for large apps)
- GetX (powerful but opinionated and less testable)
- Riverpod (modern but steeper learning curve)

**Outcome**: Clean Architecture + BLoC provided the best balance of structure, testability, and team familiarity.

### 2. Database: Firebase Firestore

**Decision**: Use Firestore for backend database

**Rationale**:
- **Real-time Sync**: Live updates across devices
- **Scalability**: Handles growth without infrastructure management
- **Security**: Built-in security rules for access control
- **Free Tier**: Generous limits for MVP and student projects

**Alternatives Considered**:
- SQLite (offline-first but requires custom sync logic)
- Supabase (open-source but less mature ecosystem)
- Custom REST API (requires backend development)

**Outcome**: Firestore's real-time capabilities and ease of integration made it ideal for SaveSmart.

### 3. Authentication: Firebase Auth with Email + Google

**Decision**: Implement two authentication methods

**Rationale**:
- **Rubric Requirement**: Minimum 2 authentication methods
- **User Convenience**: Email for privacy-conscious users, Google for convenience
- **Security**: Firebase handles token management and security
- **Email Verification**: Added OTP for extra security

**Alternatives Considered**:
- Social auth (Facebook, Apple) - added complexity
- Phone auth - requires SMS setup and costs

**Outcome**: Email + Google provides security and convenience while meeting requirements.

### 4. State Management: BLoC Pattern

**Decision**: Use flutter_bloc for state management

**Rationale**:
- **Predictable**: Events → Business Logic → States
- **Testable**: BLoCs are pure Dart classes, easy to test
- **Separation**: UI doesn't contain business logic
- **Reactive**: Streams provide real-time updates

**Implementation**:
```dart
// Example BLoC structure
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._signInWithEmail) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
  }
  
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signInWithEmail(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }
}
```

### 5. UI Design: Material Design 3

**Decision**: Follow Material Design 3 guidelines

**Rationale**:
- **Consistency**: Familiar patterns for users
- **Accessibility**: Built-in accessibility features
- **Components**: Rich widget library
- **Modern**: Contemporary design language

**Color Scheme**:
- Primary: `#00A86B` (Green - growth, money)
- Background: `#E9F9F2` (Light green - calming)
- Card: `#D6F5E6` (Medium green - distinction)
- Text: Dark gray for readability

**Typography**:
- Font: Roboto (clean, readable)
- Sizes: 24sp (headings), 16sp (body), 14sp (captions)

---

## Challenges & Solutions

### Challenge 1: Firebase Configuration Across Platforms

**Problem**: Setting up Firebase for Android, iOS, Web, and desktop platforms was complex.

**Solution**:
1. Used `flutterfire configure` CLI tool
2. Generated `firebase_options.dart` with all platform configs
3. Added platform-specific config files:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`

**Lesson Learned**: Use Firebase CLI tools early to automate configuration.

### Challenge 2: Responsive UI Across Screen Sizes

**Problem**: Layout broke on small phones (≤5.5") and large phones (≥6.7") in landscape mode.

**Solution**:
```dart
// Used MediaQuery for responsive sizing
final screenWidth = MediaQuery.of(context).size.width;
final isSmallScreen = screenWidth < 360;

// Adjusted padding and font sizes
padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
fontSize: isSmallScreen ? 14 : 16,
```

**Lesson Learned**: Always test on multiple device sizes and orientations.

### Challenge 3: Real-time Data Synchronization

**Problem**: Dashboard statistics not updating immediately after creating goals or transactions.

**Solution**:
- Used `StreamBuilder` instead of `FutureBuilder`
- Firestore `snapshots()` for real-time updates
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection('goals')
    .where('userId', isEqualTo: userId)
    .snapshots(),
  builder: (context, snapshot) {
    // UI updates automatically when data changes
  },
)
```

**Lesson Learned**: Leverage Firestore's real-time capabilities for better UX.

### Challenge 4: Email Verification Flow

**Problem**: Users could skip email verification and access the app.

**Solution**:
1. Check `user.emailVerified` after sign-in
2. Show verification screen if not verified
3. Send verification email with `user.sendEmailVerification()`
4. Poll verification status or require app restart

**Lesson Learned**: Authentication flows need careful state management.

### Challenge 5: Git Collaboration

**Problem**: Merge conflicts when multiple team members edited the same files.

**Solution**:
1. Established branching strategy:
   - `main` - production code
   - `feature/<feature-name>` - feature development
2. Daily standup meetings to coordinate work
3. Code reviews before merging PRs

**Lesson Learned**: Clear Git workflows prevent conflicts and improve code quality.

### Challenge 6: Testing BLoC State Transitions

**Problem**: Writing tests for asynchronous BLoC state changes was difficult.

**Solution**:
- Used `bloc_test` package for streamlined BLoC testing
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, Authenticated] when sign-in succeeds',
  build: () => AuthBloc(mockSignInUseCase),
  act: (bloc) => bloc.add(SignInRequested(email, password)),
  expect: () => [
    AuthLoading(),
    Authenticated(mockUser),
  ],
);
```

**Lesson Learned**: Use specialized testing libraries for complex state management.

---

## Code Quality Standards

### 1. Flutter Analyze: 0 Issues

**Command**: `flutter analyze`

**Result**: ✅ **0 issues, 0 warnings**

**Standards Enforced**:
- No unused imports
- No unused variables
- Proper type annotations
- Consistent naming conventions
- No deprecated API usage

**Screenshot**: Included in project report

### 2. Code Formatting

**Command**: `dart format lib/ test/`

**Standards**:
- 2-space indentation
- 80-character line limit (flexible for readability)
- Consistent bracket placement
- Trailing commas for multi-line function calls

**Example**:
```dart
// Well-formatted code
CustomButton(
  text: 'Save Goal',
  onPressed: _submitGoal,
  isLoading: isLoading,
);
```

### 3. Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Classes | PascalCase | `SavingsGoal`, `AuthBloc` |
| Files | snake_case | `savings_goal.dart`, `auth_bloc.dart` |
| Variables | camelCase | `userId`, `targetAmount` |
| Constants | lowerCamelCase | `primaryGreen`, `maxGoals` |
| Private | _prefixed | `_buildGoalCard`, `_userId` |

### 4. Code Comments

**Guidelines**:
- Comment **why**, not **what**
- Document complex algorithms
- Add TODO comments for future work
- Use doc comments for public APIs

**Example**:
```dart
/// Signs in a user with email and password.
///
/// Returns [Either] a [Failure] or [User] object.
/// Throws [ServerException] if Firebase is unreachable.
Future<Either<Failure, User>> signIn({
  required String email,
  required String password,
}) async {
  // Validate inputs before attempting sign-in
  // to avoid unnecessary Firebase calls
  if (!_isValidEmail(email)) {
    return Left(ValidationFailure('Invalid email format'));
  }
  // ... rest of implementation
}
```

### 5. Code Reusability

**Principles**:
- DRY (Don't Repeat Yourself)
- Extract common widgets
- Use utility functions
- Create reusable components

**Example**:
```dart
// Reusable custom button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);
  
  // Used across 15+ screens
}
```

### 6. Error Handling

**Standards**:
- Try-catch blocks for async operations
- User-friendly error messages
- Log errors for debugging
- Graceful degradation

**Example**:
```dart
try {
  await _createGoal(goal);
  _showSuccessMessage('Goal created!');
} on FirebaseException catch (e) {
  _showErrorMessage('Failed to create goal: ${e.message}');
  debugPrint('Firebase error: ${e.code}');
} catch (e) {
  _showErrorMessage('An unexpected error occurred');
  debugPrint('Unknown error: $e');
}
```

### 7. Performance Best Practices

- Use `const` constructors where possible
- Avoid rebuilding entire widget trees
- Implement `shouldRepaint` for custom painters
- Lazy-load images and data
- Cache expensive computations

### 8. Accessibility

- Semantic labels for screen readers
- Minimum tap target size (48x48 dp)
- Color contrast ratio ≥ 4.5:1
- Support for system font scaling

**Example**:
```dart
Semantics(
  label: 'Create new savings goal',
  child: FloatingActionButton(
    onPressed: _showGoalDialog,
    child: const Icon(Icons.add),
  ),
)
```

---

## Additional Resources

### Internal Documentation
- [API Documentation](docs/api.md) - Internal API reference
- [Component Library](docs/components.md) - Reusable widget catalog
- [Firebase Setup Guide](docs/firebase_setup.md) - Detailed Firebase configuration

### External References
- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design 3](https://m3.material.io/)

### Learning Resources
- [Flutter & Dart - The Complete Guide 2024](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
- [BLoC Pattern by Felix Angelov](https://www.youtube.com/watch?v=THCkkQ-V1-8)
- [Firebase for Flutter Tutorial](https://firebase.google.com/docs/flutter/setup)

---

## Conclusion

SaveSmart was developed following industry best practices for mobile application development, with a strong emphasis on code quality, testability, and user experience. The combination of Clean Architecture, BLoC state management, and Firebase backend created a scalable, maintainable foundation for future enhancements.

The project successfully addresses the financial literacy gap among young adults while demonstrating mastery of Flutter development, state management, backend integration, and collaborative software engineering.

---

**Document Version**: 1.0  
**Last Updated**: November 21, 2025  
**Authors**: SaveSmart Development Team (Group 5)
