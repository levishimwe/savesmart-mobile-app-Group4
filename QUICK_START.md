# SaveSmart - Quick Start Guide

## 🎯 What's New

### 1. Dynamic Goals on Dashboard ✅
Your dashboard now shows **your actual goals** from Firestore, not static placeholders!
- Top 3 most recent goals displayed
- Circular progress indicators show completion %
- Automatically updates when you add/modify goals

### 2. Email Notifications 📧
Receive automatic emails when you add goals:
- **Not enough savings:** "Keep Saving!" encouragement email
- **Enough savings:** "Congratulations!" achievement email

### 3. Withdraw Money 💰
Withdraw money from achieved goals:
- **Withdraw button** appears only when goal is 100%+ completed
- **Validation:** Can't withdraw if goal not achieved
- **Updates:** Total savings decreases automatically
- **Confirmation email** sent after withdrawal

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Configure Email (Required for email notifications)

Open `/lib/core/services/email_service.dart` and update:

```dart
static const String _senderEmail = 'YOUR-EMAIL@gmail.com';
static const String _senderPassword = 'YOUR-APP-PASSWORD-HERE';
```

**How to get Gmail App Password:**
1. Go to: https://myaccount.google.com/security
2. Enable "2-Step Verification"
3. Go to: https://myaccount.google.com/apppasswords
4. Create app password for "Mail"
5. Copy the 16-character password

**⚠️ Important:** For production, use SendGrid or Firebase Functions (see EMAIL_NOTIFICATIONS_SETUP.md)

### Step 2: Test the App

```bash
cd /home/ishimwe/Documents/savesmart
flutter run
```

---

## 🧪 Testing the New Features

### Test 1: Dynamic Goals on Dashboard

1. ✅ **Run the app**
2. ✅ **Go to Goals page** (tap "Goals" in bottom nav)
3. ✅ **Add a goal:**
   - Name: "New Laptop"
   - Target: $800
   - Current: $200
4. ✅ **Go back to Dashboard** (tap "Home")
5. ✅ **Verify:** Goal appears in circular display at top

**Expected Result:** Dashboard shows "New Laptop $800" with progress circle

---

### Test 2: Email Notifications

#### Test 2A: "Keep Saving" Email (User needs more money)

1. ✅ **Make sure your email is configured** in email_service.dart
2. ✅ **Check your user email in Firebase Console:**
   - Go to Firestore → users → [your-uid] → email field
3. ✅ **Add a goal** with high target (e.g., $5000)
4. ✅ **Check your email inbox**

**Expected Email:**
```
Subject: Keep Saving! Your goal Awaits 💰
Body: Continue to save until you reach your goal...
```

#### Test 2B: "Congratulations" Email (User has enough money)

1. ✅ **Add deposits** to increase your total savings
2. ✅ **Make sure:** Total Savings > Sum of all goal targets
3. ✅ **Add another goal**
4. ✅ **Check your email**

**Expected Email:**
```
Subject: Congratulations! You've Reached Your goals 🎉
Body: You can now withdraw the money for your achieved goals...
```

---

### Test 3: Withdraw Money

#### Test 3A: Achieved Goal (Should Work)

1. ✅ **Create a goal** where current >= target:
   - Name: "Test Goal"
   - Target: $100
   - Current: $100
   - Check "Allocate from Total Savings"
2. ✅ **Goal card should show:**
   - Green "Achieved" badge
   - Green "Withdraw" button
3. ✅ **Click "Withdraw"**
4. ✅ **Click "Confirm Withdrawal"**

**Expected Results:**
- ✅ Success message: "Successfully withdrew $100..."
- ✅ Total Savings decreases by $100
- ✅ Transaction appears in Transactions page: "Withdrawal from Test Goal"
- ✅ Confirmation email received

#### Test 3B: Unachieved Goal (Should Fail)

1. ✅ **Create a goal** where current < target:
   - Name: "Incomplete Goal"
   - Target: $500
   - Current: $200
