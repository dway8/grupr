import 'package:grupr/core/network/api_client.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/profile_model.dart';
import '../../../../../core/constants/constants.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: gruprAPIBaseURL)
abstract class ProfileApiService {
  factory ProfileApiService(ApiClient apiClient) {
    return _ProfileApiService(apiClient.dio);
  }

  @POST('/profiles/create')
  Future<HttpResponse<void>> createProfile(@Body() ProfileModel profile);
}
