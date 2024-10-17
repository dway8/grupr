import 'package:grupr/features/profile/domain/entities/profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileNotFound extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}
