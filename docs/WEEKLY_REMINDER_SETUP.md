# Weekly Reminder Email Setup Guide

## 🕒 Feature: Every Tuesday at 19:00 PM, Send "Remember to Save for Your Goals" Email

This feature uses **Firebase Cloud Functions** with a scheduled trigger to automatically send reminder emails to all users every Tuesday at 19:00 PM.

---

## 📋 What Was Implemented

### 1. Cloud Function (`functions/index.js`)

Two functions were created:

#### **`sendWeeklyReminders`** - Automatic Scheduled Function
- **Runs:** Every Tuesday at 19:00 PM (your local time)
- **What it does:**
  1. Fetches all users from Firestore
  2. Checks each user's active goals (not withdrawn)
  3. Sends personalized reminder email with their goal list
  4. Logs success/failure for each email

#### **`sendWeeklyRemindersManual`** - Manual Trigger (for testing)
- **Trigger:** HTTP POST request
- **Use:** Test the email functionality without waiting for Tuesday
- **Endpoint:** `https://YOUR-PROJECT.cloudfunctions.net/sendWeeklyRemindersManual`

### 2. Email Content

**Subject:** "Weekly Reminder: Save for Your Goals! 💰"

**Content:**
```
Hello [User Name],

This is your weekly reminder to save for your goals!

Your Active Goals:
• New Laptop - $800
• Emergency Fund - $1000

Remember:
• Every small deposit brings you closer to your dreams
• Consistent saving builds strong financial habits
• Your future self will thank you

Log in to SaveSmart to check your progress!
```

### 3. Smart Filtering

The function only sends emails to users who:
- ✅ Have an email address in their profile
- ✅ Have at least one active goal (not withdrawn)

Users without goals are **skipped** to avoid unnecessary emails.

---

## 🚀 Setup Instructions

### Step 1: Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login
```

### Step 2: Initialize Firebase Functions (if not already done)

```bash
cd /home/ishimwe/Documents/savesmart

# Initialize Firebase (select Functions)
firebase init functions

# When prompted:
# - Select your Firebase project
# - Choose JavaScript
# - Do you want to install dependencies? Yes
```

### Step 3: Configure Email Credentials

Edit `/home/ishimwe/Documents/savesmart/functions/index.js` (lines 9-13):

```javascript
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'your-email@gmail.com',      // ← Your Gmail
    pass: 'your-app-password-here'      // ← Your Gmail App Password
  }
});
```

**How to get Gmail App Password:**
1. Go to: https://myaccount.google.com/security
2. Enable "2-Step Verification"
3. Go to: https://myaccount.google.com/apppasswords
4. Create password for "Mail"
5. Copy the 16-character code

### Step 4: Adjust Timezone (Important!)

The default schedule is **17:00 UTC** which equals **19:00 UTC+2** (Rwanda time).

If you're in a different timezone, edit line 34 in `functions/index.js`:

```javascript
// For Rwanda (UTC+2): Use '0 17 * * 2'
// For EST (UTC-5):    Use '0 0 * * 3' (midnight Wed = 7pm Tue)
// For PST (UTC-8):    Use '0 3 * * 3' (3am Wed = 7pm Tue)
// For UTC:            Use '0 19 * * 2' (7pm Tue UTC)

.schedule('0 17 * * 2') // ← Change this line
```

**Cron format:** `'minute hour day-of-month month day-of-week'`
- `0` = minute 0
- `17` = hour 17 (5 PM UTC)
- `*` = every day of month
- `*` = every month
- `2` = Tuesday (0=Sunday, 1=Monday, 2=Tuesday, etc.)

### Step 5: Install Dependencies

```bash
cd /home/ishimwe/Documents/savesmart/functions
npm install
```

### Step 6: Deploy to Firebase

```bash
# Deploy only functions
firebase deploy --only functions

# Or deploy everything (functions + firestore rules + indexes)
firebase deploy
```

**Expected output:**
```
✔  Deploy complete!

