import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<DataState<Profile>> call() {
    return repository.fetchUserProfile();
  }
}
