import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

class NoteModel {
  String id;
  String title;
  String note;
  String date;
  bool favorite = false;

  NoteModel({this.id, this.title, this.note, this.date, this.favorite});

  factory NoteModel.fromJson(Map<String, dynamic> parsedJson) {
    return NoteModel(
        title: parsedJson['title'].toString(),
        note: parsedJson['note'].toString());
  }

  Map toJson() {
    return {'title': title, 'note': note};
  }

  //Map<String, dynamic> toJson() => {'title': title, 'note': note};

/*
  String get titleVal => title;

  set titleValue(String value) {
    title = value;
  }

  String get dateVal => date;

  set dateValue(String value) {
    date = value;
  }*/

}
