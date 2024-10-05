import 'dart:convert';

import 'package:ecopiatsa/pages/settingspassenger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileInfoScreen extends StatefulWidget {
  final int userId; // Add user ID as a parameter

  const ProfileInfoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String username = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String dateOfBirth = '';
  String telephone = '';
  String idPic = ''; // Assuming id_pic is a URL to the profile picture

  final TextEditingController _newTelephoneController = TextEditingController();

  Image convertBase64ToImage(String base64String) {
    final bytes = base64.decode(base64String);
    return Image.memory(bytes);
  }

  // Function to fetch profile info from the server
  Future<void> fetchProfileInfo(int userId) async {
    print('Received request for /profile_info');

    try {
      print('Fetching profile info for user ID: $userId');
      final url = Uri.parse('http://192.168.68.113:5000/profile_info?user_id=$userId');
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

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user_info')) {
          var userInfo = responseData['user_info'];
          setState(() {
            // Update state with fetched profile info
            username = userInfo['username']?.toString() ?? 'empty';
            print('Username: $username');
            firstName = userInfo['first_name']?.toString() ?? 'empty';
            lastName = userInfo['last_name']?.toString() ?? 'empty';
            email = userInfo['email']?.toString() ?? 'empty';
            dateOfBirth = userInfo['date_of_birth']?.toString() ?? 'empty';
            telephone = userInfo['telephone']?.toString() ?? 'empty';
            idPic = userInfo['id_pic']?.toString() ?? ''; // Assuming id_pic is a URL to the profile picture
          });
        } else {
          // Handle the case when the response is not in the expected format
          print('Invalid response format or missing "user_info" key');
        }
      } else {
        // Handle error
        print('Failed to fetch profile info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetchProfileInfo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print('Initializing ProfileInfoScreen');
    fetchProfileInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    print('Building ProfileInfoScreen Widget');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Info'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to passenger settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => settingspassenger()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60), // Increased space at the top
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: idPic.isNotEmpty
                            ? NetworkImage(idPic)
                            : AssetImage('assets/profilepic.png') as ImageProvider,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name: $firstName',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4d7c0f),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Last Name: $lastName',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4d7c0f),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Username: $username',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4d7c0f),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Date of Birth: $dateOfBirth',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4d7c0f),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Telephone: $telephone',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4d7c0f),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show the modal bottom sheet for editing telephone
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Insert new telephone number',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4d7c0f),
                                      ),
                                    ),
                                    TextField(
                                      controller: _newTelephoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'New Telephone Number',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Implement logic for updating telephone
                                        // Call your API or function to update the telephone
                                        updateTelephone(_newTelephoneController.text);
                                        Navigator.pop(context); // Close the bottom sheet
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4d7c0f),
                                      ),
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4d7c0f),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Reduced space between ID pic and Edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ID',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4d7c0f),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          /// Fetch BLOB data from the server
                          final url =
                              Uri.parse('http://192.168.68.113:5000/view_idpic?user_id=${widget.userId}');
                          final response = await http.get(url);

                          if (response.statusCode == 200) {
                            final Map<String, dynamic> responseData = json.decode(response.body);
                            final String idPicBase64 = responseData['pic'];

                            // Show modal bottom sheet when 'View' button is pressed
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200, // Adjust the height as needed
                                  child: Center(
                                    child: idPicBase64.isNotEmpty
                                        ? convertBase64ToImage(idPicBase64)
                                        : Text('No ID Pic available'),
                                  ),
                                );
                              },
                            );
                          } else {
                            print('Failed to fetch ID pic: ${response.statusCode}');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4d7c0f),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 170, // Adjust the height of the SizedBox as needed
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement delete user button logic
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF4d7c0f),
                        ),
                        child: Text(
                          'Delete User',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to update the telephone in the database
  Future<void> updateTelephone(String newTelephone) async {
    final url = Uri.parse('http://192.168.68.113:5000/update_telephone?user_id=${widget.userId}');
    final response = await http.post(
      url,
      body: {
        'new_telephone': newTelephone,
      },
    );

    if (response.statusCode == 200) {
      print('Telephone updated successfully');
      // Implement any additional logic if needed
    } else {
      print('Failed to update telephone: ${response.statusCode}');
      // Handle error, show a snackbar or any other user feedback
    }
  }
}
