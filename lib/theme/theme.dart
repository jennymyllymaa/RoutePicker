import 'package:flutter/material.dart';

var lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 247, 175, 21), //valittu teksti + nappien teksti
  onPrimary: Color.fromRGBO(231, 236, 241, 1), //AppBar teskti
  primaryContainer: Color(0xFF735761),  
  onPrimaryContainer: Color(0xFF735761), 
  secondary: Color(0xFF735761),
  onSecondary: Color(0xFF735761),
  error: Colors.red,
  onError: Colors.red,
  background: Color.fromRGBO(226, 229, 233, 1), //muu tausta
  onBackground: Color.fromARGB(255, 247, 130, 21), // "Enter distance" laatikko
  surface: Color.fromARGB(255, 247, 130, 21), //appBar tausta ja nappien taustat
  onSurface: Color.fromARGB(255, 34, 34, 34), //"Enter distance" teksti ja list tekstit ja drawer tekstit
);

var darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 124, 87, 146), //valittu teksti + nappien teksti
  onPrimary: Color.fromARGB(255, 22, 22, 22), //AppBar teksti
  primaryContainer: Color.fromARGB(255, 255, 255, 255), 
  onPrimaryContainer: Color(0xFFFFD8E6),
  secondary: Color(0xFFE1BDCA),
  onSecondary: Color(0xFF412A33),
  error: Colors.red,
  onError: Colors.red,
  background: Color.fromARGB(255, 22, 22, 22), //muu tausta
  onBackground: Color.fromARGB(255, 124, 87, 146),
  surface: Color.fromARGB(255, 124, 87, 146), //appbar tausta
  onSurface: Color.fromARGB(255, 237, 222, 245),
);

TextTheme textTheme(TextTheme base) {
  return base.apply(
    bodyColor: Colors.black, //Pikkuteskti väri
    // displayColor: Colors.pink,
  );
}

ThemeData getLightTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: lightColorScheme,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Color.fromARGB(255, 247, 130, 21)), // Route info teksti
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      titleTextStyle: TextStyle(
        color: lightColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color.fromRGBO(231, 236, 241, 1)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, // foreground (text) color
        backgroundColor: Color.fromARGB(255, 247, 130, 21), // background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   border: OutlineInputBorder(
    //     // borderSide: BorderSide(color: Colors.black)
    //   ),
    //   labelStyle: TextStyle(
    //     // color: Colors.black,
    //     // fontSize: 24.0
    //   ),
    //   prefixStyle: TextStyle(color: Colors.black,),
    //   helperStyle: TextStyle(color: Colors.black,)
    // ),
    // (
    //   style: TextStyle(color: Colors.white),
    // )
  );
}

ThemeData getDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    colorScheme: darkColorScheme,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Color.fromARGB(255, 124, 87, 146)), // Route info ja osoite teksti
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      titleTextStyle: TextStyle(
        color: darkColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 22, 22, 22)), //takaisinnuoli
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // foreground (text) color
        backgroundColor: Color.fromARGB(255, 124, 87, 146), // background color 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    ),
  );
}