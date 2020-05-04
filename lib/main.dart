import 'package:flutter/material.dart';
import 'package:noteappfirebase/splashscreen_page.dart';
import 'addnote_page.dart';
import 'login_page.dart';
import 'note_page.dart';
import 'signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home:
          SplashScreenPage(), //TODO: landing page eklenecek / 31. bölüm 214. ders
      //TODO: Oturumu kapat
    );
  }
}
