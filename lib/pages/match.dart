import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OptionListPage extends StatefulWidget {
  final int userId;
  final String start_area;
  final String start_country;
  final String end_area;
  final String end_country;
  final String hours;
  final String day;
  final String date;

  // Add parameters to the constructor
  const OptionListPage({
    Key? key,
    required this.userId, //passenger
    required this.start_area,
    required this.start_country,
    required this.end_area,
    required this.end_country,
    required this.hours,
    required this.day,
    required this.date,
  }) : super(key: key);

  @override
  _OptionListPageState createState() => _OptionListPageState();
}

class _OptionListPageState extends State<OptionListPage> {
  List<OptionData> options = [];

  @override
  void initState() {
    super.initState();
    fetchPossibleMatches();
  }

  Future<void> fetchPossibleMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.68.113:5000/possible_matches?'
          'user_id=${widget.userId}'  //passenger
          '&start_area=${widget.start_area}'
          '&start_country=${widget.start_country}'
          '&end_area=${widget.end_area}'
          '&end_country=${widget.end_country}'
          '&hours=${widget.hours}'
          '&day=${widget.day}'
          '&date=${widget.date}',
        ),
      );

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        print('API Response: $data');

        if (data is Map<String, dynamic> && data.containsKey('user_info')) {
          var driversInfo = data['user_info'];
          for (var driverInfo in driversInfo) {
            setState(() {
              options.add(
                OptionData(
                  driverInfo['drivers_route_id'] ?? 0,
                  driverInfo['passenger_routes_id'] ?? 0,
                  driverInfo['drivers_id'] ?? 0,
                  '${driverInfo['driver_first_name'] ?? ''} ${driverInfo['driver_last_name'] ?? ''}',
                  '${driverInfo['driver_email'] ?? ''}',
                  '${driverInfo['driver_phone'] ?? ''}',
                  '${driverInfo['route_start_area'] ?? ''} to ${driverInfo['route_destination_area'] ?? ''}',
                  '${driverInfo['route_day'] ?? ''}, ${driverInfo['route_date'] ?? ''} at ${driverInfo['route_hours'] ?? ''} :${driverInfo['route_minutes'] ?? ''} minutes',
                  driverInfo['scheduled'] ?? null,
                  isFavorite: false, // Initialize isFavorite to false
                ),
              );
            });
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
          option.passenger_routes_id != null &&
          option.drivers_id != null &&
          widget.userId != null) {
        _sendMatchRequest(
          option.passenger_routes_id,
          option.drivers_route_id,

          widget.userId,
          option.drivers_id
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
                          _showRouteDetails(
                            context,
                            option.name,
                            option.email,
                            option.phoneNumber,
                            option.routeDetails,
                            option.routeTime,
                            option.scheduled,
                          );
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
void _sendMatchRequest(int passengerRouteId, int driverRouteId, int userId, int driverId) async {
  try {
    print('Sending match request for passengerRouteId: $passengerRouteId, driverRouteId: $driverRouteId Passenger: $userId, Driver: $driverId');
    final response = await http.post(
      Uri.parse('http://192.168.68.113:5000/match_request'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'passenger_route_id': passengerRouteId,
        'driver_route_id': driverRouteId,
        'user_id': userId,
        'driver_id': driverId,
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

  void _launchMessage(String phoneNumber) async {
    final messageUrl = 'sms:$phoneNumber';
    if (await canLaunch(messageUrl)) {
      await launch(messageUrl);
    } else {
      print('Could not launch $messageUrl');
    }
  }

  void _showRouteDetails(BuildContext context, String driverName, String email, String phoneNumber, String routeDetails, String routeTime, int scheduled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Route Details for $driverName'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: $email'),
              Text('Phone Number: $phoneNumber'),
              Text('Route Details: $routeDetails'),
              Text('Route Time: $routeTime'),
              Text('Scheduled: ${scheduled == 1 ? 'Scheduled' : 'Not Scheduled'}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class OptionData {
  final int drivers_route_id;
  final int passenger_routes_id;
  final int drivers_id;
  final String name;
  final String phoneNumber;
  final String email;
  final String routeDetails;
  final String routeTime;
  final int scheduled;
  bool isFavorite;

  OptionData(this.drivers_route_id, this.passenger_routes_id,this.drivers_id,this.name, this.email, this.phoneNumber, this.routeDetails, this.routeTime, this.scheduled, {this.isFavorite = false});
}
