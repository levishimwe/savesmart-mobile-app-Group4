# Email Notifications Setup Guide

## 📧 Email Features Implemented

### 1. Goal Creation Notifications
When a user adds a goal, they receive an automatic email:

**If user has enough total savings for their goals:**
- Subject: "Congratulations! You've Reached Your goal(s) 🎉"
- Message: Informs user they can withdraw money for achieved goals

**If user doesn't have enough savings:**
- Subject: "Keep Saving! Your goal(s) Await 💰"
- Message: Encourages user to continue saving

### 2. Withdrawal Confirmation
When a user withdraws money from an achieved goal:
- Subject: "Withdrawal Confirmed - [Goal Name] ✅"
- Message: Confirms withdrawal amount and congratulates the user

## 🔧 Setup Instructions

### Option 1: Gmail with App Password (Development/Testing)

1. **Enable 2-Step Verification on your Gmail account:**
   - Go to: https://myaccount.google.com/security
   - Enable "2-Step Verification"

2. **Generate App Password:**
   - Go to: https://myaccount.google.com/apppasswords
   - Select "Mail" and "Other (Custom name)"
   - Name it "SaveSmart App"
   - Copy the 16-character password

3. **Update email_service.dart:**
   ```dart
   static const String _senderEmail = 'your-email@gmail.com';
   static const String _senderPassword = 'your-16-char-app-password';
   ```

### Option 2: Firebase Cloud Functions (Production - Recommended)

For production, use Firebase Cloud Functions with SendGrid or similar services:

1. **Install Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Initialize Cloud Functions:**
   ```bash
   cd /home/ishimwe/Documents/savesmart
   firebase init functions
   ```

3. **Create Cloud Function for email:**
   ```javascript
   // functions/index.js
   const functions = require('firebase-functions');
   const nodemailer = require('nodemailer');
   const sgTransport = require('nodemailer-sendgrid-transport');

   const transporter = nodemailer.createTransport(sgTransport({
     auth: {
       api_key: functions.config().sendgrid.key
     }
   }));

   exports.sendGoalEmail = functions.firestore
     .document('goals/{goalId}')
     .onCreate(async (snap, context) => {
       const goalData = snap.data();
       const userId = goalData.userId;
       
       // Get user data
       const userSnap = await admin.firestore()
         .collection('users')
         .doc(userId)
         .get();
       
       const userData = userSnap.data();
       
       // Send email
       await transporter.sendMail({
         from: 'savesmart@yourapp.com',
         to: userData.email,
         subject: 'New Goal Created!',
         html: `<p>Keep saving for ${goalData.name}!</p>`
       });
     });
   ```

4. **Deploy:**
   ```bash
   firebase deploy --only functions
   ```

### Option 3: SendGrid API (Alternative)

1. **Sign up for SendGrid:**
   - Go to: https://sendgrid.com
   - Create free account (100 emails/day)

2. **Get API Key:**
   - Go to Settings → API Keys
   - Create new API key

3. **Add sendgrid package:**
   ```yaml
   # pubspec.yaml
   dependencies:
     sendgrid_mailer: ^0.2.3
   ```

4. **Update email service to use SendGrid:**
   ```dart
   import 'package:sendgrid_mailer/sendgrid_mailer.dart';

   final mailer = Mailer(apiKey: 'YOUR_SENDGRID_API_KEY');
   await mailer.send(
     Email(
       from: 'savesmart@yourapp.com',
       to: [userEmail],
       subject: subject,
       content: [Content('text/plain', body)],
     ),
   );
   ```

## 🧪 Testing Email Notifications

### 1. Test Goal Creation Email

**Test Case 1: User with insufficient savings**
```dart
// Add a goal with target > current savings
// Expected: Email with "Keep Saving!" message
```

**Test Case 2: User with sufficient savings**
```dart
// Add a goal with target <= current savings
// Expected: Email with "Congratulations!" message
```

### 2. Test Withdrawal Email

```dart
// 1. Create a goal with currentAmount >= targetAmount
// 2. Click "Withdraw" button
// 3. Confirm withdrawal
// Expected: Email confirming withdrawal
```

### 3. Using Email Testing Services (Development)

For testing without sending real emails, use:

**Mailtrap (Recommended for testing):**
```dart
final smtpServer = SmtpServer(
  'smtp.mailtrap.io',
  port: 2525,
  username: 'your-mailtrap-username',
  password: 'your-mailtrap-password',
);
```

**Ethereal Email (Quick testing):**
- Go to: https://ethereal.email
- Get test credentials
- Use in email_service.dart

## 📋 Important Notes

### Email Delivery Considerations

1. **Gmail Limitations:**
   - Free accounts: 500 emails/day
   - G Suite: 2,000 emails/day
   - May be marked as spam initially

2. **Production Best Practices:**
   - Use dedicated email service (SendGrid, AWS SES, Mailgun)
   - Set up SPF, DKIM, DMARC records
   - Use verified sender domain
   - Monitor bounce rates

3. **Privacy & Security:**
   - Never commit email credentials to git
   - Use environment variables or Firebase config
   - Implement rate limiting
   - Add unsubscribe functionality

### Email Template Customization

All email templates are in `/lib/core/services/email_service.dart`:

- `sendGoalNotification()` - Goal creation emails
- `sendWithdrawalConfirmation()` - Withdrawal confirmation

Customize the text, add HTML formatting, or include your logo as needed.

## 🐛 Troubleshooting

### Email not sending

1. **Check credentials:**
   ```dart
   print('Testing email with: $_senderEmail');
   ```

2. **Check Gmail settings:**
   - Ensure 2FA is enabled
   - Verify app password is correct
   - Check "Less secure app access" (if not using app password)

3. **Check console logs:**
   ```dart
   catch (e) {
     print('Email error: $e'); // Check terminal output
   }
   ```

### Email marked as spam

- Add proper sender name
- Use professional email address
- Include unsubscribe link
- Send from verified domain

### Firestore permission errors

Ensure your Firestore rules allow reading user data:
```javascript
match /users/{userId} {
  allow read: if request.auth != null;
}
```

## 🚀 Next Steps

1. **Set up email credentials** (Option 1, 2, or 3 above)
2. **Test with real email** addresses
3. **Monitor email delivery** rates
4. **Add email preferences** (let users opt in/out)
5. **Create email templates** with your branding

## 📚 Additional Resources

- [Mailer package docs](https://pub.dev/packages/mailer)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
- [SendGrid documentation](https://docs.sendgrid.com)
- [Gmail App Passwords](https://support.google.com/accounts/answer/185833)
