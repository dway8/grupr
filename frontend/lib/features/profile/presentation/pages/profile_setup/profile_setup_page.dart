import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_state.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/address_page.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/date_of_birth_page.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/first_name_page.dart';
import 'package:grupr/injection_container.dart';

class ProfileSetupPage extends StatelessWidget {
  final String userId;

  const ProfileSetupPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileSetupBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Profile Setup')),
        body: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (context, state) {
            if (state is ProfileSetupInitial) {
              return FirstNamePage();
            } else if (state is ProfileSetupFirstNameEntered) {
              return AddressPage();
            } else if (state is ProfileSetupAddressEntered) {
              return DateOfBirthPage();
            } else if (state is ProfileSetupLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is ProfileSetupSuccess) {
              // Navigate to the next screen after successful profile setup
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/home');
              });
              return const Scaffold(
                body: Center(child: Text('Profile created successfully!')),
              );
            } else if (state is ProfileSetupError) {
              return Scaffold(
                body: Center(child: Text('Error: ${state.message}')),
              );
            }
            return const Scaffold(
              body: Center(child: Text('Unexpected state')),
            );
          },
        ),
      ),
    );
  }
}
