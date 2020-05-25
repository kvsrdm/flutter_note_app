import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:noteappfirebase/SpUtil.dart';
import 'package:noteappfirebase/login_page.dart';
import 'package:toast/toast.dart';
import 'addnote_page.dart';
import 'note_model_page.dart';
import 'readnote_page.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class NotePage extends StatefulWidget {
  final FirebaseUser user;

  const NotePage({this.user});

  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<NoteModel> list = List();

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController _hideButtonController;
  FaderController faderController = new FaderController();

  Map noteFromCache;

  NoteModel noteModel;

  List<String> _sortList = ['Alfabetik', 'Önce En Yeni', 'Önce En Eski'];
  String _selectedItem;

  var bannerPadding = 0;

  static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  // ca-app-pub-3940256099942544/2247696110
  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  StreamSubscription _subscription;

/*  const _reviver(String key, value){
    if(key != null && value is Map && key.contains("-")) {
        return new NoteModel.fromJson(value);
      }
    return value;
  }

  const _toEncodable(NoteModel noteModel) {
    return {'title': noteModel.title, 'note': noteModel.note};
  }*/

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    /* const jsonCodec = const JsonCodec(reviver: _reviver, toEncodable: _toEncodable);
    var noteFromCacheString = SpUtil.getString("NOTE_CACHE");
    noteFromCache = jsonCodec.decode(noteFromCacheString);*/

    var noteFromCacheString = SpUtil.getString("NOTE_CACHE");
    if (noteFromCacheString != null && noteFromCacheString.isNotEmpty) {
      var note = jsonDecode(noteFromCacheString);
      noteModel = new NoteModel.fromJson(note);
      if (noteModel != null) {
        new Future.delayed(Duration.zero, () {
          showAlertDialog();
        });
      }
    }
    /* SpUtil.remove("NOTE_CACHE");*/
    list = List();
    getList();
    floatingActionButtonAnimation();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 100;
        });
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

