class CreateProfile {
  final String firstName;
  final DateTime dateOfBirth;
  final String city;
  final double latitude;
  final double longitude;
  final String country;

  CreateProfile({
    required this.firstName,
    required this.dateOfBirth,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
  });
}
