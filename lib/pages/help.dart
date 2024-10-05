
import 'package:flutter/material.dart';

class help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help", style: TextStyle(fontSize: 22, color: Colors.green)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page (SettingsPage)
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'How can we help you?',
                style: TextStyle(fontSize: 22, color: Colors.lightGreen.shade900),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightGreen.shade900),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  maxLines: 10, // Adjust the number of lines as needed
                  decoration: InputDecoration(
                    hintText: '...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page (SettingsPage)
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen.shade900),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
