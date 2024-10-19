import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/domain/entities/event_preview.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_event.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_state.dart';
import 'package:grupr/features/profile/presentation/pages/profile_page.dart';
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
    return MaterialApp(
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('Events', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: const Material(
              elevation: 4,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBody() {
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
    });
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
