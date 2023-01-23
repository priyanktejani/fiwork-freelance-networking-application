// 2
import 'package:fiwork/services/cloud/cloud_post/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_comment.dart';

abstract class CloudPostProvider {

  Future<void> createNewPost(CloudPost cloudPost);

  Future<String> deletePost(String postId);

  Future<List<CloudPost>> searchPosts(String keyword);

  Stream<Iterable<CloudPost>> allPosts();

  Stream<Iterable<CloudPost>> userAllPosts(String userId);

  Future<String> likePost(String postId, String userId, List likes);

  Future<bool> isPostLiked(String postId, String userId, List likes);

  Future<void> createNewComment(CloudPostComment cloudPostComment);

  Stream<Iterable<CloudPostComment>> allPostComment(CloudPost cloudPost);

}
