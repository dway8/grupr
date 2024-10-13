import 'package:grupr/core/constants/constants.dart';
import 'package:grupr/features/event/data/models/event_preview.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'event_preview_api_service.g.dart';

@RestApi(baseUrl: gruprAPIBaseURL)
abstract class EventApiService {
  factory EventApiService(Dio dio) = _EventPreviewApiService;

  @GET('/events')
  Future<HttpResponse<List<EventPreviewModel>>> getEventPreviews({
    @Query("lat") double? lat,
    @Query("lon") double? lon,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
  });
}
