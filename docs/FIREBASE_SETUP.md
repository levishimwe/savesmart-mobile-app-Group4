# Firebase Setup Guide for SaveSmart

This document provides comprehensive instructions for setting up Firebase for the SaveSmart project.

## Table of Contents
1. [Firebase Project Creation](#firebase-project-creation)
2. [Firestore Database Setup](#firestore-database-setup)
3. [Authentication Configuration](#authentication-configuration)
4. [Platform-Specific Configuration](#platform-specific-configuration)
5. [Security Rules Deployment](#security-rules-deployment)
6. [Testing Firebase Connection](#testing-firebase-connection)

---

## Firebase Project Creation

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `savesmart` (or `flutter-smart-save`)
4. Enable Google Analytics (optional)
5. Click **"Create project"**

### Step 2: Register Your App

#### Android App
1. In Firebase Console, click **Android icon**
2. Enter Android package name: `com.savesmart.app`
   - Find in `android/app/build.gradle.kts`: `applicationId`
3. Enter app nickname: `SaveSmart Android`
4. Enter SHA-1 certificate (for Google Sign-In):
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Copy the SHA-1 from the output
5. Download `google-services.json`
6. Place file in `android/app/` directory

#### iOS App (Optional)
1. Click **iOS icon** in Firebase Console
2. Enter iOS bundle ID: `com.savesmart.app`
3. Enter app nickname: `SaveSmart iOS`
4. Download `GoogleService-Info.plist`
5. Place file in `ios/Runner/` directory

---

## Firestore Database Setup

### Step 1: Create Firestore Database

1. In Firebase Console, go to **Build** → **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (we'll add security rules later)
4. Choose location: `us-central1` (or closest to your users)
5. Click **"Enable"**

### Step 2: Create Collections

Create the following collections manually (or they'll be created automatically when first data is added):

#### Collection: `users`
**Purpose**: Store user profile data

**Sample Document**:
```javascript
// Document ID: {userId} (Firebase Auth UID)
{
  uid: "abc123",
  email: "user@example.com",
  displayName: "John Doe",
  photoURL: "https://...",
  createdAt: Timestamp,
  notificationsEnabled: true
}
```

**Indexes**: None required (uid is document ID)

#### Collection: `goals`
**Purpose**: Store savings goals

**Sample Document**:
```javascript
// Document ID: Auto-generated
{
  goalId: "goal_xyz",
  userId: "abc123",
  name: "Emergency Fund",
  targetAmount: 5000.00,
  currentAmount: 1250.00,
  deadline: Timestamp,
  createdAt: Timestamp,
  isCompleted: false
}
```

**Required Index**:
1. Go to **Firestore** → **Indexes** → **Composite**
2. Click **"Add index"**
3. Collection ID: `goals`
4. Fields:
   - `userId` (Ascending)
   - `createdAt` (Descending)
5. Query scope: Collection
6. Click **"Create"**

#### Collection: `transactions`
**Purpose**: Store income and expense transactions

**Sample Document**:
```javascript
// Document ID: Auto-generated
{
  transactionId: "trans_789",
  userId: "abc123",
  description: "Grocery shopping",
  amount: 75.50,
  type: "expense", // or "income"
  category: "Food",
  date: Timestamp
}
```

**Required Index**:
1. Go to **Firestore** → **Indexes** → **Composite**
2. Click **"Add index"**
3. Collection ID: `transactions`
4. Fields:
   - `userId` (Ascending)
   - `date` (Descending)
5. Query scope: Collection
6. Click **"Create"**

#### Collection: `tips`
**Purpose**: Store financial tips (admin-managed)

**Sample Document**:
```javascript
// Document ID: Auto-generated
{
  tipId: "tip_001",
  title: "Weekly Financial Tip",
  description: "Save 20% of your income before spending...",
  category: "Savings",
  imageUrl: "assets/images/weekly--financial.jpg",
  createdAt: Timestamp
}
```

**Indexes**: None required

### Step 3: Add Sample Data (Optional)

Add sample tips for testing:

```javascript
// Tip 1
{
  tipId: "tip_001",
  title: "Weekly Financial Tip",
  description: "Set aside 20% of your income for savings before spending on other items.",
  category: "Savings",
  imageUrl: "assets/images/weekly--financial.jpg",
  createdAt: new Date()
}

// Tip 2
{
  tipId: "tip_002",
  title: "Budgeting Strategies",
  description: "Use the 50/30/20 rule: 50% needs, 30% wants, 20% savings.",
  category: "Budgeting",
  imageUrl: "assets/images/bugeting--strategies.png",
  createdAt: new Date()
}

// Tip 3
{
  tipId: "tip_003",
  title: "Student Finance Tips",
  description: "Take advantage of student discounts and apply for scholarships.",
  category: "Student Finance",
  imageUrl: "assets/images/student--finance.png",
  createdAt: new Date()
}
```

---

## Authentication Configuration

### Step 1: Enable Authentication Methods

1. In Firebase Console, go to **Build** → **Authentication**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab

#### Enable Email/Password
1. Click **"Email/Password"**
2. Toggle **"Enable"**
3. Enable **"Email link (passwordless sign-in)"** (optional)
4. Click **"Save"**

#### Enable Google Sign-In
1. Click **"Google"**
2. Toggle **"Enable"**
3. Select project support email
4. Add authorized domains (if using custom domain)
5. Click **"Save"**

### Step 2: Configure Email Templates

1. Go to **Authentication** → **Templates**
2. Customize email templates:
   - **Email verification**
   - **Password reset**
   - **Email address change**

**Example Email Verification Template**:
```
Subject: Verify your email for SaveSmart

Hi %DISPLAY_NAME%,

Thanks for signing up for SaveSmart! To complete your registration, please verify your email address by clicking the link below:

%LINK%

This link will expire in 24 hours.

If you didn't create a SaveSmart account, you can safely ignore this email.

Best regards,
The SaveSmart Team
```

### Step 3: Configure Authorized Domains

1. Go to **Authentication** → **Settings** → **Authorized domains**
2. Add domains:
   - `localhost` (for local testing)
   - Your production domain (if applicable)

---

## Platform-Specific Configuration

### Android Configuration

#### 1. Update `build.gradle` Files

**Project-level** (`android/build.gradle.kts`):
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

**App-level** (`android/app/build.gradle.kts`):
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Add this
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
}
```

#### 2. Verify `google-services.json`

Ensure `android/app/google-services.json` exists and contains:
```json
{
  "project_info": {
    "project_number": "267770869749",
    "project_id": "flutter-smart-save",
    "storage_bucket": "flutter-smart-save.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:267770869749:android:4899f67b54e2e762a712bc",
        "android_client_info": {
          "package_name": "com.savesmart.app"
        }
      }
    }
  ]
}
```

#### 3. Add Google Sign-In Configuration

**AndroidManifest.xml** (`android/app/src/main/AndroidManifest.xml`):
```xml
<application>
    <!-- ... existing config ... -->
    
    <meta-data
        android:name="com.google.android.gms.version"
        android:value="@integer/google_play_services_version" />
</application>
```

### iOS Configuration (macOS only)

#### 1. Add `GoogleService-Info.plist`

Place the downloaded file in `ios/Runner/` directory.

#### 2. Update `Info.plist`

**`ios/Runner/Info.plist`**:
```xml
<dict>
    <!-- ... existing config ... -->
    
    <!-- Google Sign-In URL Scheme -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
            </array>
        </dict>
    </array>
</dict>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `GoogleService-Info.plist`.

#### 3. Update Podfile

**`ios/Podfile`**:
```ruby
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

Run:
```bash
cd ios
pod install
```

---

## Security Rules Deployment

### Step 1: Create `firestore.rules` File

The file already exists in the project root with the following content:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Goals collection
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
    
    // Transactions collection
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
    
    // Tips collection
    match /tips/{tipId} {
      allow read: if isAuthenticated();
      allow write: if false; // Admin-only via Firebase Console
    }
  }
}
```

### Step 2: Deploy Rules

#### Option 1: Firebase Console (Manual)
1. Go to **Firestore Database** → **Rules**
2. Copy the rules from `firestore.rules`
3. Paste into the editor
4. Click **"Publish"**

#### Option 2: Firebase CLI (Automated)
```bash
# Install Firebase CLI (if not installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

### Step 3: Test Security Rules

#### Test 1: Authenticated User Can Read Own Data
```javascript
// Should ALLOW
match /users/abc123
allow read: if request.auth.uid == 'abc123'
```

#### Test 2: User Cannot Read Other User's Data
```javascript
// Should DENY
match /users/xyz789
allow read: if request.auth.uid == 'abc123'
```

#### Test 3: Unauthenticated User Cannot Read
```javascript
// Should DENY
match /users/abc123
allow read: if request.auth == null
```

---

## Testing Firebase Connection

### Step 1: Test Authentication

```dart
// test/firebase_auth_test.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  test('Email/Password sign-up', () async {
    final auth = FirebaseAuth.instance;
    
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      
      expect(userCredential.user, isNotNull);
      expect(userCredential.user!.email, 'test@example.com');
      
      // Clean up
      await userCredential.user!.delete();
    } catch (e) {
      fail('Authentication failed: $e');
    }
  });
}
```

### Step 2: Test Firestore CRUD

```dart
// test/firestore_crud_test.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  test('Create and read goal', () async {
    final firestore = FirebaseFirestore.instance;
    final userId = 'test_user_123';
    
    // Create goal
    final goalRef = await firestore.collection('goals').add({
      'userId': userId,
      'name': 'Test Goal',
      'targetAmount': 1000.0,
      'currentAmount': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Read goal
    final goalDoc = await goalRef.get();
    expect(goalDoc.exists, true);
    expect(goalDoc.data()?['name'], 'Test Goal');
    
    // Clean up
    await goalRef.delete();
  });
}
```

### Step 3: Manual Testing Checklist

- [ ] Run app on physical device
- [ ] Register new user with email/password
- [ ] Receive verification email
- [ ] Verify email and login
- [ ] Logout and login with Google
- [ ] Create a savings goal
- [ ] Verify goal appears in Firestore Console
- [ ] Add a transaction
- [ ] Verify transaction appears in Firestore Console
- [ ] Check that other users cannot see your data
- [ ] Toggle notification setting
- [ ] Restart app and verify setting persisted

---

## Troubleshooting

### Issue: "google-services.json not found"

**Solution**:
1. Download `google-services.json` from Firebase Console
2. Place in `android/app/` directory
3. Run `flutter clean` and `flutter pub get`

### Issue: "Failed to resolve: com.google.firebase"

**Solution**:
1. Check internet connection
2. Sync Gradle files in Android Studio
3. Update Google Services plugin version in `build.gradle`

### Issue: "Google Sign-In fails with error 10"

**Solution**:
1. Add SHA-1 certificate to Firebase Console
2. Generate SHA-1:
   ```bash
   cd android
   ./gradlew signingReport
   ```
3. Add SHA-1 to Firebase Console → Project Settings → Your apps

### Issue: "Permission denied" on Firestore reads

**Solution**:
1. Check that user is authenticated
2. Verify security rules in Firebase Console
3. Ensure `userId` field matches authenticated user's UID

### Issue: Email verification not sending

**Solution**:
1. Check Firebase Console → Authentication → Templates
2. Verify authorized domains include your domain
3. Check spam folder
4. Wait 5-10 minutes (emails can be delayed)

---

## Best Practices

### 1. Security
- ✅ Always validate `userId` matches authenticated user
- ✅ Never store sensitive data in Firestore (use Firebase Auth)
- ✅ Use security rules to enforce access control
- ✅ Enable email verification for new users

### 2. Performance
- ✅ Create indexes for frequently queried fields
- ✅ Limit query results with `.limit()`
- ✅ Use pagination for large datasets
- ✅ Cache frequently accessed data locally

### 3. Cost Optimization
- ✅ Minimize document reads (use caching)
- ✅ Delete unused data regularly
- ✅ Use Firestore emulator for local testing
- ✅ Monitor usage in Firebase Console

### 4. Data Integrity
- ✅ Use transactions for related operations
- ✅ Validate data on client and server (security rules)
- ✅ Use timestamps instead of client dates
- ✅ Implement soft deletes instead of hard deletes

---

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)

---

**Document Version**: 1.0  
**Last Updated**: November 21, 2025  
**Author**: SaveSmart Development Team
