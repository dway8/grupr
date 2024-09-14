import 'package:equatable/equatable.dart';

abstract class ProfileSetupState extends Equatable {
  const ProfileSetupState();

  @override
  List<Object?> get props => [];
}

class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileSetupFirstNameEntered extends ProfileSetupState {
  final String firstName;

  const ProfileSetupFirstNameEntered(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class ProfileSetupAddressEntered extends ProfileSetupState {
  final String city;
  final double latitude;
  final double longitude;
  final String country;

  const ProfileSetupAddressEntered({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  @override
  List<Object> get props => [city, latitude, longitude, country];
}

class ProfileSetupDateOfBirthEntered extends ProfileSetupState {
  final DateTime dateOfBirth;

  const ProfileSetupDateOfBirthEntered(this.dateOfBirth);

  @override
  List<Object> get props => [dateOfBirth];
}

class ProfileSetupSuccess extends ProfileSetupState {}

class ProfileSetupError extends ProfileSetupState {
  final String message;

  const ProfileSetupError(this.message);

  @override
  List<Object> get props => [message];
}
