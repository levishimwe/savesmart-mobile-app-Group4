# SaveSmart - Demo Video Script & Guide

## Video Requirements

- **Duration**: 10-15 minutes
- **Format**: Single continuous recording (no cuts/edits)
- **Quality**: 1080p minimum, clear audio
- **Device**: Physical Android phone with release APK
- **Setup**: Firebase Console visible alongside phone screen

---

## Pre-Recording Checklist

### Technical Setup

- [ ] Install release APK on physical Android device
- [ ] Fully charge device or connect to power
- [ ] Connect to stable Wi-Fi
- [ ] Clear all app data (fresh install demo)
- [ ] Disable notifications from other apps
- [ ] Set phone to "Do Not Disturb" mode
- [ ] Increase screen brightness to 100%
- [ ] Set screen timeout to maximum (30 mins)

### Recording Equipment

- [ ] Screen recording app installed (AZ Screen Recorder, Mobizen)
  - OR: USB connection with `scrcpy` + OBS Studio
- [ ] Microphone tested (clear audio, no echo/background noise)
- [ ] Camera/tripod steady (if showing both phone and laptop)
- [ ] Lighting adequate (bright, no glare on screen)

### Firebase Console Setup

- [ ] Open Firebase Console in browser
- [ ] Navigate to Firestore Database tab
- [ ] Open Authentication → Users tab in another tab
- [ ] Position windows side-by-side with phone screen

### Test Accounts

Create test accounts beforehand:

**Account 1 - Email/Password**:
- Email: `demo1@savesmart.test`
- Password: `demo123456`
- Status: Verified

**Account 2 - Google Sign-In**:
- Use personal Google account
- Pre-registered

### Sample Data Prepared

- [ ] At least 2 savings goals in Firestore
- [ ] At least 3 transactions in Firestore
- [ ] Financial tips populated

---

## Video Script

### Introduction (30 seconds)

**[Show title card or app icon on phone]**

**Speaker 1 (Ishimwe Levis):**
> "Hello! We're Group 5, and we're excited to present SaveSmart, a digital piggy bank application designed to empower financial wellness in young adults. Today, we'll demonstrate all the features of our app, including authentication, CRUD operations, state management, and data persistence. Let's dive in!"

---

### Part 1: Cold Start Launch (1 minute)

**[Phone screen visible, app not yet launched]**

**Speaker 1:**
> "Let's start with a cold-start launch of the app from the device home screen."

**Actions**:
1. Show Android home screen
2. Locate SaveSmart app icon
3. Tap icon
4. Show splash screen loading
5. App opens to Welcome page

**Speaker 1:**
> "As you can see, the app launches smoothly and presents the welcome screen with options to sign in or register."

---

### Part 2: Authentication - Registration (3 minutes)

**[Welcome page visible]**

**Speaker 2 (Singa Ewing):**
> "I'll demonstrate the registration flow with email and password authentication."

**Actions**:
1. Tap "Create Account" button
2. Show registration form

**Speaker 2:**
> "First, let's test our input validation. I'll try submitting with an invalid email."

**Actions**:
3. Enter invalid email: `testuser` (no @)
4. Enter password: `test12345`
5. Enter name: `Test User`
6. Tap "Sign Up"
7. Show validation error: "Please enter a valid email"

**Speaker 2:**
> "Now let's try with a password that's too short."

**Actions**:
8. Fix email: `testuser@savesmart.test`
9. Change password to: `12345` (only 5 characters)
10. Tap "Sign Up"
11. Show validation error: "Password must be at least 6 characters"

**Speaker 2:**
> "Finally, let's register with valid credentials."

**Actions**:
12. Fix password: `test12345` (6+ characters)
13. Tap "Sign Up"
14. Show loading indicator
15. Registration success
16. Show email verification screen

**Speaker 2:**
> "The app has sent a verification email. Let me show you the email."

**Actions**:
17. **[Split screen or PiP]** Open Gmail on phone
18. Show verification email received
19. **Note**: Don't click the link yet (save for later demo)
20. Return to app

**Speaker 2:**
> "For now, let's sign out and demonstrate the login flow."

**Actions**:
21. Tap "Sign Out" or back to welcome

---

### Part 3: Authentication - Login (2 minutes)

**[Welcome page visible]**

**Speaker 2:**
> "Now I'll sign in with the account we just created."

**Actions**:
1. Tap "Sign In" button
2. Enter email: `testuser@savesmart.test`
3. Enter password: `test12345`
4. Tap "Sign In"
5. Show loading indicator
6. Success - navigate to home page (Dashboard)

