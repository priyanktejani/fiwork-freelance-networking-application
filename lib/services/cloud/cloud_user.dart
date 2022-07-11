import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudUser {
  final String userId;
  final String email;
  final String fullName;
  final String userName;

  const CloudUser({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.userName,
  });

  CloudUser.fromJson(Map<String, dynamic> json)
      : userId = json[userIdFieldName],
        email = json[emailFieldName],
        fullName = json[fullNameFieldName],
        userName = json[userNameFieldName];

  // CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  //     : userId = snapshot.data()[userIdFieldName],
  //       email = snapshot.data()[emailFieldName] as String,
  //       fullName = snapshot.data()[fullNameFieldName] as String,
  //       userName = snapshot.data()[userIdFieldName] as String;
}
