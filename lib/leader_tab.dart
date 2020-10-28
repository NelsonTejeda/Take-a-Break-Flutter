import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String username;
  Map<dynamic, dynamic> myMap;
  var list = ["1","2"];
  Widget myListOfUsers;


  @override
  void initState() {
    super.initState();
    myMap = {};
    myListOfUsers = Text("Connecting...");
  }

  @override
  void dispose() {
    myMap = {};
    myListOfUsers = Text("Connecting...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    Widget getTextWidgets(Map<dynamic, dynamic> users)
    {
      List<Widget> list = new List<Widget>();
      list.add(new SizedBox(width: 200,height: 50,));

      users.forEach((key, value) {
        list.add(new Container(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: const Radius.circular(30),
                bottom: const Radius.circular(30)
            ),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Color(0xFFFFD37A),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                //color: Colors.white,
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          value["username"],
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16
                          ),
                        ),
                        subtitle: Text(
                          "Current Score: ${value["score"]}",
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
        ));
        list.add(new SizedBox(width: 200,height: 20,));
      });
      return new Column(children: list);
    }

    databaseReference.child("/").once().then((DataSnapshot data){
      if(mounted){
        setState(() {
          myMap = data.value;
          //var sortedKeys = myMap.keys.toList()..sort();

          //myMap.forEach((key, value) => print(value["username"]));
          myListOfUsers = getTextWidgets(myMap);
        });
      }
      else{

      }

    });


    return Scaffold(
      body: SingleChildScrollView(
        child: myListOfUsers,
      ),
    );
  }
}