2. ✅ **Verify:** No "Withdraw" button shown (goal not achieved)
3. ✅ **If you manually trigger withdrawal** (shouldn't be possible via UI):

**Expected Result:**
- ❌ Error message: "You can't withdraw the money because you didn't achieve your goal"

---

## 📊 Feature Overview

### Dashboard Changes

| Before | After |
|--------|-------|
| Static goals: "New Laptop $800" | Your actual goals from Firestore |
| No progress tracking | Circular progress indicators |
| Same for all users | Personalized to your goals |

### Goals Page Changes

| Feature | Description |
|---------|-------------|
| **Green Badge** | Shows "Achieved" on 100%+ goals |
| **Withdraw Button** | Appears only on achieved goals |
| **Email Notification** | Sent when goal is created |
| **Validation** | Prevents withdrawal of unachieved goals |

### Transactions Page Changes

| New Transaction Type | When Created |
|---------------------|--------------|
| **withdrawal** | When user withdraws from achieved goal |
| Description | "Withdrawal from [Goal Name]" |
| Amount | Full current amount of goal |

---

## 🔧 Troubleshooting

### Dashboard shows "No goals yet"
- **Solution:** Add a goal from Goals page → tap + button

### Email not received
1. **Check email_service.dart** - Are credentials correct?
2. **Check spam folder**
3. **Check Firebase Console** - Is email field populated in users collection?
4. **Check terminal** - Look for "✅ Email sent" or "❌ Failed to send email"

### Withdraw button not showing
- **Solution:** Make sure `currentAmount >= targetAmount`
- Example: Current: $100, Target: $100 ✅ (shows button)
- Example: Current: $99, Target: $100 ❌ (no button)

### "Can't withdraw" error
- **Reason:** Goal not achieved (current < target)
- **Solution:** Add more deposits to reach target amount first

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `lib/features/home/presentation/pages/dashboard_page.dart` | Dashboard with dynamic goals |
| `lib/features/goals/presentation/pages/goals_page.dart` | Goals page with withdraw feature |
| `lib/core/services/email_service.dart` | Email notification service |
| `docs/EMAIL_NOTIFICATIONS_SETUP.md` | Detailed email setup guide |
| `docs/NEW_FEATURES_IMPLEMENTATION.md` | Technical documentation |

---

## 🎓 Usage Scenarios

### Scenario 1: Student Saving for Laptop

```
Day 1: Add goal "Laptop" - Target: $800, Current: $0
       → Receive "Keep Saving" email

Day 2: Add deposit +$200 (Total Savings: $200)

Day 3: Add deposit +$300 (Total Savings: $500)

Day 4: Add deposit +$300 (Total Savings: $800)
       → Update goal current amount to $800
       → "Withdraw" button appears

Day 5: Click withdraw
       → Confirm
       → Receive $800
       → Get confirmation email
       → Total Savings: $0
```

### Scenario 2: Emergency Fund

```
Step 1: Build savings first
        → Add multiple deposits over time
        → Total Savings: $2000

Step 2: Add goal "Emergency Fund" - Target: $1000, Current: $0
        → Receive "Congratulations" email (have enough savings)

Step 3: Allocate savings to goal
        → Check "Allocate from Total Savings"
        → Set Current: $1000
        → Total Savings: $1000 (decreased by $1000)
        → Goal immediately shows 100%

Step 4: Withdraw when needed
        → Click "Withdraw"
        → Confirm
        → Money available
```

---

## 🚀 What to Do Next

1. **✅ Set up email credentials** (Step 1 above)
2. **✅ Test all three features** (Tests 1, 2, 3 above)
3. **✅ Verify real-time updates** work across all pages
4. **📖 Read detailed docs** in `/docs` folder for production setup

---

## 📞 Support

If you encounter issues:
1. Check `flutter analyze` output for errors
2. Look at terminal logs for error messages
3. Review Firestore rules in Firebase Console
4. Check email configuration in email_service.dart

---

**Version:** 1.0.0  
**Last Updated:** November 18, 2025  
**Status:** ✅ All features implemented and tested
