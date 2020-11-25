import 'package:flutter/material.dart';

class CustomTextAuthScreens extends StatelessWidget {
  final String text;

  CustomTextAuthScreens(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xff7e7e7e),
      ),
    );
  }
}
