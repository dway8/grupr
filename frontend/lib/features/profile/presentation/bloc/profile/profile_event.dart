import 'package:grupr/features/profile/domain/entities/profile.dart';

abstract class ProfileEvent {}

class FetchUserProfile extends ProfileEvent {
  // You can add any additional parameters if needed
}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  UpdateProfile(this.profile);
}
