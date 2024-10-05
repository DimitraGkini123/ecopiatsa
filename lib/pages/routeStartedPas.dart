import 'package:ecopiatsa/pages/routeended-passenger.dart';
import 'package:flutter/material.dart';

class RouteStartedPas extends StatelessWidget {
  final String selectedOption;

  const RouteStartedPas({
    Key? key,
    required this.selectedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFA9C672);
    Color buttonColor = Colors.white;
    Color contourColor = const Color.fromARGB(255, 77, 124, 15);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'YOUR ROUTE IS IN PROGRESS...!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: Image.asset(
                    'assets/car.png',
                    width: 231.05,
                    height: 131.56,
                  ),
                ),
                const SizedBox(
                  height: 350,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showPaymentDialog(context, selectedOption);
                    // Add functionality for the button press here
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(308, 50)), // Set the size here
                    backgroundColor: MaterialStateProperty.all(buttonColor),
                    side: MaterialStateProperty.all(BorderSide(color: contourColor)),
                  ),
                  child: const Text(
                    'END ROUTE',
                    style: TextStyle(
                      color: Color.fromARGB(255, 77, 124, 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showPaymentDialog(BuildContext context, String selectedOption) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thank you for choosing us!', style: TextStyle(color: Color.fromARGB(255, 77, 124, 15))),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total cost of route: 15 €', style: TextStyle(color: Color.fromARGB(255, 77, 124, 15))),
              const SizedBox(height: 10),
              const Text('Choose your payment method:', style: TextStyle(color: Color.fromARGB(255, 77, 124, 15))),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RouteEndedPas(selectedOption: selectedOption)));
                },
                child: const Text('Card'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RouteEndedPas(selectedOption: selectedOption)));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text('Cash'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

