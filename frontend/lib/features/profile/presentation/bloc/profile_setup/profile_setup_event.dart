import 'package:equatable/equatable.dart';

abstract class ProfileSetupEvent extends Equatable {
  const ProfileSetupEvent();

  @override
  List<Object> get props => [];
}

class SetFirstName extends ProfileSetupEvent {
  final String firstName;

  const SetFirstName(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class SetAddress extends ProfileSetupEvent {
  final String city;
  final double latitude;
  final double longitude;
  final String country;

  const SetAddress({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  @override
  List<Object> get props => [city, latitude, longitude, country];
}

class SetDateOfBirth extends ProfileSetupEvent {
  final DateTime dateOfBirth;

  const SetDateOfBirth(this.dateOfBirth);

  @override
  List<Object> get props => [dateOfBirth];
}

class SubmitProfile extends ProfileSetupEvent {
  final String userId;

  const SubmitProfile(this.userId);

  @override
  List<Object> get props => [userId];
}
