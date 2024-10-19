import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_event.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_state.dart';
import 'package:intl/intl.dart';

class EventPreviewsPage extends StatefulWidget {
  const EventPreviewsPage({super.key});

  @override
  EventPreviewsPageState createState() => EventPreviewsPageState();
}

class EventPreviewsPageState extends State<EventPreviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RemoteEventPreviewsBloc>().add(const GetEventPreviews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events', style: TextStyle(color: Colors.black)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<RemoteEventPreviewsBloc, RemoteEventPreviewsState>(
      builder: (_, state) {
        if (state is RemoteEventPreviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RemoteEventPreviewsError) {
          return const Center(child: Icon(Icons.refresh));
        }

        if (state is RemoteEventPreviewsLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return _buildEventPreview(state.eventPreviews![index]);
            },
            itemCount: state.eventPreviews!.length,
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEventPreview(EventPreviewEntity eventPreview) {
    final formattedDate = DateFormat('EEEE d MMMM').format(eventPreview.date);
    final formattedTime = DateFormat('jm').format(eventPreview.date);

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to the event page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage(eventPreview: eventPreview)));
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
