import 'package:grupr/core/repositories/base_repository.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/data/data_sources/remote/event_api_service.dart';
import 'package:grupr/features/event/data/models/event.dart';
import 'package:grupr/features/event/data/models/event_creation.dart';
import 'package:grupr/features/event/data/models/event_preview.dart';
import 'package:grupr/features/event/domain/entities/event.dart';
import 'package:grupr/features/event/domain/entities/event_creation.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class EventRepositoryImpl extends BaseRepository implements EventRepository {
  final EventApiService _eventApiService;
  EventRepositoryImpl(this._eventApiService);

  @override
  Future<DataState<List<EventPreviewModel>>> getEventPreviews() async {
    return await handleRequest(() async {
      return await _eventApiService.getEventPreviews(
        lat: 12,
        lon: 14,
      );
    }, (response) => response, requestType: 'Get Event Previews');
  }

  @override
  Future<DataState<List<EventPreviewEntity>>> getMyEvents() async {
    return await handleRequest(() async {
      return await _eventApiService.getMyEvents();
    }, (response) => response, requestType: 'Get My Events');
  }

  @override
  Future<DataState<EventEntity>> createEvent(EventCreationEntity event) async {
    return await handleRequest(() async {
      final eventModel = EventCreationModel(
        name: event.name,
        location: event.location,
        date: event.date,
        description: event.description,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      return await _eventApiService.createEvent(eventModel);
    }, (model) => _mapEventDataModelToDomainEntity(model),
        requestType: 'Create Event');
  }

  @override
  Future<DataState<EventEntity>> getEvent(int eventId) async {
    return await handleRequest(() async {
      return await _eventApiService.getEvent(eventId);
    }, (model) => _mapEventDataModelToDomainEntity(model),
        requestType: 'Get Event');
  }

  EventEntity _mapEventDataModelToDomainEntity(EventModel model) {
    return EventEntity(
      id: model.id,
      name: model.name,
      location: model.location,
      date: model.date,
      description: model.description,
      latitude: model.latitude,
      longitude: model.longitude,
    );
  }
}
