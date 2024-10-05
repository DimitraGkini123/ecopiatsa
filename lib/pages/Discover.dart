import 'package:ecopiatsa/pages/OptionpagePas.dart';
import 'package:ecopiatsa/pages/SceduledPas.dart';
import 'package:ecopiatsa/pages/location_test_pas.dart';
import 'package:ecopiatsa/pages/matchPas.dart';
import 'package:ecopiatsa/pages/passenger.dart';
import 'package:flutter/material.dart';

import 'AirportPas.dart';
//import 'GoogleMap.dart';
import 'Calendar.dart';
import 'NowPas.dart';
import 'settingspassenger.dart';

class Discover extends StatelessWidget {
  const Discover({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page',
        style: TextStyle(
        color: Color(0xFF4d7c0f),),
        ),
        backgroundColor: Color(0xFFffecfccc),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.0, // Set the width of the rectangle
                        height: 90.0,
                        decoration: BoxDecoration(
                          // BoxDecoration is used to provide styling, such as color or image
                          image: DecorationImage(
                            image: AssetImage('assets/logo.png'), // Replace with your image path
                            fit: BoxFit.cover, // You can use different BoxFit values based on your needs
                          ),
                        ),
                      ),
                      Text('Discover',
                        style: TextStyle(
                          color: Color(0xFF4d7c0f),
                          fontSize: 30.0,
                          fontFamily: 'TiroDevanagari',
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings_outlined,
                          size: 45.0, // Set the size of the icon as needed
                          color: Color(0xFF4d7c0f),
                        ),
                        onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => settingspassenger()));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100.0, 100.0),
                            backgroundColor: Color(0xFFffecfccc),
                            // Change the background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Change the shape
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduledPagePas(initialAddress: '',)));
                          },
                          child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_alarm,
                                      size: 30.0,
                                      // Set the size of the icon as needed
                                      color: Color(0xFF4d7c0f),),
                                    Text('  Sceduled ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        // Set the font size as needed
                                        color: Color(
                                            0xFF4d7c0f), // Set the text color
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100.0, 100.0),
                            backgroundColor: Color(0xFFffecfccc),
                            // Change the background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Change the shape
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyPagePas(initialAddress: '',)));
                          },
                          child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.place_outlined,
                                      size: 30.0,
                                      // Set the size of the icon as needed
                                      color: Color(0xFF4d7c0f),),
                                    Text('    Now    ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        // Set the font size as needed
                                        color: Color(
                                            0xFF4d7c0f), // Set the text color
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100.0, 100.0),
                            backgroundColor: Color(0xFFffecfccc),
                            // Change the background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Change the shape
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AirportPas(initialAddress: '',)));
                          },
                          child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.airplanemode_active_outlined,
                                      size: 30.0,
                                      // Set the size of the icon as needed
                                      color: Color(0xFF4d7c0f),),
                                    // Set the color of the icon),
                                    Text('  Airport  ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        // Set the font size as needed
                                        color: Color(
                                            0xFF4d7c0f), // Set the text color
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFffecfccc),
                      padding: EdgeInsets.all(0.0),
                      fixedSize: Size(double.maxFinite, 250.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Change the shape
                      ),
                      // Set the size (width, height) of the button
                    ),
                    onPressed: () {
                      Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => Test()),
                      );                     // Button 3 action
                    },
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Ink.image(
                            image: AssetImage('assets/MAP.png'),
                            // Replace with your image path
                            fit: BoxFit.cover,
                            // Set the fit property as needed
                            width: double.infinity,
                            // Set width to match the button width
                            height: 25220.0, // Set height to match the button height
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Maps',
                                style: TextStyle(
                                  fontSize: 18.0, // Set the font size as needed
                                  color: Color(0xFF4d7c0f), // Set the text color
                                ),
                              ),
                              Icon(Icons.map_outlined,
                                size: 24.0, // Set the size of the icon as needed
                                color: Color(0xFF4d7c0f),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return BorderSide(color: Color(0xFFffecfccc)); // Disabled button color
                          }
                          return BorderSide(
                              color: Color(0xFF4d7c0f)); // Enabled button color
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StartRouteOptionsPas(userId: Passenger.loggedInUserId ?? 0,)));
                    },
                    child: Text('START ROUTE',
                      style: TextStyle(
                        color: const Color(0xFF4d7c0f),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity, // Set the width of the rectangle
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      // Set the height of the rectangle
                      color: Color(0xFF4d7c0f), // Set the color of the rectangle
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_month_outlined,
                              size: 24.0, // Set the size of the icon as needed
                              color: Color(0xFFffecfccc),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Calendar()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border_outlined,
                              size: 24.0, // Set the size of the icon as needed
                              color: Color(0xFFffecfccc),),
                            onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => MatchPas(userId: Passenger.loggedInUserId ?? 0,)));
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}