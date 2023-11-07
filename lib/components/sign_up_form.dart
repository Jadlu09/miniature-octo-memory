import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Key to associate with the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to retrieve text field input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordMachingController =
      TextEditingController();

  // Dispose controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordMachingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordMachingController,
            decoration: const InputDecoration(labelText: 'Confirm password'),
            validator: (value) => value!.isEmpty
                ? 'Please confirm your poassword'
                : (value != _passwordController.text
                    ? 'Passwords do not match'
                    : null),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            // Button to trigger sign in upon pressing
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, perform the sign-in
                await signUpWithEmailAndPassword(context);
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  // Function to handle sign-in using email and password
  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // if the widget is no longer mounted for any reasonb, just don't try to show the snackbar
      if (!mounted) return;

      // If sign-up fails, display an error message to the user
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('The password provided is too weak. Please try again.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('The account already exists for that email.')),
        );
      }
    }
  }
}
