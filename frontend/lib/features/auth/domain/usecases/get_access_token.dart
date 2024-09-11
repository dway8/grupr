import 'package:grupr/features/auth/domain/repository/auth_repository.dart';

class GetAccessToken {
  final AuthRepository repository;

  GetAccessToken(this.repository);

  Future<String?> call() {
    return repository.getAccessToken();
  }
}
