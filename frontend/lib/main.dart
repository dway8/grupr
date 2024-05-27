import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup/phone_number_screen.dart';
import 'screens/signup/profile_dob_screen.dart';
import 'screens/signup/profile_firstname_screen.dart';
import 'screens/signup/profile_location_screen.dart';
import 'screens/signup/verification_code_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PhoneNumberScreen(),
        '/verification': (context) => VerificationCodeScreen(),
        '/profile-firstname': (context) => ProfileFirstNameScreen(),
        '/profile-dob': (context) => const ProfileDobScreen(),
        '/profile-location': (context) => const ProfileLocationScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
