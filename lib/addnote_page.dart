import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFfff),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),
                          hintText: 'Başlık',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _noteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),
                          hintText: 'Not',
                        ),
                      ),
                      SizedBox(height: 20),
                      buildButtonContainer(),
                    ],
                  ),
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
            debugPrint(_titleController.text);
            debugPrint(_noteController.text);
            _addNoteFirebase(_titleController.text, _noteController.text);
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
              "Kaydet",
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

  int lengthNote() {
    var noteId = 0;
    _firestore.collection("users").getDocuments().then((querySnapshots) {
      noteId = querySnapshots.documents.length;
    });
    return noteId;
  }

  void _addNoteFirebase(String title, String note) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    var noteCont = lengthNote() + 1;

    _firestore
        .collection("users")
        .document(uid)
        .collection("Notes")
        .document("Note" + noteCont.toString())
        .setData({'title': title, 'note': note},
            merge: true).whenComplete(() => debugPrint(title + ":D"));

    /*   DocumentSnapshot documentSnapshot =
        await _firestore.document("users/$uid").get();
    debugPrint("Ad : " + documentSnapshot.data['ad']);*/
  }
}
