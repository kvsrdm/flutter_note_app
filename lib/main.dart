import 'package:flutter/material.dart';
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
      home: LoginPage(), //TODO: landing page eklenecek / 31. bölüm 214. ders
    );
  }
}
