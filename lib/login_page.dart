import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:toast/toast.dart';
import 'note_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _userEmailController = new TextEditingController();
  TextEditingController _userPasswordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  void _tgVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _userEmailController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFe99fde), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.0),
                                ),
                                hintText: 'Email',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'E-mail is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _userPasswordController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFe99fde), width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black38, width: 1.0),
                                  ),
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: _tgVisibility,
                                    icon: passwordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  )),
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'Password must be least 6 characters';
                                }
                                return null;
                              },
                              obscureText: passwordVisible,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint("Forgot :(");
                                },
                                child: Row(
                                  children: <Widget>[
                                    Spacer(),
                                    Text(
                                      "Forgot?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            buildButtonContainer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipPath(
                        clipper: WaveClipperOne(flip: true, reverse: true),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xFF7e87d2), Color(0xFFe99fde)],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(height: 20),

                            //TODO: Sign up sayfasına git
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                                debugPrint("Sign up");
                              },
                              child: Container(
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonContainer() {
    return Container(
      height: 56.0,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            debugPrint(_userEmailController.text);
            debugPrint(_userPasswordController.text);
            _userLogin(_userEmailController.text, _userPasswordController.text);
          }
          /*else {
            debugPrint("else");
          }*/
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
                colors: [Color(0xFF7e87d2), Color(0xFFe99fde)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft),
          ),
          child: Center(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void _userLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      //debugPrint("");
      //email.trim() maili girerken boşluk kullanırsan parçalayıp gözardı ediyor
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotePage()));
      //debugPrint("oldu");
    } catch (e) {
      Toast.show("Email veya şifre hatalı!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      debugPrint("bak gene hata " + e.toString());
    }
  }
}
