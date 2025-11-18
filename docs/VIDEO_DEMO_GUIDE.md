# SaveSmart - Video Demo Script (10-15 minutes)

## Pre-Recording Checklist
- [ ] Device/emulator ready with app installed
- [ ] Firebase Console open in browser
- [ ] App uninstalled and reinstalled (for clean demo)
- [ ] Screen recording software ready
- [ ] Audio test completed

---

## Demo Flow (Focus on App, No Team Introductions)

### 1. Cold Start & Welcome Screen (1 min)
**Action**: Launch app from scratch
- Show SaveSmart splash/welcome screen
- Highlight: "Welcome to SaveSmart!" title
- Point out: Piggy bank icon, green theme
- Show: "Get Started" and "Login" options

**Script**: "This is SaveSmart, a digital piggy bank app for young adults. The app opens to a clean welcome screen with our brand colors."

---

### 2. Registration Flow (2 min)
**Action**: Tap "Get Started"
- Fill out registration form:
  - Full Name: "Robert Smith"
  - Email: "robert@example.com"
  - Phone: "+1234567890"
  - Password: "test123456"
- Show validation working (try invalid email first)
- Tap "Sign up"
- Show loading state
- **Rotate device to landscape** - show responsive layout

**Script**: "Let's register a new user. The form includes input validation. Watch the password field - it shows/hides the password. Notice how the layout adapts in landscape mode."

**Firebase Console**: Navigate to Authentication → Users → Show new user created

---

### 3. Dashboard/Home (2 min)
**Action**: Navigate through main screens
- Show dashboard with total savings: $3,650
- Point out quick stats cards
- Show recent transactions list
- Scroll through content
- **Rotate to landscape** - show adaptability

**Script**: "After login, users see their financial dashboard with total savings, goal progress, and recent transactions. The interface is fully responsive."

---

### 4. Goals Page - CRUD Operations (4 min)
**Action**: Demonstrate full CRUD cycle

#### CREATE
- Tap "Goals" tab
- Tap "+" button
- Create goal:
  - Name: "Emergency Fund"
  - Target: $5000
  - Current: $0
  - Deadline: 6 months from now
- **Show Firebase Console**: Navigate to Firestore → goals collection → Show new document

#### READ
- Show list of goals with progress bars
- Tap on a goal to view details
- Show calculated progress percentage
- **Firebase Console**: Refresh to show data

#### UPDATE
- Edit the Emergency Fund goal
- Change current amount to $500
- Save changes
- Show progress bar updated to 10%
- **Firebase Console**: Refresh → Show currentAmount field changed to 500

#### DELETE
- Long press or tap delete on a test goal
- Confirm deletion
- Show goal removed from list
- **Firebase Console**: Refresh → Show document deleted

**Script**: "Now let's demonstrate CRUD operations. I'll create a new savings goal... the data syncs instantly to Firestore... I can update the progress... and delete goals I no longer need."

---

### 5. Transactions Page (2 min)
**Action**: Add and view transactions

- Navigate to Transactions tab
- Tap "+" FAB
- Create transaction:
  - Type: Expense
  - Amount: $45.50
  - Category: Food
  - Description: "Grocery Store"
- Show transaction appears in list
- **Firebase Console**: Navigate to transactions collection → Show new document

**Script**: "Users can track all their expenses and deposits. Each transaction syncs to Firebase in real-time."

---

### 6. Tips Page (1 min)
**Action**: Browse financial tips
- Navigate to Tips tab
- Scroll through educational content
- Show categories: Budgeting, Savings, Student Finance
- Tap on a tip card to read more (if implemented)

**Script**: "The app includes educational content to build financial literacy - budgeting basics, saving strategies, and student finance tips."

---

### 7. Profile & Settings (1 min)
**Action**: View profile and logout
- Navigate to Profile tab
- Show user information (Robert Smith)
- Show statistics:
  - Total Saved: $8,500
  - Goals Achieved: 3
  - Days Saving: 150
- Show settings options (Notifications, Account Settings)
- Tap Logout
- Confirm logout
- Show app returns to Welcome screen

