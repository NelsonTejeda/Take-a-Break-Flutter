import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:take_a_break/globals.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String username;

  @override
  Widget build(BuildContext context) {
    databaseReference.child("${Globals.uid}/username").once().then((DataSnapshot data){
      setState(() {
        username = data.value;
      });
    });
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd yyyy').format(now);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                            "Hello, ${username}!",
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
                  Text("")
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
