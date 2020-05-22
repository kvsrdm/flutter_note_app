import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SpUtil.dart';
import 'login_page.dart';
import 'note_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseUser user;
  FirebaseAuth _auth;

  bool redirectToLogin = false;

  /*bool isLoggedIn = false;*/

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    initSpUtil();
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    Widget home;

    /* _auth.currentUser().then((user) {

    });*/

    /*return MaterialApp(
      title: 'Note App',
      home: home,
      routes: {
        '/login': (context) => new LoginPage(),
        '/note_page': (context) => new NotePage(),
      },
    );*/
    return Scaffold(
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
      )),
    );
  }

  Future<void> _checkUser() async {
    user = await _auth.currentUser();

    setState(() {
      redirectToLogin = user != null && user.uid != null && user.uid.isNotEmpty;

      if (user != null) {
        /*return NotePage();*/
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotePage(user: user)));
        /* return false;*/
      } else {
        /* return LoginPage();*/
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        /*return false;*/
      }
    });

    debugPrint("Check user" + redirectToLogin.toString() + " " + user.uid);
    /* setState(() {
      isLoggedIn = user != null;
    });*/
  }

  void initSpUtil() async {
    await SpUtil.getInstance();
  }
}
