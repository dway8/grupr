import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/create_profile.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<DataState<void>> createProfile(CreateProfile profile);
  Future<DataState<Profile>> fetchUserProfile();
}
