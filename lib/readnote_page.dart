import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteappfirebase/note_model_page.dart';
import 'package:noteappfirebase/note_page.dart';

class NoteRead extends StatefulWidget {
  final NoteModel noteModel;
  NoteRead(this.noteModel);

  @override
  _NoteReadState createState() => _NoteReadState();
}

class _NoteReadState extends State<NoteRead> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  var readableText = true;

  final _formKey = GlobalKey<FormState>();

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
                      Container(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                /* final instance = NotePageState();
                                instance.getList()[3];*/
                              },
                              child: Icon(Icons.edit,
                                  size: 30, color: Colors.deepPurple),
                            ),
                            SizedBox(width: 30),
                            Icon(Icons.delete,
                                size: 30, color: Colors.deepPurple),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        readOnly: readableText,
                        controller: _titleController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            /*enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),*/
                            /*focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                          ),*/
                            hintText: 'Başlık',
                            labelText: widget.noteModel.title),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        readOnly: readableText,
                        controller: _noteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Not',
                            labelText: widget.noteModel.note),
                      ),
                      SizedBox(height: 20),
                      //buildButtonContainer(),
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

/*  Widget buildButtonContainer() {
    return Container(
      height: 56.0,
      child: RaisedButton(
        onPressed: () {
          //TODO: Progress show

          */ /*    if (_formKey.currentState.validate()) {
            debugPrint(_titleController.text);
            debugPrint(_noteController.text);
            DateTime today = new DateTime.now();
            String dateSlug =
                "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
          }*/ /*
          */ /*else {
            debugPrint("else");
          }*/ /*
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
  }*/
}
