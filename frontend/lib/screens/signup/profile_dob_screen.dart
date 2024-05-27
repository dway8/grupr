import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDobScreen extends StatefulWidget {
  const ProfileDobScreen({super.key});

  @override
  _ProfileDobScreenState createState() => _ProfileDobScreenState();
}

class _ProfileDobScreenState extends State<ProfileDobScreen> {
  final TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final accessToken = arguments['accessToken'];
    final firstName = arguments['firstName'];

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Date of Birth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/profile-location',
                  arguments: {
                    'accessToken': accessToken,
                    'firstName': firstName,
                    'dob': _dobController.text,
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
