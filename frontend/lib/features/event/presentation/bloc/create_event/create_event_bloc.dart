import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/entities/event_creation.dart';
import 'package:grupr/features/event/domain/usecases/create_event.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_event.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final CreateEventUseCase createEventUseCase;

  CreateEventBloc(this.createEventUseCase) : super(CreateEventInitial()) {
    on<SubmitEvent>(_onSubmitEvent);
  }

  Future<void> _onSubmitEvent(
      SubmitEvent event, Emitter<CreateEventState> emit) async {
    emit(CreateEventLoading());
    final dataState = await createEventUseCase.call(EventCreationEntity(
      name: event.name,
      location: event.location,
      date: event.date,
      description: event.description,
      latitude: event.latitude,
      longitude: event.longitude,
    ));

    if (dataState is DataSuccess) {
      emit(CreateEventSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateEventError(dataState.error.toString()));
    }
  }
}
