import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_bloc.dart';
import 'package:grupr/features/profile/presentation/bloc/profile_setup/profile_setup_state.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/first_name_page.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/address_page.dart';
import 'package:grupr/features/profile/presentation/pages/profile_setup/date_of_birth_page.dart';
import 'package:grupr/injection_container.dart';

class ProfileSetupPage extends StatelessWidget {
  final String userId;

  const ProfileSetupPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileSetupBloc>(),
      child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          try {
            if (state is ProfileSetupInitial) {
              return FirstNamePage();
            } else if (state is ProfileSetupFirstNameEntered) {
              return const AddressPage();
            } else if (state is ProfileSetupAddressEntered) {
              return const DateOfBirthPage();
            } else if (state is ProfileSetupDateOfBirthEntered) {
              // Stay on the DateOfBirthPage after DOB is entered
              return const DateOfBirthPage();
            } else if (state is ProfileSetupError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProfileSetupSuccess) {
              return const Center(child: Text('Profile setup completed!'));
            } else if (state is ProfileSetupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('Unexpected state: $state'));
            }
          } catch (e, stackTrace) {
            print('Error in ProfileSetupPage build: $e');
            print('Stack trace: $stackTrace');
            return const Center(child: Text('An unexpected error occurred'));
          }
        },
      ),
    );
  }
}
