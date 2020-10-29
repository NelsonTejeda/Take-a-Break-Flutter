import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        "name here",
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
                                        Text("Some Text")
                                      ],
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: (){
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
              child: ListWheelScrollView(
                children: <Widget>[
                  Text("Friend 1"),
                  Text("Friend 2"),
                  Text("Friend 2"),
                  Text("Friend 4"),
                  Text("Friend 5")
                ],
                itemExtent: 42,
              ),
            )
          )
        ],
      ),
    );
  }
}
