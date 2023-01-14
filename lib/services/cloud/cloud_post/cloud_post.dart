import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudPost {
  final String userId;
  final String postId;
  final String profileUrl;
  final String fullName;
  final String profession;
  final DateTime publishedTime;
  final String postUrl;
  final String caption;
  final List likes;

  const CloudPost({
    required this.userId,
    required this.postId,
    required this.profileUrl,
    required this.fullName,
    required this.profession,
    required this.publishedTime,
    required this.postUrl,
    required this.likes,
    required this.caption,
  });

  CloudPost.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        postId = snapshot.data()[postIdFieldName],
        profileUrl = snapshot.data()[profileUrlFieldName] as String,
        fullName = snapshot.data()[fullNameFieldName] as String,
        profession = snapshot.data()[professionFieldName] as String,
        publishedTime =
            DateTime.parse(snapshot.data()[publishedTimeFieldName] as String),
        postUrl = snapshot.data()[postUrlFieldName] as String,
        caption = snapshot.data()[captionFieldName] as String,
        likes = snapshot.data()[likesFieldName];

  Map<String, dynamic> toJson() => {
        userIdFieldName: userId,
        postIdFieldName: postId,
        profileUrlFieldName: profileUrl,
        fullNameFieldName: fullName,
        professionFieldName: profession,
        publishedTimeFieldName: publishedTime.toIso8601String(),
        postUrlFieldName: postUrl,
        captionFieldName: caption,
        likesFieldName: likes,
      };

  @override
  bool operator ==(covariant CloudPost other) => postId == other.postId;

  @override
  int get hashCode => postId.hashCode;
}
