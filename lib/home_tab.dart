import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:take_a_break/globals.dart';
import 'package:dio/dio.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String username;
  Future<List<Widget>> news;

  Container newArticle(String title, String img, String description ){
    return Container(
      width: 200,
      height: 200,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(img),
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
    var response = await Dio().get('https://newsapi.org/v2/top-headlines?country=us&apiKey=5f3442d6b21842528f3eb23490cf9e3d');
    return response.data["articles"][0]["title"];
  }

  Future<List<Widget>> makeNewsScroll() async{
    List<Widget> list = new List<Widget>();
    var response = await Dio().get('https://newsapi.org/v2/top-headlines?country=us&apiKey=5f3442d6b21842528f3eb23490cf9e3d');
    for(var i = 0; i < 10; i++){
      list.add(newArticle(response.data["articles"][i]["title"], response.data["articles"][i]["urlToImage"], response.data["articles"][i]["description"]));
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    news = makeNewsScroll();
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
                  Container(
                    width: 400,
                    height: 300,
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
                  RaisedButton(
                    onPressed: () {
                      context.read<AuthenticationHelper>().signOut();
                    },
                    child: Text("Sign out"),
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
}
