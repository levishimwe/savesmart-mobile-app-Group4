import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart/features/transactions/domain/entities/transaction.dart'
    as entity;

/// Transaction model for data layer
class TransactionModel extends entity.Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.amount,
    required super.category,
    required super.description,
    required super.date,
    super.goalId,
  });

  /// Convert from domain entity
  factory TransactionModel.fromEntity(entity.Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      type: transaction.type,
      amount: transaction.amount,
      category: transaction.category,
      description: transaction.description,
      date: transaction.date,
      goalId: transaction.goalId,
    );
  }

  /// Convert from Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      userId: data['userId'] as String,
      type: data['type'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      description: data['description'] as String,
      date: (data['date'] as Timestamp).toDate(),
      goalId: data['goalId'] as String?,
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'goalId': goalId,
    };
  }

  /// Convert from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      goalId: json['goalId'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'goalId': goalId,
    };
  }
}
