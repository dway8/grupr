import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event.dart';
import 'package:grupr/features/event/domain/usecases/get_event.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_event.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventUseCase getEvent;

  EventBloc(this.getEvent) : super(EventInitial()) {
    on<FetchEvent>((event, emit) async {
      emit(EventLoading());
      final result = await getEvent(event.eventId);

      if (result is DataSuccess<EventEntity>) {
        emit(EventLoaded(result.data!));
      } else if (result is DataNotSet) {
        emit(const EventError('Event not found'));
      } else if (result is DataFailed) {
        emit(EventError(result.error.toString()));
      }
    });
  }
}
