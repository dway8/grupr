import 'package:grupr/features/event/domain/entities/event_preview.dart';

class EventPreviewModel extends EventPreviewEntity {
  const EventPreviewModel({
    required super.id,
    required super.name,
    required super.date,
    required super.latitude,
    required super.longitude,
    super.imageUrl,
  });

  factory EventPreviewModel.fromJson(Map<String, dynamic> map) {
    return EventPreviewModel(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }
}
