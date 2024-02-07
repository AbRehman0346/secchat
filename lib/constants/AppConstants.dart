import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppContent {
  static const String profilePlaceHolder =
      "assets/images/profileplaceholder.jpeg";

  //Firebase Database Variables
  static const String userProfileDataDoc = "profileData";
  static late String _collection;
  static late User _user;
  static late String _userProfilePicture;
  static String firebaseProfileImageFolderName = "profileImages/";

  //Setters
  static set user(User? user) {
    _user = user!;
    _collection = formatEmail(user!.email!);
    _userProfilePicture = "$firebaseProfileImageFolderName$_collection";
  }

  //Getters
  static get collection => _collection;
  static User get user => _user;

  static String get userProfilePicture => _userProfilePicture;

  static String formatEmail(String email) {
    String charKey = "character";
    String repKey = "replacement";
    List<Map> specialCharacters = [
      {charKey: "@", repKey: "ATTHERATE"},
      {charKey: "-", repKey: "HYPHEN"},
      {charKey: ".", repKey: "PERIOD"},
      {charKey: "+", repKey: "PLUS"},
    ];
    for (Map s in specialCharacters) {
      email = email.replaceAll(s[charKey], s[repKey]);
    }
    return email.trim();
  }

  static String reverseFormatEmail(String email) {
    String replaceKey = "character";
    String charKey = "replacement";
    List<Map> specialCharacters = [
      {replaceKey: "@", charKey: "ATTHERATE"},
      {replaceKey: "-", charKey: "HYPHEN"},
      {replaceKey: ".", charKey: "PERIOD"},
      {replaceKey: "+", charKey: "PLUS"},
    ];
    for (Map s in specialCharacters) {
      email = email.replaceAll(s[charKey], s[replaceKey]);
    }
    return email.trim();
  }

  //Theme
  Color fontBlackColor = Colors.black;
  Color screenWhiteColor = Colors.white;
  Color selectionColorWithWhiteBG = Colors.grey;
}
