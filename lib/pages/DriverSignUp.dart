
import 'dart:convert';

import 'package:ecopiatsa/pages/secondpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'textfield.dart' as myTextField;

class DriverSignUp extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final colourController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final numberController = TextEditingController();
  final consumptionController = TextEditingController();
  DateTime? dateofbirth;

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != dateofbirth) {
    // If a date is selected, update the state
    dateofbirth = picked;
    // You can also update the UI by calling setState here if needed
  }
}

Future<void> signup(BuildContext context, String first_name, String last_name, String username,
      String password, String email, String telephone, String? date_of_birth, String car_number, String car_model, String car_colour, String car_year, String car_consumption) async {
    
    String? firstNameError = _validateField(first_name, 'First Name');
    String? lastnameError = _validateField(last_name, 'Last Name');
    String? usernameError = _validateField(username, 'Username');
    String? passwordError = _validateField(password, 'Password');
    String? emailError = _validateField(email, 'Email');
    String? phoneError = _validateField(telephone, 'Telephone');
    String dateOfBirthString = date_of_birth.toString();
    String? car_numbeError = _validateField(car_number, 'Car number');
    String? car_modelError = _validateField(car_model, 'Car model');
    String? car_colourError = _validateField(car_colour, 'Car colour');
    String? car_yearError = _validateField(car_year, 'Car Year');
    String? car_consumptionError = _validateField(car_consumption, 'Car Consumption');
    

        final url = Uri.parse('http://192.168.68.113:5000/driver_signup');
    //String dateOfBirthString = date_of_birth?.toIso8601String() ?? '';
    Map<String, dynamic> requestBody = {
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'password': password,
      'email': email,
      'telephone': telephone,
      'date_of_birth': date_of_birth,
      'car_number': car_number,
      'car_model': car_model,
      'car_colour': car_colour,
      'car_year': car_year,
      'car_consumption': car_consumption
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
        MaterialPageRoute(builder: (context) => SecondPage ()),
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
        title: Text('Driver Sign Up'),
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

              myTextField.MyTextField(controller: firstNameController, hintText: 'First Name', obscureText: false),
              SizedBox(height: 10),
              myTextField.MyTextField(controller: lastNameController, hintText: 'Last Name', obscureText: false),
              SizedBox(height: 10),
              myTextField.MyTextField(controller: usernameController, hintText: 'Username', obscureText: false),
              SizedBox(height: 10),
              myTextField.MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
              SizedBox(height: 10),
              myTextField.MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
              SizedBox(height: 10),
              myTextField.MyTextField(controller: telephoneController, hintText: 'Telephone', obscureText: false),
              SizedBox(height: 10),
              MyTextField(controller: modelController, hintText: 'Model'),
              SizedBox(height: 10),
              MyTextField(controller: colourController, hintText: 'Colour'),
              SizedBox(height: 10),
              MyTextField(controller: numberController, hintText: 'Number'),
              SizedBox(height: 10),
              MyTextField(controller: consumptionController, hintText: 'Consumption'),
              SizedBox(height: 10),
              MyTextField(controller: yearController, hintText: 'Year', numericOnly :true ),
              SizedBox(height: 10),

              ChooseFromCameraBox(hintText: 'Scan the traffic license'),
              
              SizedBox(height: 16.0),
              // Date of Birth text without input
              // Date of Birth text with input
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
      GestureDetector(
        onTap: () {
          _selectDate(context); // Call function to show the date picker
        },
        child: Text(
          dateofbirth != null
              ? '${dateofbirth!.day}/${dateofbirth!.month}/${dateofbirth!.year}'
              : 'Select date',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    ],
  ),
),

              // ID box with camera icon on the right
              ChooseFromCameraBox(hintText: 'Scan your ID'),

              // License box with camera icon on the right
              ChooseFromCameraBox(hintText: 'Scan your license'),

              // Button for "Car Details"
              SizedBox(height: 16.0),

              // Sign Up button
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{
                    await signup(context, firstNameController.text, lastNameController.text, usernameController.text, passwordController.text, emailController.text, telephoneController.text, dateofbirth.toString(), numberController.text,modelController.text,  colourController.text, yearController.text, consumptionController.text);
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
  final bool numericOnly;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
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
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: const Color(0xFF4d7c0f)),
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
            onPressed: () {
              // Implement your camera scanning logic here for $hintText
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Scan with camera'),
                  content: Text('Implement your camera scanning logic here for $hintText.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
}
