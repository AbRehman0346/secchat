import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../constants/AppConstants.dart';

class FirebaseStorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<void> uploadProfileImage(File file) async {
    await _storage.ref(AppContent.userProfilePicture).putFile(file);
  }

  Future<String> getImage(String imageURL) async {
    return await _storage.ref(imageURL).getDownloadURL();
  }
}
