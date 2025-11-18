import 'package:equatable/equatable.dart';

/// Transaction entity
class Transaction extends Equatable {
  final String id;
  final String userId;
  final String type; // 'expense' or 'deposit'
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String? goalId;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.goalId,
  });

  bool get isExpense => type == 'expense';
  bool get isDeposit => type == 'deposit';

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    amount,
    category,
    description,
    date,
    goalId,
  ];

  Transaction copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    String? goalId,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      goalId: goalId ?? this.goalId,
    );
  }
}
