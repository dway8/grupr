import '../../../../core/resources/data_state.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class CreateProfile {
  final ProfileRepository repository;

  CreateProfile(this.repository);

  Future<DataState<void>> call(Profile profile) async {
    return await repository.createProfile(profile);
  }
}
