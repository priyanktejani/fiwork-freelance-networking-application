import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';

abstract class CloudUserProvider {
  Future<void> createNewUser(CloudUser cloudUser);

  Future<CloudUser?> getUser({
    required String userId,
  });

  Future<List<CloudUser>> searchUsers(String keyword);

  Future<bool> followUser(CloudUser currentUser, CloudUser followUser);

  Future<bool> isFollowing(CloudUser currentUser, CloudUser followUser);
}
