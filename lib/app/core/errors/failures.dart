/// Base class for all failures in the application
/// Following Clean Architecture pattern for error handling
abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Database related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
  });
}

/// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Network related failures (for future use)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Cache related failures (for future use)
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}

/// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
  });
}
