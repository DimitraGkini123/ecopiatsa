import 'package:ecopiatsa/pages/Discover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RouteEndedPas extends StatelessWidget {
  final String selectedOption;

  const RouteEndedPas({
    Key? key,
    required this.selectedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFA9C672);
    Color buttonColor = Colors.white;
    Color contourColor = const Color.fromARGB(255, 77, 124, 15);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/car.png',
                  width: 231.05,
                  height: 131.56,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'YOUR ROUTE ENDED...!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'We hope you enjoyed...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Discover()),
                  );
                },

                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(308, 50)), // Set the size here
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                  side: MaterialStateProperty.all(BorderSide(color: contourColor)),
                ),
                child: const Text(
                  'RATE YOUR DRIVER',
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 124, 15),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '$selectedOption:', // Use the selectedOption parameter here
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  // Handle the rating update
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
