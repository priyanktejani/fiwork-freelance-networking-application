// 4
import 'package:fiwork/services/cloud/cloud_message/cloud_message.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_chat.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_message_provider.dart';
import 'package:fiwork/services/cloud/cloud_message/firebase_cloud_message_provder.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';

class CloudMessageService implements CloudMessageProvider {
  final CloudMessageProvider provider;

  const CloudMessageService(this.provider);

  factory CloudMessageService.firebase() =>
      CloudMessageService(FirebaseCloudMessageProvider());

  @override
  Future<void> createNewMessage
      (CloudUser currentUser, CloudUser sendToUser,
      CloudChat cloudChatUser, CloudMessage cloudMessage,) =>
      provider.createNewMessage
        (currentUser, sendToUser,
        cloudChatUser, cloudMessage,);

  @override
  Future<List<CloudChat>> userAllChats(CloudUser currentUser) =>
      provider.userAllChats(currentUser);

  @override
  Stream<Iterable<CloudMessage>> userAllMessages(
          CloudUser currentUser, CloudUser sendToUser) =>
      provider.userAllMessages(currentUser, sendToUser);
}
