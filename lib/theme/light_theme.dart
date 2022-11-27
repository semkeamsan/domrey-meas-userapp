import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  textTheme: TextTheme(
    headline1: TextStyle(color: Color.fromARGB(255, 54, 2, 2)),
    headline2: TextStyle(color: Color.fromARGB(255, 54, 2, 2)),
    bodyText2: TextStyle(color: Color.fromARGB(255, 54, 2, 2)),
    subtitle1: TextStyle(color: Color.fromARGB(255, 54, 2, 2)),
  ),
  fontFamily: 'Mulish',
  primaryColor: Color(0xFFdfad27),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: Color(0xFF9E9E9E),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