Function URL (sendWeeklyRemindersManual):
https://us-central1-YOUR-PROJECT.cloudfunctions.net/sendWeeklyRemindersManual
```

---

## 🧪 Testing the Weekly Reminder

### Option 1: Manual Trigger (Recommended for Testing)

```bash
# Test immediately without waiting for Tuesday
curl -X POST https://YOUR-PROJECT.cloudfunctions.net/sendWeeklyRemindersManual
```

**Expected response:**
```json
{
  "success": true,
  "message": "Sent 5 emails, skipped 2 users"
}
```

### Option 2: Check Firebase Logs

```bash
firebase functions:log

# Or view in Firebase Console:
# https://console.firebase.google.com/project/YOUR-PROJECT/functions/logs
```

### Option 3: Wait for Tuesday 19:00 PM

The function will automatically run every Tuesday at 19:00 PM your local time (if timezone configured correctly).

---

## 📊 Monitoring & Debugging

### View Function Logs

**Firebase Console:**
1. Go to: https://console.firebase.google.com
2. Select your project
3. Go to: Functions → Logs
4. Look for `sendWeeklyReminders` executions

**Terminal:**
```bash
firebase functions:log --only sendWeeklyReminders
```

### Common Log Messages

```
✅ "Weekly reminder sent to user@example.com"
   - Email sent successfully

❌ "Failed to send to user@example.com: Error..."
   - Email failed (check credentials)

ℹ️  "Skipping user@example.com - no active goals"
   - User has no goals, email skipped

ℹ️  "Skipping user xyz - no email"
   - User has no email in profile
```

### Test Email Delivery

1. **Create a test user** in your app
2. **Add a goal** for that user
3. **Trigger manual function:**
   ```bash
   curl -X POST https://YOUR-PROJECT.cloudfunctions.net/sendWeeklyRemindersManual
   ```
4. **Check email inbox** (including spam folder)

---

## 💰 Cost Considerations

### Firebase Cloud Functions Pricing

**Free Tier (Spark Plan):**
- 2 million invocations/month
- 400,000 GB-seconds compute time
- 200,000 CPU-seconds
- 5 GB network egress

**Your Usage:**
- Weekly reminder = 4 executions/month
- 100 users = 400 emails/month
- **Well within free tier** ✅

**Paid Tier (Blaze Plan):**
- Only needed if you exceed free tier
- ~$0.40 per million invocations after free tier

### Email Sending Limits

**Gmail:**
- Free: 500 emails/day
- G Suite: 2,000 emails/day

**SendGrid (Alternative):**
- Free: 100 emails/day
- Paid: Starting at $14.95/month for 40,000 emails

---

## 🔧 Troubleshooting

### Function Not Deploying

**Error:** "Permission denied"
```bash
# Make sure you're logged in
firebase login

# Check which project you're using
firebase use

# If wrong project:
firebase use YOUR-PROJECT-ID
```

### Function Not Running on Schedule

**Check deployment:**
```bash
firebase functions:list

# Should show:
# sendWeeklyReminders (scheduled: 0 17 * * 2)
```

**Check timezone:**
- Firebase uses UTC by default
- Make sure you adjusted for your local timezone in the schedule

### Emails Not Sending

**1. Check email credentials:**
```javascript
// In functions/index.js
console.log('Email config:', {
  user: 'savesmart.app@gmail.com',
  // Don't log password!
});
```

**2. Check Gmail settings:**
- 2FA enabled?
- App password created?
- "Less secure apps" disabled (use app password instead)

**3. Check user data:**
```bash
# Make sure users have email field
firebase firestore:get users/USER_ID
```

**4. Check spam folder:**
- Emails might be marked as spam initially
- Ask users to mark as "Not Spam"

### Function Timeout

**Default timeout:** 60 seconds

**If sending to many users (1000+), increase timeout:**
```javascript
exports.sendWeeklyReminders = functions
  .runWith({ timeoutSeconds: 300 }) // 5 minutes
  .pubsub.schedule('0 17 * * 2')
  // ... rest of code
