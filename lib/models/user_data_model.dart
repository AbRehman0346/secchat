import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String docId;
  String email;
  String firstName;
  String lastName;
  String phone;
  String date;
  UserDataModel({
    required this.docId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.date,
  });

  factory UserDataModel.fromJson(DocumentSnapshot snapshot) {
    return UserDataModel(
      docId: snapshot.id,
      email: snapshot["email"] ?? "",
      firstName: snapshot["firstName"] ?? "",
      lastName: snapshot["lastName"] ?? "",
      phone: snapshot["phone"] ?? "",
      date: snapshot["date"].toString(),
    );
  }
}
