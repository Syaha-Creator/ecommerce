// lib/features/auth/presentation/bloc/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../app/di.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _secureStorage = locator<SecureStorage>();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await _secureStorage.getAuthToken();
      final userId = await _secureStorage.getUserId();

      if (token != null && userId != null) {
        // Untuk saat ini, kita simulasikan user data
        // Nanti bisa diganti dengan API call untuk mendapatkan user data
        emit(AuthAuthenticated(
          userId: userId,
          userName: 'Test User',
          userEmail: 'test@example.com',
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication: $e'));
    }
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Simulasi login - nanti diganti dengan API call
      await Future.delayed(const Duration(seconds: 1));

      // Simulasi menyimpan token dan user data
      await _secureStorage.saveAuthToken(
          'dummy_token_${DateTime.now().millisecondsSinceEpoch}');
      await _secureStorage.saveUserId('user_123');

      emit(AuthAuthenticated(
        userId: 'user_123',
        userName: 'Test User',
        userEmail: event.email,
      ));
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  void _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Simulasi register - nanti diganti dengan API call
      await Future.delayed(const Duration(seconds: 1));

      // Simulasi menyimpan token dan user data
      await _secureStorage.saveAuthToken(
          'dummy_token_${DateTime.now().millisecondsSinceEpoch}');
      await _secureStorage.saveUserId('user_123');

      emit(AuthAuthenticated(
        userId: 'user_123',
        userName: event.name,
        userEmail: event.email,
      ));
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Hapus semua data authentication
      await _secureStorage.clearAll();

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }
}
