import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteappfirebase/note_model_page.dart';
import 'package:noteappfirebase/note_page.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class NoteRead extends StatefulWidget {
  final NoteModel noteModel;

  NoteRead(this.noteModel);

  final notePage = NotePageState();

  @override
  _NoteReadState createState() => _NoteReadState();
}

class _NoteReadState extends State<NoteRead> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var readableText = true;
  var _isVisibleButton = false;
  var editIcon = true;
  var deleteIcon = false;

  final _formKey = GlobalKey<FormState>();
  var _id;
  var date;

  bool willUpdate = false;

  bool favorite = false;

  @override
  void initState() {
    _titleController.text = widget.noteModel.title;
    _noteController.text = widget.noteModel.note;
    _id = widget.noteModel.id;
    date = widget.noteModel.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, willUpdate);
        return new Future(() => false);
      },
      child: Scaffold(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: deleteIcon,
                                child: Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.noteModel.favorite =
                                            !widget.noteModel.favorite;
                                        Toast.show(
                                            widget.noteModel.favorite
                                                ? "Not favorilere eklendi."
                                                : "Not favorilerinden kaldırıldı.",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      });
                                    },
                                    child: Container(
                                        child: Icon(
                                      widget.noteModel.favorite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 36,
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //Share
                                    share(_titleController.text,
                                        _noteController.text);
                                  });
                                },
                                child: Icon(Icons.share,
                                    size: 30, color: Colors.deepPurple),
                              ),
                              SizedBox(width: 30),
                              Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        readableText = false;
                                        _isVisibleButton = true;
                                        editIcon = false;
                                        deleteIcon = true;
                                      });
                                      debugPrint("düzenleme aktif");
                                    },
                                    child: Visibility(
                                      visible: editIcon,
                                      child: Icon(Icons.edit,
                                          size: 30, color: Colors.deepPurple),
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showDialog();
                                      });
                                    },
                                    child: Visibility(
                                      visible: deleteIcon,
                                      child: Icon(Icons.delete,
                                          size: 30, color: Colors.deepPurple),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          readOnly: readableText,
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 5.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Başlık',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          readOnly: readableText,
                          controller: _noteController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 5.0),
                              borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }

  Widget buildButtonContainer() {
    return Visibility(
      visible: _isVisibleButton,
      child: Container(
        height: 56.0,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              readableText = true;
              _isVisibleButton = false;
              editIcon = true;
              deleteIcon = false;
              setState(() {
                if (_formKey.currentState.validate()) {
                  debugPrint(_titleController.text);
                  debugPrint(_noteController.text);
                  DateTime today = new DateTime.now();
                  String dateSlug =
                      "${today.day.toString()}/${today.month.toString().padLeft(2, '0')}/${today.year.toString().padLeft(2, '0')}-${today.hour.toString().padLeft(2, '0')}/${today.minute.toString().padLeft(2, '0')}/${today.second.toString().padLeft(2, '0')}";

                  NoteModel noteModel = NoteModel(
                      title: _titleController.text,
                      note: _noteController.text,
                      date: dateSlug,
                      favorite: widget.noteModel.favorite);
                  _updateNoteFirebase(noteModel);
                }
              });
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.deepPurple),
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
      ),
    );
  }

  void _updateNoteFirebase(NoteModel noteModel) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    final docRef = _firestore
        .collection("users")
        .document(uid)
        .collection("Notes")
        .document(widget.noteModel.id);

    docRef.updateData({
      'id': _id,
      'date': noteModel.date,
      'title': noteModel.title,
      'note': noteModel.note,
      'favorite': noteModel.favorite
    }).then((v) {
      willUpdate = true;
    });
  }

  void _deleteNoteFirebase() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    final docRef = _firestore
        .collection("users")
        .document(uid)
        .collection("Notes")
        .document(widget.noteModel.id);

    docRef.delete().then((v) {
      willUpdate = true;
      debugPrint("İstenilen veri silindi");
    });
  }

  Future<void> _showDialog() async {
    FirebaseUser user = await _auth.currentUser();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Notu silmek istediğinizden emin misiniz?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Evet"),
              onPressed: () {
                _deleteNoteFirebase();
                Toast.show("Not listeden silindi.", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(user: user)));
              },
            ),
            new FlatButton(
              child: new Text("İptal Et"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void share(String title, String content) {
    final String text = "$title - $content";
    Share.share(text, subject: content);
  }
}
