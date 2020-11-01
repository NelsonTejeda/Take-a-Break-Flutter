import 'package:flutter/material.dart';
import 'package:take_a_break/globals.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController emailController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  var userExist = false;
  var newCounterVal = "";
  var friendPosistion = "0";
  Map<dynamic, dynamic> userFriends = Map();
  Map<dynamic,dynamic> friendListInfo =  Map();
  List<Widget> listTemp;
  Future<List<Widget>>listOfFriendWidget;

  List<Widget> getFriendWidgets(Map<dynamic, dynamic> users){
    List<Widget> list = new List<Widget>();
    list.add(Text(""));
    users.forEach((key, value) {
      print(value);
      list.add(
          new Row(
            children: <Widget>[
              SizedBox(width: 150,),
              CircleAvatar(
                backgroundImage: null,
                radius: 15,
              ),
              SizedBox(width: 10,),
              Text(value)
            ],
          ),
      );
    });
    return list;
  }

  Future<List<Widget>> getFriends() async{
    List<Widget> temp;
    await databaseReference.child("${Globals.uid}/friends").once().then((DataSnapshot data) async{
      userFriends = data.value;
      await databaseReference.child("/").once().then((DataSnapshot dataroot) async{
        userFriends.forEach((key, value) {
          if(dataroot.value[key] != null){
            friendListInfo[key] = dataroot.value[key]["username"];
          }
        });
        temp = getFriendWidgets(friendListInfo);
      });
    });
    return temp;
  }

  @override
  void initState() {
    super.initState();
    listOfFriendWidget = getFriends();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40)
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE89696), Color(0xFFFFD37A)]
                )
            ),
            child: Container(
              width: 500.0,
              height: 275.0,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: null,
                        radius: 50.0,
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        Globals.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 150,),
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            iconSize: 30.0,
                            tooltip: "Change/Set Profile Photo",
                            color: Color(0xFFE89696),
                            onPressed: (){
                              print("icon camera");
                            },
                          ),
                          SizedBox(width: 5,),
                          IconButton(
                            icon: Icon(Icons.person_add),
                            iconSize: 30.0,
                            tooltip: "add Friends",
                            color: Color(0xFFE89696),
                            onPressed: (){
                              return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                   return AlertDialog(
                                    title: Text("Add a Friend"),
                                    content: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            hintText: "email of friend",
                                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: (){
                                          if(emailController.text.trim().length > 0){
                                            databaseReference.child("/").once().then((DataSnapshot data){
                                              data.value.forEach((key, value){
                                                if(value["email"] == emailController.text.trim()){
                                                  newCounterVal = value["friends"]["counter"];
                                                  newCounterVal = "${int.parse(newCounterVal) + 1}";
                                                  userExist = true;
                                                  databaseReference.child("${Globals.uid}/friends").update({
                                                    'counter' : newCounterVal,
                                                    key : emailController.text.trim()
                                                  });
                                                }
                                              });
                                              if(!userExist){
                                                print("user does not exist");
                                              }
                                              else{
                                                userExist = false;
                                              }
                                            });
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        textColor: Theme.of(context).primaryColor,
                                        child: const Text("add"),
                                      )
                                    ],
                                  );
                                }
                              );
                            },
                          ),
                        ],
                      )
                    ]
                ),
              )
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            "Stats",
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w400
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Icon(
                Icons.airline_seat_flat,
                color: Color(0xFFE89696),
                size: 45,
              ),
              SizedBox(width: 20,),
              Text(
                "Breaks",
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              SizedBox(width: 200,),
              Text(
                "#breaks",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Icon(
                Icons.timer,
                color: Color(0xFFE89696),
                size: 45,
              ),
              SizedBox(width: 20,),
              Text(
                "Longest Break",
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              SizedBox(width: 155,),
              Text(
                "#time",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Text(
            "Friends",
            style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w400
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 200,
            child: Center(
              child: FutureBuilder<List<Widget>>(
                future: listOfFriendWidget,
                builder: (context, snapshot){
                  return snapshot.hasData ?
                      ListWheelScrollView(
                        children: snapshot.data,
                        itemExtent: 50,
                        useMagnifier: true,
                        magnification: 1.5,
                      ) :
                  ListWheelScrollView(
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                    itemExtent: 42,
                    useMagnifier: true,
                    magnification: 1.5,
                  );
                },
              ),
            )
          )
        ],
      )),
    );
  }
}
