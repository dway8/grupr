import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerificationCodeScreen extends StatelessWidget {
  final TextEditingController _verificationCodeController =
      TextEditingController();

  VerificationCodeScreen({super.key});

  Future<void> verifyCode(BuildContext context, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'verificationCode': _verificationCodeController.text,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody['access_token'];
      Navigator.pushNamed(
        context,
        '/profile-firstname',
        arguments: {'accessToken': accessToken},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to verify code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _verificationCodeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyCode(context, phoneNumber),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
