import 'package:covid19_tracker/utils/constants.dart';
import 'package:covid19_tracker/utils/services/vaccine_data_fetcher.dart';
import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class VaccinationTab extends StatefulWidget {
  @override
  _VaccinationTabState createState() => _VaccinationTabState();
}

class _VaccinationTabState extends State<VaccinationTab>
    with AutomaticKeepAliveClientMixin<VaccinationTab> {
  @override
  bool get wantKeepAlive => false;

  Future<List<Map<String, dynamic>>>? _dataList;
  List<Map<String, dynamic>> dataList = [];
  List<String> stateList = [];
  List<Map<String, dynamic>> districtList = [];
  String? selectedState;
  Map<String, dynamic>? selectedDistrict;
  int? districtId;
  DateTime? _date;
  Future<List<Map<String, dynamic>>>? _vaccineData;
  List<Map<String, dynamic>> vaccineData = [];

  @override
  void initState() {
    super.initState();
    _dataList = getStatesData();
    _dataList!.then((value) {
      this.dataList = value;
      for (Map<String, dynamic> data in value) {
        this.stateList.add(data["state_name"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomTopBar(
                child: Text(
              "Vaccination Details",
              style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[50]),
            )),
            FutureBuilder(
                future: _dataList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 16,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  DropdownButton(
                                    isExpanded: true,
                                    value: selectedState,
                                    hint: Text(" State"),
                                    items: stateList
                                        .map((value) => DropdownMenuItem(
                                            child: Text(" $value"),
                                            value: value))
                                        .toList(),
                                    onChanged: getDistrictList,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButton(
                                    isExpanded: true,
                                    value: selectedDistrict,
                                    hint: Text(" District"),
                                    items: districtList
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                  " ${value["district_name"]}"),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (dynamic value) {
                                      print(value);
                                      setState(() {
                                        selectedDistrict = value;
                                        districtId = value["district_id"];
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        var date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(
                                                DateTime.now().year + 1));
                                        setState(() {
                                          _date = date;
                                        });
                                      },
                                      child: Text(_date == null
                                          ? "Pick Start Date"
                                          : "${_date!.day}-${_date!.month}-${_date!.year}")),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_date != null &&
                                            districtId != null) {
                                          _vaccineData = getVaccineData(
                                              districtId!, _date!);
                                          setState(() {
                                            _vaccineData!.then((value) =>
                                                this.vaccineData = value);
                                          });
                                        }
                                      },
                                      child: Text("Get Vaccination Details")),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (vaccineData.isNotEmpty) ...[
                            FutureBuilder(
                                future: _vaccineData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: vaccineData.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                              title: Text(
                                                vaccineData[index]["name"],
                                              ),
                                              subtitle: Text(
                                                  "Vaccine: ${vaccineData[index]["vaccine"]}"),
                                            ));
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                })
                          ]
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  getDistrictList(dynamic value) {
    int stateIndex = stateList.indexOf(value.toString());
    List<Map<String, dynamic>> _districtList = [];
    for (Map<String, dynamic> data in dataList[stateIndex]["districts"]) {
      _districtList.add({
        "district_name": data["district_name"],
        "district_id": data["district_id"]
      });
    }
    print(_districtList);
    setState(() {
      selectedState = value.toString();
      this.districtList = _districtList;
    });
  }
}
