import 'package:flutter/material.dart';

import 'SignInDrOrPass.dart';
import 'SignUpDrOrPass.dart';

class SecondPage extends StatelessWidget {
  void signUp(BuildContext context) {
    // Navigate to the signup page
    // Replace SignUpPage() with the actual widget for your signup page
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpDrOrPass()));
  }
  void signIn(BuildContext context) {
    // Navigate to the signup page
    // Replace SignUpPage() with the actual widget for your signup page
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInDrOrPass()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up/ Sign In'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgroundsecond.png', // Replace with your actual image path
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        signUp(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4d7c0f)),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: const Color(0xFFffecfccc),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        signIn(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFffecfccc)),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: const Color(0xFF4d7c0f),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for SignUpPage
class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Center(
        child: Text(
          'This is the Sign Up page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
