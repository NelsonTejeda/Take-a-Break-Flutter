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
