import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/config/theme/app_themes.dart';
import 'package:grupr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grupr/features/auth/presentation/pages/login_page.dart';
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
    return MaterialApp(
      theme: theme(),
      home: BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: LoginPage(),
      ),
    );
  }
}
