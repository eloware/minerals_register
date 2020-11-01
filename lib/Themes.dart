import 'package:flutter/material.dart';

class Themes{

  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.lightBlue,
    buttonColor: Colors.cyanAccent,
    appBarTheme: AppBarTheme(
      color: Color(0xFF34529d)
    )
  );

  static ThemeData get darkTheme => ThemeData(
    primarySwatch: Colors.blueGrey,
  );

}
