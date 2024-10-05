import 'package:flutter/material.dart';


class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: const Color(0xFF4d7c0f)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFF4d7c0f)),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFF4d7c0f)),
            borderRadius: BorderRadius.circular(50.0),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
