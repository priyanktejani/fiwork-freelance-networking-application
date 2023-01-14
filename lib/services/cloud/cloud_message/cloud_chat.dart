import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudChat {
  final String userId;
  final String profileUrl;
  final String userName;
  final String fullNmae;

  const CloudChat({
    required this.userId,
    required this.profileUrl,
    required this.userName,
    required this.fullNmae,
  });

  CloudChat.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        profileUrl = snapshot.data()[profileUrlFieldName] as String,
        userName = snapshot.data()[userNameFieldName] as String,
        fullNmae = snapshot.data()[fullNameFieldName] as String;

  Map<String, dynamic> toJson() => {
        userIdFieldName: userId,
        profileUrlFieldName: profileUrl,
        userNameFieldName: userName,
        fullNameFieldName: fullNmae,
      };
}
