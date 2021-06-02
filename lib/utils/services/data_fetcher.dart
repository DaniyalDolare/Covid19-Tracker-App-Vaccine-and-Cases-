import 'dart:convert';
import 'dart:io';
import 'package:covid19_tracker/utils/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

final headers = {
  "x-rapidapi-host": "covid-193.p.rapidapi.com",
  "x-rapidapi-key": "f7de9c9031mshc6181de5aca69b3p1f88a8jsn8140b4cacc69",
};

Future<Map<String, dynamic>> fetchStatistics() async {
  // Get statistics data from api

  final url = Uri.https("covid-193.p.rapidapi.com", "statistics");
  var responseBody;

  try {
    final response = await http.get(url, headers: headers);
    responseBody = _response(response);
  } on SocketException {
    throw FetchDataException("No internet connection");
  }
  final responseList = responseBody["response"] as List<dynamic>;

  // Get saved country list from pref else use default
  SharedPreferences pref = await SharedPreferences.getInstance();

  // Check if countries are saved or not
  List<String>? savedCountryList = [];
  bool areSaved = pref.containsKey("savedCountries");
  if (!areSaved) {
    pref.setStringList("savedCountries", ["USA", "India", "Brazil", "France"]);
    savedCountryList = ["USA", "India", "Brazil", "France"];
  } else {
    savedCountryList = pref.getStringList("savedCountries");
  }

  // Process data into required format
  List<Map<String, dynamic>> globalDataList = [
    {"title": "Total Confirmed", "number": "", "color": pColor},
    {"title": "Total Deaths", "number": "", "color": Colors.red},
    {"title": "Total Recovered", "number": "", "color": Colors.black}
  ];
  List<Map<String, dynamic>> allCountryDataList = [];
  for (Map<String, dynamic> response in responseList) {
    if (response["country"] == "All") {
      // Set the global data
      globalDataList[0]["number"] = response["cases"]["total"] ?? 0;
      globalDataList[1]["number"] = response["deaths"]["total"] ?? 0;
      globalDataList[2]["number"] = response["cases"]["recovered"] ?? 0;
    } else {
      allCountryDataList.add({
        "name": response["country"],
        "total": response["cases"]["total"] ?? 0
      });
    }
  }
  // Make a map from global,saved and allcountrydata list
  Map<String, dynamic> data = {
    "globalDataList": globalDataList,
    "allCountryDataList": allCountryDataList,
    "savedCountryList": savedCountryList
  };

  // Return the data
  return data;
}

Future<List<Map<String, dynamic>>> getCountryList() async {
  // Get country list from api

  final url = Uri.https("covid-193.p.rapidapi.com", "countries");
  var responseBody;

  try {
    final response = await http.get(url, headers: headers);
    responseBody = _response(response);
  } on SocketException {
    throw FetchDataException("No internet connection");
  }

  final countries = responseBody["response"] as List<dynamic>;

  // Get saved country list from pref
  final pref = await SharedPreferences.getInstance();
  Set<String> savedCountries = pref.getStringList("savedCountries")!.toSet();

  // For countries in saved country, mark their isSaved as true else false
  List<Map<String, dynamic>> countryList = [];
  for (String country in countries) {
    if (savedCountries.contains(country)) {
      countryList.add({"name": country, "isSaved": true});
    } else {
      countryList.add({"name": country, "isSaved": false});
    }
  }
  return countryList;
}

dynamic _response(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> getStatesData() async {
  final response = await rootBundle.loadString("assets/data/data.json");
  final statesData =
      List<Map<String, dynamic>>.from(jsonDecode(response)["states"]);
  return statesData;
}

Future<List<Map<String, dynamic>>> getVaccineData(
    int districtId, DateTime date) async {
  final Map<String, dynamic> param = {
    "district_id": districtId.toString(),
    "date": "${date.day}-${date.month}-${date.year}"
  };
  var responseBody;

  final url = Uri.https("cdn-api.co-vin.in",
      "api/v2/appointment/sessions/public/findByDistrict", param);
  try {
    final response = await http.get(url);
    responseBody = _response(response);
  } on SocketException {}

  final data = List<Map<String, dynamic>>.from(responseBody["sessions"]);
  return data;
}
