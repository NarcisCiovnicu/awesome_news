import 'package:flutter/material.dart';

class MyThemes {
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      //backgroundColor: const Color.fromARGB(255, 141, 201, 214),
      backgroundColor: const Color.fromARGB(255, 237, 196, 169),
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
      ),
      textTheme: _createTextTheme(),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      //backgroundColor: const Color.fromARGB(255, 61, 109, 65),
      backgroundColor: const Color.fromARGB(255, 4, 49, 63),
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 67, 48, 93),
        //color: Color.fromARGB(255, 23, 105, 26),
      ),
      textTheme: _createTextTheme(),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  static TextTheme _createTextTheme() {
    return const TextTheme(
      // headline6: TextStyle(
      //   fontWeight: FontWeight.normal,
      //   decoration: TextDecoration.underline,
      // ),
      subtitle2: TextStyle(
        fontStyle: FontStyle.italic,
      ),
      caption: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
