import 'package:covid19_tracker/screens/tabs/dashboard_tab.dart';
import 'package:covid19_tracker/screens/tabs/guidelines_tab.dart';
import 'package:covid19_tracker/screens/tabs/vaccination_tab.dart';
import 'package:covid19_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final boldStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  final savedCountryList = ["USA", "India", "Brazil", "France"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
            indicatorWeight: 5.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: pColor,
            tabs: [
              Tab(
                text: "Dashboard",
                icon: Icon(Icons.dashboard),
              ),
              Tab(
                text: "Vaccination",
                icon: Icon(Icons.medication),
              ),
              Tab(
                text: "Guidelines",
                icon: Icon(Icons.info_outline_rounded),
              ),
            ]),
        body: SafeArea(
          child: TabBarView(
            children: [DashboardTab(), VaccinationTab(), GuidelinesTab()],
          ),
        ),
      ),
    );
  }
}
