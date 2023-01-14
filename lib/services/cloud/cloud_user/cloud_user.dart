import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudUser {
  final String userId;
  final String email;
  final String fullName;
  final String userName;
  final String profession;
  final String? description;
  final String? profileUrl;
  final List following;
  final List follower;

  const CloudUser({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.userName,
    required this.profession,
    this.description,
    this.profileUrl,
    required this.following,
    required this.follower,
  });

  CloudUser.fromMap(Map<String, dynamic> json)
      : userId = json[userIdFieldName],
        email = json[emailFieldName],
        fullName = json[fullNameFieldName],
        userName = json[userNameFieldName],
        profileUrl = json[profileUrlFieldName],
        profession = json[professionFieldName],
        description = json[descriptionFieldName],
        following = json[followingFieldName],
        follower = json[followerFieldName];

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName] as String,
        email = snapshot.data()[emailFieldName] as String,
        fullName = snapshot.data()[fullNameFieldName] as String,
        userName = snapshot.data()[userNameFieldName] as String,
        profileUrl = snapshot.data()[profileUrlFieldName] as String,
        profession = snapshot.data()[professionFieldName] as String,
        description = snapshot.data()[descriptionFieldName] as String,
        following = snapshot.data()[followingFieldName] as List,
        follower = snapshot.data()[followerFieldName] as List;

  Map<String, dynamic> toMap() => {
        userIdFieldName: userId,
        emailFieldName: email,
        fullNameFieldName: fullName,
        userNameFieldName: userName,
        profileUrlFieldName: profileUrl,
        professionFieldName: profession,
        descriptionFieldName: description,
        followingFieldName: following,
        followerFieldName: follower,
      };

  @override
  bool operator == (covariant CloudUser other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
