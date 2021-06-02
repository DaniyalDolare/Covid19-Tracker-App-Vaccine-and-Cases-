import 'package:covid19_tracker/utils/constants.dart';
import 'package:covid19_tracker/utils/services/data_fetcher.dart';
import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class VaccinationTab extends StatefulWidget {
  @override
  _VaccinationTabState createState() => _VaccinationTabState();
}

class _VaccinationTabState extends State<VaccinationTab>
    with AutomaticKeepAliveClientMixin<VaccinationTab> {
  @override
  bool get wantKeepAlive => true;

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
  bool getData = false;
  String selectedButton = "Find by district";
  List<String> buttonList = ["Find by district", "Find by pin"];
  TextEditingController pinController = TextEditingController();

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
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: buttonList.map((value) {
                                        Color fillColor = bgColor;
                                        Color textColor = Colors.black;
                                        if (value == selectedButton) {
                                          fillColor = pColor;
                                          textColor = Colors.white;
                                        }
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: fillColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            onPressed: () {
                                              setState(() {
                                                selectedButton = value;
                                              });
                                            },
                                            child: Text(
                                              value,
                                              style:
                                                  TextStyle(color: textColor),
                                            ));
                                      }).toList()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (selectedButton == "Find by district") ...[
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
                                        setState(() {
                                          selectedDistrict = value;
                                          districtId = value["district_id"];
                                        });
                                      },
                                    ),
                                  ],
                                  if (selectedButton == "Find by pin")
                                    TextField(
                                      controller: pinController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Enter pin code"),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  OutlinedButton(
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
                                    child: Text(
                                      _date == null
                                          ? "Pick Date"
                                          : "${_date!.day}-${_date!.month}-${_date!.year}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: getVaccineData,
                                    child: Text("Get Vaccination Details",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (getData) ...[
                            FutureBuilder(
                                future: _vaccineData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (vaccineData.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Center List",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(4.0),
                                            color: Colors.white,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: vaccineData.length,
                                                itemBuilder: (context, index) =>
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400))),
                                                      child: ListTile(
                                                        trailing: Icon(Icons
                                                            .navigate_next),
                                                        title: Text(
                                                          vaccineData[index]
                                                              ["name"],
                                                        ),
                                                        subtitle: Text(
                                                            "Vaccine: ${vaccineData[index]["vaccine"]}"),
                                                        tileColor: Colors.white,
                                                        shape: Border(
                                                            bottom:
                                                                BorderSide()),
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "centerDetails",
                                                              arguments: {
                                                                "data":
                                                                    vaccineData[
                                                                        index]
                                                              });
                                                        },
                                                      ),
                                                    )),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Center(
                                        child:
                                            Text("No vaccine data available"),
                                      );
                                    }
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                })
                          ] else ...[
                            Center(
                              child: Text(" Select all fields appropriately"),
                            )
                          ]
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  void getDistrictList(dynamic value) {
    //Clear the previous district data
    if (selectedDistrict != null) {
      this.districtList.clear();
      this.selectedDistrict = null;
    }

    int stateIndex = stateList.indexOf(value.toString());
    List<Map<String, dynamic>> _districtList = [];
    for (Map<String, dynamic> data in dataList[stateIndex]["districts"]) {
      _districtList.add({
        "district_name": data["district_name"],
        "district_id": data["district_id"]
      });
    }
    setState(() {
      selectedState = value.toString();
      this.districtList = _districtList;
    });
  }

  getVaccineData() {
    if (selectedButton == buttonList[0]) {
      //Get data by district
      if (_date != null && districtId != null) {
        this._vaccineData = getVaccineDataByDistrict(districtId!, _date!);
      }
    } else {
      // Get data by pin

      if (_date != null && pinController.text.isNotEmpty) {
        print(pinController.text);
        this._vaccineData =
            getVaccineDataByPin(pinController.text.toString(), _date!);
      }
    }
    setState(() {
      this.getData = true;
      _vaccineData!.then((value) => this.vaccineData = value);
    });
  }
}
