import 'package:equatable/equatable.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:dio/dio.dart';

abstract class MyEventsState extends Equatable {
  const MyEventsState();

  @override
  List<Object?> get props => [];
}

class MyEventsLoading extends MyEventsState {}

class MyEventsLoaded extends MyEventsState {
  final List<EventPreviewEntity> eventPreviews;

  const MyEventsLoaded(this.eventPreviews);

  @override
  List<Object?> get props => [eventPreviews];
}

class MyEventsError extends MyEventsState {
  final DioException error;

  const MyEventsError(this.error);

  @override
  List<Object?> get props => [error];
}
