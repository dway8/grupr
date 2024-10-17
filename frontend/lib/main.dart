import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/config/theme/app_themes.dart';
import 'package:grupr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grupr/features/auth/presentation/pages/login_page.dart';
import 'package:grupr/features/event/domain/usecases/get_event_previews.dart';
import 'package:grupr/features/event/presentation/bloc/event_preview/remote/remote_event_previews_bloc.dart';
import 'package:grupr/features/event/presentation/pages/home/event_previews_page.dart';
import 'package:grupr/features/profile/domain/usecases/get_user_profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/profile_setup_page.dart';
import 'package:grupr/injection_container.dart';

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
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(sl<GetUserProfileUseCase>()),
        ),
      ],
      child: MaterialApp(
        theme: theme(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final profileBloc = BlocProvider.of<ProfileBloc>(context);
              profileBloc.add(FetchUserProfile());

              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  print('Profile state: $profileState');
                  if (profileState is ProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (profileState is ProfileNotFound) {
                    return ProfileSetupPage(userId: state.userId);
                  } else if (profileState is ProfileLoaded) {
                    return const EventPreviewsPage();
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}