**Speaker 2:**
> "Perfect! We're now authenticated and can see the dashboard. Note the bottom navigation bar with four tabs: Dashboard, Goals, Transactions, and Profile."

---

### Part 4: Authentication - Google Sign-In (2 minutes)

**[Profile page]**

**Speaker 2:**
> "Let me sign out and demonstrate Google Sign-In."

**Actions**:
1. Navigate to Profile tab
2. Scroll down
3. Tap "Logout" button
4. Return to Welcome page

**Speaker 2:**
> "Now I'll sign in with Google."

**Actions**:
5. Tap "Sign in with Google" button
6. Google account picker appears
7. Select Google account
8. Confirm permissions
9. Show loading
10. Success - navigate to Dashboard

**[Switch to Firebase Console on laptop]**

**Speaker 2:**
> "Let's verify in Firebase Console that our user was created."

**Actions**:
11. Show Firebase Authentication → Users tab
12. Show user entry with Google email
13. Show UID matching

**Speaker 2:**
> "Great! Now let's explore the app features."

---

### Part 5: Screen Navigation & Rotation (2 minutes)

**[Dashboard visible]**

**Speaker 3 (Josephine Duba Kanu):**
> "I'll navigate through all the screens and demonstrate our responsive design."

**Actions**:
1. **Dashboard**: Show Total Savings card, goal circles, recent transactions
2. Rotate to landscape mode
3. Show no pixel overflow, layout adapts
4. Rotate back to portrait

5. **Goals Tab**: Tap Goals in bottom nav
6. Show goals list
7. Rotate to landscape
8. Show responsive layout
9. Rotate back to portrait

10. **Transactions Tab**: Tap Transactions
11. Show transaction list
12. Rotate to landscape
13. Show responsive layout
14. Rotate back to portrait

15. **Profile Tab**: Tap Profile
16. Show user info, stats, notification toggle
17. Rotate to landscape
18. Show responsive layout
19. Rotate back to portrait

**Speaker 3:**
> "As you can see, every screen works perfectly in both portrait and landscape modes with no pixel overflow errors."

---

### Part 6: CRUD Operations - Create Goal (3 minutes)

**[Goals page visible, Firebase Console Firestore tab open on laptop]**

**Speaker 3:**
> "Now I'll demonstrate CRUD operations, starting with creating a savings goal. Watch the Firebase Console on the left as I create a goal."

**Actions**:
1. Tap "Add Goal" floating action button
2. Goal creation dialog appears
3. Enter goal name: `New Laptop`
4. Enter target amount: `1500`
5. Select deadline: (select a future date)
6. Tap "Save" button
7. Show loading indicator

**[Switch to Firebase Console]**

**Speaker 3:**
> "And there it is! The goal was instantly created in Firestore."

**Actions**:
8. Show Firestore → goals collection
9. Show new document with fields:
   - `userId`: (match authenticated user)
   - `name`: "New Laptop"
   - `targetAmount`: 1500.0
   - `currentAmount`: 0.0
   - `deadline`: (selected date)
   - `createdAt`: (timestamp)

**[Switch back to phone]**

**Speaker 3:**
> "And here it is on the phone, updated in real-time!"

**Actions**:
10. Show goal appears in list immediately
11. Show circular progress indicator at 0%

---

### Part 7: CRUD Operations - Read Goal (1 minute)

**[Goals page with goals list visible]**

**Speaker 3:**
> "Reading goals is straightforward. The app fetches all goals for the authenticated user from Firestore."

**Actions**:
1. Scroll through goals list
2. Show multiple goals with different progress percentages
3. Point out:
   - Goal names
   - Target amounts
   - Current amounts
   - Progress circles
   - Deadlines

**Speaker 3:**
> "Each goal displays its progress visually, making it easy for users to track their savings."

---

### Part 8: CRUD Operations - Update Goal (2 minutes)

**[Goals page with goals list]**

**Speaker 3:**
> "Next, let's update an existing goal. I'll tap on a goal to edit it."

**Actions**:
1. Tap on "New Laptop" goal card
2. Goal details or edit dialog appears
3. Change target amount from `1500` to `2000`
4. Tap "Update" or "Save"
5. Show loading indicator

**[Switch to Firebase Console]**

**Speaker 3:**
> "Let's check Firestore to confirm the update."

**Actions**:
6. Refresh Firestore view
7. Show "New Laptop" document
8. Highlight `targetAmount` field now shows `2000.0`

