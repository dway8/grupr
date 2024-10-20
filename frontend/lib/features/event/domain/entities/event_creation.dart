import 'package:equatable/equatable.dart';

class EventCreationEntity extends Equatable {
  final String name;
  final String location;
  final DateTime date;
  final String description;
  final double latitude;
  final double longitude;

  const EventCreationEntity({
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        name,
        location,
        date,
        description,
        latitude,
        longitude,
      ];
}