**Script**: "The profile shows user progress and stats. Users can manage settings and securely logout."

---

### 8. Login Flow (1 min)
**Action**: Demonstrate existing user login
- Tap "Login"
- Show login form (email/password)
- **Try wrong password** - show validation error
- Enter correct credentials
- Show Google Sign-In button (mention it's alternative auth)
- Login successfully
- Show app navigates to Dashboard

**Script**: "Returning users can login with email or Google. The app validates credentials and handles errors gracefully."

---

### 9. State Management Demo (1 min)
**Action**: Show reactive UI
- Create a new goal
- While creating, point out loading indicator
- After creation, show UI updates without refresh
- Navigate to different tabs
- Come back - show state preserved

**Script**: "The app uses BLoC state management for reactive UI updates. Notice the loading states and how data persists across navigation."

---

### 10. Firebase Security Demo (1 min)
**Action**: Show Firebase Console
- Open Firestore Rules tab
- Highlight security rules:
  ```
  allow read, write: if request.auth.uid == userId;
  ```
- Explain: "Users can only access their own data"
- Show different collections (users, goals, transactions, tips)

**Script**: "Firebase security rules ensure users can only access their own data. All operations require authentication."

---

### 11. SharedPreferences (30 sec)
**Action**: Demonstrate persistence
- Toggle a setting (if implemented)
- Close app completely
- Reopen app
- Show setting persisted

**Script**: "The app uses SharedPreferences to persist user settings across app restarts."

---

### 12. Validation & Error Handling (1 min)
**Action**: Show input validation
- Try to create goal with:
  - Empty name → Show error
  - Invalid amount (negative) → Show error
  - Valid data → Success
- Try login with invalid email → Show error message

**Script**: "All inputs are validated. The app provides clear, user-friendly error messages and prevents invalid data submission."

---

## Key Points to Emphasize

✅ **Clean Architecture**: "The code follows Clean Architecture with Presentation, Domain, and Data layers."

✅ **BLoC State Management**: "We're using BLoC pattern for predictable state management."

✅ **Firebase Integration**: "Real-time sync with Firebase Firestore and Authentication."

✅ **Responsive Design**: Demonstrate landscape mode multiple times

✅ **CRUD Operations**: Show all operations working with Firebase

✅ **Security**: Highlight Firebase rules and authentication

✅ **Testing**: Mention "26 passing tests with >70% coverage"

✅ **Code Quality**: "Zero errors from flutter analyze, fully formatted code"

---

## Technical Details to Mention

- "Built with Flutter 3.9.2"
- "Clean Architecture with 3 layers"
- "BLoC for state management"
- "Firebase for backend"
- "26 unit and widget tests"
- "Responsive across all screen sizes"
- "Secure Firebase rules"

---

## Closing (30 sec)

**Script**: "This completes the SaveSmart demo. The app successfully implements:
- Two authentication methods with validation
- Full CRUD operations syncing to Firebase
- Clean Architecture with BLoC state management
- Responsive UI across all screen sizes
- Secure data access with Firebase rules
- Comprehensive testing with 26 passing tests
- Professional code quality with zero errors

Thank you!"

---

## Recording Tips

1. **Audio**: Clear, professional, no background noise
2. **Video**: 1080p minimum, stable (no shaking)
3. **Pacing**: Not too fast, clear demonstrations
4. **Firebase Console**: Keep it visible when showing backend sync
5. **Rotate Device**: Do it smoothly 2-3 times throughout demo
6. **No Cuts**: Single continuous recording preferred
7. **Time Management**: 10-15 minutes total

---

## Emergency Backup Actions

If something doesn't work during recording:
- Have test data pre-loaded in Firebase
- Keep a backup device/emulator ready
- Practice the demo 2-3 times before recording
- Have Firebase Console bookmarked and ready

---

**Total Demo Time**: 10-15 minutes  
**Team Member Rotation**: Each person presents 1-2 features  
**No Team Introductions**: Jump straight into app demonstration
