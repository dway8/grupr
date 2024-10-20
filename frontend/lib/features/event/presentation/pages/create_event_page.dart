import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grupr/features/event/presentation/bloc/create_event/create_event_event.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  CreateEventPageState createState() => CreateEventPageState();
}

class CreateEventPageState extends State<CreateEventPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _descriptionController = TextEditingController();
  double? _latitude;
  double? _longitude;

  void _onPlaceSelected(Prediction prediction) {
    setState(() {
      _locationController.text = prediction.description ?? '';
      _latitude = 0; // TODO
      _longitude = 0;
    });
  }

  Future<void> _submitEvent() async {
    if (_selectedDate != null && _selectedTime != null) {
      DateTime startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      context.read<CreateEventBloc>().add(SubmitEvent(
            name: _nameController.text,
            location: _locationController.text,
            date: startDateTime,
            description: _descriptionController.text,
            latitude: _latitude ?? 0,
            longitude: _longitude ?? 0,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            GooglePlaceAutoCompleteTextField(
              textEditingController: _locationController,
              googleAPIKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
              inputDecoration: const InputDecoration(labelText: 'Location'),
              debounceTime: 800,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                _onPlaceSelected(prediction);
              },
              itemClick: (Prediction prediction) {
                _onPlaceSelected(prediction);
              },
            ),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedTime == null
                    ? 'Select Start Time'
                    : 'Start Time: ${_selectedTime!.format(context)}',
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitEvent,
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
