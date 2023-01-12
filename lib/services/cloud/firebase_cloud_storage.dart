import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_chat_user.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_message.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_order.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_post_comment.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_user.dart';

class FirebaseCloudStorage {
  final firebaseFirestore = FirebaseFirestore.instance;

  final users = 'users';
  final posts = 'posts';
  final comment = 'comments';
  final gigs = 'gigs';
  final orders = 'orders';
  final offers = 'offers';
  final chats = 'chats';
  final message = 'message';
  final sendTo = 'sendTo';

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  void createNewUser(CloudUser cloudUser) async {
    await firebaseFirestore
        .collection(users)
        .doc(cloudUser.userId)
        .set(cloudUser.toJson());
  }

  Future<CloudUser?> getUser({
    required String userId,
  }) async {
    final document =
        await firebaseFirestore.collection(users).doc(userId).get();
    final json = document.data();

    if (json != null) {
      return CloudUser.fromJson(json);
    } else {
      throw UserNotFoundException();
    }
  }

  // search user
  Future<List<CloudUser>> searchAccounts(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseFirestore
          .collection(users)
          .where('full_name', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudUser.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseFirestore.collection(users).get().then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudUser.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  // search post
  Future<List<CloudPost>> searchPosts(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseFirestore
          .collection(posts)
          .where('full_name', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudPost.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseFirestore.collection(posts)
      .orderBy('published_time', descending: true)
      .get().then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudPost.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  // for post
  Future<void> createNewPost(CloudPost cloudPost) async {
    await firebaseFirestore.collection(posts).doc(cloudPost.postId).set(
          cloudPost.toJson(),
        );
  }

  Stream<Iterable<CloudPost>> allPosts() =>
      firebaseFirestore.collection(posts)
      .orderBy('published_time', descending: true)
      .snapshots().map(
            (event) => event.docs.map(
              (doc) => CloudPost.fromSnapshot(doc),
            ),
          );

  Future<String> likePost(String postId, String userId, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(userId)) {
        // if the likes list contains the user uid, we need to remove it
        firebaseFirestore.collection(posts).doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        // else we need to add uid to the likes array
        firebaseFirestore.collection(posts).doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> isPostliked(String postId, String userId, List likes) async {
    if (likes.contains(userId)) {
      return true;
    } else {
      return false;
    }
  }

  // Post comment
  Future<void> addComment(CloudPostComment cloudPostComment) async {
    if (cloudPostComment.commentText.isNotEmpty) {
      firebaseFirestore
          .collection(posts)
          .doc(cloudPostComment.postId)
          .collection(comment)
          .doc(cloudPostComment.commentId)
          .set(
            cloudPostComment.toJson(),
          );
    }
  }

  Stream<Iterable<CloudPostComment>> allComment(CloudPost cloudPost) {
    return firebaseFirestore
        .collection(posts)
        .doc(cloudPost.postId)
        .collection(comment)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudPostComment.fromSnapshot(doc),
          ),
        );
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await firebaseFirestore.collection(posts).doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Stream<Iterable<CloudPost>> userAllPosts(String userId) {
    return firebaseFirestore
        .collection(posts)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudPost.fromSnapshot(doc),
          ),
        );
  }

  Future<bool> followUser(CloudUser currentUser, CloudUser followUser) async {
    bool res = false;
    try {
      res = false;
      if (followUser.follower.contains(currentUser.userId)) {
        firebaseFirestore.collection(users).doc(followUser.userId).update({
          'follower': FieldValue.arrayRemove([currentUser.userId])
        });
        firebaseFirestore.collection(users).doc(currentUser.userId).update({
          'following': FieldValue.arrayRemove([followUser.userId])
        });
      } else {
        res = true;
        firebaseFirestore.collection(users).doc(followUser.userId).update({
          'follower': FieldValue.arrayUnion([currentUser.userId])
        });
        firebaseFirestore.collection(users).doc(currentUser.userId).update({
          'following': FieldValue.arrayUnion([followUser.userId])
        });
      }
    } catch (_) {}
    return res;
  }

  Future<bool> isFollowing(CloudUser currentUser, CloudUser followUser) async {
    bool res = false;
    try {
      if (followUser.follower.contains(currentUser.userId)) {
        res = true;
      } else {
        res = false;
      }
    } catch (_) {}
    return res;
  }

  // for gig
  Future<void> createNewGig(CloudGig cloudGig) async {
    await firebaseFirestore.collection(gigs).doc(cloudGig.gigId).set(
          cloudGig.toJson(),
        );
  }

  Stream<Iterable<CloudGig>> allGigs() =>
      firebaseFirestore.collection(gigs).snapshots().map(
            (event) => event.docs.map(
              (doc) => CloudGig.fromSnapshot(doc),
            ),
          );

  // search gig
  Future<List<CloudGig>> searchGigs(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseFirestore
          .collection(gigs)
          .where('gig_title', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudGig.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseFirestore.collection(gigs).get().then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudGig.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  Stream<Iterable<CloudGig>> gigsByCategory(String category) {
    return firebaseFirestore
        .collection(gigs)
        .where('gig_category', isEqualTo: category)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudGig.fromSnapshot(doc),
          ),
        );
  }

  Stream<Iterable<CloudGig>> userAllGigs(String userId) {
    return firebaseFirestore
        .collection(gigs)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudGig.fromSnapshot(doc),
          ),
        );
  }

