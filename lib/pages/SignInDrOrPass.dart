import 'package:flutter/material.dart';

import 'DriverSignIn.dart';
import 'PassengerSignIn.dart';

class SignInDrOrPass extends StatelessWidget {
  void driver(BuildContext context) {
    // Navigate to the signup page
    // Replace SignUpPage() with the actual widget for your signup page
    Navigator.push(context, MaterialPageRoute(builder: (context) => DriverSignIn()));
  }
  void passenger(BuildContext context) {
    // Navigate to the signup page
    // Replace SignUpPage() with the actual widget for your signup page
    Navigator.push(context, MaterialPageRoute(builder: (context) => PassengerSignIn()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose how you want to sign in'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgroundsecond.png',
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
                        driver(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4d7c0f)),
                      ),
                      child: Text(
                        'Driver',
                        style: TextStyle(
                          color: const Color(0xFFffecfccc),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        passenger(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFffecfccc)),
                      ),
                      child: Text(
                        'Passenger',
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

