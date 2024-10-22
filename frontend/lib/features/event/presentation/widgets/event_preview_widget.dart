import 'package:flutter/material.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/presentation/pages/event_page.dart';
import 'package:intl/intl.dart';

class EventPreviewWidget extends StatelessWidget {
  final EventPreviewEntity eventPreview;

  const EventPreviewWidget({super.key, required this.eventPreview});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE d MMMM').format(eventPreview.date);
    final formattedTime = DateFormat('jm').format(eventPreview.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(eventId: eventPreview.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventPreview.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$formattedDate at $formattedTime',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
