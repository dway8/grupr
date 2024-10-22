import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class GetEventUseCase {
  final EventRepository _eventRepository;

  GetEventUseCase(this._eventRepository);

  Future<DataState<EventEntity>> call(int eventId) {
    return _eventRepository.getEvent(eventId);
  }
}
