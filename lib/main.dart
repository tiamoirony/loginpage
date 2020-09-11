import 'package:firebase_auth/firebase_auth.dart';
import 'package:zz/data/join_or_login.dart';
import 'package:zz/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zz/screens/main_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return ChangeNotifierProvider<JoinOrLogin>.value(
              value: JoinOrLogin(),
              child: AuthPage());
        } else {
          return MainPage(email: snapshot.data.email);
        }
      }
    );
  }
}


