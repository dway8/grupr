import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';
import 'package:grupr/features/auth/presentation/bloc/auth_bloc.dart';

class DateOfBirthPage extends StatefulWidget {
  const DateOfBirthPage({super.key});

  @override
  State<DateOfBirthPage> createState() => _DateOfBirthPageState();
}

class _DateOfBirthPageState extends State<DateOfBirthPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<ProfileSetupBloc>().add(SetDateOfBirth(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Date of Birth')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate != null
                  ? 'Selected: ${_selectedDate!.toLocal().toString().split(' ')[0]}'
                  : 'Select Date of Birth'),
            ),
            const SizedBox(height: 20),
            if (_selectedDate != null)
              ElevatedButton(
                onPressed: () {
                  print('Submit button pressed');
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    print(
                        'Dispatching SubmitProfile event with userId: ${authState.userId}');
                    context
                        .read<ProfileSetupBloc>()
                        .add(SubmitProfile(authState.userId));
                  } else {
                    print('User not authenticated');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not authenticated')),
                    );
                  }
                },
                child: const Text('Submit Profile'),
              ),
          ],
        ),
      ),
    );
  }
}
