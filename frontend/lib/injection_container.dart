import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grupr/features/event/data/data_sources/remote/event_api_service.dart';
import 'package:grupr/features/event/data/repository/event_repository_impl.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';
import 'package:grupr/features/event/domain/usecases/get_event_previews.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Dependencies
  sl.registerSingleton<EventApiService>(EventApiService(sl()));

  sl.registerSingleton<EventRepository>(EventRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<GetEventPreviewsUseCase>(GetEventPreviewsUseCase(sl()));

  // Blocs
  sl.registerFactory<RemoteEventPreviewsBloc>(
      () => RemoteEventPreviewsBloc(sl()));
}
