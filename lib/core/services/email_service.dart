import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Service to send email notifications to users
class EmailService {
  // TODO: Replace with your SMTP credentials
  // For production, use environment variables or Firebase Functions
  static const String _senderEmail = 'i.levis@alustudent.com';
  static const String _senderPassword = 'uaoxwmqmjbldbrru'; // Get this from Google
  static const String _appName = 'SaveSmart';

  /// Send email notification when a goal is added
  /// 
  /// If user has enough savings for all goals, sends "goals achieved" message
  /// Otherwise, sends "continue saving" message
  Future<void> sendGoalNotification({
    required String userEmail,
    required String userName,
    required List<String> goalNames,
    required bool hasEnoughSavings,
  }) async {
    try {
      debugPrint('📧 Attempting to send goal notification to: $userEmail');
      
      // Configure SMTP server (Gmail example)
      // For production, use SendGrid, AWS SES, or Firebase Functions
      final smtpServer = gmail(_senderEmail, _senderPassword);

      final goalsText = goalNames.length == 1 ? 'goal' : 'goals';
      final goalsList = goalNames.map((g) => '• $g').join('\n');

      String subject;
      String body;

      if (hasEnoughSavings) {
        subject = 'Congratulations! You\'ve Reached Your $goalsText 🎉';
        body = '''
Hello $userName,

Great news! You have enough savings to achieve your $goalsText:

$goalsList

You can now withdraw the money for your achieved $goalsText. Keep up the great saving habits!

Best regards,
The $_appName Team
''';
      } else {
        subject = 'Keep Saving! Your $goalsText Await 💰';
        body = '''
Hello $userName,

Thank you for setting your savings $goalsText:

$goalsList

You're on the right track! Continue to save until you reach your $goalsText. Every deposit brings you closer to your dreams.

Best regards,
The $_appName Team
''';
      }

      final message = Message()
        ..from = Address(_senderEmail, _appName)
        ..recipients.add(userEmail)
        ..subject = subject
        ..text = body;

      debugPrint('📤 Sending email with subject: $subject');
      await send(message, smtpServer);
      debugPrint('✅ Email sent successfully to $userEmail');
    } catch (e) {
      debugPrint('❌ Failed to send email to $userEmail');
      debugPrint('❌ Error details: $e');
      // Don't throw error - email failure shouldn't block goal creation
    }
  }

  /// Send withdrawal confirmation email
  Future<void> sendWithdrawalConfirmation({
    required String userEmail,
    required String userName,
    required String goalName,
    required double amount,
  }) async {
    try {
      final smtpServer = gmail(_senderEmail, _senderPassword);

      final message = Message()
        ..from = Address(_senderEmail, _appName)
        ..recipients.add(userEmail)
        ..subject = 'Withdrawal Confirmed - $goalName ✅'
        ..text = '''
Hello $userName,

Your withdrawal has been confirmed!

Goal: $goalName
Amount: \$${amount.toStringAsFixed(2)}

Congratulations on achieving your goal! We're proud of your saving discipline.

Best regards,
The $_appName Team
''';

      await send(message, smtpServer);
      debugPrint('✅ Withdrawal confirmation sent to $userEmail');
    } catch (e) {
      debugPrint('❌ Failed to send withdrawal email: $e');
    }
  }

  /// Send weekly reminder email to save for goals
  /// This should be called every Tuesday at 19:00 PM
  Future<void> sendWeeklyReminder({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final smtpServer = gmail(_senderEmail, _senderPassword);

      final message = Message()
        ..from = Address(_senderEmail, _appName)
        ..recipients.add(userEmail)
        ..subject = 'Weekly Reminder: Save for Your Goals! 💰'
        ..text = '''
Hello $userName,

This is your weekly reminder to save for your goals!

Remember:
• Every small deposit brings you closer to your dreams
• Consistent saving builds strong financial habits
• Your future self will thank you

Log in to $_appName to:
• Check your progress
• Add a new deposit
• Review your goals

Keep up the great work!

Best regards,
The $_appName Team
''';

      await send(message, smtpServer);
      debugPrint('✅ Weekly reminder sent to $userEmail');
    } catch (e) {
      debugPrint('❌ Failed to send weekly reminder: $e');
    }
  }
}
