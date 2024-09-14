import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required String userId,
    required String firstName,
    required DateTime dateOfBirth,
    required String city,
    required double latitude,
    required double longitude,
    required String country,
  }) : super(
          userId: userId,
          firstName: firstName,
          dateOfBirth: dateOfBirth,
          city: city,
          latitude: latitude,
          longitude: longitude,
          country: country,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'],
      firstName: json['firstName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
    };
  }
}
