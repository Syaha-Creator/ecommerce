// lib/features/auth/presentation/bloc/auth/auth_state.dart
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String userName;
  final String userEmail;

  const AuthAuthenticated({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  List<Object> get props => [userId, userName, userEmail];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
