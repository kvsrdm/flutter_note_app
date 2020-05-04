import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:noteappfirebase/note_model_page.dart';
import 'package:noteappfirebase/note_page.dart';
import 'package:toast/toast.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  bool _saving = false;
  bool _isAbsorbing = false;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isAbsorbing,
      child: Scaffold(
        body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xFFfff),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 30, right: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.0),
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
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1.0),
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
            inAsyncCall: _saving),
      ),
    );
  }

  Widget buildButtonContainer() {
    return Container(
      height: 56.0,
      child: RaisedButton(
        onPressed: () {
          //Progress show

          setState(() {
            _saving = true;
            _isAbsorbing = true;
          });

          if (_formKey.currentState.validate()) {
            debugPrint(_titleController.text);
            debugPrint(_noteController.text);
            DateTime today = new DateTime.now();
            String dateSlug =
                "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

            NoteModel noteModel = NoteModel(
                title: _titleController.text,
                note: _noteController.text,
                date: dateSlug);
            _addNoteFirebase(noteModel);
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
            color: Colors.deepPurple,
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

  void _addNoteFirebase(NoteModel noteModel) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    final docRef = _firestore
        .collection("users")
        .document(uid)
        .collection("Notes")
        .document();

    docRef
        .setData({
          'id': docRef.documentID,
          'date': noteModel.date,
          'title': noteModel.title,
          'note': noteModel.note
        }, merge: true)
        .whenComplete(() => Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotePage(user: user))))
        .catchError((onError) {
          debugPrint(onError);
          //Hide progress
          _saving = false;
          _isAbsorbing = false;
        });
  }
}
