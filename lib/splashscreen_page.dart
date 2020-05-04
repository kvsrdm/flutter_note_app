import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'note_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseUser user;
  FirebaseAuth _auth;

  /*bool isLoggedIn = false;*/

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return LoginPage();
    } else if (user != null) {
      return NotePage(user: user);
    }
  }

  Future<void> _checkUser() async {
    user = await _auth.currentUser();
    /* setState(() {
      isLoggedIn = user != null;
    });*/
  }
}
