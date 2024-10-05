import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MatchPas extends StatefulWidget {
  final int userId;

  const MatchPas({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _MatchPasState createState() => _MatchPasState();
}

class _MatchPasState extends State<MatchPas> {
  final List<OptionData> options = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.68.113:5000/see_matches_passenger?user_id=${widget.userId}',
        ),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('user_info')) {
          var driversInfo = data['user_info'];

          if (driversInfo is List<dynamic>) {
            setState(() {
              options.addAll(driversInfo.map((driverInfo) => OptionData(
                    '${driverInfo['driver_first_name'] ?? ''} ${driverInfo['driver_last_name'] ?? ''}',
                    '${driverInfo['driver_telephone'] ?? ''}',
                    '${driverInfo['driver_email'] ?? ''}',
                  )));
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
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                OptionData option = options[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
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
                            SizedBox(width: 2)
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
