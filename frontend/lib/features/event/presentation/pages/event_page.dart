import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_event.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_state.dart';

class EventPage extends StatelessWidget {
  final int eventId;

  const EventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    context.read<EventBloc>().add(FetchEvent(eventId));

    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is EventError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        if (state is EventLoaded) {
          final event = state.event;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                event.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Date: ${event.date}'),
                  const SizedBox(height: 8),
                  Text('Location: ${event.location}'),
                  const SizedBox(height: 8),
                  Text('Description: ${event.description}'),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
