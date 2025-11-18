import 'package:dartz/dartz.dart';
import 'package:savesmart/core/error/failures.dart';
import 'package:savesmart/features/transactions/domain/entities/transaction.dart';

/// Transactions repository interface
abstract class TransactionsRepository {
  /// Create a new transaction
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  );

  /// Get all transactions for a user
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId);

  /// Get transactions by date range
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get a single transaction by ID
  Future<Either<Failure, Transaction>> getTransactionById(String transactionId);

  /// Update a transaction
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  );

  /// Delete a transaction
  Future<Either<Failure, void>> deleteTransaction(String transactionId);

  /// Get transactions by goal
  Future<Either<Failure, List<Transaction>>> getTransactionsByGoal(
    String goalId,
  );

  /// Stream of transactions for real-time updates
  Stream<Either<Failure, List<Transaction>>> watchTransactions(String userId);
}
