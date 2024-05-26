import 'package:flutter/material.dart';
import 'screens/phone_number_screen.dart';
import 'screens/verification_code_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      },
    );
  }
}
