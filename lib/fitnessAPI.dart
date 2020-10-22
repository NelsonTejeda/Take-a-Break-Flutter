import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new FitnessAPI(),
  ));
}

class FitnessAPI extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<FitnessAPI> {

  Map data;

  Future<String> getData() async {
    //https://hacker-news.firebaseio.com/v0/
    //https://ron-swanson-quotes.herokuapp.com/v2/quotes
    //http://www.recipepuppy.com/api/
    //https://api.adviceslip.com/advice
    var response = await http.get(
        Uri.encodeFull("https://api.adviceslip.com/advice"),
        headers: {
          "Accept": "application/json"
        }
    );
    data = json.decode(response.body);
    print(data["slip"]["advice"]);

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text("Get Advice!"),
          onPressed: getData,
        ),
      ),
    );
  }
}
