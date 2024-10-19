import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Preview'),
              Tab(text: 'Edit'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfilePreview(),
            ProfileEdit(),
          ],
        ),
      ),
    );
  }
}

class ProfilePreview extends StatelessWidget {
  const ProfilePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;

    if (state is ProfileLoaded) {
      final profile = state.profile;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${profile.firstName}'),
            Text(
                'Date of Birth: ${DateFormat('yMMMd').format(profile.dateOfBirth)}'),
            Text('City: ${profile.city}'),
            Text('Country: ${profile.country}'),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Profile not loaded.'));
    }
  }
}

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;

    if (state is ProfileLoaded) {
      final profile = state.profile;

      final firstNameController =
          TextEditingController(text: profile.firstName);
      final dateOfBirthController = TextEditingController(
          text: DateFormat('yMMMd').format(profile.dateOfBirth));
      final cityController = TextEditingController(text: profile.city);
      final countryController = TextEditingController(text: profile.country);

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: dateOfBirthController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedProfile = Profile(
                  firstName: firstNameController.text,
                  dateOfBirth: DateTime.parse(dateOfBirthController.text),
                  city: cityController.text,
                  country: countryController.text,
                  latitude: profile.latitude,
                  longitude: profile.longitude,
                );
                context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Profile not loaded.'));
    }
  }
}
