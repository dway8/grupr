import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<DataState<Profile>> call(Profile profile) async {
    return await repository.updateProfile(profile);
  }
}
