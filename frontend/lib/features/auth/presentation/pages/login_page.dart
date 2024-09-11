import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              print('LoginPage: Received AuthAuthenticated state');
              // TODO: Navigate to home screen
              // For now, let's just print a message
              print('TODO: Navigate to home screen');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return CircularProgressIndicator();
            }
            if (state is AuthAuthenticated) {
              return Text('Logged in successfully!');
            }
            return ElevatedButton(
              child: Text('Login with Auth0'),
              onPressed: () {
                context.read<AuthBloc>().add(LoginRequested());
              },
            );
          },
        ),
      ),
    );
  }
}
