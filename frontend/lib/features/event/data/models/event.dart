import 'package:grupr/features/event/domain/entities/event.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.name,
    required super.location,
    required super.date,
    required super.description,
    required super.latitude,
    required super.longitude,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
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
      'id': id,
      'name': name,
      'location': location,
      'date': date.toIso8601String(),
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
