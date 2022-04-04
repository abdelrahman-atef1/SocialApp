import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/colors.dart';

var lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: mainColor)),
    fontFamily: 'jannah',
    primarySwatch: mainColor,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      selectedItemColor: mainColor,
      unselectedItemColor: Colors.grey,
    ));
