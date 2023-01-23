// 4
import 'package:fiwork/services/cloud/cloud_post/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_comment.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_provider.dart';
import 'package:fiwork/services/cloud/cloud_post/firebase_cloud_post_provder.dart';

class CloudPostService implements CloudPostProvider {
  final CloudPostProvider provider;

  const CloudPostService(this.provider);

  factory CloudPostService.firebase() =>
      CloudPostService(FirebaseCloudPostProvider());

  @override
  Stream<Iterable<CloudPost>> allPosts() => provider.allPosts();

  @override
  Future<void> createNewPost(CloudPost cloudPost) =>
provider.createNewPost(cloudPost);

  @override
  Future<String> deletePost(String postId) => provider.deletePost(postId);

  @override
  Future<bool> isPostLiked(String postId, String userId, List likes) =>
      provider.isPostLiked(postId, userId, likes);

  @override
  Future<String> likePost(String postId, String userId, List likes) =>
      provider.likePost(postId, userId, likes);

  @override
  Future<List<CloudPost>> searchPosts(String keyword) =>
      provider.searchPosts(keyword);

  @override
  Stream<Iterable<CloudPost>> userAllPosts(String userId) =>
      provider.userAllPosts(userId);

  @override
  Future<void> createNewComment(CloudPostComment cloudPostComment) =>
      provider.createNewComment(cloudPostComment);

  @override
  Stream<Iterable<CloudPostComment>> allPostComment(CloudPost cloudPost) =>
      provider.allPostComment(cloudPost);
}
