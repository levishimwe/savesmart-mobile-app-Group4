const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

// Configure your email transport
// Option 1: Gmail with App Password
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'ishimwelevi74@gmail.com', // Your Gmail address
    pass: 'your-app-password-here'    // Replace with your app password from Google
  }
});

// Option 2: SendGrid (Recommended for production)
// const sgTransport = require('nodemailer-sendgrid-transport');
// const transporter = nodemailer.createTransport(sgTransport({
//   auth: {
//     api_key: functions.config().sendgrid.key
//   }
// }));

/**
 * Scheduled function that runs every Tuesday at 19:00 UTC
 * Sends reminder emails to all users to save for their goals
 * 
 * Cron schedule format: 'minute hour day-of-month month day-of-week'
 * '0 19 * * 2' = Every Tuesday at 19:00
 * 
 * Note: Firebase uses UTC timezone. Adjust for your local timezone:
 * - For UTC+2 (Rwanda): Use '0 17 * * 2' (17:00 UTC = 19:00 UTC+2)
 * - For UTC-5 (EST): Use '0 0 * * 3' (00:00 UTC Wednesday = 19:00 Tuesday EST)
 */
exports.sendWeeklyReminders = functions.pubsub
  .schedule('0 17 * * 2') // Every Tuesday at 17:00 UTC (19:00 UTC+2)
  .timeZone('UTC')
  .onRun(async (context) => {
    try {
      console.log('Starting weekly reminder email job...');

      // Get all users from Firestore
      const usersSnapshot = await admin.firestore()
        .collection('users')
        .get();

      if (usersSnapshot.empty) {
        console.log('No users found');
        return null;
      }

      const emailPromises = [];

      // Send email to each user
      for (const userDoc of usersSnapshot.docs) {
        const userData = userDoc.data();
        const userEmail = userData.email;
        const userName = userData.name || 'User';

        if (!userEmail) {
          console.log(`Skipping user ${userDoc.id} - no email`);
          continue;
        }

        // Check if user has any active goals
        const goalsSnapshot = await admin.firestore()
          .collection('goals')
          .where('userId', '==', userDoc.id)
          .where('withdrawn', '==', false)
          .get();

        // Only send reminder if user has active goals
        if (goalsSnapshot.empty) {
          console.log(`Skipping user ${userEmail} - no active goals`);
          continue;
        }

        const goalsList = goalsSnapshot.docs.map(doc => {
          const goalData = doc.data();
          return `• ${goalData.name} - $${goalData.targetAmount}`;
        }).join('\n');

        const mailOptions = {
          from: 'SaveSmart <savesmart.app@gmail.com>',
          to: userEmail,
          subject: 'Weekly Reminder: Save for Your Goals! 💰',
          text: `
Hello ${userName},

This is your weekly reminder to save for your goals!

Your Active Goals:
${goalsList}

Remember:
• Every small deposit brings you closer to your dreams
• Consistent saving builds strong financial habits
• Your future self will thank you

Log in to SaveSmart to:
• Check your progress
• Add a new deposit
• Review your goals

Keep up the great work!

Best regards,
The SaveSmart Team
          `.trim(),
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #4CAF50;">Weekly Reminder: Save for Your Goals! 💰</h2>
              
              <p>Hello ${userName},</p>
              
              <p>This is your weekly reminder to save for your goals!</p>
              
              <h3>Your Active Goals:</h3>
              <ul style="list-style: none; padding: 0;">
                ${goalsSnapshot.docs.map(doc => {
                  const goalData = doc.data();
                  return `<li style="padding: 8px; background: #f5f5f5; margin: 4px 0; border-radius: 4px;">
                    📌 ${goalData.name} - <strong>$${goalData.targetAmount}</strong>
                  </li>`;
                }).join('')}
              </ul>
              
              <div style="background: #e8f5e9; padding: 16px; border-radius: 8px; margin: 20px 0;">
                <p style="margin: 8px 0;"><strong>Remember:</strong></p>
                <ul>
                  <li>Every small deposit brings you closer to your dreams</li>
                  <li>Consistent saving builds strong financial habits</li>
                  <li>Your future self will thank you</li>
                </ul>
              </div>
              
              <p><strong>Log in to SaveSmart to:</strong></p>
              <ul>
                <li>Check your progress</li>
                <li>Add a new deposit</li>
                <li>Review your goals</li>
              </ul>
              
              <p>Keep up the great work!</p>
              
              <p style="color: #666; font-size: 12px; margin-top: 30px;">
                Best regards,<br>
                The SaveSmart Team
              </p>
            </div>
          `
        };

        const emailPromise = transporter.sendMail(mailOptions)
          .then(() => {
            console.log(`✅ Reminder sent to ${userEmail}`);
          })
          .catch(error => {
            console.error(`❌ Failed to send to ${userEmail}:`, error);
          });

        emailPromises.push(emailPromise);
      }

      // Wait for all emails to be sent
      await Promise.all(emailPromises);

      console.log(`Weekly reminder job completed. Sent ${emailPromises.length} emails.`);
      return null;

    } catch (error) {
      console.error('Error in weekly reminder job:', error);
      return null;
    }
  });

/**
 * Optional: HTTP endpoint to manually trigger weekly reminders (for testing)
 * Call: POST https://YOUR-PROJECT.cloudfunctions.net/sendWeeklyRemindersManual
 */
exports.sendWeeklyRemindersManual = functions.https.onRequest(async (req, res) => {
  try {
    // Only allow POST requests
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    console.log('Manual trigger: Starting weekly reminder email job...');

    const usersSnapshot = await admin.firestore()
      .collection('users')
      .get();

    if (usersSnapshot.empty) {
      res.json({ success: true, message: 'No users found' });
      return;
    }

    let sentCount = 0;
    let skippedCount = 0;

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const userEmail = userData.email;
      const userName = userData.name || 'User';

      if (!userEmail) {
        skippedCount++;
        continue;
      }

      const goalsSnapshot = await admin.firestore()
        .collection('goals')
        .where('userId', '==', userDoc.id)
        .where('withdrawn', '==', false)
        .get();

      if (goalsSnapshot.empty) {
        skippedCount++;
        continue;
      }

      const goalsList = goalsSnapshot.docs.map(doc => {
        const goalData = doc.data();
        return `• ${goalData.name} - $${goalData.targetAmount}`;
      }).join('\n');

      const mailOptions = {
        from: 'SaveSmart <savesmart.app@gmail.com>',
        to: userEmail,
        subject: 'Weekly Reminder: Save for Your Goals! 💰',
        text: `
Hello ${userName},

This is your weekly reminder to save for your goals!

Your Active Goals:
${goalsList}

Keep up the great work!

Best regards,
The SaveSmart Team
        `.trim()
      };

      await transporter.sendMail(mailOptions);
      sentCount++;
    }

    res.json({ 
      success: true, 
      message: `Sent ${sentCount} emails, skipped ${skippedCount} users` 
    });

  } catch (error) {
    console.error('Error in manual reminder trigger:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});
