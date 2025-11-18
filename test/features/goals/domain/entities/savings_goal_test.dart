import 'package:flutter_test/flutter_test.dart';
import 'package:savesmart/features/goals/domain/entities/savings_goal.dart';

void main() {
  group('SavingsGoal Entity Tests', () {
    test('should calculate progress correctly', () {
      // Arrange
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 500.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Act
      final progress = goal.progress;

      // Assert
      expect(progress, 50.0);
    });

    test('should return true when goal is completed', () {
      // Arrange
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 1000.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(goal.isCompleted, true);
    });

    test('should return false when goal is not completed', () {
      // Arrange
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 500.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Act & Assert
      expect(goal.isCompleted, false);
    });

    test('should calculate days remaining correctly', () {
      // Arrange
      final deadline = DateTime.now().add(const Duration(days: 30));
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 500.0,
        deadline: deadline,
        createdAt: DateTime.now(),
      );

      // Act
      final daysRemaining = goal.daysRemaining;

      // Assert
      expect(daysRemaining, greaterThanOrEqualTo(29));
      expect(daysRemaining, lessThanOrEqualTo(30));
    });

    test('should handle progress over 100%', () {
      // Arrange
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 1500.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Act
      final progress = goal.progress;

      // Assert
      expect(progress, 100.0); // Should be clamped to 100
    });

    test('copyWith should update specified fields', () {
      // Arrange
      final goal = SavingsGoal(
        id: '1',
        userId: 'user1',
        name: 'Test Goal',
        targetAmount: 1000.0,
        currentAmount: 500.0,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      // Act
      final updatedGoal = goal.copyWith(
        name: 'Updated Goal',
        currentAmount: 750.0,
      );

      // Assert
      expect(updatedGoal.name, 'Updated Goal');
      expect(updatedGoal.currentAmount, 750.0);
      expect(updatedGoal.targetAmount, 1000.0); // Should remain unchanged
      expect(updatedGoal.id, '1'); // Should remain unchanged
    });
  });
}
