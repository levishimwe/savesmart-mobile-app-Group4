import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savesmart/core/utils/constants.dart';
import 'package:savesmart/features/auth/presentation/bloc/auth_bloc.dart';

/// Profile page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppConstants.primaryGreen,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            return ListView(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.mediumPadding),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppConstants.lightGreen,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                stream: uid == null
                                    ? null
                                    : FirebaseFirestore.instance
                                        .collection(AppConstants.usersCollection)
                                        .doc(uid)
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  final data = snapshot.data?.data();
                                  final fullName = data?['fullName'] as String? ?? (state is Authenticated ? state.user.fullName : 'User');
                                  final email = data?['email'] as String? ?? (state is Authenticated ? state.user.email : 'user@example.com');
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fullName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          color: AppConstants.textSecondary,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Total Saved from users doc
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: uid == null
                              ? null
                              : FirebaseFirestore.instance
                                  .collection(AppConstants.usersCollection)
                                  .doc(uid)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            final total = (snapshot.data?.data()?['totalSavings'] as num?)?.toDouble() ?? 0;
                            return _buildStatRow('Total Saved', '\$${total.toStringAsFixed(0)}');
                          },
                        ),
                        // Goals Achieved count
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: uid == null
                              ? null
                              : FirebaseFirestore.instance
                                  .collection(AppConstants.goalsCollection)
                                  .where('userId', isEqualTo: uid)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            final goals = snapshot.data?.docs ?? [];
                            int achieved = 0;
                            for (final g in goals) {
                              final d = g.data();
                              final current = (d['currentAmount'] as num?)?.toDouble() ?? 0;
                              final target = (d['targetAmount'] as num?)?.toDouble() ?? 0;
                              if (target > 0 && current >= target) achieved++;
                            }
                            return _buildStatRow('Goals Achieved', '$achieved');
                          },
                        ),
                        // Days Saving since account creation
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: uid == null
                              ? null
                              : FirebaseFirestore.instance
                                  .collection(AppConstants.usersCollection)
                                  .doc(uid)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            final ts = snapshot.data?.data()?['createdAt'];
                            DateTime? created;
                            if (ts is Timestamp) created = ts.toDate();
                            if (ts is DateTime) created = ts;
                            final days = created == null
                                ? 0
                                : DateTime.now().difference(created).inDays;
                            return _buildStatRow('Days Saving', '$days');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Settings
                _buildSettingsTile(
                  'Notification',
                  Icons.notifications_outlined,
                  () {},
                ),
                _buildSettingsTile(
                  'Account Setting',
                  Icons.settings_outlined,
                  () {},
                ),
                _buildSettingsTile('Transaction History', Icons.history, () {}),
                const SizedBox(height: 16),
                // Logout
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: AppConstants.errorColor,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: AppConstants.errorColor),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppConstants.errorColor,
                    ),
                    onTap: () async {
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                      
                      // Let main.dart handle navigation on Unauthenticated
                      context.read<AuthBloc>().add(SignOutEvent());
                      
                      // Wait a moment for state change to propagate
                      await Future.delayed(const Duration(milliseconds: 500));
                      
                      // Close loading dialog if still mounted
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppConstants.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryGreen),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
