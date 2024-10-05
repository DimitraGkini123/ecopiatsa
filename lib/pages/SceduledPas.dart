import 'dart:async';
import 'dart:convert';

import 'package:ecopiatsa/pages/Discover.dart';
import 'package:ecopiatsa/pages/passenger.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'PinsPas.dart';
import 'match.dart';

class ScheduledPagePas extends StatefulWidget {
  final String initialAddress;

  ScheduledPagePas({Key? key, required this.initialAddress}) : super(key: key);

  @override
  _ScheduledPagePasState createState() => _ScheduledPagePasState();
}

class _ScheduledPagePasState extends State<ScheduledPagePas> {
  String? _selectedDay;
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _mapLocationController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListeningFirstMic = false;
  bool _isListeningSecondMic = false;
  TextEditingController _startstreetController = TextEditingController();
  TextEditingController _startlocalityController = TextEditingController();
  TextEditingController _startcountryController = TextEditingController();
  TextEditingController _destinationStreetController = TextEditingController();
  TextEditingController _destinationLocalityController = TextEditingController();
  TextEditingController _destinationCountryController = TextEditingController();
  TextEditingController _dayOfWeekController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  
  Future<void> save_routes(
  BuildContext context,
  String startStreet,
  String startLocality,
  String startCountry,
  String destinationStreet,
  String destinationLocality,
  String destinationCountry,
  String passengers,
  String selectedDay,
  DateTime? date,
  TimeOfDay selectedTime,
  String userId,
) async {
  try {
    print('Start Street: $startStreet');
    String hour = selectedTime.hour.toString();
    String minute = selectedTime.minute.toString();
    
      // Prepare the data to be sent in the request
      Map<String, dynamic> requestData = {
        'start_street': startStreet,
        'start_area': startLocality,
        'start_country': startCountry,
        'destination_street': destinationStreet,
        'destination_area': destinationLocality,
        'destination_country': destinationCountry,
        'capacity': passengers,
        'day': selectedDay,
        'date': date != null ? date.toString() : '0000-00-00',
        'hours': hour,
        'minutes': minute,
        'user_id': userId,
      };

      // Make the POST request for each day
      final response = await http.post(
        Uri.parse('http://192.168.68.113:5000/save_passenger_route_scheduled'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Driver route saved successfully for $selectedDay');
      } else {
        print('Failed to save driver route for $selectedDay. Status code: ${response.statusCode}');
        // Handle the error or provide feedback to the user
      }


    // Show a SnackBar to indicate the success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your route has been saved! Get ready to find your driver!'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to the discover page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Discover()),
    );

  } catch (e) {
    print('An error occurred while saving the route: $e');
    // Handle the error or provide feedback to the user
  }
}

