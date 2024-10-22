import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_event.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_state.dart';
import 'package:grupr/features/event/presentation/widgets/event_preview_widget.dart';

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
              return EventPreviewWidget(
                  eventPreview: state.eventPreviews![index]);
            },
            itemCount: state.eventPreviews!.length,
          );
        }
        return const SizedBox();
      },
    );
  }
}
