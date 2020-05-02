import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'addnote_page.dart';
import 'note_model_page.dart';
import 'readnote_page.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage>
    with SingleTickerProviderStateMixin {
  List<NoteModel> list = List();
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController _hideButtonController;
  FaderController faderController = new FaderController();

  @override
  void initState() {
    getList();
    floatingActionButtonAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Notlar",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,

                //Refresh listview
                child: ListView.builder(
                  controller: _hideButtonController,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteRead(list[index])));
                        },
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          color: Color(0xFFf7f7f7),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 15),
                              Icon(Icons.note, color: Colors.deepPurple),
                              Spacer(),
                              Text(list[index].title),
                              Spacer(),
                              Text(list[index].date),
                              SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: list == null ? 0 : list.length,
                  // itemCount: list.length = 2,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Fader(
          controller: faderController,
          duration: const Duration(milliseconds: 280),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddNote()));
            },
          ),
        ),
      ),
    );
  }

  getList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    _firestore
        .collection("users")
        .document(uid)
        .collection("Notes")
        .getDocuments()
        .then((querySnapshots) {
      for (int i = 0; i < querySnapshots.documents.length; i++) {
        NoteModel titleDate = NoteModel(
            id: querySnapshots.documents[i].data['id'].toString(),
            title: querySnapshots.documents[i].data['title'].toString(),
            note: querySnapshots.documents[i].data['note'].toString(),
            date: querySnapshots.documents[i].data['date'].toString());

        setState(() {
          list.add(titleDate);
        });
      }
    });
  }

  void floatingActionButtonAnimation() {
    _hideButtonController = ScrollController();

    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        faderController.fadeOut();
      } else if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        faderController.fadeIn();
      }
    });
  }
}
