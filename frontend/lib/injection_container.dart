import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grupr/core/network/api_client.dart';
import 'package:grupr/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:grupr/features/auth/data/repository/auth_repository_impl.dart';
import 'package:grupr/features/auth/domain/repository/auth_repository.dart';
import 'package:grupr/features/event/data/data_sources/remote/event_api_service.dart';
import 'package:grupr/features/event/data/repository/event_repository_impl.dart';
import 'package:grupr/features/event/domain/repository/event_repository.dart';
import 'package:grupr/features/event/domain/usecases/create_event.dart';
import 'package:grupr/features/event/domain/usecases/get_event_previews.dart';
import 'package:grupr/features/event/domain/usecases/get_my_events.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_bloc.dart';
import 'package:grupr/features/profile/data/data_sources/remote/profile_api_service.dart';
import 'package:grupr/features/profile/domain/usecases/create_profile.dart';
import 'package:grupr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:grupr/features/profile/domain/usecases/update_profile.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/get_access_token.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grupr/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:grupr/features/profile/domain/repositories/profile_repository.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Services
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => ProfileApiService(sl<ApiClient>()));
  sl.registerLazySingleton(() => EventApiService(sl<ApiClient>()));

  // Initialize ApiClient and pass AuthService
  sl.registerSingleton<ApiClient>(ApiClient(sl<AuthService>()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerSingleton<EventRepository>(EventRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetAccessToken(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerSingleton<GetEventPreviewsUseCase>(GetEventPreviewsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetMyEventsUseCase(sl()));
  sl.registerLazySingleton(() => CreateEventUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(login: sl()));
  sl.registerFactory(() => ProfileSetupBloc(createProfile: sl()));
  sl.registerFactory<RemoteEventPreviewsBloc>(
      () => RemoteEventPreviewsBloc(sl()));
  sl.registerFactory(() => MyEventsBloc(sl<GetMyEventsUseCase>()));
  sl.registerFactory(() => CreateEventBloc(sl<CreateEventUseCase>()));
}