  // for order
  Future<void> createNewOrder(CloudOrder cloudOrder) async {
    await firebaseFirestore.collection(orders).doc(cloudOrder.orderId).set(
          cloudOrder.toJson(),
        );
  }

  Future<CloudOrder> getOrder({
    required String orderId,
  }) async {
    final document =
        await firebaseFirestore.collection(orders).doc(orderId).get();
    final json = document.data();

    if (json != null) {
      return CloudOrder.fromJson(json);
    } else {
      throw UserNotFoundException();
    }
  }

  Stream<Iterable<CloudOrder>> userAllReceivedOrders(String userId) {
    return firebaseFirestore
        .collection(orders)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrder.fromSnapshot(doc),
          ),
        );
  }

  Stream<Iterable<CloudOrder>> userAllPlacedOrders(String employerId) {
    return firebaseFirestore
        .collection(orders)
        .where('employer_id', isEqualTo: employerId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrder.fromSnapshot(doc),
          ),
        );
  }

  Future<void> updateOrder(
    String orderId,
    String filePath,
    String deliveryMessage,
    bool isDelivered,
  ) async {
    await firebaseFirestore.collection(orders).doc(orderId).update({
      'file_path': filePath,
      'delivery_message': deliveryMessage,
      'is_delivered': isDelivered
    });
  }

  Future<void> acceptDelivery(
    String orderId,
    bool isDeliveryAccepted,
  ) async {
    await firebaseFirestore.collection(orders).doc(orderId).update({
      'is_delivery_accepted': isDeliveryAccepted,
    });
  }

  // for custom offer
  Future<void> createCustomOffer(CloudCustomOffer cloudCustomOffer) async {
    await firebaseFirestore
        .collection(offers)
        .doc(cloudCustomOffer.orderId)
        .set(
          cloudCustomOffer.toJson(),
        );
  }

  // Delete offer
  Future<String> deleteOffer(String orderId) async {
    String res = "Some error occurred";
    try {
      await firebaseFirestore.collection(offers).doc(orderId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Stream<Iterable<CloudCustomOffer>> userAllReceivedOffers(String userId) {
    return firebaseFirestore
        .collection(offers)
        .where('employer_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudCustomOffer.fromSnapshot(doc),
          ),
        );
  }

  Stream<Iterable<CloudCustomOffer>> userAllSentOffers(String userId) {
    return firebaseFirestore
        .collection(offers)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudCustomOffer.fromSnapshot(doc),
          ),
        );
  }

  Future<void> acceptOrder(
    String orderId,
    bool isOrderAccepted,
  ) async {
    await firebaseFirestore.collection(orders).doc(orderId).update({
      'is_order_accepted': isOrderAccepted,
    });
  }

  Future<void> rejectOrder(
    String orderId,
    bool isOrderRejected,
  ) async {
    await firebaseFirestore.collection(orders).doc(orderId).update({
      'is_order_rejected': isOrderRejected,
    });
  }

  // message
  Future<void> addMessage(
    CloudUser existingUser,
    CloudUser sendToUser,
    CloudChatUser cloudChatUser,
    CloudMessage cloudMessage,
  ) async {
    if (cloudMessage.messageText.isNotEmpty) {
      firebaseFirestore
          .collection(users)
          .doc(existingUser.userId)
          .collection(chats)
          .doc(sendToUser.userId)
          .set(cloudChatUser.toJson())
          .whenComplete(() {
        firebaseFirestore
            .collection(users)
            .doc(existingUser.userId)
            .collection(chats)
            .doc(sendToUser.userId)
            .collection(message)
            .doc(cloudMessage.messageId)
            .set(
              cloudMessage.toJson(),
            );
      });
    }
  }

  // for chat
  Future<List<CloudChatUser>> userAllChats(CloudUser existingUser) {
    return firebaseFirestore
        .collection(users)
        .doc(existingUser.userId)
        .collection(chats)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map(
              (doc) => CloudChatUser.fromSnapshot(doc),
            )
            .toList());
  }

  Stream<Iterable<CloudMessage>> userAllMessages(
    CloudUser existingUser,
    CloudUser sendToUser,
  ) {
    return firebaseFirestore
        .collection(users)
        .doc(existingUser.userId)
        .collection(chats)
        .doc(sendToUser.userId)
        .collection(message)
        .orderBy('send_at', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudMessage.fromSnapshot(doc),
          ),
        );
  }
}
