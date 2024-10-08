import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_state.dart';

class EventPreviewsPage extends StatelessWidget {
  const EventPreviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('Events', style: TextStyle(color: Colors.black)),
    );
  }

  _buildBody() {
    return BlocBuilder<RemoteEventPreviewsBloc, RemoteEventPreviewsState>(
        builder: (_, state) {
      if (state is RemoteEventPreviewsLoading) {
        return const Center(child: CupertinoActivityIndicator());
      }

      if (state is RemoteEventPreviewsError) {
        return const Center(child: Icon(Icons.refresh));
      }

      if (state is RemoteEventPreviewsLoaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('$index'),
            );
          },
          itemCount: state.eventPreviews!.length,
        );
      }
      return const SizedBox();
    });
  }
}
