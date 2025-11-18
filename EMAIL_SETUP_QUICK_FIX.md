# 🔧 Fix Email Notifications - Quick Setup Guide

## ⚠️ Current Issue

Email notifications are not working because:
1. Gmail App Password is not configured in the code
2. The placeholder `'your-app-password-here'` needs to be replaced with a real password

## 📧 Your Email Configuration

**Your Gmail:** `ishimwelevi74@gmail.com` ✅ (Detected from Firestore)

**What needs to be done:**
- Get Gmail App Password
- Update `email_service.dart` with the password
- Restart the app

---

## 🚀 Step-by-Step Setup (5 Minutes)

### Step 1: Enable 2-Step Verification on Your Gmail

1. **Open your browser** and go to:
   ```
   https://myaccount.google.com/security
   ```

2. **Sign in** with `ishimwelevi74@gmail.com`

3. **Scroll down** to find "2-Step Verification"

4. **Click "Get Started"** and follow the prompts:
   - Enter your phone number
   - Receive verification code via SMS
   - Enter the code
   - Click "Turn On"

5. ✅ **Confirm:** You should see "2-Step Verification is ON"

---

### Step 2: Generate App Password

1. **Go to App Passwords page:**
   ```
   https://myaccount.google.com/apppasswords
   ```
   
   Or:
   - Go to https://myaccount.google.com/security
   - Click "2-Step Verification"
   - Scroll down and click "App passwords"

2. **You might be asked to sign in again** - enter your password

3. **Create App Password:**
   - In the "Select app" dropdown: Choose **"Mail"**
   - In the "Select device" dropdown: Choose **"Other (Custom name)"**
   - Type: **"SaveSmart App"**
   - Click **"Generate"**

4. **Copy the 16-character password:**
   ```
   Example: abcd efgh ijkl mnop
   ```
   
   ⚠️ **Important:** Copy this password immediately! You won't be able to see it again.

---

### Step 3: Update Your Code

1. **Open the file:**
   ```bash
   nano /home/ishimwe/Documents/savesmart/lib/core/services/email_service.dart
   ```
   
   Or open it in VS Code

2. **Find line 9** (should look like this):
   ```dart
   static const String _senderPassword = 'your-app-password-here';
   ```

3. **Replace with your App Password** (remove spaces):
   ```dart
   static const String _senderPassword = 'abcdefghijklmnop';
   ```
   
   Example if your password is `abcd efgh ijkl mnop`:
   ```dart
   static const String _senderPassword = 'abcdefghijklmnop';
   ```

4. **Save the file:**
   - In nano: Press `Ctrl+X`, then `Y`, then `Enter`
   - In VS Code: Press `Ctrl+S`

---

### Step 4: Restart the App

```bash
cd /home/ishimwe/Documents/savesmart
flutter run
```

---

### Step 5: Test Email Notifications

1. **Open the app**

2. **Add a new goal:**
   - Tap "Goals" tab
   - Tap "+" button
   - Fill in:
     - Name: "Test Email"
     - Target: 1000
     - Current: 0
   - Tap "Add Goal"

3. **Check the terminal output:**
   ```
   📧 Attempting to send goal notification to: ishimwelevi74@gmail.com
   📤 Sending email with subject: Keep Saving! Your goal Awaits 💰
   ✅ Email sent successfully to ishimwelevi74@gmail.com
   ```

4. **Check your email inbox:**
   - Open Gmail on your phone or computer
   - Look for email from "SaveSmart"
   - **Check spam folder** if not in inbox

5. ✅ **Success!** You should receive the email within 1-2 minutes

---

## 🐛 Troubleshooting

### Issue 1: "Invalid credentials" Error

**Symptoms:**
```
❌ Failed to send email
❌ Error details: Invalid login: 535-5.7.8 Username and Password not accepted
```

**Solution:**
1. Make sure 2-Step Verification is **enabled**
2. Generate a **new** App Password
3. Copy it **without spaces**: `abcdefghijklmnop` (not `abcd efgh ijkl mnop`)
4. Update `email_service.dart` line 9
5. Restart the app

---

