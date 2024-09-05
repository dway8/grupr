import 'package:equatable/equatable.dart';

class EventPreviewEntity extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String date;
  final String city;
  final num latitude;
  final num longitude;
  final String createdAt;

  const EventPreviewEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.date,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      imageUrl,
      date,
      city,
      latitude,
      longitude,
      createdAt,
    ];
  }
}
