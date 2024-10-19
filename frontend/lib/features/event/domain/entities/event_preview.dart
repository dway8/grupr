import 'package:equatable/equatable.dart';

class EventPreviewEntity extends Equatable {
  final int id;
  final String name;
  final DateTime date;
  final num latitude;
  final num longitude;
  final String? imageUrl;

  const EventPreviewEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      date,
      latitude,
      longitude,
      imageUrl,
    ];
  }
}
