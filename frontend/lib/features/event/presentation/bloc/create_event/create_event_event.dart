import 'package:equatable/equatable.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends CreateEventEvent {
  final String name;
  final String location;
  final DateTime date;
  final String description;
  final double latitude;
  final double longitude;

  const SubmitEvent({
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props =>
      [name, location, date, description, latitude, longitude];
}
