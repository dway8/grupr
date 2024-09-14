import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/config/theme/app_themes.dart';
import 'package:grupr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grupr/features/auth/presentation/pages/login_page.dart';
import 'package:grupr/features/event/presentation/pages/home/event_previews.dart';
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
      ],
      child: MaterialApp(
        theme: theme(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              // Check if the user needs to complete profile setup
              bool needsProfileSetup = true; // Replace with actual logic
              if (needsProfileSetup) {
                return ProfileSetupPage(userId: state.userId);
              } else {
                return EventPreviews();
              }
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}
