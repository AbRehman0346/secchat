import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/msg_constants.dart';
import '../constants/user_constants.dart';
import '../models/user_data_model.dart';
import '../models/variable_class_model/msg_status.dart';
import '../constants/AppConstants.dart';
import '../xutils/xalert_dialog.dart';

class FirestoreServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> saveUserProfileData({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
  }) async {
    //Uploading Data of User to database.
    await firebaseFirestore
        .collection(AppContent.collection)
        .doc(AppContent.userProfileDataDoc)
        .set({
      UserFields.date: DateTime.now(),
      UserFields.firstName: firstName,
      UserFields.lastName: lastName,
      UserFields.email: email,
      UserFields.phone: phone,
      UserFields.uid: AppContent.user.uid,
    });
    return true;
  }

  dynamic addContact(String email,
      {String? firstName, String? lastName}) async {
    String doc = AppContent.formatEmail(email);
    if (await verifyExistance(doc)) {
      await firebaseFirestore.collection(AppContent.collection).doc(doc).set({
        MsgVariables.contactsDataField: {
          UserFields.firstName: firstName,
          UserFields.lastName: lastName,
          UserFields.email: email
        }
      });
      return true;
    } else {
      return "Contact Doesn't Exist";
    }
  }

  Future<UserDataModel> getUserData() async {
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(AppContent.collection)
        .doc(AppContent.userProfileDataDoc)
        .get();
    return UserDataModel.fromJson(snapshot);
  }

  Future<bool> verifyExistance(String email) async {
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(email)
        .doc(AppContent.userProfileDataDoc)
        .get();
    return snapshot.exists;
  }

  Future<void> sendMsg(String receiverEmail, String msg) async {
    String senderCollection = AppContent.collection;
    receiverEmail = AppContent.formatEmail(receiverEmail);
    Map<String, dynamic> senderReadyMsg = {
      MsgFields.content: msg,
      MsgFields.date: DateTime.now(),
      MsgFields.status: MsgStatus.sent,
      MsgFields.arrival: MsgStatus.sent,
      MsgFields.interval: DateTime.now().millisecondsSinceEpoch,
      MsgFields.type: MsgType.plainText,
    };

    Map<String, dynamic> receiverReadyMsg = {
      MsgFields.content: msg,
      MsgFields.date: DateTime.now(),
      MsgFields.status: MsgStatus.new_,
      MsgFields.interval: DateTime.now().millisecondsSinceEpoch,
    };

// Saving Msg to Sender's Account.
    //Adding Document if it doesn't exist
    await firebaseFirestore
        .collection(receiverEmail)
        .doc(senderCollection)
        .set({});

    //Saving msg.
    await firebaseFirestore
        .collection(senderCollection)
        .doc(receiverEmail)
        .collection(MsgVariables.msgsCollectionName)
        .add(senderReadyMsg);

//Saving Msg to Receiver's Account.
    //Adding Document if it doesn't exist
    await firebaseFirestore
        .collection(receiverEmail)
        .doc(senderCollection)
        .set({});
    //Saving Msg.
    await firebaseFirestore
        .collection(receiverEmail)
        .doc(senderCollection)
        .collection(MsgVariables.msgsCollectionName)
        .add(receiverReadyMsg);
  }

  Future<void> deleteMsg({required String email, required String docId}) async {
    email = AppContent.formatEmail(email).trim();
    await firebaseFirestore
        .collection(AppContent.collection)
        .doc(email)
        .collection(MsgVariables.msgsCollectionName)
        .doc(docId)
        .delete();
  }

  Future<void> deleteAllMsgs(
      {required String email, isEmailFormatted = false}) async {
    if (!isEmailFormatted) {
      email = AppContent.formatEmail(email).trim();
    }
    //First Deleting All the Msgs
    //Getting all the docs.
    final QuerySnapshot snapshot = await firebaseFirestore
        .collection(AppContent.collection)
        .doc(email)
        .collection(MsgVariables.msgsCollectionName)
        .get();

    //Getting collection reference to use it later for delete.
    CollectionReference collection = firebaseFirestore
        .collection(AppContent.collection)
        .doc(email)
        .collection(MsgVariables.msgsCollectionName);

    //Deleting all the docs.
    for (var doc in snapshot.docs) {
      await collection.doc(doc.id).delete();
    }
  }

  Future<void> deleteContact({required String email}) async {
    email = AppContent.formatEmail(email).trim();
    //First Deleting All the Msgs
    deleteAllMsgs(email: email, isEmailFormatted: true);

    //Deleting the main contact doc.
    await firebaseFirestore
        .collection(AppContent.collection)
        .doc(email)
        .delete();
  }
}
