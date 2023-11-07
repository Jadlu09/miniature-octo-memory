import 'package:flutter/material.dart';

import '../components/sign_in_form.dart';
import '../components/sign_up_form.dart';

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
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Center(
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
                          // transition between the two widgets using an AnimatedSwitcher
                          child: AnimatedSwitcher(
                            // set animation duration
                            duration: const Duration(milliseconds: 300),
                            // use a transition builder to determine the direction of the animation
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              // Determine the direction of the animation based on the key
                              // the animated switcher takes care of running the animation forwards and in reverse
                              // the builder is called twice, immediately, once for each widget

                              // the inAnimation slides things in from the right and out to the right
                              final inAnimation = Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation);

                              // the outAnimation slides things in from the left and out to the left
                              final outAnimation = Tween<Offset>(
                                begin: const Offset(-1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation);

                              // apply the correct transitions based on the widgets that is transitioned
                              return child.key == const ValueKey('SignUpForm')
                                  ? SlideTransition(
                                      position: inAnimation,
                                      child: child,
                                    )
                                  : SlideTransition(
                                      position: outAnimation,
                                      child: child,
                                    );
                            },
                            // give the two widgets string keys so that we can know how to handle the transitions.
                            child: type == 'Sign In'
                                ? const SignInForm(key: ValueKey('SignInForm'))
                                : const SignUpForm(key: ValueKey('SignUpForm')),
                          ),
                        ),
                      ),
                    ),
                    // navigation button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(type == 'Sign In'
                            ? 'Don\'t have an account?'
                            : 'Already have an account?'),
                        TextButton(
                          // button to navigate to sign up screen
                          onPressed: () {
                            setState(() {
                              type = type == 'Sign In' ? 'Sign Up' : 'Sign In';
                            });
                          },
                          child:
                              Text(type == 'Sign In' ? 'Sign Up' : 'Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
