import 'package:take_a_break/Authentication_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Image.asset('assets/images/logohighrez.png')),
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
                onPressed: () {
                  context.read<AuthenticationHelper>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  );
                },
                child: Text("Sign in"),
          )),
          Container(
            width: 300.0,
              child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                onPressed: () {
                  context.read<AuthenticationHelper>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  );
                },
                child: Text("Sign Up"),
          ))
        ],
      ), backgroundColor: Colors.white
    );
  }
}