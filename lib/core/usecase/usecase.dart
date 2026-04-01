/// ERP System - Base Use Case
///
/// Abstract use case classes that enforce Clean Architecture.
/// Every business operation is a UseCase.
library;

import 'package:erp/core/network/api_result.dart';

/// Use case with parameters
abstract class UseCase<T, Params> {
  Future<ApiResult<T>> call(Params params);
}

/// Use case without parameters
abstract class UseCaseNoParams<T> {
  Future<ApiResult<T>> call();
}

/// Stream-based use case for real-time data
abstract class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

/// Stream-based use case without parameters
abstract class StreamUseCaseNoParams<T> {
  Stream<T> call();
}
