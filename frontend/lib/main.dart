import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/config/theme/app_themes.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_event.dart';
import 'package:grupr/features/event/presentation/pages/home/event_previews.dart';
import 'package:grupr/injection_container.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteEventPreviewsBloc>(
      create: (context) => sl()..add(const GetEventPreviews()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: const EventPreviews()),
    );
  }
}
