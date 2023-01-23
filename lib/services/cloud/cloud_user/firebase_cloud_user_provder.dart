// 3

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_storage_exceptions.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_provider.dart';

class FirebaseCloudUserProvider extends CloudUserProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();

  final _users = 'users';

  @override
  Future<void> createNewUser(CloudUser cloudUser) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_users)
        .doc(cloudUser.userId)
        .set(cloudUser.toMap());
  }

  @override
  Future<CloudUser?> getUser({
    required String userId,
  }) async {
    final document = await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_users)
        .doc(userId)
        .get();
    final json = document.data();

    if (json != null) {
      return CloudUser.fromMap(json);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<List<CloudUser>> searchUsers(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_users)
          .where('full_name', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudUser.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_users)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudUser.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  @override
  Future<bool> followUser(CloudUser currentUser, CloudUser followUser) async {
    bool res = false;
    try {
      res = false;
      if (followUser.follower.contains(currentUser.userId)) {
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_users)
            .doc(followUser.userId)
            .update({
          'follower': FieldValue.arrayRemove([currentUser.userId])
        });
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_users)
            .doc(currentUser.userId)
            .update({
          'following': FieldValue.arrayRemove([followUser.userId])
        });
      } else {
        res = true;
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_users)
            .doc(followUser.userId)
            .update({
          'follower': FieldValue.arrayUnion([currentUser.userId])
        });
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_users)
            .doc(currentUser.userId)
            .update({
          'following': FieldValue.arrayUnion([followUser.userId])
        });
      }
    } catch (_) {}
    return res;
  }

  @override
  Future<bool> isFollowing(CloudUser currentUser, CloudUser followUser) async {
    bool res = false;
    try {
      if (followUser.follower.contains(currentUser.userId)) {
        res = true;
      } else {
        res = false;
      }
    } catch (_) {}
    return res;
  }
}
