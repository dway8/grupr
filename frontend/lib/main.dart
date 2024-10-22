import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/config/theme/app_themes.dart';
import 'package:grupr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grupr/features/auth/presentation/pages/login_page.dart';
import 'package:grupr/features/event/domain/usecases/create_event.dart';
import 'package:grupr/features/event/domain/usecases/get_event.dart';
import 'package:grupr/features/event/domain/usecases/get_event_previews.dart';
import 'package:grupr/features/event/domain/usecases/get_my_events.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event/event_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/my_events/my_events_bloc.dart';
import 'package:grupr/features/event/presentation/pages/home/event_previews_page.dart';
import 'package:grupr/features/event/presentation/pages/my_events_page.dart';
import 'package:grupr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:grupr/features/profile/domain/usecases/update_profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:grupr/features/profile/presentation/pages/profile_page.dart';
import 'package:grupr/injection_container.dart';
import 'package:grupr/widgets/global_bottom_bar.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider<RemoteEventPreviewsBloc>(
          create: (_) => RemoteEventPreviewsBloc(sl<GetEventPreviewsUseCase>()),
        ),
        BlocProvider<MyEventsBloc>(
          create: (_) => MyEventsBloc(sl<GetMyEventsUseCase>()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
              sl<GetUserProfileUseCase>(), sl<UpdateProfileUseCase>()),
        ),
        BlocProvider<CreateEventBloc>(
          create: (context) => CreateEventBloc(sl<CreateEventUseCase>()),
        ),
        BlocProvider(
          create: (context) => EventBloc(sl<GetEventUseCase>()),
        ),
      ],
      child: MaterialApp(
        theme: theme(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final profileBloc = BlocProvider.of<ProfileBloc>(context);
              profileBloc.add(FetchUserProfile());

              return const MainLayout();
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    EventPreviewsPage(),
    MyEventsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GlobalBottomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
