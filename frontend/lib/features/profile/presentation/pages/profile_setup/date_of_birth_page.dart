import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';

class DateOfBirthPage extends StatelessWidget {
  const DateOfBirthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Date of Birth')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now()
                      .subtract(const Duration(days: 6570)), // 18 years ago
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now()
                      .subtract(const Duration(days: 6570)), // 18 years ago
                );
                if (picked != null) {
                  context.read<ProfileSetupBloc>().add(SetDateOfBirth(picked));
                }
              },
              child: const Text('Select Date of Birth'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Assuming you have access to the userId here
                // You might need to pass it through the constructor or get it from a user service
                String userId = 'example_user_id';
                context.read<ProfileSetupBloc>().add(SubmitProfile(userId));
              },
              child: const Text('Submit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
