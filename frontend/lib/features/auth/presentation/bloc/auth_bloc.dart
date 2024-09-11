import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/get_access_token.dart';
import '../../domain/usecases/logout.dart';

// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;

  AuthBloc({required this.login}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        print('AuthBloc: Starting login process...');
        final token = await login();
        if (token != null) {
          print('AuthBloc: Login successful. Token: $token');
          emit(AuthAuthenticated(token));
        } else {
          print('AuthBloc: Login failed: token is null');
          emit(AuthError('Login failed'));
        }
      } catch (e, s) {
        print('AuthBloc: Login error: $e');
        print('AuthBloc: Stack trace: $s');
        emit(AuthError(e.toString()));
      }
    });
  }
}