```

---

## 🎨 Customization

### Change Email Schedule

**Daily at 9 AM:**
```javascript
.schedule('0 9 * * *') // Every day at 9 AM
```

**Every Monday and Friday at 18:00:**
```javascript
.schedule('0 18 * * 1,5') // Mon & Fri at 6 PM
```

**First day of every month at 10 AM:**
```javascript
.schedule('0 10 1 * *') // 1st of month at 10 AM
```

### Change Email Content

Edit the `mailOptions` object in `functions/index.js`:

```javascript
const mailOptions = {
  from: 'SaveSmart <your-email@gmail.com>',
  to: userEmail,
  subject: 'Your Custom Subject Here',
  text: `Your custom plain text email`,
  html: `<h1>Your custom HTML email</h1>`
};
```

### Add More Conditions

**Only send if user hasn't logged in for 7 days:**
```javascript
const lastLogin = userData.lastLoginAt?.toDate();
const daysSinceLogin = (Date.now() - lastLogin) / (1000 * 60 * 60 * 24);

if (daysSinceLogin < 7) {
  console.log(`Skipping ${userEmail} - logged in recently`);
  continue;
}
```

**Only send if user has goals below 50% progress:**
```javascript
const hasLowProgressGoals = goalsSnapshot.docs.some(doc => {
  const data = doc.data();
  const progress = data.currentAmount / data.targetAmount;
  return progress < 0.5;
});

if (!hasLowProgressGoals) {
  console.log(`Skipping ${userEmail} - all goals on track`);
  continue;
}
```

---

## 📚 Additional Resources

- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Scheduled Functions](https://firebase.google.com/docs/functions/schedule-functions)
- [Cron Expression Generator](https://crontab.guru/)
- [Nodemailer Docs](https://nodemailer.com/)
- [SendGrid Alternative Setup](https://sendgrid.com/docs/for-developers/sending-email/node-js/)

---

## 🔐 Security Best Practices

1. **Never commit email passwords to Git:**
   ```bash
   # Add to .gitignore
   echo "functions/.env" >> .gitignore
   ```

2. **Use Firebase Config for production:**
   ```bash
   firebase functions:config:set sendgrid.key="YOUR_SENDGRID_API_KEY"
   firebase functions:config:set gmail.password="YOUR_APP_PASSWORD"
   ```

3. **Add rate limiting:**
   ```javascript
   // In functions/index.js
   const rateLimit = require('express-rate-limit');
   
   const limiter = rateLimit({
     windowMs: 60 * 60 * 1000, // 1 hour
     max: 1 // 1 manual trigger per hour
   });
   ```

4. **Require authentication for manual trigger:**
   ```javascript
   exports.sendWeeklyRemindersManual = functions.https.onRequest(async (req, res) => {
     // Check authorization header
     const authToken = req.headers.authorization;
     if (authToken !== 'your-secret-token') {
       res.status(401).send('Unauthorized');
       return;
     }
     // ... rest of code
   });
   ```

---

## ✅ Checklist

- [ ] Firebase CLI installed and logged in
- [ ] Functions initialized in project
- [ ] Email credentials configured in `functions/index.js`
- [ ] Timezone adjusted for local time (line 34)
- [ ] Dependencies installed (`npm install` in functions folder)
- [ ] Functions deployed (`firebase deploy --only functions`)
- [ ] Manual trigger tested successfully
- [ ] Test user received email
- [ ] Email not in spam folder
- [ ] Logs showing successful execution
- [ ] Schedule verified (will run next Tuesday at 19:00)

---

**Last Updated:** November 18, 2025  
**Status:** ✅ Ready to deploy  
**Next Step:** Run `firebase deploy --only functions`
