import 'package:flutter/material.dart';
import 'package:gphone/src/helpers/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthService.signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
