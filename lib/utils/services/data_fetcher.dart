import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

Future<Map<String, dynamic>> fetchStatistics() async {
  // Get statistics data from api
  final url = Uri.https("covid-193.p.rapidapi.com", "statistics");
  final headers = {
    "x-rapidapi-host": "covid-193.p.rapidapi.com",
    "x-rapidapi-key": "f7de9c9031mshc6181de5aca69b3p1f88a8jsn8140b4cacc69",
  };
  final response = await http.get(url, headers: headers);
  final responseBody = jsonDecode(response.body);
  final responseList = responseBody["response"] as List<dynamic>;

  // Get saved country list from pref else use default
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String>? savedCountryList = pref.getStringList("savedCountry") ??
      ["USA", "India", "Brazil", "France"];

  // Process data into required format
  List<Map<String, dynamic>> globalDataList = [
    {"title": "Total Confirmed", "number": "", "color": pColor},
    {"title": "Total Deaths", "number": "", "color": Colors.red},
    {"title": "Total Recovered", "number": "", "color": Colors.black}
  ];
  List<Map<String, dynamic>> countryDataList = [];
  for (Map<String, dynamic> response in responseList) {
    if (response["country"] == "All") {
      // Set the global data
      globalDataList[0]["number"] = response["cases"]["total"] ?? 0;
      globalDataList[1]["number"] = response["deaths"]["total"] ?? 0;
      globalDataList[2]["number"] = response["cases"]["recovered"] ?? 0;
    } else {
      for (String country in savedCountryList) {
        // For countries in savedCountries, add data to country list
        if (response["country"] == country) {
          countryDataList.add({
            "name": response["country"],
            "total": response["cases"]["total"] ?? 0
          });
        }
      }
    }
  }
  Map<String, dynamic> data = {
    "globalDataList": globalDataList,
    "countryDataList": countryDataList
  };

  // Return the data
  return data;
}

getCountryList() async {
  // Get country list from api
  final url = Uri.https("covid-193.p.rapidapi.com", "countries");
  final headers = {
    "x-rapidapi-host": "covid-193.p.rapidapi.com",
    "x-rapidapi-key": "f7de9c9031mshc6181de5aca69b3p1f88a8jsn8140b4cacc69",
  };
  final response = await http.get(url, headers: headers);
  final responseBody = jsonDecode(response.body);
  final responseList = responseBody["response"] as List<dynamic>;
  print(responseList);
}
