import 'package:take_a_break/Authentication_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:take_a_break/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_a_break/home_page.dart';

class SignInPage extends StatelessWidget {
  //make a static string
  static String emailName;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Image.asset('assets/images/logohighrez.png')),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Create/Set new Username",
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 20.0,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Email",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 20.0,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          ),
          Container(
            width: 300.0,
              child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Color(0xFFE89696),
                onPressed: () async{
                  await context.read<AuthenticationHelper>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  );
                  databaseReference.child("${Globals.uid}/username").once().then((DataSnapshot data) {
                    Globals.username = data.value;
                  });
                  print(Globals.uid);
                  if(usernameController.text.trim().length > 0){
                    Globals.username = usernameController.text.trim();
                    databaseReference.child(Globals.uid).update({
                      'username': usernameController.text.trim(),
                      'email': emailController.text.trim(),
                      'password': passwordController.text.trim()
                    });
                  }
                },
                child: Text("Sign in"),
          )),
          Container(
            width: 300.0,
              child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                onPressed: () async{
                  await context.read<AuthenticationHelper>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  );
                  print(Globals.uid);
                  print(Globals.uid);
                  Globals.username = usernameController.text.trim();
                  databaseReference.child(Globals.uid).set({
                    'username': usernameController.text.trim(),
                    'email': emailController.text.trim(),
                    'password': passwordController.text.trim(),
                    'score' : "0",
                    'friends' : {
                      'counter' : "0"
                    }
                  });
                },
                child: Text("Sign Up"),
          ))
        ],
      ), backgroundColor: Colors.white
    );
  }
}