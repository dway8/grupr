import 'package:grupr/core/repositories/base_repository.dart';
import 'package:grupr/features/profile/data/models/profile_model.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/create_profile.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/domain/repositories/profile_repository.dart';
import 'package:grupr/features/profile/data/models/create_profile_model.dart';
import 'package:grupr/features/profile/data/data_sources/remote/profile_api_service.dart';

class ProfileRepositoryImpl extends BaseRepository
    implements ProfileRepository {
  final ProfileApiService _profileApiService;

  ProfileRepositoryImpl(this._profileApiService);

  @override
  Future<DataState<void>> createProfile(CreateProfile profile) async {
    return await handleRequest<void, void>(() async {
      return await _profileApiService.createProfile(
        CreateProfileModel(
          firstName: profile.firstName,
          dateOfBirth: profile.dateOfBirth,
          city: profile.city,
          latitude: profile.latitude,
          longitude: profile.longitude,
          country: profile.country,
        ),
      );
    }, (response) => response, requestType: 'Create Profile');
  }

  @override
  Future<DataState<Profile>> fetchUserProfile() async {
    return await handleRequest<ProfileModel, Profile>(
      () async {
        return await _profileApiService.fetchUserProfile();
      },
      (model) => _mapProfileDataModelToDomainEntity(model),
      requestType: 'Fetch User Profile',
    );
  }

  @override
  Future<DataState<Profile>> updateProfile(Profile profile) async {
    return await handleRequest<ProfileModel, Profile>(
      () async {
        return await _profileApiService.updateProfile(
          ProfileModel(
            firstName: profile.firstName,
            dateOfBirth: profile.dateOfBirth,
            city: profile.city,
            latitude: profile.latitude,
            longitude: profile.longitude,
            country: profile.country,
          ),
        );
      },
      (model) => _mapProfileDataModelToDomainEntity(model),
      requestType: 'Update Profile',
    );
  }

  Profile _mapProfileDataModelToDomainEntity(ProfileModel model) {
    return Profile(
      firstName: model.firstName,
      dateOfBirth: model.dateOfBirth,
      city: model.city,
      latitude: model.latitude,
      longitude: model.longitude,
      country: model.country,
    );
  }
}
