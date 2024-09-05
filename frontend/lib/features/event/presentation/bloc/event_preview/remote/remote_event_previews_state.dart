import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';

abstract class RemoteEventPreviewsState extends Equatable {
  final List<EventPreviewEntity>? eventPreviews;
  final DioException? error;

  const RemoteEventPreviewsState({
    this.eventPreviews,
    this.error,
  });

  @override
  List<Object?> get props => [eventPreviews!, error];
}

class RemoteEventPreviewsLoading extends RemoteEventPreviewsState {
  const RemoteEventPreviewsLoading();
}

class RemoteEventPreviewsLoaded extends RemoteEventPreviewsState {
  const RemoteEventPreviewsLoaded(List<EventPreviewEntity> eventPreviews)
      : super(eventPreviews: eventPreviews);
}

class RemoteEventPreviewsError extends RemoteEventPreviewsState {
  const RemoteEventPreviewsError(DioException error) : super(error: error);
}
