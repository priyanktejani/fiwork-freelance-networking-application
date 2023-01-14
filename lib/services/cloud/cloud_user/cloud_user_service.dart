// 4
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_provider.dart';
import 'package:fiwork/services/cloud/cloud_user/firebase_cloud_user_provder.dart';

class CloudUserService implements CloudUserProvider {
  final CloudUserProvider provider;

  const CloudUserService(this.provider);

  factory CloudUserService.firebase() =>
      CloudUserService(FirebaseCloudUserProvider());

  @override
  Future<void> createNewUser(CloudUser cloudUser) =>
      provider.createNewUser(cloudUser);

  @override
  Future<CloudUser?> getUser({required String userId}) =>
      provider.getUser(userId: userId);

  @override
  Future<List<CloudUser>> searchUsers(String keyword) =>
      provider.searchUsers(keyword);

  @override
  Future<bool> followUser(CloudUser currentUser, CloudUser followUser) =>
      provider.followUser(currentUser, followUser);

  @override
  Future<bool> isFollowing(CloudUser currentUser, CloudUser followUser) =>
      provider.isFollowing(currentUser, followUser);
}
