import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class GetMyEventsUseCase {
  final EventRepository _eventRepository;

  GetMyEventsUseCase(this._eventRepository);

  Future<DataState<List<EventPreviewEntity>>> call() {
    return _eventRepository.getMyEvents();
  }
}
