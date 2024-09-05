import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/core/usecase/usecase.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';

class GetEventPreviewsUseCase
    implements UseCase<DataState<List<EventPreviewEntity>>, void> {
  final EventRepository _eventRepository;

  GetEventPreviewsUseCase(this._eventRepository);

  @override
  Future<DataState<List<EventPreviewEntity>>> call({void params}) {
    return _eventRepository.getEventPreviews();
  }
}