### Issue 2: No Error, But No Email Received

**Check Terminal Output:**
If you see:
```
📧 Attempting to send goal notification to: ishimwelevi74@gmail.com
📤 Sending email with subject: ...
✅ Email sent successfully
```

**Then check:**
1. **Gmail Spam folder** - Email might be there
2. **Gmail "All Mail"** - Search for "SaveSmart"
3. **Wait 2-3 minutes** - Email might be delayed

**If email is in spam:**
1. Open the email
2. Click "Not spam" button
3. Future emails will go to inbox

---

### Issue 3: Still Getting "your-app-password-here" Error

**Solution:**
```bash
# Open the file
code /home/ishimwe/Documents/savesmart/lib/core/services/email_service.dart

# Find line 9 and make sure it looks like:
static const String _senderPassword = 'abcdefghijklmnop';

# NOT like:
static const String _senderPassword = 'your-app-password-here';

# Save and restart app
flutter run
```

---

### Issue 4: "App Password" Option Not Showing

**Solution:**
1. Make sure you're signed in to **ishimwelevi74@gmail.com**
2. **Enable 2-Step Verification first** (required for App Passwords)
3. Wait 5 minutes after enabling 2-Step Verification
4. Refresh the page: https://myaccount.google.com/apppasswords
5. The option should now appear

---

## 📋 Quick Checklist

Before testing, make sure:

- [ ] ✅ 2-Step Verification is **enabled** on ishimwelevi74@gmail.com
- [ ] ✅ App Password is **generated** (16 characters)
- [ ] ✅ App Password is **copied** (without spaces)
- [ ] ✅ `email_service.dart` line 9 is **updated** with real password
- [ ] ✅ File is **saved**
- [ ] ✅ App is **restarted** (`flutter run`)
- [ ] ✅ Goal is **added** to trigger email
- [ ] ✅ Terminal shows **"✅ Email sent successfully"**
- [ ] ✅ Email is **received** (check inbox and spam)

---

## 🎯 Expected Terminal Output (After Setup)

When you add a goal, you should see:

```bash
📧 Attempting to send goal notification to: ishimwelevi74@gmail.com
📤 Sending email with subject: Keep Saving! Your goal Awaits 💰
✅ Email sent successfully to ishimwelevi74@gmail.com

Goal added successfully!
```

---

## 🔒 Security Notes

1. **Never share your App Password** with anyone
2. **Don't commit it to Git:**
   ```bash
   # Make sure .gitignore includes:
   echo "*.env" >> .gitignore
   ```

3. **For production,** use environment variables:
   ```dart
   static final String _senderPassword = 
       Platform.environment['GMAIL_APP_PASSWORD'] ?? 'fallback';
   ```

4. **Revoke App Password** if compromised:
   - Go to: https://myaccount.google.com/apppasswords
   - Find "SaveSmart App"
   - Click "Remove"
   - Generate new one

---

## 📞 Need Help?

If emails still don't work after following all steps:

1. **Check terminal output** - Share the error message
2. **Verify credentials:**
   ```bash
   # In terminal, check if email is set correctly:
   grep "_senderEmail" /home/ishimwe/Documents/savesmart/lib/core/services/email_service.dart
   
   # Should show:
   # static const String _senderEmail = 'ishimwelevi74@gmail.com';
   ```

3. **Test with simple email first** - Try sending to yourself

---

## 🎉 What to Expect After Setup

Once configured correctly:

1. **Add Goal** → Email sent within 10 seconds ✅
2. **Withdraw from Goal** → Confirmation email sent ✅
3. **Every Tuesday 19:00** → Weekly reminder email ✅ (after Cloud Functions setup)

---

## 📚 Next Steps

After email notifications work:

1. ✅ Test delete transactions feature
2. ✅ Test withdrawal fix (no double deduction)
3. 🚀 Deploy Cloud Functions for weekly reminders (see `WEEKLY_REMINDER_SETUP.md`)

---

**Last Updated:** November 18, 2025  
**Your Email:** ishimwelevi74@gmail.com  
**Status:** ⚠️ Needs App Password Configuration
