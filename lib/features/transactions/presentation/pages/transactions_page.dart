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
        title: const Text('Transactions'),
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
            return const Center(
              child: Text('No transactions yet. Tap + to add one.'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        backgroundColor: AppConstants.primaryGreen,
        child: const Icon(Icons.add),
      ),
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
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteTransactionDialog(
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

  void _showAddTransactionDialog(BuildContext context) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String transactionType = 'expense';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g., Grocery Store',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'e.g., 50.00',
                    prefixText: '\$',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: transactionType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'expense',
                      child: Text('Expense'),
                    ),
                    DropdownMenuItem(
                      value: 'deposit',
                      child: Text('Deposit'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      transactionType = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) return;

                final description = descriptionController.text.trim();
                final amount = double.tryParse(amountController.text.trim()) ?? 0;
                final isDeposit = transactionType == 'deposit';

                // 1) Add transaction document
                final txRef = FirebaseFirestore.instance
                    .collection(AppConstants.transactionsCollection)
                    .doc();

                await txRef.set({
                  'id': txRef.id,
                  'userId': uid,
                  'description': description,
                  'amount': amount,
                  'type': isDeposit ? 'deposit' : 'expense',
                  'date': FieldValue.serverTimestamp(),
                });

                // 2) Update user's totalSavings atomically
                final userRef = FirebaseFirestore.instance
                    .collection(AppConstants.usersCollection)
                    .doc(uid);

                await FirebaseFirestore.instance.runTransaction((t) async {
                  final snap = await t.get(userRef);
                  final current = (snap.data()?['totalSavings'] as num?)?.toDouble() ?? 0;
                  final updated = isDeposit ? current + amount : (current - amount);
                  t.update(userRef, {'totalSavings': updated < 0 ? 0 : updated});
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully!'),
                      backgroundColor: AppConstants.successColor,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryGreen,
              ),
              child: const Text('Add Transaction'),
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

  /// Show confirmation dialog before deleting transaction
  void _showDeleteTransactionDialog(
    BuildContext context,
    String transactionId,
    String description,
    double amount,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this transaction?'),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$${amount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'This will also update your total savings accordingly.',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
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

  /// Delete transaction and update total savings
  Future<void> _deleteTransaction(
    BuildContext context,
    String transactionId,
    double amount,
    String type,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      // Delete the transaction
      await FirebaseFirestore.instance
          .collection(AppConstants.transactionsCollection)
          .doc(transactionId)
          .delete();

      // Update totalSavings atomically
      // If it was a deposit, we need to subtract it back
      // If it was an expense/withdrawal, we need to add it back
      final userRef = FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(uid);

      await FirebaseFirestore.instance.runTransaction((t) async {
        final snap = await t.get(userRef);
        final totalSavings = (snap.data()?['totalSavings'] as num?)?.toDouble() ?? 0;
        
        double updated;
        if (type == 'deposit') {
          // Remove the deposit amount
          updated = (totalSavings - amount).clamp(0, double.infinity);
        } else {
          // Add back the expense/withdrawal amount
          updated = totalSavings + amount;
        }
        
        t.update(userRef, {'totalSavings': updated});
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted successfully!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}

