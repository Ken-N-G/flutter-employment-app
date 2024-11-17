import 'package:flutter/material.dart';

final primaryTheme = ThemeData(
  colorScheme: colorScheme,
  textTheme: textTheme,
  inputDecorationTheme: inputDecorationTheme
);

const inputDecorationTheme = InputDecorationTheme(
  floatingLabelStyle: TextStyle(
    color: Color(0xFF2E5094)
  )
);
 
ColorScheme anotherScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF27488A));

const colorScheme = ColorScheme(
  brightness: Brightness.light, 
  primary: Color(0xFF27488A), 
  onPrimary: Color(0xFFFEFEFE), 
  secondary: Color(0xFF5475B7), 
  onSecondary: Color(0xFFFEFEFE), 
  error: Color(0xFFA63636), 
  onError: Color(0xFFFEFEFE), 
  errorContainer: Color.fromARGB(255, 246, 130, 130),
  onErrorContainer: Color(0xFFA63636),
  background: Color(0xFFFEFEFE),
  onBackground: Color(0xFF212121), 
  surface: Color(0xFFFEFEFE), 
  onSurface: Color(0xFF212121),
  outline: Color.fromARGB(255, 122, 122, 122)
);

const textTheme = TextTheme(
  displaySmall: TextStyle(
    fontFamily: "DMSans",
    fontSize: 48,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
  headlineMedium: TextStyle(
    fontFamily: "DMSans",
    fontSize: 34,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
  headlineSmall: TextStyle(
    fontFamily: "DMSans",
    fontSize: 24,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
  titleLarge: TextStyle(
    fontFamily: "DMSans",
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFF212121)
  ),
  bodyLarge: TextStyle(
    fontFamily: "DMSans",
    fontSize: 16,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
  bodyMedium: TextStyle(
    fontFamily: "DMSans",
    fontSize: 14,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
  bodySmall: TextStyle(
    fontFamily: "DMSans",
    fontSize: 12,
    fontStyle: FontStyle.normal,
    color: Color(0xFF212121)
  ),
);

