import 'dart:io';
import 'package:dio/dio.dart';
import 'package:grupr/features/profile/data/models/profile_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/create_profile.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/domain/repositories/profile_repository.dart';
import 'package:grupr/features/profile/data/models/create_profile_model.dart';
import 'package:grupr/features/profile/data/data_sources/remote/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _profileApiService;

  ProfileRepositoryImpl(this._profileApiService);

  @override
  Future<DataState<void>> createProfile(CreateProfile profile) async {
    return await _handleRequest<void, void>(() async {
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
    return await _handleRequest<ProfileModel, Profile>(
      () async {
        return await _profileApiService.fetchUserProfile();
      },
      (model) => _mapProfileDataModelToDomainEntity(model),
      requestType: 'Fetch User Profile',
    );
  }

  @override
  Future<DataState<Profile>> updateProfile(Profile profile) async {
    return await _handleRequest<ProfileModel, Profile>(
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

  Future<DataState<TDomain>> _handleRequest<TModel, TDomain>(
      Future<HttpResponse<TModel>> Function() request,
      TDomain Function(TModel) transform,
      {required String requestType}) async {
    try {
      final httpResponse = await request();

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(transform(httpResponse.data));
      } else {
        print(
            'Request failed: $requestType - Status: ${httpResponse.response.statusCode}, Message: ${httpResponse.response.statusMessage}');
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      print('DioException occurred during $requestType: ${e.message}');
      return DataFailed(e);
    } on SocketException catch (e) {
      print('SocketException occurred during $requestType: ${e.message}');
      return DataFailed(
        DioException(
          error: 'Please check your internet connection',
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        ),
      );
    } catch (e) {
      print('Unexpected error occurred during $requestType: $e');
      return DataFailed(
        DioException(
          error: e.toString(),
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
        ),
      );
    }
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