**[Switch back to phone]**

**Speaker 3:**
> "And it's updated on the phone immediately!"

**Actions**:
9. Show goal card now displays `$2000` target
10. Show progress percentage recalculated

---

### Part 9: CRUD Operations - Delete Goal (2 minutes)

**[Goals page with goals list]**

**Speaker 3:**
> "Finally, let's delete a goal. I'll long-press on a goal to delete it."

**Actions**:
1. Long-press on a goal (e.g., "Old Goal")
2. Confirmation dialog appears: "Are you sure you want to delete this goal?"
3. Tap "Delete"
4. Show loading indicator
5. Goal disappears from list

**[Switch to Firebase Console]**

**Speaker 3:**
> "Let's verify it's deleted in Firestore."

**Actions**:
6. Show Firestore goals collection
7. Confirm goal document no longer exists
8. Count documents (should be one fewer)

**[Switch back to phone]**

**Speaker 3:**
> "Perfect! The goal is removed from the app and the database."

---

### Part 10: State Management - Multi-Widget Update (2 minutes)

**[Dashboard page visible]**

**Speaker 4 (Benitha Iradukunda):**
> "Now I'll demonstrate our BLoC state management by showing how a single action updates multiple widgets across the app."

**Actions**:
1. Show Dashboard with:
   - Total Savings amount: e.g., `$5,250`
   - Recent transactions list: 3 items
   - Goals overview: 3 goal circles

**Speaker 4:**
> "I'll add a new transaction and watch both the Total Savings and Recent Transactions update simultaneously."

**Actions**:
2. Navigate to Transactions tab
3. Tap "Add Transaction" button
4. Enter description: `Freelance Income`
5. Enter amount: `500`
6. Select type: `Income`
7. Select category: `Work`
8. Tap "Save"

**Speaker 4:**
> "Now let's go back to the Dashboard and see the updates."

**Actions**:
9. Navigate back to Dashboard tab
10. **Highlight**: Total Savings increased from `$5,250` to `$5,750`
11. **Highlight**: Recent Transactions list now shows "Freelance Income" at the top

**Speaker 4:**
> "Notice how both widgets updated from a single state change. This is the power of BLoC state management!"

---

### Part 11: SharedPreferences - Notification Toggle (2 minutes)

**[Profile page visible]**

**Speaker 5 (Henriette Utatsineza):**
> "I'll demonstrate data persistence with SharedPreferences by toggling the notification setting."

**Actions**:
1. Show notification toggle in Profile page
2. Current state: Toggle is OFF (gray)

**Speaker 5:**
> "Let me enable notifications."

**Actions**:
3. Tap notification toggle
4. Toggle switches to ON (green)
5. Show toast/snackbar: "Notifications enabled"

**[Switch to Firebase Console]**

**Speaker 5:**
> "This setting is saved in Firestore."

**Actions**:
6. Show Firestore → users → {userId} document
7. Highlight `notificationsEnabled: true`

**[Switch back to phone]**

**Speaker 5:**
> "Now I'll restart the app to show the setting persists."

**Actions**:
8. Close app completely (swipe up from recent apps)
9. Re-launch app from home screen
10. Navigate to Profile page
11. **Highlight**: Notification toggle is still ON

**Speaker 5:**
> "Perfect! The setting was saved and restored using SharedPreferences and Firestore."

---

### Part 12: Validation & Error Handling (2 minutes)

**[Transactions page]**

**Speaker 4:**
> "Let me demonstrate our input validation and error handling. I'll try to create a transaction with invalid data."

**Actions**:
1. Tap "Add Transaction" button
2. Leave description empty
3. Enter amount: `-50` (negative)
4. Tap "Save"
5. Show validation errors:
   - "Description is required"
   - "Amount must be positive"

**Speaker 4:**
> "Now let me try with an invalid amount format."

**Actions**:
6. Enter description: `Test Transaction`
7. Enter amount: `abc` (non-numeric)
8. Tap "Save"
9. Show validation error: "Please enter a valid amount"

**Speaker 4:**
> "Finally, let's create a valid transaction."

**Actions**:
10. Fix amount: `75.50`
11. Select type: `Expense`
12. Select category: `Food`
13. Tap "Save"
14. Show success message: "Transaction added"
15. Transaction appears in list

**Speaker 4:**
> "Our app validates all user inputs and provides clear, polite error messages."

---

### Part 13: Tips Page & UI Polish (1 minute)

