import 'package:covid19_tracker/utils/constants.dart';
import 'package:covid19_tracker/utils/services/data_fetcher.dart';
import 'package:covid19_tracker/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final boldStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  final savedCountryList = ["USA", "India", "Brazil", "France"];

  Future<Map<String, dynamic>>? _allData;
  List<Map<String, dynamic>> globalDataList = [];
  List<Map<String, dynamic>> allCountriesDataList = [];
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();

    _allData = fetchStatistics();
    // Set state variables values
    _allData!.then((value) {
      this.globalDataList =
          value["globalDataList"] as List<Map<String, dynamic>>;
      this.allCountriesDataList = value["allCountryDataList"];
      var savedCountryList = value["savedCountryList"] as Set<String>;
      print(savedCountryList);
      this.dataList = getDataList(savedCountryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: pColor,
        onPressed: () async {
          // Get changed saved country list
          var result =
              await Navigator.pushNamed(context, "addCountry") as List<String>;
          print(result);
          setState(() {
            this.dataList = getDataList(result.toSet());
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              CustomTopBar(
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[50]),
                ),
              ),
              FutureBuilder(
                  future: _allData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Confirmed", style: boldStyle),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 10.0),
                            child: Text("Last updated on ${DateTime.now()}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 2),
                              itemCount: dataList.length,
                              itemBuilder: (context, index) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 2.0,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dataList[index]['name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600]),
                                              ),
                                              Flexible(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      dataList.removeAt(index);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.grey[300],
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                            dataList[index]['total'].toString(),
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
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
                  })
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getDataList(Set<String> savedCountryList) {
    // For countries in savedCountries, add country to data list
    List<Map<String, dynamic>> dataList = [];
    for (Map<String, dynamic> country in this.allCountriesDataList) {
      if (savedCountryList.contains(country["name"])) {
        dataList.add(country);
      }
    }
    print(dataList);
    return dataList;
  }
}
