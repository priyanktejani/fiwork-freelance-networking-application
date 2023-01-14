//3
import 'package:fiwork/services/cloud/cloud_message/cloud_message.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_chat.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_message_provider.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';

class FirebaseCloudMessageProvider extends CloudMessageProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();

  final _users = 'users';
  final _chats = 'chats';
  final _message = 'message';

  @override
  Future<void> createNewMessage(
    CloudUser currentUser,
    CloudUser sendToUser,
    CloudChat cloudChatUser,
    CloudMessage cloudMessage,
  ) async {
    if (cloudMessage.messageText.isNotEmpty) {
      firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_users)
          .doc(currentUser.userId)
          .collection(_chats)
          .doc(sendToUser.userId)
          .set(cloudChatUser.toJson())
          .whenComplete(() {
        firebaseCloudStorage
            .firebaseFirestoreInstance()
            .collection(_users)
            .doc(currentUser.userId)
            .collection(_chats)
            .doc(sendToUser.userId)
            .collection(_message)
            .doc(cloudMessage.messageId)
            .set(
              cloudMessage.toJson(),
            );
      });
    }
  }

  @override
  Future<List<CloudChat>> userAllChats(CloudUser currentUser) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_users)
        .doc(currentUser.userId)
        .collection(_chats)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map(
              (doc) => CloudChat.fromSnapshot(doc),
            )
            .toList());
  }

  @override
  Stream<Iterable<CloudMessage>> userAllMessages(
      CloudUser currentUser, CloudUser sendToUser) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_users)
        .doc(currentUser.userId)
        .collection(_chats)
        .doc(sendToUser.userId)
        .collection(_message)
        .orderBy('send_at', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudMessage.fromSnapshot(doc),
          ),
        );
  }
}
