import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/data/data_sources/remote/event_api_service.dart';
import 'package:grupr/features/event/data/models/event_preview.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventApiService _eventApiService;
  EventRepositoryImpl(this._eventApiService);

  @override
  Future<DataState<List<EventPreviewModel>>> getEventPreviews() async {
    try {
      print('Fetching event previews');
      final httpResponse = await _eventApiService.getEventPreviews(
        lat: 12,
        lon: 14,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<EventPreviewEntity>>> getMyEvents() async {
    try {
      print('Fetching my events...');
      final httpResponse = await _eventApiService.getMyEvents();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('Successfully fetched my events.');
        return DataSuccess(httpResponse.data);
      } else {
        print(
            'Failed to fetch my events: ${httpResponse.response.statusMessage}');
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      print('Error fetching my events: ${e.message}');
      return DataFailed(e);
    }
  }
}
