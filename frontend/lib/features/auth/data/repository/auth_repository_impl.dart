import 'package:grupr/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:grupr/features/auth/domain/repository/auth_repository.dart';
import '../../domain/usecases/login.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<LoginResult> login() async {
    try {
      final result = await _authService.login();
      print('Login result: $result');
      if (result != null) {
        return LoginResult.success(
            token: result['accessToken']!, userId: result['userId']!);
      } else {
        return LoginResult.failure('Login failed');
      }
    } catch (e) {
      return LoginResult.failure('An error occurred: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAccessToken() {
    return _authService.getAccessToken();
  }

  @override
  Future<void> logout() {
    return _authService.logout();
  }
}
