import 'package:flutter/material.dart';

class ProfileFirstNameScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();

  ProfileFirstNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final accessToken = arguments['accessToken'];

    return Scaffold(
      appBar: AppBar(title: const Text('Enter First Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/profile-dob',
                  arguments: {
                    'accessToken': accessToken,
                    'firstName': _firstNameController.text,
                  },
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
