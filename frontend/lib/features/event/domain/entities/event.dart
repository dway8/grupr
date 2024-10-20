import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String name;
  final String location;
  final DateTime date;
  final String description;
  final num latitude;
  final num longitude;

  const EventEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        date,
        description,
        latitude,
        longitude,
      ];
}
