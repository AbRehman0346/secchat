import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secchat/constants/AppConstants.dart';
import 'firebase_storage_services.dart';
import 'firestore_services.dart';

class FirebaseAuthServices {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  Future<User?> registerNewUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    File? file,
  }) async {
    email = email.trim();
    password = password.trim();
    firstName = firstName.trim();
    lastName = lastName.trim();
    phone != null ? phone.trim() : phone;

    //Registering/Creating User using email.
    AppContent.user = await FirebaseAuthServices()
        ._registerWithEmailAndPassword(email, password);
    if (AppContent.user == null) {
      return AppContent.user;
    }

    //Uploading Data of User to database.
    FirestoreServices().saveUserProfileData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
    //Uploading User Profile Image to Database
    if (file != null) {
      FirebaseStorageServices().uploadProfileImage(file);
    }
    return AppContent.user;
  }

  Future<auth.User?> _registerWithEmailAndPassword(
      String email, String password) async {
    auth.UserCredential userCre = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    AppContent.user = userCre.user;
    return userCre.user;
  }

  Future<auth.User?> signInWithEmailAndPassword(
      String email, String password) async {
    auth.UserCredential userCre = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    AppContent.user = userCre.user;
    return userCre.user;
  }

  Future<void> signOut() async {
    firebaseAuth.signOut();
  }
}
