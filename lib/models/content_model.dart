import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/msg_constants.dart';

class ContentModel {
  String content;
  String date;
  String status;
  bool isSafe;

  ContentModel({
    required this.content,
    required this.status,
    required this.date,
    required this.isSafe,
  });

  factory ContentModel.fromJson(DocumentSnapshot doc) {
    try {
      Map map = doc["1"];
      return ContentModel(
        content: map[MsgFields.content] ?? "",
        status: map[MsgFields.status] ?? "",
        date: map[MsgFields.date].toString(),
        isSafe: true,
      );
    } catch (e) {
      return ContentModel(content: "", status: "", date: "", isSafe: false);
    }
  }
}