**[Navigate to Tips page]**

**Speaker 1:**
> "Let me show you our financial education feature - the Tips page."

**Actions**:
1. Navigate to home, then swipe/tap to open side menu or tips section
2. Show Tips page with:
   - SaveSmart logo at top
   - Weekly Financial Tip card with image
   - Savings Strategies card with image
   - Budgeting Strategies card with image
   - Student Finance Tips card with image
3. Scroll through tips smoothly

**Speaker 1:**
> "Each tip includes relevant financial advice with visual imagery to engage our target audience - young adults and university students."

---

### Part 14: Additional Features & Polish (1 minute)

**[Various screens]**

**Speaker 1:**
> "Before we conclude, let me highlight some additional features."

**Actions**:
1. **Dashboard**: Show goal progress circles with smooth animations
2. **Goals**: Show deadline countdown
3. **Profile**: Show progress statistics (Total Saved, Goals Achieved, Days Saving)
4. **App-wide**: Show consistent color scheme (light green theme)
5. **App-wide**: Show smooth page transitions
6. **App-wide**: Show loading states with progress indicators

---

### Conclusion (1 minute)

**[All team members visible or taking turns]**

**Speaker 1 (Ishimwe Levis):**
> "That concludes our demo of SaveSmart. Let me summarize what we've shown:"

**Team (taking turns):**
- ✅ "Two authentication methods: Email/Password and Google Sign-In with email verification"
- ✅ "Complete CRUD operations on savings goals with real-time Firestore sync"
- ✅ "BLoC state management updating multiple widgets simultaneously"
- ✅ "Data persistence with SharedPreferences and Firestore"
- ✅ "Comprehensive input validation with user-friendly error messages"
- ✅ "Responsive design working perfectly on all screen sizes and orientations"
- ✅ "Clean architecture following industry best practices"
- ✅ "Zero errors from flutter analyze"

**Speaker 1:**
> "SaveSmart successfully addresses the financial literacy gap among young adults by combining practical money management tools with educational content. Thank you for watching!"

**[Show app logo or final screen]**

---

## Post-Recording Checklist

- [ ] Video is 10-15 minutes long
- [ ] Video is single continuous recording (no cuts)
- [ ] All 7 required actions demonstrated:
  1. ✅ Cold-start launch
  2. ✅ Register → logout → login (both auth methods)
  3. ✅ Visit every screen + rotate once
  4. ✅ CRUD operations with Firebase Console visible
  5. ✅ State update touching two widgets
  6. ✅ SharedPreferences persistence after restart
  7. ✅ Validation error with polite message
- [ ] Every team member spoke and presented
- [ ] No team member introductions (focused on app only)
- [ ] Audio is clear (no hum/echo)
- [ ] Video is ≥1080p
- [ ] Phone and Firebase Console both legible
- [ ] Camera steady throughout

---

## Upload & Submission

1. **Export video**: Save in MP4 format (H.264 codec, 1080p)
2. **Upload to YouTube**: 
   - Set as "Unlisted"
   - Title: "SaveSmart - Financial Wellness App Demo - Group 5"
   - Description: Include GitHub repo link
3. **OR upload to Google Drive**:
   - Set sharing to "Anyone with link can view"
   - Get shareable link
4. **Add link to project report PDF**

---

## Tips for a Great Demo

### Do:
- ✅ Practice the demo 2-3 times before recording
- ✅ Speak clearly and at a moderate pace
- ✅ Use a script but sound natural
- ✅ Show enthusiasm and confidence
- ✅ Point out key features explicitly
- ✅ Transition smoothly between sections

### Don't:
- ❌ Rush through demonstrations
- ❌ Apologize for features ("Sorry, this isn't perfect...")
- ❌ Go off-script or ramble
- ❌ Have background noise or interruptions
- ❌ Use filler words excessively ("um", "uh", "like")
- ❌ Forget to show Firebase Console for CRUD operations

---

## Backup Plan

**If recording fails mid-demo**:
1. Don't panic!
2. Review the footage
3. If critical steps are missing, re-record entire demo
4. Do NOT splice/edit recordings together (must be continuous)

**If technical issues occur during demo**:
- Have a second device ready as backup
- Test everything 30 minutes before recording
- Close all unnecessary apps on phone
- Ensure stable internet connection

---

Good luck with your demo recording! 🎥🚀

**Document Version**: 1.0  
**Last Updated**: November 21, 2025  
**Author**: SaveSmart Development Team (Group 5)
