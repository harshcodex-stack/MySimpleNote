import 'package:flutter/material.dart';

class Note {
  int? id;
  String title, noteDescription;
  DateTime createdAt;
  double fontSize;
  Color fontColor;
  bool isBold;
  bool isItalic;
  bool isUnderline;


  Note({
    this.id,
    required this.title,
    required this.noteDescription,
    required this.createdAt,
    this.fontSize = 16.0,
    this.fontColor = Colors.black,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
});

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'noteDescription': noteDescription,
      'createdAt':createdAt.toString(),
      'fontSize': fontSize,
      'fontColor': fontColor.value,
      'isBold': isBold ? 1 : 0,
      'isItalic': isItalic ? 1 : 0,
      'isUnderline': isUnderline ? 1 : 0,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      noteDescription: map['noteDescription'],
      createdAt: DateTime.parse(map['createdAt']),
      fontSize: map['fontSize'],
      fontColor: Color(map['fontColor']),
      isBold: map['isBold'] == 1,
      isItalic: map['isItalic'] == 1,
      isUnderline: map['isUnderline'] == 1,
    );
  }

}

