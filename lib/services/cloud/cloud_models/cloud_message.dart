import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudMessage {
  final String messageId;
  final String sendBy;
  final String messageText;
  final DateTime sendAt;

  const CloudMessage({
    required this.messageId,
    required this.sendBy,
    required this.messageText,
    required this.sendAt,
  });

  CloudMessage.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : messageId = snapshot.data()[messageIdFieldName],
        sendBy = snapshot.data()[sendByFieldName],
        messageText = snapshot.data()[messageTextFieldName] as String,
        sendAt = DateTime.parse(snapshot.data()[sendAtFieldName] as String);

  Map<String, dynamic> toJson() => {
        messageIdFieldName: messageId,
        sendByFieldName: sendBy,
        messageTextFieldName: messageText,
        sendAtFieldName: sendAt.toIso8601String(),
      };
}
