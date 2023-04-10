import 'package:flutter/material.dart';

// --------------------------------- Styling ---------------------------------
Color primaryColor = Color(0xFF5C4982);
Color secondaryColor = Color(0xFFFD6A56);

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF5C4982),
  fontFamily: "Poppins",
);

TextStyle alarmAddDescriptions =
    TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);

BoxDecoration backgoundImage = BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/back.jpg"),
    fit: BoxFit.cover,
  ),
);
