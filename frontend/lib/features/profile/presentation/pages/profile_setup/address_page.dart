import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_event.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(0, 0);
  String _selectedCity = '';
  String _selectedCountry = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.animateCamera(CameraUpdate.newLatLng(_selectedLocation));
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    // Here you would typically use a geocoding service to get the city and country
    // For this example, we'll just use placeholder values
    setState(() {
      _selectedCity = 'Sample City';
      _selectedCountry = 'Sample Country';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Location')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: (LatLng latLng) {
                setState(() {
                  _selectedLocation = latLng;
                });
                _getAddressFromLatLng();
              },
              markers: {
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: _selectedLocation,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Selected City: $_selectedCity'),
                Text('Selected Country: $_selectedCountry'),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileSetupBloc>().add(
                          SetAddress(
                            city: _selectedCity,
                            latitude: _selectedLocation.latitude,
                            longitude: _selectedLocation.longitude,
                            country: _selectedCountry,
                          ),
                        );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
