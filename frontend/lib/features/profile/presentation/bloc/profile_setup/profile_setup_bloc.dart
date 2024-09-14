import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/core/resources/data_state.dart';
import 'package:grupr/features/profile/domain/usecases/create_profile.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final CreateProfile createProfile;
  String? _firstName;
  String? _city;
  double? _latitude;
  double? _longitude;
  String? _country;
  DateTime? _dateOfBirth;

  ProfileSetupBloc({required this.createProfile})
      : super(ProfileSetupInitial()) {
    on<SetFirstName>(_onSetFirstName);
    on<SetAddress>(_onSetAddress);
    on<SetDateOfBirth>(_onSetDateOfBirth);
    on<SubmitProfile>(_onSubmitProfile);
  }

  void _onSetFirstName(SetFirstName event, Emitter<ProfileSetupState> emit) {
    _firstName = event.firstName;
    emit(ProfileSetupFirstNameEntered(event.firstName));
  }

  void _onSetAddress(SetAddress event, Emitter<ProfileSetupState> emit) {
    _city = event.city;
    _latitude = event.latitude;
    _longitude = event.longitude;
    _country = event.country;
    emit(ProfileSetupAddressEntered(
      city: event.city,
      latitude: event.latitude,
      longitude: event.longitude,
      country: event.country,
    ));
  }

  void _onSetDateOfBirth(
      SetDateOfBirth event, Emitter<ProfileSetupState> emit) {
    _dateOfBirth = event.dateOfBirth;
    emit(ProfileSetupDateOfBirthEntered(event.dateOfBirth));
  }

  void _onSubmitProfile(
      SubmitProfile event, Emitter<ProfileSetupState> emit) async {
    if (_firstName == null ||
        _city == null ||
        _latitude == null ||
        _longitude == null ||
        _country == null ||
        _dateOfBirth == null) {
      emit(const ProfileSetupError('Please fill in all fields'));
      return;
    }

    emit(ProfileSetupLoading());

    final profile = Profile(
      userId: event.userId,
      firstName: _firstName!,
      dateOfBirth: _dateOfBirth!,
      city: _city!,
      latitude: _latitude!,
      longitude: _longitude!,
      country: _country!,
    );

    final result = await createProfile(profile);

    if (result is DataSuccess) {
      emit(ProfileSetupSuccess());
    } else if (result is DataFailed) {
      emit(ProfileSetupError(
          result.error?.toString() ?? 'An unknown error occurred'));
    }
  }
}
