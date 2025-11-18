import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savesmart/core/utils/constants.dart';

/// Dashboard page showing overview
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppConstants.primaryGreen,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'SaveSmart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Total Savings',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(AppConstants.usersCollection)
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final total = (snapshot.data?.data()?['totalSavings'] as num?)?.toDouble() ?? 0;
                          return Text(
                            '\$${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Goals Section with circular progress - Dynamic from Firestore
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection(AppConstants.goalsCollection)
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const SizedBox(height: 100);
                      }
                      
                      final docs = snapshot.data!.docs;
                      
                      // Sort by creation date and take top 3
                      docs.sort((a, b) {
                        final aTime = a.data()['createdAt'] as Timestamp?;
                        final bTime = b.data()['createdAt'] as Timestamp?;
                        if (aTime == null || bTime == null) return 0;
                        return bTime.compareTo(aTime);
                      });
                      
                      final topGoals = docs.take(3).toList();
                      
                      if (topGoals.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No goals yet. Add your first goal!',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      // Icon and color options for goals
                      const icons = [Icons.laptop, Icons.favorite, Icons.home, Icons.flight, Icons.school];
                      const colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];
                      
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(topGoals.length, (index) {
                          final data = topGoals[index].data();
                          final name = data['name'] as String? ?? 'Goal';
                          final current = (data['currentAmount'] as num?)?.toDouble() ?? 0;
                          final target = (data['targetAmount'] as num?)?.toDouble() ?? 0;
                          final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
                          
                          return _buildGoalCircle(
                            name,
                            '\$${target.toStringAsFixed(0)}',
                            icons[index % icons.length],
                            colors[index % colors.length],
                            progress,
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Recent Transactions Section
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection(AppConstants.transactionsCollection)
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      final items = snapshot.data!.docs;
                      
                      // Sort in-memory since orderBy requires composite index
                      items.sort((a, b) {
                        final aTime = a.data()['date'] as Timestamp?;
                        final bTime = b.data()['date'] as Timestamp?;
                        if (aTime == null || bTime == null) return 0;
                        return bTime.compareTo(aTime); // descending
                      });
                      
                      final recent = items.take(5).toList();
                      
                      return Column(
                        children: recent.map((d) {
                          final data = d.data();
                          final title = data['description'] as String? ?? 'Transaction';
                          final amount = (data['amount'] as num?)?.toDouble() ?? 0;
                          final isPositive = (data['type'] as String?) == 'deposit';
                          final date = (data['date'] as Timestamp?)?.toDate();
                          final icon = isPositive ? Icons.add_circle : Icons.remove_circle;
                          final color = isPositive ? Colors.green : Colors.red;
                          return _buildTransactionItem(
                            title,
                            '\$${amount.toStringAsFixed(2)}',
                            _formatDate(date),
                            icon,
                            color,
                            isPositive,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCircle(
    String title,
    String amount,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 85,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}$amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final m = (date.month >= 1 && date.month <= 12) ? months[date.month - 1] : '';
    return '$m ${date.day}';
  }
}
