import '../usecases/login.dart';

abstract class AuthRepository {
  Future<LoginResult?> login();
  Future<String?> getAccessToken();
  Future<void> logout();
}
