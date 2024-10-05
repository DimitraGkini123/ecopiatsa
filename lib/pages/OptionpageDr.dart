import 'dart:convert';

import 'package:ecopiatsa/pages/routeStartedDr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartRouteOptionsDr extends StatefulWidget {
  final int userId;

  const StartRouteOptionsDr({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _StartRouteOptionsDrState createState() => _StartRouteOptionsDrState();
}

class _StartRouteOptionsDrState extends State<StartRouteOptionsDr> {
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
        'http://192.168.68.113:5000/see_matches_driver?user_id=${widget.userId}', //driver
      ),
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);

      print('API Response: $data');

      if (data is Map<String, dynamic> && data.containsKey('user_info')) {
        var userInfos = data['user_info'];

        if (userInfos is List<dynamic>) {
          setState(() {
            options.addAll(
              userInfos.map(
                (userInfo) => OptionData(
                  '${userInfo['passenger_first_name'] ?? ''} ${userInfo['passenger_last_name'] ?? ''}',
                  userInfo['passenger_id'] ?? 0,
                  userInfo['passengers_route_id'] ?? 0,
                  '${userInfo['passenger_start_area'] ?? ''}',
                  '${userInfo['passenger_destination_area'] ?? ''}',
                ),
              ),
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


  void _viewDetails(BuildContext context, OptionData option) {
  print(option.passenger_destination_area);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Passenger Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start Area: ${option.passenger_start_area}'),
            Text('Destination Area: ${option.passenger_destination_area}'),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Your Route'),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          OptionData option = options[index];

          return Card(
            child: ListTile(
              title: Text(
                ' ${option.name}',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                setState(() {
                  option.isSelected = !option.isSelected;
                });
              },
              tileColor: option.isSelected ? Colors.green : null,
              trailing: ElevatedButton(
                onPressed: () {
                  _viewDetails(context,option);
                },
                child: Text('View'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 120.0,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {
            List<OptionData> selectedOptions = options.where((element) => element.isSelected).toList();
            if (selectedOptions.isNotEmpty) {
              print('Selected Options: $selectedOptions');
              selectedOptions.forEach((selectedOption) {
                print(selectedOption.name);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteStartedDr(selectedOptions: selectedOptions),
                ),
              );
            } else {
              print('Please select at least one person before starting the route.');
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
  final int passengerId; // Add a unique identifier for each passenger
  final int passengers_route_id;
  final String passenger_start_area;
  final String passenger_destination_area;
  bool isSelected;

  OptionData(this.name, this.passengerId,this.passengers_route_id, this. passenger_start_area, this.passenger_destination_area,{this.isSelected = false});
}
