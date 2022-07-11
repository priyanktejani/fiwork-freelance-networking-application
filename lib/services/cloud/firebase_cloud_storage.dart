import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:fiwork/services/cloud/cloud_user.dart';

class FirebaseCloudStorage {
  final users = FirebaseFirestore.instance.collection('users');

  void createNewUser({
    required String email,
    required String userId,
    required String fullName,
    required String userName,
  }) async {
    await users.doc(userId).set({
      emailFieldName: email,
      userIdFieldName: userId,
      fullNameFieldName: fullName,
      userNameFieldName: userName,
    });
  }

  Future<CloudUser?> getUser({
    required String userId,
  }) async {
    final document = await users.doc(userId).get();
    final json = document.data();

    if (json != null) {
      return CloudUser.fromJson(json);
    } else {
      throw UserNotFoundException();
    }
  }

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
