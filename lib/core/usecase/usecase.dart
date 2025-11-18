import 'package:dartz/dartz.dart';
import 'package:savesmart/core/error/failures.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No params use case
class NoParams {}
