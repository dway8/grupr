import 'dart:io';
import 'package:dio/dio.dart';
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
    try {
      final httpResponse = await _profileApiService.createProfile(
        CreateProfileModel(
          firstName: profile.firstName,
          dateOfBirth: profile.dateOfBirth,
          city: profile.city,
          latitude: profile.latitude,
          longitude: profile.longitude,
          country: profile.country,
        ),
      );

      print(
          'Profile creation response status: ${httpResponse.response.statusCode}');

      if (httpResponse.response.statusCode == HttpStatus.created ||
          httpResponse.response.statusCode == HttpStatus.ok) {
        print('Profile created successfully');
        return const DataSuccess(null);
      } else {
        print(
            'Profile creation failed. Status: ${httpResponse.response.statusCode}, Message: ${httpResponse.response.statusMessage}');
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
      print('DioException occurred: ${e.message}');
      return DataFailed(e);
    } on SocketException catch (e) {
      print('SocketException occurred: ${e.message}');
      return DataFailed(
        DioException(
          error: 'Please check your internet connection',
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        ),
      );
    } catch (e) {
      print('Unexpected error occurred: $e');
      return DataFailed(
        DioException(
          error: e.toString(),
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
        ),
      );
    }
  }

  @override
  Future<DataState<Profile>> fetchUserProfile() async {
    print('Fetching profile');
    try {
      final httpResponse = await _profileApiService.fetchUserProfile();

      print('Profile fetch response: ${httpResponse.response}');

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(Profile(
          firstName: httpResponse.data.firstName,
          dateOfBirth: httpResponse.data.dateOfBirth,
          city: httpResponse.data.city,
          latitude: httpResponse.data.latitude,
          longitude: httpResponse.data.longitude,
          country: httpResponse.data.country,
        ));
      } else if (httpResponse.response.statusCode == HttpStatus.notFound) {
        return const DataNotSet();
      } else {
        print(
            'Profile fetch failed. Status: ${httpResponse.response.statusCode}, Message: ${httpResponse.response.statusMessage}');
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
      print('DioException occurred: ${e.message}');
      return DataFailed(e);
    } on SocketException catch (e) {
      print('SocketException occurred: ${e.message}');
      return DataFailed(
        DioException(
          error: 'Please check your internet connection',
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        ),
      );
    } catch (e) {
      print('Unexpected error occurred: $e');
      return DataFailed(
        DioException(
          error: e.toString(),
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
        ),
      );
    }
  }
}
