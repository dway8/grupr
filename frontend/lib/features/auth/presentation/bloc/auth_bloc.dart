import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';

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
  final String userId;

  AuthAuthenticated({required this.token, required this.userId});

  List<Object> get props => [token, userId];
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
        final result = await login();
        switch (result) {
          case LoginSuccess(:final token, :final userId):
            emit(AuthAuthenticated(token: token, userId: userId));
          case LoginFailure(:final error):
            emit(AuthError('Login failed: $error'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
