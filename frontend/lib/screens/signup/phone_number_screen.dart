import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhoneNumberScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  PhoneNumberScreen({super.key});

  Future<void> sendPhoneNumber(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': _phoneNumberController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushNamed(context, '/verification',
          arguments: _phoneNumberController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send verification code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendPhoneNumber(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
