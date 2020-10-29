import 'package:take_a_break/Authentication_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_a_break/home_tab.dart';
import 'package:take_a_break/leader_tab.dart';
import 'package:take_a_break/profile_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_a_break/fitnessAPI.dart';
import 'package:intl/intl.dart';
import 'package:take_a_break/sign_in_page.dart';
import 'main.dart';


//Enock was here
//Nelson was here as well

class Pages extends StatefulWidget{
  HomePage createState() => HomePage();
}

class HomePage extends State<Pages> {
  String clean = "";
  int _currentIndex = 1;
  final tabs = [
    LeaderBoard(),
    HomeTab(),
    ProfileTab(),
  ];
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd yyyy').format(now);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F4),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(
          color: const Color(0xFFE89696)
        ),
        unselectedIconTheme: IconThemeData(
          color: const Color(0xFFFFD37A)
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text(
              "leaderboards",
              style: TextStyle(color: Color(0xFFE89696)),
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(color: Color(0xFFE89696)),
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                "Profile",
                style: TextStyle(color: Color(0xFFE89696)),
              )
          )
        ],
        onTap: (int index){
          if(!mounted) return;
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}