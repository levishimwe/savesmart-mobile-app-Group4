import 'package:flutter_test/flutter_test.dart';
import 'package:savesmart/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        // Arrange
        const email = 'test@example.com';

        // Act
        final result = Validators.validateEmail(email);

        // Assert
        expect(result, null);
      });

      test('should return error message for invalid email', () {
        // Arrange
        const email = 'invalid-email';

        // Act
        final result = Validators.validateEmail(email);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('valid email'));
      });

      test('should return error message for empty email', () {
        // Arrange
        const email = '';

        // Act
        final result = Validators.validateEmail(email);

        // Assert
        expect(result, isNotNull);
        expect(result, 'Email is required');
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        // Arrange
        const password = 'password123';

        // Act
        final result = Validators.validatePassword(password);

        // Assert
        expect(result, null);
      });

      test('should return error message for short password', () {
        // Arrange
        const password = '123';

        // Act
        final result = Validators.validatePassword(password);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('at least 6 characters'));
      });

      test('should return error message for empty password', () {
        // Arrange
        const password = '';

        // Act
        final result = Validators.validatePassword(password);

        // Assert
        expect(result, 'Password is required');
      });
    });

    group('validateAmount', () {
      test('should return null for valid amount', () {
        // Arrange
        const amount = '100.50';

        // Act
        final result = Validators.validateAmount(amount);

        // Assert
        expect(result, null);
      });

      test('should return error message for invalid amount', () {
        // Arrange
        const amount = 'abc';

        // Act
        final result = Validators.validateAmount(amount);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('valid amount'));
      });

      test('should return error message for negative amount', () {
        // Arrange
        const amount = '-10';

        // Act
        final result = Validators.validateAmount(amount);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('valid amount'));
      });

      test('should return error message for zero amount', () {
        // Arrange
        const amount = '0';

        // Act
        final result = Validators.validateAmount(amount);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('valid amount'));
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        // Arrange
        const name = 'John Doe';

        // Act
        final result = Validators.validateName(name);

        // Assert
        expect(result, null);
      });

      test('should return error message for short name', () {
        // Arrange
        const name = 'J';

        // Act
        final result = Validators.validateName(name);

        // Assert
        expect(result, isNotNull);
        expect(result, contains('at least 2 characters'));
      });

      test('should return error message for empty name', () {
        // Arrange
        const name = '';

        // Act
        final result = Validators.validateName(name);

        // Assert
        expect(result, 'Name is required');
      });
    });
  });
}
