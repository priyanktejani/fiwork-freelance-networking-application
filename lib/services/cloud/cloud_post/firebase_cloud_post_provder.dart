// 3
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_comment.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_provider.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';

class FirebaseCloudPostProvider extends CloudPostProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();
  final _posts = 'posts';
  final _comment = 'comments';

  @override
  Stream<Iterable<CloudPost>> allPosts() {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_posts)
        .orderBy('published_time', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudPost.fromSnapshot(doc),
          ),
        );
  }

  @override
  Future<void> createNewPost(CloudPost cloudPost) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_posts)
        .doc(cloudPost.postId)
        .set(
          cloudPost.toJson(),
        );
  }

  @override
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_posts)
          .doc(postId)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Future<bool> isPostLiked(String postId, String userId, List likes) async {
    if (likes.contains(userId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> likePost(String postId, String userId, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(userId)) {
        // if the likes list contains the user uid, we need to remove it
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_posts)
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        // else we need to add uid to the likes array
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_posts)
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Stream<Iterable<CloudPost>> userAllPosts(String userId) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_posts)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudPost.fromSnapshot(doc),
          ),
        );
  }

  @override
  Future<List<CloudPost>> searchPosts(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_posts)
          .where('full_name', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudPost.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_posts)
          .orderBy('published_time', descending: true)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudPost.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  @override
  Future<void> createNewComment(CloudPostComment cloudPostComment) async {
    if (cloudPostComment.commentText.isNotEmpty) {
      firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_posts)
          .doc(cloudPostComment.postId)
          .collection(_comment)
          .doc(cloudPostComment.commentId)
          .set(
            cloudPostComment.toJson(),
          );
    }
  }

  @override
  Stream<Iterable<CloudPostComment>> allPostComment(CloudPost cloudPost) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_posts)
        .doc(cloudPost.postId)
        .collection(_comment)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudPostComment.fromSnapshot(doc),
          ),
        );
  }
}
