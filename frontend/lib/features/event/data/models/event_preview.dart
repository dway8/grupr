import 'package:grupr/features/event/domain/entities/event_preview.dart';

class EventPreviewModel extends EventPreviewEntity {
  const EventPreviewModel({
    required super.id,
    required super.name,
    super.imageUrl,
    required super.date,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.createdAt,
  });

  factory EventPreviewModel.fromJson(Map<String, dynamic> map) {
    return EventPreviewModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      date: map['date'],
      city: map['city'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'date': date,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
    };
  }
}
