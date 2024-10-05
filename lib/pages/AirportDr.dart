import 'dart:convert';

import 'package:ecopiatsa/pages/DiscoverDr.dart';
import 'package:ecopiatsa/pages/driver.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AirportDr extends StatefulWidget {
  final String initialAddress;

  AirportDr({Key? key, required this.initialAddress}) : super(key: key);

  @override
  _AirportDrState createState() => _AirportDrState();
}

class _AirportDrState extends State<AirportDr> {
  List<String> _selectedOptions = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _currentLocationController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _startstreetController = TextEditingController();
  TextEditingController _startlocalityController = TextEditingController();
  TextEditingController _startcountryController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _dayOfWeekController = TextEditingController();

  Future<void> save_route(
  BuildContext context,
  String startStreet,
  String startLocality,
  String startCountry,
  String destinationStreet,
  String destinationLocality,
  String destinationCountry,
  String passengers,
  String dayOfWeek,
  DateTime selectedDate,
  String hour,
  String minute,
  String userId,
) async {
  try {
    String formattedDate = selectedDate.toIso8601String();
    print('Start Street: $startStreet');
    print('Destination Street: $destinationStreet');
    print('Destination Locality: $destinationLocality');
    print('Destination Country: $destinationCountry');

    // Split the destination locality into separate entries if needed
    List<String> destinationLocalities = destinationLocality.split(', ');

    for (String loc in destinationLocalities) {
      // Prepare the data to be sent in the request
      Map<String, dynamic> requestData = {
        'start_street': startStreet,
        'start_area': startLocality,
        'start_country': startCountry,
        'destination_street': destinationStreet,
        'destination_area': loc, // Use each locality separately
        'destination_country': destinationCountry,
        'capacity': passengers,
        'day': dayOfWeek,
        'date': formattedDate,
        'hours': hour,
        'minutes': minute,
        'user_id': userId,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse('http://192.168.68.113:5000/save_driver_route_airport'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode != 200) {
        print('Failed to save driver route. Status code: ${response.statusCode}');
        // Handle the error or provide feedback to the user
        return;
      }
    }

    print('Driver route saved successfully');

    // Show a SnackBar to indicate the success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Your route(s) have been saved! Get ready to find your matches!'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to the discover page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DiscoverDr()),
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
    _numberController = TextEditingController();
    _speech = stt.SpeechToText();
    _updateTimeControllers();
    _findCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airport'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentLocationController,
                    decoration: InputDecoration(
                      hintText: 'Enter location...',
                      labelText: 'Location',
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
                  icon: Icon(Icons.mic),
                  onPressed: _isListening ? null : _listen,
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 100,
            child: Row(
              children: [
                Icon(Icons.person),
                Expanded(
                  child: TextField(
                    controller: _numberController,
                    decoration: InputDecoration(
                        labelText: 'Passengers',
                        hintText: ' '
                    ),
                    obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showOptionsDialog(context);
            },
            child: Text(_selectedOptions.isEmpty
                ? 'Airport'
                : _selectedOptions.join(', ')),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text(
              ' ${_getFormattedDateWithDay()}',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectTime(context);
            },
            child: Text(' ${_selectedTime.format(context)}'),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          SizedBox(
            width: 120.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                await save_route(
                  context,
                  _startstreetController.text,
                  _startlocalityController.text,
                  _startcountryController.text,
                  'airport', // Destination street
                  _getDestinationLocality(),
                  'airport', // Destination country
                  _numberController.text,
                  _dayOfWeekController.text,
                  _selectedDate,
                  _hourController.text,
                  _minuteController.text,
                  Driver.loggedInUserId.toString(),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4d7c0f),),
              ),
              child:
              Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFFffecfccc),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

String _getDestinationLocality() {
  // Check if 'Departures' and 'Arrivals' are selected
  if (_selectedOptions.contains('Departures') && _selectedOptions.contains('Arrivals')) {
    // Save 'Departures' and 'Arrivals' as separate entries
    return 'Spata, Spata';
  } else {
    // If only one option is selected, return that option
    return _selectedOptions.join(', ');
  }
}
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _getFormattedDateWithDay() {
    final dayOfWeek = getDayOfWeek(_selectedDate.weekday);
    _dayOfWeekController.text = getDayOfWeek(_selectedDate.weekday);
    return '$dayOfWeek ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }
  String getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Options'),
              content: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    2,
                        (index) => CheckboxListTile(
                      title: Text(getOptionText(index)),
                      value: _selectedOptions.contains(getOptionText(index)),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              _selectedOptions.add(getOptionText(index));
                            } else {
                              _selectedOptions.remove(getOptionText(index));
                            }
                          }
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
                    _printSelectedOptions();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  


  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _hourController.text = _selectedTime.hour.toString();
        _minuteController.text = _selectedTime.minute.toString();
      });
    }
  }
  String getOptionText(int index) {
    switch (index) {
      case 0:
        return 'Departures';
      case 1:
        return 'Arrivals';

      default:
        return '';
    }
  }

  void _printSelectedOptions() {
    print('Selected Options: ${_selectedOptions.join(', ')}');
    setState(() {
      _selectedOptions.isEmpty
          ? 'Select your Destination'
          : _selectedOptions.join(', ');
    });
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


  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
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
        _isListening = false;
        _speech.stop();
      });
    }
  }
}
class InitialAddressPage extends StatelessWidget {
  final String initialAddress;

  InitialAddressPage({Key? key, required this.initialAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AirportDr(initialAddress: initialAddress);
  }
}
