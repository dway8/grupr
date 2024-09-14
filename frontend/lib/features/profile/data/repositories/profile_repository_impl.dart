import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../data_sources/remote/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _profileApiService;

  ProfileRepositoryImpl(this._profileApiService);

  @override
  Future<DataState<void>> createProfile(Profile profile) async {
    try {
      final httpResponse = await _profileApiService.createProfile(
        ProfileModel(
          userId: profile.userId,
          firstName: profile.firstName,
          dateOfBirth: profile.dateOfBirth,
          city: profile.city,
          latitude: profile.latitude,
          longitude: profile.longitude,
          country: profile.country,
        ),
      );

      if (httpResponse.response.statusCode == HttpStatus.created ||
          httpResponse.response.statusCode == HttpStatus.ok) {
        return const DataSuccess(null);
      } else {
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
      return DataFailed(e);
    } on SocketException catch (e) {
      return DataFailed(
        DioException(
          error: 'Please check your internet connection',
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        ),
      );
    } catch (e) {
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
