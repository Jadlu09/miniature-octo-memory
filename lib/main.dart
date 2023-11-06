import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

// Widget to determine whether to show Authentication or Home screen
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Using StreamBuilder to listen to authentication state changes
    return StreamBuilder(
      // Subscribing to the auth state changes stream
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, it means user is signed in
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const FormScreen();
        }
      },
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String type = 'Sign In';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),
      // a center widget to center the content on both axis
      body: Center(
        // a column to display the content of the page
        child: Column(
          // the column should onbly take the minimum amount of neccesary space on main axis (vertical)
          mainAxisSize: MainAxisSize.min,
          children: [
            // some padding from the edges of the screen
            Padding(
              padding: const EdgeInsets.all(16.0),
              // a material card to hold the form
              child: Card(
                // some padding inside the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Form widget to validate and save user input
                  child: type == 'Sign In'
                      ? const SignInForm()
                      : const SignUpForm(),
                ),
              ),
            ),
            // navigation button
            TextButton(
              // button to navigate to sign up screen
              onPressed: () {
                setState(() {
                  type = type == 'Sign In' ? 'Sign Up' : 'Sign In';
                });
              },
              child: Text(type == 'Sign In'
                  ? 'Don\'t have an account? Sign Up'
                  : 'Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Sign-In Screen
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
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            obscureText: true,
          ),
          ElevatedButton(
            // Button to trigger sign in upon pressing
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, perform the sign-in
                await signInWithEmailAndPassword(context);
              }
            },
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
      if (!mounted) return;
      // If sign-in fails, display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to sign in with Email & Password: ${e.message}')),
      );
    }
  }
}

// Widget for Sign-In Screen
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
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            obscureText: true,
          ),
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

// HomeScreen widget (where the user lands after sign-in)
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
