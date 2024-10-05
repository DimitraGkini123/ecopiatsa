import 'dart:convert';

import 'package:ecopiatsa/pages/MatchRequests.dart';
import 'package:ecopiatsa/pages/driver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OptionListPageDr extends StatefulWidget {
  final int userId;

  const OptionListPageDr({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _OptionListPageDrState createState() => _OptionListPageDrState();
}

class _OptionListPageDrState extends State<OptionListPageDr> {
  final List<OptionData> options = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
  try {
    final response = await http.get(
      Uri.parse(
        'http://192.168.68.113:5000/see_matches_driver?user_id=${widget.userId}',
      ),
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);

      print('API Response: $data');

      if (data is Map<String, dynamic> && data.containsKey('user_info')) {
        var userInfos = data['user_info'];

        if (userInfos is List<dynamic>) {
          setState(() {
            options.clear(); // Clear existing options
            options.addAll(
              userInfos.map((driverInfo) => OptionData(
                '${driverInfo['passenger_first_name'] ?? ''} ${driverInfo['passenger_last_name'] ?? ''}',
                '${driverInfo['passenger_phone'] ?? ''}',
                '${driverInfo['passenger_email'] ?? ''}',
              )),
            );
          });
        } else {
          print('Invalid format: user_info is not a list');
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
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(width: 8.0),
              Text('Request', style: TextStyle(color: Colors.black)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchRequests(
                        userId: Driver.loggedInUserId ?? 0,
                      ),
                    ),
                  );
                  print('Navigate button pressed');
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              OptionData option = options[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        ' ${option.name}',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.phone, size: 20),
                            onPressed: () {
                              _launchPhone(option.phoneNumber);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.message, size: 20),
                            onPressed: () {
                              _launchMessage(option.phoneNumber);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.mail, size: 20),
                            onPressed: () {
                              _launchMail(option.email);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
}

class OptionData {
  final String name;
  final String phoneNumber;
  final String email;

  OptionData(this.name, this.phoneNumber, this.email);
}
