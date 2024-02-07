import 'package:cloud_firestore/cloud_firestore.dart';

class MsgModel {
  final String docId;
  final String content;
  final String date;
  final String status;
  final String arrival;
  MsgModel({
    required this.docId,
    required this.content,
    required this.date,
    required this.status,
    required this.arrival,
  });

  factory MsgModel.fromDocument(DocumentSnapshot snap) {
    late String arrival;
    try {
      arrival = snap["arrival"];
    } catch (e) {
      arrival = "";
    }
    return MsgModel(
      docId: snap.id,
      content: snap["content"] ?? "",
      date: snap["date"].toString(),
      status: snap["status"] ?? "",
      arrival: arrival,
    );
  }
}
