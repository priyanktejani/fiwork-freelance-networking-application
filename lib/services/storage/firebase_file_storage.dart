import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFileStorage {
  final fireStorage = FirebaseStorage.instance;

  Future<String> uploadPostImage({
    required String userId,
    required File image,
    required String imageName,
  }) async {
    final ref = fireStorage.ref().child('post/$userId/$imageName').putFile(image);
    TaskSnapshot snapshot = await ref;
    return await snapshot.ref.getDownloadURL();
  }
}
