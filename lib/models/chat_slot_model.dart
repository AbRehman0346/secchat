import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/AppConstants.dart';
import '../constants/msg_constants.dart';
import '../constants/user_constants.dart';

class ChatSlotModel {
  final String email;
  final String firstName;
  final String lastName;
  ChatSlotModel(
      {required this.email, required this.firstName, required this.lastName});

  factory ChatSlotModel.fromJson(DocumentSnapshot doc) {
    try {
      Map data = doc[MsgVariables.contactsDataField];
      return ChatSlotModel(
        email: data[UserFields.email],
        firstName: data[UserFields.firstName] ?? UserFields.defaultName,
        lastName: data[UserFields.lastName] ?? "",
      );
    } catch (e) {
      return ChatSlotModel(
          email: AppContent.reverseFormatEmail(doc.id),
          firstName: UserFields.defaultName,
          lastName: "");
    }
  }
}
