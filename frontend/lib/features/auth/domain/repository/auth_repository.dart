abstract class AuthRepository {
  Future<String?> login();
  Future<String?> getAccessToken();
  Future<void> logout();
}
