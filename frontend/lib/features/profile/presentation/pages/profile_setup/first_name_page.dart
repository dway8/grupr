import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';

class FirstNamePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  FirstNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your First Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context
                      .read<ProfileSetupBloc>()
                      .add(SetFirstName(_controller.text));
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
