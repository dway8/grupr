import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/profile_model.dart';
import '../../../../../core/constants/constants.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: gruprAPIBaseURL)
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio) = _ProfileApiService;

  @POST('/profiles/create')
  Future<HttpResponse<void>> createProfile(@Body() ProfileModel profile);
}
