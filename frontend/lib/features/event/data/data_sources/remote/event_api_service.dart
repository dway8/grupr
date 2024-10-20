import 'package:grupr/core/constants/constants.dart';
import 'package:grupr/core/network/api_client.dart';
import 'package:grupr/features/event/data/models/event.dart';
import 'package:grupr/features/event/data/models/event_creation.dart';
import 'package:grupr/features/event/data/models/event_preview.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'event_api_service.g.dart';

@RestApi(baseUrl: gruprAPIBaseURL)
abstract class EventApiService {
  factory EventApiService(ApiClient apiClient) {
    return _EventApiService(apiClient.dio);
  }

  @GET('/events')
  Future<HttpResponse<List<EventPreviewModel>>> getEventPreviews({
    @Query("lat") num? lat,
    @Query("lon") num? lon,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
  });

  @GET('/users/me/events')
  Future<HttpResponse<List<EventPreviewModel>>> getMyEvents();

  @POST('/events')
  Future<HttpResponse<EventModel>> createEvent(
      @Body() EventCreationModel event);
}
