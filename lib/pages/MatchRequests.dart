import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MatchRequests extends StatefulWidget {
  final int userId;
  const MatchRequests({
    Key? key,
    required this.userId
  }): super(key:key);
  @override
  _MatchRequestsState createState() => _MatchRequestsState();
}

class _MatchRequestsState extends State<MatchRequests> {
  final List<OptionData> options = [];
    @override
  void initState() {
    super.initState();
    fetchPossibleMatches();
  }

    Future<void> fetchPossibleMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.68.113:5000/see_match_requests_driver?'
          'user_id=${widget.userId}'  //driver
        ),
      );

if (response.statusCode == 200) {
  dynamic data = jsonDecode(response.body);

  print('API Response: $data');

  if (data is Map<String, dynamic> && data.containsKey('user_info')) {
    var driverInfo = data['user_info'];

 if (driverInfo is Map<String, dynamic>) {
  setState(() {
    options.add(
      OptionData(
        driverInfo['drivers_route_id'] ?? 0,
        driverInfo['passenger_route_id'] ?? 0,
        driverInfo['passenger_id'] ?? 0,
        '${driverInfo['passenger_first_name'] ?? ''} ${driverInfo['passenger_last_name'] ?? ''}',
        '${driverInfo['passenger_telephone'] ?? ''}',
        '${driverInfo['passenger_email'] ?? ''}',
        isFavorite: false,
      ),
    );
  });
} else {
  print('Invalid format: user_info is not a map');
}
  } else {
    print('Invalid response format or no drivers found');
  }
} else {
  print('Failed to fetch data. Status code: ${response.statusCode}');
}
    } catch (e) {
      print('An error occurred while fetching data: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Match'),
    ),
    body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      child: Row(
        children: options.map((option) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
  // Handle the tap and toggle the color
  setState(() {
    option.isFavorite = !option.isFavorite;
    if (option.isFavorite) {
      // Show a message when the heart icon is pressed
      _showMessage('Your request to match has been sent!');
      
      // Add null checks before calling _sendMatchRequest
      if (option.drivers_route_id != null &&
          option.passenger_route_id != null &&
          option.passenger_id != null &&
          widget.userId != null) {
        _confirmMatch(
          option.passenger_route_id,
          option.drivers_route_id,
          option.passenger_id,
          widget.userId,  //driver
        );
      } else {
        print('One or more required values are null. Unable to send match request.');
      }
    }
  }); 
},
                        child: Icon(
                          option.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: option.isFavorite
                              ? Colors.red
                              : Colors.black,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        ' ${option.name}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone, size: 20),
                        onPressed: () {
                          _launchPhone(option.phoneNumber);
                        },
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.message, size: 20),
                        onPressed: () {
                          _launchMessage(option.phoneNumber);
                        },
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.mail, size: 20),
                        onPressed: () {
                          _launchMail(option.email);
                        },
                      ),
                      SizedBox(width: 2),
                      TextButton(
                        onPressed: () {
                         /*_showRouteDetails(
                            context,
                            option.name,
                            option.email,
                            option.phoneNumber,
                            option.routeDetails,
                            option.routeTime,
                            option.scheduled,
                          );
                          */
                        },
                        child: Text('Details', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

void _confirmMatch(int passengerRouteId, int driverRouteId, int passengerId, int driverId) async {
  try {
    print('Sending match confirm for passengerRouteId: $passengerRouteId, driverRouteId: $driverRouteId Passenger: $passengerId, Driver: $driverId');
    final response = await http.post(
      Uri.parse('http://192.168.68.113:5000/match_confirm'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'passenger_route_id': passengerRouteId,
        'driver_route_id': driverRouteId,
        'passenger_id': passengerId,
        'driver_id':driverId,
      }),
    );

    if (response.statusCode == 200) {
      print('Match request sent successfully');
    } else {
      print('Failed to send match request. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred while sending match request: $e');
  }
}

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  void _launchPhone(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      print('Could not launch $phoneUrl');
    }
  }

  void _launchMail(String email) async {
    final mailUrl = 'mailto:$email';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Could not launch $mailUrl');
    }
  }
}
void _launchMessage(String phoneNumber) async {
  final messageUrl = 'sms:$phoneNumber';
  if (await canLaunch(messageUrl)) {
    await launch(messageUrl);
  } else {
    print('Could not launch $messageUrl');
  }
}

class OptionData {
  final int drivers_route_id;
  final int passenger_route_id;
  final int passenger_id;
  final String name;
  final String phoneNumber;
  final String email;
  bool isFavorite;

  OptionData(this.drivers_route_id,this.passenger_route_id, this.passenger_id,this.name, this.phoneNumber, this.email, {this.isFavorite = false});
}
