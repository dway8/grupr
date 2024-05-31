import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProfileLocationScreen extends StatefulWidget {
  const ProfileLocationScreen({super.key});

  @override
  _ProfileLocationScreenState createState() => _ProfileLocationScreenState();
}

class _ProfileLocationScreenState extends State<ProfileLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  final String googleApiKey =
      dotenv.env['GOOGLE_PLACES_API_KEY'] ?? 'No API Key Found';
  final String proxyUrl = 'http://localhost:3002/places/autocomplete/json';
  List<dynamic> _predictions = [];

  double? latitude;
  double? longitude;
  String? city;
  String? country;

  Future<void> _autoCompleteSearch(String input) async {
    final String url =
        '$proxyUrl?input=$input&types=(cities)&language=en&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _predictions = data['predictions'];
        });
      } else {
        print('Failed to load predictions');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final String url =
        'http://localhost:3002/places/details/json?place_id=$placeId&language=en&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        final components = result['address_components'];

        setState(() {
          latitude = result['geometry']['location']['lat'];
          longitude = result['geometry']['location']['lng'];
          city = components.firstWhere(
              (c) => c['types'].contains('locality') ? true : false,
              orElse: () => null)?["long_name"];
          country = components.firstWhere(
              (c) => c['types'].contains('country') ? true : false,
              orElse: () => null)?["long_name"];
          _locationController.text = '$city, $country';
        });
      } else {
        print('Failed to load place details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool _isLocationValid() {
    return city != null &&
        country != null &&
        latitude != null &&
        longitude != null;
  }

  Future<void> submitProfile(
      BuildContext context, Map<String, dynamic> profileData) async {
    if (_isLocationValid()) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/profile/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${profileData['accessToken']}',
        },
        body: jsonEncode(<String, dynamic>{
          'firstName': profileData['firstName']!,
          'dateOfBirth': profileData['dob']!,
          'city': city,
          'country': country,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create profile')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid location')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      _autoCompleteSearch(_locationController.text),
                ),
              ),
              onChanged: (value) {
                _autoCompleteSearch(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(_predictions[index]['description'] ?? ''),
                    onTap: () {
                      _getPlaceDetails(_predictions[index]['place_id']);
                      setState(() {
                        _predictions = [];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submitProfile(context, profileData),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
