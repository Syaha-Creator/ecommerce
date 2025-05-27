// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({required String message, dynamic code})
      : super(message: message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message, dynamic code})
      : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message, dynamic code})
      : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message, dynamic code})
      : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message, dynamic code})
      : super(message: message, code: code);
}
