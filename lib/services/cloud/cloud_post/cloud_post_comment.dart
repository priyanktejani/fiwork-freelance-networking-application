import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';

class CloudPostComment {
  final String userId;
  final String postId;
  final String commentId;
  final String profileUrl;
  final String fullName;
  final DateTime publishedTime;
  final String commentText;

  CloudPostComment({
    required this.userId,
    required this.postId,
    required this.commentId,
    required this.profileUrl,
    required this.fullName,
    required this.publishedTime,
    required this.commentText,
  });

  CloudPostComment.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        postId = snapshot.data()[postIdFieldName],
        commentId = snapshot.data()[commentIdFieldName],
        profileUrl = snapshot.data()[profileUrlFieldName] as String,
        fullName = snapshot.data()[fullNameFieldName] as String,
        publishedTime =
            DateTime.parse(snapshot.data()[publishedTimeFieldName] as String),
        commentText = snapshot.data()[commentTextFieldName] as String;

  Map<String, dynamic> toJson() => {
        userIdFieldName: userId,
        postIdFieldName: postId,
        commentIdFieldName: postId,
        profileUrlFieldName: profileUrl,
        fullNameFieldName: fullName,
        publishedTimeFieldName: publishedTime.toIso8601String(),
        commentTextFieldName: commentText,
      };
}
