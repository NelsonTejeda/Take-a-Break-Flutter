import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String username;
  Map<dynamic, dynamic> myMap;
  //var list = ["1","2"];
  Widget myListOfUsers;

  Future<String> getImage(String image) async {
    final _storage = FirebaseStorage.instance;
    String profileURL;
    try{
      profileURL = await _storage.ref().child("${image}/profilePhoto").getDownloadURL();
      print("URL LINKS TO PROFILE PIC: $profileURL");
      return profileURL;
    }
    catch(e){
      return "https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg";
    }
  }

  Widget getTextWidgets(Map<dynamic, dynamic> users)
  {
    List<Widget> list = new List<Widget>();
    list.add(
      new Text(
        "Leaderboard ",
        style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: Color(0xFFE89696)
        ),
      )
    );
    list.add(new SizedBox(width: 200,height: 10,));

    users.forEach((key, value) {
      list.add(new Container(
        padding: const EdgeInsets.only(top: 2.5, left: 10, right: 10, bottom: 2.5),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
              top: const Radius.circular(30),
              bottom: const Radius.circular(30)
          ),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  //width: 2,
                  color: Color(0xFF99a1ad),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE89696), Color(0xFFFFD37A)]
                  )
              ),
              //color: Colors.white,
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading:
                      FutureBuilder<String>(
                        future: getImage(key.toString()),
                        builder: (context, snapshot){
                          return snapshot.hasData ? CircleAvatar(backgroundImage: NetworkImage(snapshot.data), radius: 25.0) : CircularProgressIndicator();
                        },
                      ),
                      title: Text(
                        value["username"],
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                        "Current Score: ${value["score"]} \nLast Break: ${value["lastBreak"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            //color: Color(0xFFE89696)
                        ),
                      ),
                      isThreeLine: true,
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

  @override
  void initState() {
    super.initState();
    databaseReference.child("/").once().then((DataSnapshot data){
      myMap = data.value;
      myListOfUsers = getTextWidgets(myMap);
    });
    //myListOfUsers = getTextWidgets(myMap);
  }

  @override
  void dispose() {
    myMap = {};
    myListOfUsers = Text("Connecting...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){



    databaseReference.child("/").once().then((DataSnapshot data){
      if(mounted){
        setState(() {
          //myMap = data.value;
          //var sortedKeys = myMap.keys.toList()..sort();
          //myMap.forEach((key, value) => print(value["username"]));
          //myListOfUsers = getTextWidgets(myMap);
        });
      }
    });


    return Scaffold(
      body: SingleChildScrollView(
        child: myListOfUsers,
      ),
    );
  }
}

