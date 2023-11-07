import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  // Key to associate with the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to retrieve text field input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  // Dispose controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.lock,
                size: 48,
                color: Colors.blueGrey[100],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Pls, gib cridentiuls',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(
            height: 48,
            thickness: 1,
            color: Colors.blueGrey[100],
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                  onPressed: () => toggleVisibility(),
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  )),
              labelText: 'Password',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            obscureText: !showPassword,
          ),
          Divider(
            height: 48,
            thickness: 1,
            color: Colors.blueGrey[100],
          ),
          ElevatedButton(
            // Button to trigger sign in upon pressing
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, perform the sign-in
                await signInWithEmailAndPassword(context);
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                  vertical: 24.0,
                ))),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  // Function to handle sign-in using email and password
  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // if the widget is no longer mounted for any reasonb, just don't try to show the snackbar
      if (!mounted) return;
      // If sign-in fails, display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to sign in with Email & Password: ${e.message}')),
      );
    }
  }

  toggleVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }
}
