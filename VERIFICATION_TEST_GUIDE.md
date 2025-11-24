# Email Verification Testing Guide

## What I Fixed

1. **Main.dart** - Added handling for `EmailVerificationPending` state
2. **Register Page** - Added navigation to EmailVerificationPage when signup succeeds
3. **Login Page** - Added navigation to EmailVerificationPage for unverified users
4. **Auth Bloc** - Already had proper handlers for verification events

## How to Test Email Verification

### 1. Sign Up a New User
```bash
# Run the app
flutter run
```

1. Click "Sign Up" / "Create Account"
2. Fill in the form with a REAL email you can access
3. Click "Sign Up"
4. **Expected:** You should immediately see the Email Verification Page (not stuck on loading!)

### 2. Check Your Email
1. Open your email inbox (check spam folder too!)
2. Look for email from Firebase (noreply@<your-project>.firebaseapp.com)
3. Click the verification link
4. **Expected:** Browser opens and shows "Your email has been verified"

### 3. Return to App
1. Go back to the SaveSmart app
2. You should see the Email Verification Page
3. Click "I've Verified" button
4. **Expected:** App should now let you into the home page

### 4. Test Resend Email
1. If you didn't get the email, click "Resend verification email"
2. Check your inbox again
3. **Expected:** New verification email arrives

## Troubleshooting

### Issue: Still stuck on loading after signup
**Fix:** Hot restart the app (press 'R' in terminal or restart from IDE)

### Issue: Not receiving verification emails
**Possible causes:**
1. Check spam/junk folder
2. Verify Firebase Authentication is enabled (Firebase Console > Authentication)
3. Check email template is configured (Firebase Console > Authentication > Templates > Email address verification)
4. Try with different email provider (Gmail, Outlook, etc.)

### Issue: "I've Verified" button doesn't work
**Fix:** Make sure you actually clicked the link in the email first. The button checks if Firebase has marked your email as verified.

## Testing Login with Unverified Email

1. Sign up a new user but DON'T verify the email
2. Close the app completely
3. Reopen and try to log in with that email
4. **Expected:** After login, you should be redirected to Email Verification Page (not home page)

## Firebase Console Verification

Check in Firebase Console:
1. Go to Authentication > Users
2. Find your test user
3. Look at "Email verified" column
4. After clicking verification link, this should show checkmark ✓

## What Happens Now

- **Signup:** User → Loading → Email Verification Page
- **Login (unverified):** User → Loading → Email Verification Page
- **Login (verified):** User → Loading → Home Page
- **Logout:** Any page → Welcome Page (clears navigation stack)

