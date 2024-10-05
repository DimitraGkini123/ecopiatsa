import 'package:flutter/material.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> carDetails;

  const CarDetailsScreen({Key? key, required this.carDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 131, 224, 134),  // Set your desired background color here
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                buildDetailField('Number', carDetails['car_number'].toString()),
                buildDetailField('Model', carDetails['car_model'].toString()),
                buildDetailField('Colour', carDetails['car_colour'].toString()),
                buildDetailField('Year', carDetails['car_year'].toString()),
                buildDetailField('Consumption', carDetails['car_consumption'].toString()),
                buildTrafficLicenseField(),
                // Add more fields as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTrafficLicenseField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Traffic License',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement logic for viewing traffic license
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.green,
            ),
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
