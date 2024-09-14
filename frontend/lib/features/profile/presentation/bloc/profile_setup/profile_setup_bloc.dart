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
    try {
      _firstName = event.firstName;
      emit(ProfileSetupFirstNameEntered(event.firstName));
      print('First name set: $_firstName');
    } catch (e, stackTrace) {
      print('Error in _onSetFirstName: $e');
      print('Stack trace: $stackTrace');
      emit(ProfileSetupError('Error setting first name'));
    }
  }

  void _onSetAddress(SetAddress event, Emitter<ProfileSetupState> emit) {
    try {
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
      print('Address set: $_city, $_country');
    } catch (e, stackTrace) {
      print('Error in _onSetAddress: $e');
      print('Stack trace: $stackTrace');
      emit(ProfileSetupError('Error setting address'));
    }
  }

  void _onSetDateOfBirth(
      SetDateOfBirth event, Emitter<ProfileSetupState> emit) {
    try {
      _dateOfBirth = event.dateOfBirth;
      emit(ProfileSetupDateOfBirthEntered(event.dateOfBirth));
      print('Date of birth set: $_dateOfBirth');
    } catch (e, stackTrace) {
      print('Error in _onSetDateOfBirth: $e');
      print('Stack trace: $stackTrace');
      emit(ProfileSetupError('Error setting date of birth'));
    }
  }

  void _onSubmitProfile(
      SubmitProfile event, Emitter<ProfileSetupState> emit) async {
    print(
        '_onSubmitProfile called with userId: ${event.userId}'); // Add this line
    try {
      if (_firstName == null ||
          _city == null ||
          _latitude == null ||
          _longitude == null ||
          _country == null ||
          _dateOfBirth == null) {
        print('Some fields are missing'); // Add this line
        emit(const ProfileSetupError('Please fill in all fields'));
        return;
      }

      print(
          'All fields are present, proceeding with profile creation'); // Add this line
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

      print('Calling createProfile use case'); // Add this line
      final result = await createProfile(profile);

      if (result is DataSuccess) {
        print('Profile creation successful'); // Add this line
        emit(ProfileSetupSuccess());
      } else if (result is DataFailed) {
        print('Profile creation failed: ${result.error}'); // Add this line
        emit(ProfileSetupError(
            result.error?.toString() ?? 'An unknown error occurred'));
      }
    } catch (e, stackTrace) {
      print('Error in _onSubmitProfile: $e');
      print('Stack trace: $stackTrace');
      emit(ProfileSetupError('Error submitting profile'));
    }
  }
}
