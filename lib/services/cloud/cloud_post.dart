import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:intl/intl.dart';

class CloudPost {
  final String userId;
  final String profileUrl;
  final String fullName;
  final String publishedTime;
  final String postUrl;
  final String caption;
  final String likes;

  CloudPost({
    required this.userId,
    required this.profileUrl,
    required this.fullName,
    required this.publishedTime,
    required this.postUrl,
    required this.likes,
    required this.caption,
  });

  CloudPost.fromJson(Map<String, dynamic> json)
      : userId = json[userIdFieldName],
        profileUrl = json[profileUrlFieldName],
        fullName = json[fullNameFieldName],
        publishedTime = json[publishedTimeFieldName],
        postUrl = json[postUrlFieldName],
        caption = json[captionFieldName],
        likes = json[likesFieldName];

  CloudPost.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        profileUrl = snapshot.data()[profileUrlFieldName] as String,
        fullName = snapshot.data()[fullNameFieldName] as String,
        publishedTime = DateFormat.yMMMd().format(snapshot.data()[publishedTimeFieldName].toDate()) ,
        postUrl = snapshot.data()[postUrlFieldName] as String,
        caption = snapshot.data()[captionFieldName] as String,
        likes = 'snapshot.data()[likesFieldName]';
}
