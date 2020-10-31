import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:take_a_break/home_page.dart';
import 'package:take_a_break/sign_in_page.dart';
import 'package:take_a_break/globals.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationHelper>(
            create: (_) => AuthenticationHelper(FirebaseAuth.instance)
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationHelper>().authStateChanges,
        )
      ],
      child: MaterialApp(
      title: "Take a Break",
      theme: ThemeData(
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: AuthenticationWrapper(),
    ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser!= null){
      print("this is the uid: ${firebaseUser.uid}");
      Globals.uid = firebaseUser.uid;
      databaseReference.child("${Globals.uid}/username").once().then((DataSnapshot data) {
        Globals.username = data.value;
      });
      return Pages();
    }
    return SignInPage();
  }
}

