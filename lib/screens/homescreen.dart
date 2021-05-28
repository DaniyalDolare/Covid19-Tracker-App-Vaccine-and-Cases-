import 'package:covid19_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> globalDataList = [
    {"title": "Total Confirmed", "number": 169879799, "color": pColor},
    {"title": "Total Deaths", "number": 3530136, "color": Colors.red},
    {"title": "Total Recovered", "number": 151786249, "color": Colors.black}
  ];
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
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [pSwatch, pSwatch[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16,
                  ),
                  Card(
                    margin: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Globally",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          for (var item in globalDataList)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item["title"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                  ),
                                  Text(
                                    item["number"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: item["color"]),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
