class CreateProfileModel {
  final String firstName;
  final DateTime dateOfBirth;
  final String city;
  final double latitude;
  final double longitude;
  final String country;

  CreateProfileModel({
    required this.firstName,
    required this.dateOfBirth,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory CreateProfileModel.fromJson(Map<String, dynamic> json) {
    return CreateProfileModel(
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
      'firstName': firstName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
    };
  }
}
