import 'dart:convert';

import 'package:ecopiatsa/pages/settingspassenger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPaymentsScreen extends StatefulWidget {
  final int userId; // Add user ID as a parameter

  const MyPaymentsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MyPaymentsScreenState createState() => _MyPaymentsScreenState();
}

class _MyPaymentsScreenState extends State<MyPaymentsScreen> {
  String cardName = '';
  String cardNumber = '';
  String cvv = '';
  String expDate = '';

  @override
  void initState() {
    super.initState();

    // Fetch card details for the specified user ID
    fetchCardDetails(widget.userId);
  }

  // Function to fetch card details from the server
  Future<void> fetchCardDetails(int userId) async {
    print('Fetching card details for user ID: $userId');
    final url = Uri.parse('http://192.168.68.113:5000/card_details?user_id=$userId');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response from the server: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the JSON response
      dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic> && responseData.containsKey('user_info')) {
        var userInfo = responseData['user_info'];
        setState(() {
          // Update state with fetched card details
          cardName = userInfo['card_name']?.toString() ?? 'empty';
          cardNumber = userInfo['card_number']?.toString() ?? 'empty';
          cvv = userInfo['cvv']?.toString() ?? 'empty';
          expDate = userInfo['exp_date']?.toString() ?? 'empty';
        });
      } else {
        // Handle the case when the response is not in the expected format
        print('Invalid response format or missing "user_info" key');
      }
    } else {
      // Handle error
      print('Failed to fetch card details: ${response.statusCode}');
    }
  }

  void _editCard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCardScreen(
          userId: widget.userId,
          initialCardName: cardName,
          initialCardNumber: cardNumber,
          initialCvv: cvv,
          initialExpDate: expDate,
        ),
      ),
    ).then((editedCardDetails) {
      if (editedCardDetails != null) {
        // Update the state with edited card details
        setState(() {
          cardName = editedCardDetails['card_name'] ?? cardName;
          cardNumber = editedCardDetails['card_number'] ?? cardNumber;
          cvv = editedCardDetails['cvv'] ?? cvv;
          expDate = editedCardDetails['exp_date'] ?? expDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => settingspassenger()));
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/card_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextBoxField(label: 'Card Name', value: cardName),
                TextBoxField(label: 'Card Number', value: cardNumber),
                Row(
                  children: [
                    Expanded(
                      child: TextBoxField(label: 'Exp Date', value: expDate),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextBoxField(label: 'CVV', value: cvv),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editCard,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Edit Card'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextBoxField extends StatelessWidget {
  final String label;
  final String value;

  const TextBoxField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}

class EditCardScreen extends StatefulWidget {
  final int userId;
  final String initialCardName;
  final String initialCardNumber;
  final String initialCvv;
  final String initialExpDate;

  const EditCardScreen({
    Key? key,
    required this.userId,
    required this.initialCardName,
    required this.initialCardNumber,
    required this.initialCvv,
    required this.initialExpDate,
  }) : super(key: key);

  @override
  _EditCardScreenState createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for editing
    cardNameController.text = widget.initialCardName;
    cardNumberController.text = widget.initialCardNumber;
    cvvController.text = widget.initialCvv;
    expDateController.text = widget.initialExpDate;
  }

  Future<void> _saveChanges() async {
    // Prepare the edited card details to pass back to the previous screen
    Map<String, String> editedCardDetails = {
      'card_name': cardNameController.text,
      'card_number': cardNumberController.text,
      'cvv': cvvController.text,
      'exp_date': expDateController.text,
    };

    // Send a request to update the card details in the database
    final url = Uri.parse('http://192.168.68.113:5000/update_card_details');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': widget.userId,
        'edited_card_details': editedCardDetails,
      }),
    );

    if (response.statusCode == 200) {
      // Update successful, you can handle the response accordingly
      print('Card details updated successfully');
      Navigator.pop(context, editedCardDetails); // Pass back the updated details
    } else {
      // Handle error
      print('Failed to update card details: ${response.statusCode}');
      // Show an error message to the user
      // You can customize this based on your error handling requirements
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update card details. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Edit Card'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/card_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Card Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextBoxField2(label: 'Card Name', controller: cardNameController),
                TextBoxField2(label: 'Card Number', controller: cardNumberController),
                Row(
                  children: [
                    Expanded(
                      child: TextBoxField2(label: 'Exp Date', controller: expDateController),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextBoxField2(label: 'CVV', controller: cvvController),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextBoxField2 extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const TextBoxField2({
    Key? key,
    required this.label,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
      ),
    );
  }
}
