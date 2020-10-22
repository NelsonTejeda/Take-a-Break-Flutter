import 'package:take_a_break/Authentication_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_a_break/fitnessAPI.dart';


//Enock was here
//Nelson was here as well

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HOME"),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationHelper>().signOut();
              },
              child: Text("Sign out"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FitnessAPI()),
                );
              },
              child: Text("google maps"),
            )
          ],
        ),
      ),
    );
  }
}