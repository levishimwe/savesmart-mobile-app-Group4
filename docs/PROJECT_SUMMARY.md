git clone <repo-url>
# SaveSmart – Project Summary (Condensed ~150 lines)

1. Overview  
SaveSmart is a mobile-first Flutter application designed for young adults to build consistent saving habits. It combines savings goal tracking, transaction logging, financial education tips, and verified user authentication. The app emphasizes clarity, simplicity, and incremental progress.

2. Motivation  
Many students and early professionals struggle with starting and sustaining savings discipline. SaveSmart reduces friction by: (a) visualizing goal progress, (b) simplifying deposits/withdrawals, (c) educating through curated tips, and (d) reinforcing identity with verified signup.

3. Target Users  
Primary: University students / young adults (18–28). Secondary: Early-career professionals seeking lightweight financial tracking.

4. High-Level Feature Set  
- Email/Password signup + mandatory first-time email verification.  
- Google Sign-In convenience.  
- Goals CRUD (title, target, dynamic current amount update).  
- Transaction history (deposit/withdraw).  
- Savings accumulation + totals shown on profile.  
- Financial tips (Firestore driven).  
- Profile analytics: total saved, goals achieved, days saving, notifications toggle.  
- Logout with stack reset to Welcome.  

5. Platform & Tech  
- Flutter (cross-platform UI).  
- Firebase (Auth, Firestore, Core).  
- Architecture: Clean (presentation/domain/data separation).  
- State Management: BLoC (predictable event→state transitions).  
- Dependency Injection: GetIt.  

6. Data Model (Simplified)  
Users, Goals, Transactions, Tips (collections). Goals reference userId; transactions optionally reference goalId; aggregated stats computed client-side streams.

7. Authentication Flow  
Signup creates user document, sends verification email, gates UI until verified. Login bypasses verification if already completed. Google Sign-In uses Firebase credential exchange; People API must be enabled for web. Logout clears session and navigates to Welcome.

8. Email Verification Rationale  
Ensures genuine contact, prevents throwaway accounts, enables future notification features (goal milestone emails). Implemented using FirebaseAuth's verification API.

9. Savings & Goal Logic  
Each transaction updates aggregated totals. Goal achievement threshold: currentAmount >= targetAmount. Profile shows real-time counts and derived metrics (days since creation).

10. Tips Module  
Provides financial literacy snippets (budgeting, student finance, savings strategies). Lightweight cards with asset images and Firestore-backed content allow easy future expansion.

11. State & Reactivity  
Firestore snapshots power real-time updates for progress, totals, and UI statistics. Auth states include Authenticated, Unauthenticated, Loading, EmailVerificationPending, AuthError.

12. Validation  
Client-side checks: email format, password length, non-negative amounts, matching confirm password, withdrawal boundary (not exceeding current saving). Errors surfaced via SnackBars.

13. Testing Strategy  
Unit tests: validators, entities logic. Widget tests: button behavior, loading states. Manual test matrix covers signup, verification, login, Google sign-in, CRUD operations, rotation, error paths. Target coverage ≥50% (achieved).

14. Security Considerations  
Access restricted to authenticated users' own documents via Firestore rules (conceptually: match /users/{uid} where request.auth.uid == uid; similarly filter goals/transactions by userId). Sensitive operations avoid unauthenticated writes.

15. Performance  
Lean queries filtered by userId. Limited payload sizes. Real-time streams instead of polling. Potential future optimization: transaction pagination & caching.

16. UX Principles  
Consistent palette; clear typography; card grouping; minimal friction for common actions; explicit verification guidance; polite errors.

17. Team Contributions (Attendance 9,13,22 Nov 2025)  
- Levis: Core setup, Firebase integration, Google Auth, savings & withdrawal logic, goal utilities, debugging, final docs.  
- Josephine: UI design & build (core screens, styling).  
- Singa Ewing: Auth backend (Login, Register, Logout flows).  
- Henriette: Savings logic, initial summary draft, documentation support.  

18. AI Assistance  
~35–40% scaffolding & wording aided by Copilot + ChatGPT (reviews, refactors). Critical logic and architecture human-driven.

19. Risks & Mitigations  
- Google sign-in misconfiguration → Added People API guidance.  
- Email delays → Resend + user messaging.  
- Data growth → Plan for pagination.  

20. Future Enhancements  
Push notifications (goal milestones), budgeting categories, transaction export (CSV), dark mode, localization, advanced analytics (monthly trends graph).

21. Educational Impact  
Promotes financial awareness; integrates learning (tips) with actionable saving; fosters self-efficacy via progress metrics.

22. Ethical & Privacy Notes  
No external bank data; only user-declared amounts. Email addresses used strictly for auth and potential notifications.

23. Deployment Considerations  
Current build suitable for classroom/demo. Production needs: stronger validation, monitoring, analytics, privacy policy.

24. Conclusion  
SaveSmart delivers a cohesive, testable foundation for a youth-focused savings assistant. Balanced practicality (transactions, goals) + motivation (visual progress) + education (tips). Ready for evaluation and iteration.
