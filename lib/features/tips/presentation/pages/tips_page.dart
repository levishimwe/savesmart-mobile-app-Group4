import 'package:flutter/material.dart';
import 'package:savesmart/core/utils/constants.dart';

/// Tips page
class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Financial Tips'),
        backgroundColor: AppConstants.primaryGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        children: [
          _buildTipCard(
            'Weekly Financial Tip',
            'Budgeting Basics',
            'Learn how to create and manage an effective budget that helps identify areas where you can save money.',
            Icons.account_balance_wallet,
            Colors.green,
          ),
          _buildTipCard(
            'Educational Articles',
            'Saving Strategies',
            'Discover effective ways to grow your savings and reach your financial goals faster.',
            Icons.trending_up,
            Colors.blue,
          ),
          _buildTipCard(
            'Money Tips',
            'Student Finance',
            'Tips for Managing your finances during college and avoiding common financial pitfalls.',
            Icons.school,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    String category,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: AppConstants.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
