import 'dart:convert';

import 'package:ecopiatsa/pages/DiscoverDr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverSignUp.dart';
import 'driver.dart';

void main() {
  runApp(MaterialApp(
    home:DriverSignIn(),
  ));
}

class DriverSignIn extends StatefulWidget {
  const DriverSignIn({Key? key}) : super(key: key);

  @override
  _DriverSignInState createState() => _DriverSignInState();
}

// Save the user ID
Future<void> saveUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', userId);
}

// Retrieve user ID from shared preferences
Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}

class _DriverSignInState extends State<DriverSignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login(String username, String password) async {
    final url = Uri.parse('http://192.168.68.113:5000/driver_login');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userId = responseData['user_id'];
      await saveUserId(userId);
      Driver.loggedInUserId = userId;
      Driver.username = responseData['username'];
      Driver.firstName = responseData['first_name'];
      Driver.lastName = responseData['last_name'];
      Driver.email = responseData['email'];
      Driver.password = responseData['password'];
      Driver.date_of_birth = responseData['date_of_birth'];
      Driver.telephone = responseData['telephone'];
      Driver.car_model = responseData['car_model'];
      Driver.car_number = responseData['car_number'];
      Driver.car_year = responseData['car_year'];
      Driver.car_colour = responseData['car_colour'];
      Driver.car_consumption = responseData['car_consumption'];

      // Successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiscoverDr()),
      );
    } else {
      // Login failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Invalid username or password"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundsecond.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Welcome back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Hero(
                    tag: 'LoginImage',
                    child: Image.asset('assets/backgroundsecond.png'),
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(usernameController.text, passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0x00618264),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't you have an account?"),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DriverSignUp()),
                          );
                        },
                        child: const Text('Sign Up'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
