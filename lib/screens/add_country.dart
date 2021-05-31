import 'package:covid19_tracker/utils/constants.dart';
import 'package:covid19_tracker/utils/services/data_fetcher.dart';
import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  TextEditingController _controller = TextEditingController();
  Future<List<Map<String, dynamic>>>? _countryList;
  List<Map<String, dynamic>> countryList = [];
  List<Map<String, dynamic>> searchResult = [];

  @override
  void initState() {
    super.initState();
    _countryList = getCountryList();
    _countryList!.then((value) => this.countryList = value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        List<String> savedCountries = await saveCountries();
        // Pop screen with savedCountries list
        Navigator.pop(context, savedCountries);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                CustomTopBar(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          List<String> savedCountries = await saveCountries();
                          // Pop screen with savedCountries list
                          Navigator.pop(context, savedCountries);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Add Country",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[50]),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 16 + 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search..",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                        ),
                        onChanged: searchCountry,
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                        future: _countryList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // print(countryList == snapshot.data);
                            // this.countryList =
                            //     snapshot.data as List<Map<String, dynamic>>;
                            if (searchResult.isNotEmpty ||
                                _controller.text.isNotEmpty) {
                              return Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: searchResult.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Container(
                                          margin: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors
                                                          .grey.shade400))),
                                          child: SwitchListTile(
                                              tileColor: Colors.white,
                                              title: Text(
                                                  searchResult[index]["name"]),
                                              value: searchResult[index]
                                                  ["isSaved"],
                                              onChanged: (value) {
                                                for (var country
                                                    in countryList) {
                                                  if (country["name"] ==
                                                      searchResult[index]
                                                          ["name"]) {
                                                    country["isSaved"] = value;
                                                  }
                                                }
                                                setState(() {
                                                  searchResult[index]
                                                      ["isSaved"] = value;
                                                });
                                              }),
                                        )),
                              );
                            } else {
                              return Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: countryList.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Container(
                                          margin: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors
                                                          .grey.shade400))),
                                          child: SwitchListTile(
                                              tileColor: Colors.white,
                                              title: Text(
                                                  countryList[index]["name"]),
                                              value: countryList[index]
                                                  ["isSaved"],
                                              onChanged: (value) {
                                                setState(() {
                                                  countryList[index]
                                                      ["isSaved"] = value;
                                                });
                                              }),
                                        )),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Container(
                              height: MediaQuery.of(context).size.height -
                                  (MediaQuery.of(context).size.height / 4),
                              alignment: Alignment.center,
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchCountry(
    String text,
  ) {
    searchResult.clear();
    List<Map<String, dynamic>> resultList = [];
    for (Map<String, dynamic> data in countryList) {
      if (data["name"].toString().toLowerCase().contains(text.toLowerCase())) {
        resultList.add(data);
      }
    }
    setState(() {
      searchResult = resultList;
    });
  }

  Future<List<String>> saveCountries() async {
    // Save changes of savedCountries in pref
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> savedCountries = [];
    for (var country in countryList) {
      if (country["isSaved"]) {
        savedCountries.add(country["name"]);
      }
    }
    pref.setStringList("savedCountries", savedCountries);
    print("countries saved");
    return savedCountries;
  }
}
