import 'package:grupr/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:grupr/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<String?> login() {
    return _authService.login();
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
