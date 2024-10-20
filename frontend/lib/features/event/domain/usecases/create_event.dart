import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event_creation.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class CreateEventUseCase {
  final EventRepository _eventRepository;

  CreateEventUseCase(this._eventRepository);

  Future<DataState<void>> call(EventCreationEntity event) {
    return _eventRepository.createEvent(event);
  }
}
