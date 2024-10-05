import 'dart:convert';

import 'package:ecopiatsa/pages/routeStartedPas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartRouteOptionsPas extends StatefulWidget {
  final int userId;

  const StartRouteOptionsPas({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _StartRouteOptionsPasState createState() => _StartRouteOptionsPasState();
}

class _StartRouteOptionsPasState extends State<StartRouteOptionsPas> {
  final List<OptionData> options = [];
  int? selectedOptionIndex;

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

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        print('API Response: $data');

        if (data is Map<String, dynamic> && data.containsKey('user_info')) {
          var driverInfo = data['user_info'];

          if (driverInfo is List<dynamic>) {
            setState(() {
              options.addAll(driverInfo.map((info) {
                return OptionData(
                  '${info['driver_first_name'] ?? ''} ${info['driver_last_name'] ?? ''}',
                );
              }));
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
        title: Text('Start Your Route'),
      ),
      body: ListView(
        children: options.asMap().entries.map((entry) {
          int index = entry.key;
          OptionData option = entry.value;

          return Card(
            child: ListTile(
              title: Text(option.name),
              leading: Checkbox(
                value: index == selectedOptionIndex,
                onChanged: (value) {
                  setState(() {
                    selectedOptionIndex = value! ? index : null;
                  });
                },
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: SizedBox(
        width: 120.0, // Set the width
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {
            if (selectedOptionIndex != null) {
              OptionData selectedOption = options[selectedOptionIndex!];
              print('Selected Option: ${selectedOption.name}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RouteStartedPas(selectedOption: selectedOption.name),
                ),
              );
            } else {
              print('Please select a driver before starting the route.');
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4d7c0f)),
          ),
          child: Text(
            'Start Route',
            style: TextStyle(
              color: Color(0xFFffecfccc),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionData {
  final String name;
  OptionData(this.name);
}
