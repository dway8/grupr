import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_event.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_state.dart';
import 'package:grupr/features/event/presentation/widgets/event_preview_widget.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<MyEventsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyEventsBloc>().add(const GetMyEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events', style: TextStyle(color: Colors.black)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MyEventsBloc, MyEventsState>(
      builder: (_, state) {
        if (state is MyEventsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyEventsError) {
          return const Center(child: Icon(Icons.refresh));
        }

        if (state is MyEventsLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return EventPreviewWidget(
                  eventPreview: state.eventPreviews[index]);
            },
            itemCount: state.eventPreviews.length,
          );
        }
        return const SizedBox();
      },
    );
  }
}
