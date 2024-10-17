import 'package:grupr/core/constants/constants.dart';
import 'package:grupr/core/network/api_client.dart';
import 'package:grupr/features/profile/data/models/create_profile_model.dart';
import 'package:grupr/features/profile/data/models/profile_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: gruprAPIBaseURL)
abstract class ProfileApiService {
  factory ProfileApiService(ApiClient apiClient) {
    return _ProfileApiService(apiClient.dio);
  }

  @POST('/profiles')
  Future<HttpResponse<void>> createProfile(@Body() CreateProfileModel profile);

  @GET('/profiles/me')
  Future<HttpResponse<ProfileModel>> fetchUserProfile();
}
