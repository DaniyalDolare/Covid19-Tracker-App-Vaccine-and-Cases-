import 'package:covid19_tracker/screens/add_country.dart';
import 'package:covid19_tracker/screens/homescreen.dart';
import 'package:covid19_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: pColor,
          primarySwatch: pSwatch,
        ),
        routes: {
          "homescreen": (context) => HomeScreen(),
          "addCountry": (context) => AddCountry()
        },
        home: HomeScreen());
  }
}