 @override
void initState() {
  super.initState();
  _currentLocationController = TextEditingController(text: widget.initialAddress);
  _mapLocationController = TextEditingController();
  _numberController = TextEditingController();
  _speech = stt.SpeechToText();
  _updateTimeControllers();
  _findCurrentLocation();
}
   void _updateTimeControllers() {
    // Set the initial values for hours and minutes
    _hourController.text = _selectedTime.hour.toString();
    _minuteController.text = _selectedTime.minute.toString();
  }
  void _findCurrentLocation() async {
  try {
    Position position = await _determineUserCurrentPosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;

      // Extracting address components
      String street = firstPlacemark.street ?? '';
      String locality = firstPlacemark.locality ?? '';
      String country = firstPlacemark.country ?? '';

      // Printing address components
print('_currentLocationController: $_currentLocationController');
print('_startstreetController: $_startstreetController');
print('_startlocalityController: $_startlocalityController');
print('_startcountryController: $_startcountryController');
print('Street: $street');
print('Locality: $locality');
print('Country: $country');


      // Concatenating address components
      String address = '$street, $locality, $country';

      setState(() {
        _currentLocationController.text = address;
        _startstreetController.text = street;
        _startlocalityController.text = locality;
        _startcountryController.text = country;
      });
    } else {
      print('Placemarks list is empty');
      setState(() {
        _currentLocationController.text = 'Error getting location';
      });
    }

  } catch (e) {
    print('Error getting location: $e');
    setState(() {
      _currentLocationController.text = 'Error getting location';
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all( 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _currentLocationController,
                          decoration: InputDecoration(
                            hintText: 'Current Location',
                            labelText: 'Current Location',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          _findCurrentLocation();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic_none_outlined),
                        onPressed: _isListeningFirstMic ? null : () => _listen(microphoneNumber: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _mapLocationController,
                          decoration: InputDecoration(
                            hintText: 'Destination',
                            labelText: 'Destination',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () {
                          _navigateToPinsPage(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic_none),
                        onPressed: _isListeningSecondMic ? null : () => _listen(microphoneNumber: 2),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Row(
                    children:[
                      Icon(Icons.person),
                  Expanded(
                    child: TextField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        hintText: ' ',
                        labelText: 'Passengers',),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showOptionsDialog(context);
                    },
                    child: Text(_selectedDay ?? 'Select Day'),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Text(' ${_selectedTime.format(context)}'),
                ),
                SizedBox(height: 20),
                  SizedBox(
                    width: 120.0, // Set the width
                    height: 50.0,
                    child: ElevatedButton(
                        onPressed: () async {
  await save_routes(
    context,
    _startstreetController.text,
    _startlocalityController.text,
    _startcountryController.text,
    _destinationStreetController.text,
    _destinationLocalityController.text,
    _destinationCountryController.text,
    _numberController.text,
    _selectedDay ?? '',
    null, // You may need to provide a specific date here
    _selectedTime,
    Passenger.loggedInUserId.toString(),
  );
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OptionListPage(
      userId: Passenger.loggedInUserId ?? 0,
      start_area: _startlocalityController.text,
      start_country: _startcountryController.text,
      end_area: _destinationLocalityController.text,
      end_country: _destinationCountryController.text,
      hours: _selectedTime.hour.toString(),
      day: _selectedDay ?? '',
      date: '0000-00-00',
    ),
  ),
);
},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4d7c0f),),),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ Icon( Icons.favorite,
                              color: Color(0xFFffecfccc)),
                            Text('Match',
                              style: TextStyle(
                                  color: Color(0xFFffecfccc),),
                            ),
                          ],
                        )

                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }


void _showOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? selectedOption;

      return AlertDialog(
        title: Text('Select Day'),
        content: SingleChildScrollView(
          child: Column(
            children: List.generate(
              7,
              (index) => Radio(
                value: getOptionText(index),
                groupValue: _selectedDay,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _printSelectedOption();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void _printSelectedOption() {
  print('Selected Day: $_selectedDay');
  setState(() {
    // Update any UI components based on the selected day
  });
}


  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String getOptionText(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }

  Future<Position> _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print("Location service is not enabled");
      // You may want to inform the user to enable location services
      // or open the device settings for location services.
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        print("User denied location permission");
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      print("User denied location permission forever");
    }

    // If you want to return the Position object, include the return statement
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  
  void _listen({required int microphoneNumber}) async {
    if (microphoneNumber == 1) {
      _listenFirstMic();
    } else if (microphoneNumber == 2) {
      _listenSecondMic();
    }
  }

  void _listenFirstMic() async {
    // Logic for the first microphone
    if (!_isListeningFirstMic) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() {
              _isListeningFirstMic = false;
            });
          }
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListeningFirstMic = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _currentLocationController.text = result.recognizedWords;
            });
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      setState(() {
        _isListeningFirstMic = false;
        _speech.stop();
      });
    }
  }

  void _listenSecondMic() async {
    // Logic for the first microphone
    if (!_isListeningSecondMic) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() {
              _isListeningSecondMic = false;
            });
          }
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListeningSecondMic = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _mapLocationController.text = result.recognizedWords;
            });
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      setState(() {
        _isListeningSecondMic = false;
        _speech.stop();
      });
    }
  }

  void updateMapLocationTextField(String address) {
    setState(() {
      _mapLocationController.text = address;
    });
  }


void _navigateToPinsPage(BuildContext context) async {
  // Navigate to Pins page and wait for the selected address
  final selectedAddress = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PinsPas()),
  );
  print('Selected Address: $selectedAddress');
  // Update the controllers with the selected address
  if (selectedAddress != null && selectedAddress is String) {
    List<String> destinationAddressComponents = selectedAddress.split(', ');

    if (destinationAddressComponents.length >= 3) {
      String destinationStreet = destinationAddressComponents[0];
      String destinationLocality = destinationAddressComponents[1];
      String destinationCountry = destinationAddressComponents[2];
      print('Destination Country: $destinationCountry');

      setState(() {
        _destinationStreetController.text = destinationStreet;
        _destinationLocalityController.text = destinationLocality;
        _destinationCountryController.text = destinationCountry;

      });
    } else {
      print('Invalid destination address format');
    }

    updateMapLocationTextField(selectedAddress);
  }
}

    void _saveLocationDetails() {
  // Extracting address components
  List<String> addressComponents = _currentLocationController.text.split(', ');

  // Ensure that there are at least three components (street, locality, country)
  if (addressComponents.length >= 3) {
    String street = addressComponents[0];
    String locality = addressComponents[1];
    String country = addressComponents[2];

    // Print address components
    print('Street: $street');
    print('Locality: $locality');
    print('Country: $country');
    print('id ${Passenger.loggedInUserId}');

    // You can use these components as needed for further processing or storage
  } else {
    print('Invalid address format');
  }
}
}


class InitialAddressPage extends StatelessWidget {
  final String initialAddress;

  InitialAddressPage({Key? key, required this.initialAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScheduledPagePas(initialAddress: initialAddress);
  }
}
