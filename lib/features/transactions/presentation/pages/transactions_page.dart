import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savesmart/core/utils/constants.dart';

/// Transactions page
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppConstants.primaryGreen,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.transactionsCollection)
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load transactions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          
          // Sort in-memory since orderBy requires composite index
          docs.sort((a, b) {
            final aTime = a.data()['date'] as Timestamp?;
            final bTime = b.data()['date'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime); // descending
          });

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your savings and withdrawals will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final transactionId = doc.id;
              final desc = data['description'] as String? ?? 'Transaction';
              final date = (data['date'] as Timestamp?)?.toDate();
              final amount = (data['amount'] as num?)?.toDouble() ?? 0;
              final type = data['type'] as String? ?? 'expense';
              final isPositive = type == 'deposit';
              final icon = isPositive ? Icons.add_circle : Icons.remove_circle;
              final color = isPositive ? Colors.green : Colors.red;

              return _buildTransactionItem(
                context,
                transactionId,
                desc,
                _formatDate(date),
                '\$${amount.toStringAsFixed(2)}',
                icon,
                color,
                isPositive,
                amount,
                type,
              );
            },
          );
        },
      ),
      // No FAB - transactions page is read-only
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String transactionId,
    String title,
    String date,
    String amount,
    IconData icon,
    Color color,
    bool isPositive,
    double amountValue,
    String type,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(date),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isPositive ? '+' : '-'}$amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => _showDeleteDialog(
                context,
                transactionId,
                title,
                amountValue,
                type,
              ),
              tooltip: 'Delete transaction',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    // Simple day+month format; could use intl if desired
    return '${_monthAbbr(date.month)} ${date.day}';
  }

  String _monthAbbr(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (m < 1 || m > 12) return '';
    return months[m - 1];
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(
    BuildContext context,
    String transactionId,
    String description,
    double amount,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this transaction from history?'),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$${amount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Note: This only removes the transaction from history. Your total savings will not be affected.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _deleteTransaction(context, transactionId, amount, type);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Delete transaction (display only - does NOT affect totalSavings)
  Future<void> _deleteTransaction(
    BuildContext context,
    String transactionId,
    double amount,
    String type,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      // Delete transaction from history (display only)
      // This does NOT affect the user's totalSavings
      await FirebaseFirestore.instance
          .collection(AppConstants.transactionsCollection)
          .doc(transactionId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted from history!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
