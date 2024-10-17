import 'package:grupr/features/profile/domain/entities/create_profile.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  Future<DataState<void>> call(CreateProfile profile) async {
    return await repository.createProfile(profile);
  }
}
