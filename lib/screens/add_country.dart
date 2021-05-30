import 'package:covid19_tracker/utils/constants.dart';
import 'package:covid19_tracker/utils/services/data_fetcher.dart';
import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> countryList = [];
  List<Map<String, dynamic>> searchResult = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    Text("Add Country")
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
                            borderSide: BorderSide(color: Colors.red, width: 5),
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
                  FutureBuilder(
                      future: getCountryList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          countryList =
                              snapshot.data as List<Map<String, dynamic>>;
                          if (searchResult.isNotEmpty ||
                              _controller.text.isNotEmpty) {
                            return ListView.builder(
                                itemCount: searchResult.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => SwitchListTile(
                                    tileColor: Colors.white,
                                    title: Text(searchResult[index]["name"]),
                                    value: searchResult[index]["isSaved"],
                                    onChanged: (value) {
                                      setState(() {
                                        countryList[index]["isSaved"] = value;
                                      });
                                    }));
                          } else {
                            return ListView.builder(
                                itemCount: countryList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => SwitchListTile(
                                    tileColor: Colors.white,
                                    title: Text(countryList[index]["name"]),
                                    value: countryList[index]["isSaved"],
                                    onChanged: (value) {
                                      setState(() {
                                        countryList[index]["isSaved"] = value;
                                      });
                                    }));
                          }
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
    );
  }

  void searchCountry(String text) {
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
}
