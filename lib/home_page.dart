import 'package:take_a_break/Authentication_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_a_break/fitnessAPI.dart';
import 'package:intl/intl.dart';
import 'package:take_a_break/sign_in_page.dart';
import 'main.dart';


//Enock was here
//Nelson was here as well

class HomePage extends StatelessWidget {
  final String emailName;
  HomePage({Key key, @required this.emailName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String cutEmail = emailName!=null?emailName.substring(0,emailName.indexOf("@")):"Person";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd yyyy').format(now);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F4),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: 1,
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
              style: const TextStyle(color: Color(0xFFE89696)),
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                "Home",
                style: const TextStyle(color: Color(0xFFE89696)),
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                "Profile",
                style: const TextStyle(color: Color(0xFFE89696)),
              )
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            height: height * 0.15,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: const Radius.circular(40)
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        formattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                        "Hello, " + cutEmail,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Color(0xFFE89696)
                        ),
                      ),
                    ),
                  ]
                )
              ),
            ),
          ),
          Positioned(
            top: height * 0.20,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFFF2F3F4),
              height: height * 0.7,
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      context.read<AuthenticationHelper>().signOut();
                    },
                    child: Text("Sign out"),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}