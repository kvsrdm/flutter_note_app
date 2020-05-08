import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteappfirebase/login_page.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool agreePol = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Sign up",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  controller: emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'E-mail is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Password'),
                  controller: passwordController,
                  validator: (value) {
                    if (value.length < 6) {
                      return 'Password must be least 6 characters';
                    }
                    if (value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value.length < 6) {
                      return 'Password must be least 6 characters';
                    }
                    if (value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: agreePol,
                      onChanged: (bool value) {
                        setState(() {
                          agreePol = value;
                        });
                      },
                    ),
                    Text("I agree to the Terms of Use and Privacy Policy.",
                        style: TextStyle(fontSize: 14, color: Colors.black38)),
                  ],
                ),
                SizedBox(height: 50),
                Container(
                  height: 56.0,
                  child: RaisedButton(
                    onPressed: () {
                      //_userSignUp(emailController.text, passwordController.text);
                      if (_formKey.currentState.validate()) {
                        if (confirmPasswordController.text ==
                            passwordController.text) {
                          _userSignUp(
                              emailController.text, passwordController.text);
                          Toast.show("Kullanıcı kaydı oluşturuldu.", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          Toast.show("Password uyuşmazlığı!", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: LinearGradient(
                            colors: [Color(0xFFe79ddc), Color(0xFFd490e7)],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft),
                      ),
                      child: Center(
                        child: Text(
                          "Create",
                          style: TextStyle(
                              color: Color(0xFFeabfed),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _userSignUp(String email, String password) async {
    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .catchError((e) => debugPrint("Hata: " + e.toString()));

    if (firebaseUser != null) {
      debugPrint("Uid: " + firebaseUser.user.uid);
    }
  }
}