/*  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        */ /*getList();*/ /*
        break;
      case AppLifecycleState.inactive: //IOS
        debugPrint("inactive çalıştı");
        break;
      case AppLifecycleState.paused:
        debugPrint("paused çalıştı");
        break;
      case AppLifecycleState.detached:
        debugPrint("detached çalıştı");
        break;
    }
  }*/

  /* @override
  void didChangeDependencies() {
    debugPrint("Resume çalıştı");
    getList();
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*    RaisedButton(
                onPressed: () {},
                child: Text('Show SnackBar'),
              ),*/
              /*  SizedBox(
                  height: bannerPadding
                      .toDouble()), //TODO: Boyut farklı telefon boyutlarına göre düzenlenecek*/
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        if (_auth.currentUser() != null) {
                          _auth.signOut().then((data) {
                            /*Toast.show("Oturum kapatılıyor.", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                            debugPrint("Çıkış yapıldı");
                          }).catchError((onError) {
                            debugPrint(
                                "Çıkış yaparken bir hata oluştu. $onError");
                          });
                        } else {
                          debugPrint("Kullanıcı yok.");
                        }
                      },
                      child: Text(
                        "Çıkış",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.deepPurple),
                      ),
                    )),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Text(
                      "Notlar",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    child: DropdownButton(
                      hint: Text('Sıralama'), // Not necessary for Option 1
                      value: _selectedItem,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedItem = newValue;
                          if (_selectedItem == _sortList[0]) {
                            sortListString(list);
                          } else if (_selectedItem == _sortList[1]) {
                            sortListDateNew(list);
                          } else if (_selectedItem == _sortList[2]) {
                            sortListDateOld(list);
                          }
                        });
                      },
                      items: _sortList.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: _height,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: NativeAdmob(
                    adUnitID: _adUnitID,
                    controller: _nativeAdController,
                    loading: Container(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: list.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          controller: _hideButtonController,
                          itemBuilder: (BuildContext context, int index) {
                            debugPrint("Liste bos değil");
                            return Container(
                              height: 120,
                              child: GestureDetector(
                                onTap: () {
                                  moveToNote(index);
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
                                      Icon(Icons.note,
                                          color: Colors.deepPurple),
                                      Spacer(),
                                      Text(list[index].title),
                                      Spacer(),
                                      SizedBox(width: 15),
                                      Text(list[index].date.split('-')[0]),
                                      SizedBox(width: 15),
                                      GestureDetector(
                                        onTap: () {
                                          _updateNote(!list[index].favorite,
                                              list[index].id);
                                          if (list[index].favorite == false) {
                                            Toast.show(
                                                "Not favorilerine eklendi.",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          } else {
                                            Toast.show(
                                                "Not favorilerinden kaldırıldı.",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }
                                        },
                                        child: Container(
                                            child: Icon(
                                                list[index].favorite
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.amber)),
                                      ),
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
        ),
        floatingActionButton: Fader(
          controller: faderController,
          duration: const Duration(milliseconds: 280),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              openAddNotePage(null);
            },
          ),
        ),
      ),
    );
  }

  openAddNotePage(NoteModel noteModel) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => noteModel == null
                ? AddNote.name()
                : AddNote.name(cachedNote: noteModel)));
    debugPrint(result.toString());

    if (result) {
      getList();
    }
  }

  getList() async {
    //final FirebaseUser user = await _auth.currentUser();

    List<NoteModel> noteList = List();

    _firestore
        .collection("users")
        .document(widget.user.uid)
        .collection("Notes")
        .getDocuments()
        .then((querySnapshots) {
      for (int i = 0; i < querySnapshots.documents.length; i++) {
        NoteModel titleDate = NoteModel(
            id: querySnapshots.documents[i].data['id'].toString(),
            title: querySnapshots.documents[i].data['title'].toString(),
            note: querySnapshots.documents[i].data['note'].toString(),
            date: querySnapshots.documents[i].data['date'].toString(),
            favorite: querySnapshots.documents[i].data['favorite'] as bool);
        noteList.add(titleDate);
      }

      setState(() {
        list = noteList;
        sortListDateNew(list);
      });
    });
  }

  sortListDateNew(List<NoteModel> list) {
    //yeniden eski tarihe göre sıralama işlemi
    list.sort((a, b) => b.date.toString().compareTo(a.date.toString()));
  }

  sortListDateOld(List<NoteModel> list) {
    //eskiden yeni tarihe göre sıralama işlemi
    list.sort((a, b) => a.date.toString().compareTo(b.date.toString()));

    /* //TODO: Reklamları kaldır deneme aşaması
    removeAds();*/
  }

  sortListString(List<NoteModel> list) {
    //title'a göre alfabetik sıralama işlemi
    list.sort((a, b) => a.title
        .toString()
        .toLowerCase()
        .compareTo(b.title.toString().toLowerCase()));
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

  void moveToNote(int index) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteRead(list[index])));
    debugPrint(result.toString());

    if (result) {
      getList();
    }
  }

  void showAlertDialog() {
    showGeneralDialog(
        /* barrierColor: Colors.black.withOpacity(0.5),*/
        transitionBuilder: (context, a1, a2, widget) {
          return Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Kaydedilmemiş notunuz var.'),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          NoteModel note = noteModel;
                          openAddNotePage(note);

                          SpUtil.remove("NOTE_CACHE");
                          noteModel = null;
                        },
                        child: Text("Düzenle"),
                      ),
                      FlatButton(
                        onPressed: () {
                          SpUtil.remove("NOTE_CACHE");
                          noteModel = null;
                          Navigator.pop(context);
                        },
                        child: Text("Atla"),
                      ),
                    ],
                  )
                ],
              ));
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  _emptyState() {
    debugPrint("Liste bos");
    return Center(
      child: Container(
        height: 150,
        child: Column(
          children: <Widget>[
            Container(
              /*child: Image(image: AssetImage('assets/images/note.png')),*/
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/note.png'))),
            ),
            SizedBox(height: 10),
            Text("Henüz not eklemedin", style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text("Ekle butonuna basarak yeni not ekleyebilirsin.",
                style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _updateNote(bool favorite, var noteId) {
    final docRef = _firestore
        .collection("users")
        .document(widget.user.uid)
        .collection("Notes")
        .document(noteId);

    docRef.updateData({
      'favorite': favorite,
    }).then((v) {
      setState(() {
        getList();
      });
    });
  }
}
