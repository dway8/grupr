import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event.dart';
import 'package:grupr/features/event/domain/entities/event_creation.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';

abstract class EventRepository {
  Future<DataState<List<EventPreviewEntity>>> getEventPreviews();
  Future<DataState<List<EventPreviewEntity>>> getMyEvents();
  Future<DataState<EventEntity>> createEvent(EventCreationEntity event);
}
