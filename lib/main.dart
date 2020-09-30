import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:take_a_break/Authentication_Helper.dart';
import 'package:take_a_break/home_page.dart';
import 'package:take_a_break/sign_in_page.dart';

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
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: AuthenticationWrapper(),
    ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser!= null){
      return HomePage();
    }
    return SignInPage();
  }
}

