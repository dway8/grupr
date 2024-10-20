import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/usecases/get_my_events.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_event.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_state.dart';

class MyEventsBloc extends Bloc<MyEventsEvent, MyEventsState> {
  final GetMyEventsUseCase _getMyEventsUseCase;

  MyEventsBloc(this._getMyEventsUseCase) : super(MyEventsLoading()) {
    on<GetMyEvents>(onGetMyEvents);
  }

  void onGetMyEvents(GetMyEvents event, Emitter<MyEventsState> emit) async {
    final dataState = await _getMyEventsUseCase();
    if (dataState is DataSuccess) {
      emit(MyEventsLoaded(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(MyEventsError(dataState.error!));
    }
  }
}
