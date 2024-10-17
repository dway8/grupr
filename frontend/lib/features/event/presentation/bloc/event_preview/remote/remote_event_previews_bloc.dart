import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/event/domain/usecases/get_event_previews.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_event.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteEventPreviewsBloc
    extends Bloc<RemoteEventPreviewsEvent, RemoteEventPreviewsState> {
  final GetEventPreviewsUseCase _getEventPreviewsUseCase;

  RemoteEventPreviewsBloc(this._getEventPreviewsUseCase)
      : super(const RemoteEventPreviewsLoading()) {
    on<GetEventPreviews>(onGetEventPreviews);
  }

  void onGetEventPreviews(
      GetEventPreviews event, Emitter<RemoteEventPreviewsState> emit) async {
    final dataState = await _getEventPreviewsUseCase();

    if (dataState is DataSuccess) {
      emit(RemoteEventPreviewsLoaded(dataState.data!));
    }

    if (dataState is DataFailed) {
      print(dataState.error!.message);
      emit(RemoteEventPreviewsError(dataState.error!));
    }
  }
}
