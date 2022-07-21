import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/cloud/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:fiwork/services/cloud/cloud_user.dart';

class FirebaseCloudStorage {
  final firebaseFirestore = FirebaseFirestore.instance;
  final users = 'users';
  final posts = 'posts';

  void createNewUser({
    required String email,
    required String userId,
    required String fullName,
    required String userName,
  }) async {
    await firebaseFirestore.collection(users).doc(userId).set({
      emailFieldName: email,
      userIdFieldName: userId,
      fullNameFieldName: fullName,
      userNameFieldName: userName,
    });
  }

  Future<CloudUser?> getUser({
    required String userId,
  }) async {
    final document =
        await firebaseFirestore.collection(users).doc(userId).get();
    final json = document.data();

    if (json != null) {
      return CloudUser.fromJson(json);
    } else {
      throw UserNotFoundException();
    }
  }

  Future<void> createNewPost({
    required String userId,
    required String profileUrl,
    required String fullName,
    required String postUrl,
    required String caption,
    required final likes,
  }) async {
    await firebaseFirestore.collection(posts).add({
      userIdFieldName: userId,
      profileUrlFieldName: postUrl,
      fullNameFieldName: fullName,
      publishedTimeFieldName: DateTime.now(),
      postUrlFieldName: postUrl,
      captionFieldName: caption,
      likesFieldName: likes,
    });
  }

  Stream<Iterable<CloudPost>> allPosts() =>
      firebaseFirestore.collection(posts).snapshots().map(
            (event) => event.docs.map(
              (doc) => CloudPost.fromSnapshot(doc),
            ),
          );

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
