import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String _selectedCity = '';
  String _selectedCountry = '';
  double _latitude = 0;
  double _longitude = 0;

  final _cityController = TextEditingController();

  void _onPlaceSelected(Prediction prediction) {
    setState(() {
      _selectedCity = prediction.description?.split(',').first ?? '';
      _selectedCountry = prediction.description?.split(',').last.trim() ?? '';
      _cityController.text = prediction.description ?? '';
      // Note: This package doesn't provide lat/lng directly. You might need to use another API call to get coordinates if needed.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: _cityController,
              googleAPIKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
              inputDecoration: const InputDecoration(
                labelText: 'City',
                suffixIcon: Icon(Icons.search),
              ),
              debounceTime: 800,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                _onPlaceSelected(prediction);
              },
              itemClick: (Prediction prediction) {
                _onPlaceSelected(prediction);
              },
            ),
            SizedBox(height: 20),
            Text('Selected City: $_selectedCity'),
            Text('Selected Country: $_selectedCountry'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileSetupBloc>().add(
                      SetAddress(
                        city: _selectedCity,
                        latitude: _latitude,
                        longitude: _longitude,
                        country: _selectedCountry,
                      ),
                    );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
