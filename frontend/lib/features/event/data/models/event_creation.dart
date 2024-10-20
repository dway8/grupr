import 'package:grupr/features/event/domain/entities/event_creation.dart';

class EventCreationModel extends EventCreationEntity {
  const EventCreationModel({
    required super.name,
    required super.location,
    required super.date,
    required super.description,
    required super.latitude,
    required super.longitude,
  });

  factory EventCreationModel.fromJson(Map<String, dynamic> json) {
    return EventCreationModel(
      name: json['name'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'date': date.toIso8601String(),
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
