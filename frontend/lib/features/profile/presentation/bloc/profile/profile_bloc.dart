import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfile;

  ProfileBloc(this.getUserProfile) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(ProfileLoading());
      final result = await getUserProfile();

      // Use type checking instead of switch-case
      if (result is DataSuccess<Profile>) {
        emit(ProfileLoaded(result.data!));
      } else if (result is DataNotSet) {
        emit(ProfileNotFound());
      } else if (result is DataFailed) {
        emit(ProfileError(result.error.toString()));
      }
    });
  }
}
