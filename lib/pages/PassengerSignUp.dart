import 'dart:convert';

import 'package:ecopiatsa/pages/Discover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class PassengerSignUp extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController cardnameController = TextEditingController();
  final TextEditingController cardnumberController = TextEditingController();
  final TextEditingController carddateController = TextEditingController();
  final TextEditingController cardcvvController = TextEditingController();
  DateTime? dateofbirth;


Future<void> signup(BuildContext context, String first_name, String last_name, String username,
      String password, String email, String telephone, String card_name, String date_of_birth, String card_number, String cvv, String exp_date ) async {
    
    String? firstNameError = _validateField(first_name, 'First Name');
    String? lastnameError = _validateField(last_name, 'Last Name');
    String? usernameError = _validateField(username, 'Username');
    String? passwordError = _validateField(password, 'Password');
    String? emailError = _validateField(email, 'Email');
    String? phoneError = _validateField(telephone, 'Telephone');
    String dateOfBirthString = date_of_birth.toString();
    String? cardnameError = _validateField(card_name, 'Card name');
    String? cardnumberError = _validateField(card_number, 'Card number');
    String? cardcvvError = _validateField(cvv, 'CVV');
    String? cardexpdateError = _validateField(exp_date, 'Exp. Date');
    

        final url = Uri.parse('http://192.168.68.113:5000/passenger_signup');

    Map<String, dynamic> requestBody = {
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'password': password,
      'email': email,
      'telephone': telephone,
      'date_of_birth': date_of_birth,
      'card_name': card_name,
      'card_number': card_number,
      'cvv': cvv,
      'exp_date': exp_date
    };

    String data = jsonEncode(requestBody);

    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Discover ()),
      );
    } else {
      // Login failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("SignUp Failed"),
            content: const Text(
                "You are trying to sign up with invalid information"),
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

  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null; // Return null if validation succeeds
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Sign Up',
                style: TextStyle(
                  color: const Color(0xFF4d7c0f),
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 25),

              MyTextField(controller: firstNameController, hintText: 'First Name', obscureText: false),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: lastNameController, hintText: 'Last Name', obscureText: false),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: usernameController, hintText: 'Username', obscureText: false),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: telephoneController, hintText: 'Telephone', obscureText: false),
              SizedBox(height: 20), // Add larger spacing

              // Date of Birth text without input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text('📅', style: TextStyle(fontSize: 24.0)),
                  ],
                ),
              ),
              SizedBox(height: 20), // Add spacing

              // Payment Info text
              Text(
                'Payment Info',
                style: TextStyle(
                  color: const Color(0xFF4d7c0f),
                  fontSize: 20.0,
                ),
              ),

              MyTextField(controller: cardnameController, hintText: 'Name', obscureText: false),
              SizedBox(height: 10), // Add spacing
              MyTextField(controller: cardnumberController, hintText: 'Card Number', obscureText: false, numericOnly: true),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(controller: carddateController, hintText: 'Exp. Date', obscureText: false, numericOnly: true),
                  ),
                  SizedBox(width: 10), // Add spacing between text fields
                  Expanded(
                    child: MyTextField(controller: cardcvvController, hintText: 'CVV', obscureText: false, numericOnly: true),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add spacing
              // ID box with camera icon on the right
              ChooseFromCameraBox(hintText: 'Scan your ID'),

              // Sign Up button
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await signup(context, firstNameController.text, lastNameController.text, usernameController.text, passwordController.text, emailController.text, telephoneController.text, cardnameController.text, dateofbirth.toString(), cardnumberController.text, cardcvvController.text, carddateController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d7c0f),
                  foregroundColor: Colors.lightGreenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool numericOnly;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.numericOnly = false,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.numericOnly ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.numericOnly
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFF4d7c0f)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFF4d7c0f)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}

class ChooseFromCameraBox extends StatelessWidget {
  final String hintText;

  ChooseFromCameraBox({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Text widget instead of TextField
          Expanded(
            child: Text(
              hintText,
              style: TextStyle(
                color: Colors.black, // Set the color as needed
                fontSize: 16.0, // Set the font size as needed
              ),
            ),
          ),

          // Spacer to add some space between the text and the camera icon
          SizedBox(width: 8.0),

          // Camera icon on the right
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

              if (pickedFile != null) {
                // Do something with the picked image file (pickedFile.path)
                print('Image path: ${pickedFile.path}');

                // Save the image path to a variable or list for later use
                String imagePath = pickedFile.path;
                // You may want to store the imagePath in a state variable or a list
                // so that it can be accessed later when needed.

                // If you want to display the image or perform other actions,
                // you can use the imagePath accordingly.
              }

            },
          ),
        ],
      ),
    );
  }
}
