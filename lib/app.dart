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
        home: HomeScreen());
  }
}
