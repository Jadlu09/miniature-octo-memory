import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            // Sign out button
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child:
                const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      // Rest of your home screen layout goes here
      body: const Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
