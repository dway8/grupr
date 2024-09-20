import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.userId,
    required super.firstName,
    required super.dateOfBirth,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.country,
  });

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
    print('*******userId: $userId');
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
