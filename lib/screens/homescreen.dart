import 'package:covid19_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 8,
                width: double.infinity,
                color: pColor,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 10.0, left: 10.0),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[50]),
                    ),
                  ),
                ),
              ),
              Column(
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}
