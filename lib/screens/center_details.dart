import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class CenterDetails extends StatelessWidget {
  late final centerData;
  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    centerData = data["data"];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              CustomTopBar(
                child: Text(
                  "Center Details",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[50]),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16 + 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["name"],
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["address"],
                              decoration: InputDecoration(
                                labelText: "Address",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["from"],
                              decoration: InputDecoration(
                                labelText: "From",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["to"],
                              decoration: InputDecoration(
                                labelText: "To",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["fee"].toString(),
                              decoration: InputDecoration(
                                labelText: "Fee",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["date"],
                              decoration: InputDecoration(
                                labelText: "Date",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue:
                                  centerData["available_capacity"].toString(),
                              decoration: InputDecoration(
                                labelText: "Available Capacity",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue:
                                  centerData["min_age_limit"].toString(),
                              decoration: InputDecoration(
                                labelText: "Minimum age limit",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              initialValue: centerData["vaccine"],
                              decoration: InputDecoration(
                                labelText: "Vaccine",
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Go back"),
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
