import 'package:grupr/features/auth/domain/repository/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<String?> call() {
    return repository.login();
  }
}
