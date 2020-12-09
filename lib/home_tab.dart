import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:take_a_break/globals.dart';
import 'package:dio/dio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String videoURL = "https://www.youtube.com/watch?v=fUv9gO8t8b4";
  YoutubePlayerController _controller;
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String username;
  Future<List<Widget>> news;
  Future<List<Widget>> workouts;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Container newWorkout(String img, String name, String reps, String sets, String time, String link){
    return Container(
      width: 200,
      height: 200,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(img,height: 100,width: double.infinity,),
            ListTile(
              title: Text(name),
              subtitle: Text("Sets: ${sets}, Reps: ${reps}, Time: ${time}"),
            ),
            RaisedButton(
              child: Text("Learn"),
              onPressed: (){
                print(link);
                setState(() {
                  _controller = YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(link)
                  );
                });
                return showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text(name),
                      content: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          YoutubePlayer(
                            controller: YoutubePlayerController(
                                initialVideoId: YoutubePlayer.convertUrlToId(link)
                            )
                          )
                        ],
                      ),
                    );
                  }
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Container newArticle(String title, String img, String description ){
    return Container(
      width: 200,
      height: 200,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(img,height: 100,width: double.infinity,),
            ListTile(
              title: Text(title),
              subtitle: Text(description),
            )
          ],
        ),
      ),
    );
  }

  apiCallTest() async {
    var response = await Dio().get('https://api.spoonacular.com/food/search?query=apple&number=2&apiKey=94b75a6f34c04e789c7ea46f2e23bdc9');
    await firestore.collection("workouts").get().then((snapshot){
      snapshot.docs.forEach((element) {
        print(element.data()["image"]);
      });
    });
    return response.data["searchResults"][0]["results"][0]["image"];
  }

  Future<List<Widget>> makeNewsScroll() async{
    List<Widget> list = new List<Widget>();
    var response = await Dio().get('https://api.spoonacular.com/food/menuItems/search?query=protein&number=10&apiKey=94b75a6f34c04e789c7ea46f2e23bdc9');
    for(var i = 0; i < 10; i++){
      print("times");
      list.add(newArticle(response.data["menuItems"][i]["title"], response.data["menuItems"][i]["image"], response.data["menuItems"][i]["title"]));
    }
    print("finished");
    return list;
  }
  Future<List<Widget>> makeWorkoutScroll() async{
    List<Widget> list = new List<Widget>();
    await firestore.collection("workouts").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        list.add(newWorkout(element.data()["image"], element.data()["name"], element.data()["reps"], element.data()["sets"], element.data()["time"],element.data()["link"]));
      });
    });
    return list;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoURL)
    );
    workouts = makeWorkoutScroll();
    news = makeNewsScroll();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings(null);
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings();
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    databaseReference.child("${Globals.uid}/username").once().then((DataSnapshot data){
      if(mounted && username != null){
        return;
      }
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
                            "Hello, ${Globals.username}!",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Color(0xFFE89696)
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.exit_to_app),
                            iconSize: 30.0,
                            tooltip: "add Friends",
                            color: Color(0xFFE89696),
                            onPressed: (){
                              context.read<AuthenticationHelper>().signOut();
                            },
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
              //color: Color(0xFFF2F3F4),
              height: height * 0.7,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Workouts:",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Color(0xFFE89696)
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 220,
                    child: FutureBuilder<List<Widget>>(
                      future: workouts,
                      builder: (context, snapshot){
                        return snapshot.hasData ?
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data,
                        ) :
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "..."),
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "..."),
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "...")
                          ],
                        );
                      },
                    ),
                  ),
                  Text(
                    "Foods:",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Color(0xFFE89696)
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    child: FutureBuilder<List<Widget>>(
                      future: news,
                      builder: (context, snapshot){
                        return snapshot.hasData ?
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data,
                        ) :
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "..."),
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "..."),
                            newArticle("loading", "https://i.pinimg.com/originals/6d/73/4e/6d734e72142078bc2b1994ef80902d9b.gif", "...")
                          ],
                        );
                      },
                    ),
                  ),
                  Text(
                    "Take A Break!",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: Color(0xFFE89696)
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('5 Seconds'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                await databaseReference.child("${Globals.uid}").once().then((DataSnapshot data) async {
                                  await databaseReference.child(Globals.uid).update({
                                    "score" : "${int.parse(data.value["score"]) + 1}",
                                    "lastBreak" : "5 Second Break"
                                  });
                                });

                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('10 Seconds'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 10));
                                FlutterRingtonePlayer.playAlarm();
                                print("10 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('5 minutes'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('10 minutes'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('15 minutes'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('30 minutes'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('45 minutes'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: Color(0xFFE89696),
                                size: 25,
                              ),
                              title: Text('1 hour'),
                              onTap: () async{
                                //showNotification();
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.playAlarm();
                                print("5 seconds have passed");
                                await Future.delayed(Duration(seconds: 5));
                                FlutterRingtonePlayer.stop();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                       print(await apiCallTest());
                    },
                    child: Text("api call test"),
                  ),

                ],
              ),
            ),
          )
        ],
      )
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high,importance: Importance.max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

}
