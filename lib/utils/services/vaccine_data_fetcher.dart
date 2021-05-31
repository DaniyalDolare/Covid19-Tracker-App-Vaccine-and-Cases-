import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getStatesData() async {
  final response = await rootBundle.loadString("assets/data/data.json");
  // Map<String, dynamic> data = jsonDecode(response) as Map<String, dynamic>;
  final statesData =
      List<Map<String, dynamic>>.from(jsonDecode(response)["states"]);
  // final statesData = data["states"] as List<Map<String, dynamic>>;
  return statesData;
}

Future<List<Map<String, dynamic>>> getVaccineData(
    int districtId, DateTime date) async {
  final Map<String, dynamic> param = {
    "district_id": districtId.toString(),
    "date": "${date.day}-${date.month}-${date.year}"
  };
  final url = Uri.https("cdn-api.co-vin.in",
      "api/v2/appointment/sessions/public/findByDistrict", param);
  final response = await http.get(url);
  final responseBody =
      List<Map<String, dynamic>>.from(jsonDecode(response.body)["sessions"]);
  return responseBody;
}
