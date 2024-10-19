import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/domain/entities/profile.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_event.dart';
import 'package:grupr/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void switchToPreviewTab() {
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Preview'),
            Tab(text: 'Edit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProfilePreview(),
          ProfileEdit(),
        ],
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateOfBirthController,
                    readOnly: true,
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: profile.dateOfBirth,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        dateOfBirthController.text =
                            DateFormat('yMMMd').format(selectedDate);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: profile.dateOfBirth,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      dateOfBirthController.text =
                          DateFormat('yMMMd').format(selectedDate);
                    }
                  },
                ),
              ],
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
                  dateOfBirth:
                      DateFormat('yMMMd').parse(dateOfBirthController.text),
                  city: cityController.text,
                  country: countryController.text,
                  latitude: profile.latitude,
                  longitude: profile.longitude,
                );

                context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile updated successfully!')),
                );

                final profilePageState =
                    context.findAncestorStateOfType<ProfilePageState>();
                profilePageState?.switchToPreviewTab();
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
