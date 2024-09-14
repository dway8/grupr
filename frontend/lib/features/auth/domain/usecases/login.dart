import 'package:grupr/features/auth/domain/repository/auth_repository.dart';

sealed class LoginResult {
  const LoginResult();

  factory LoginResult.success({required String token, required String userId}) =
      LoginSuccess;
  factory LoginResult.failure(String error) = LoginFailure;
}

class LoginSuccess extends LoginResult {
  final String token;
  final String userId;

  const LoginSuccess({required this.token, required this.userId});
}

class LoginFailure extends LoginResult {
  final String error;

  const LoginFailure(this.error);
}

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<LoginResult> call() async {
    return await repository.login() ?? LoginResult.failure("Login failed");
  }
}
