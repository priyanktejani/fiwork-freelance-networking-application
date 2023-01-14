// 3

import 'package:fiwork/services/cloud/cloud_order/cloud_order.dart';
import 'package:fiwork/services/cloud/cloud_order/cloud_order_provider.dart';
import 'package:fiwork/services/cloud/cloud_storage_exceptions.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';

class FirebaseCloudOrderProvider extends CloudOrderProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();

  final _orders = 'orders';

  @override
  Future<void> acceptDelivery(String orderId, bool isDeliveryAccepted) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(orderId)
        .update({
      'is_delivery_accepted': isDeliveryAccepted,
    });
  }

  @override
  Future<void> acceptOrder(String orderId, bool isOrderAccepted) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(orderId)
        .update({
      'is_order_accepted': isOrderAccepted,
    });
  }

  @override
  Future<void> createNewOrder(CloudOrder cloudOrder) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(cloudOrder.orderId)
        .set(
          cloudOrder.toJson(),
        );
  }

  @override
  Future<CloudOrder> getOrder({required String orderId}) async {
    final document = await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(orderId)
        .get();
    final json = document.data();

    if (json != null) {
      return CloudOrder.fromJson(json);
    } else {
      throw OrderNotFoundException();
    }
  }

  @override
  Future<void> rejectOrder(String orderId, bool isOrderRejected) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(orderId)
        .update({
      'is_order_rejected': isOrderRejected,
    });
  }

  @override
  Future<void> updateOrder(String orderId, String filePath,
      String deliveryMessage, bool isDelivered) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .doc(orderId)
        .update({
      'file_path': filePath,
      'delivery_message': deliveryMessage,
      'is_delivered': isDelivered
    });
  }

  @override
  Stream<Iterable<CloudOrder>> userAllPlacedOrders(String employerId) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .where('employer_id', isEqualTo: employerId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrder.fromSnapshot(doc),
          ),
        );
  }

  @override
  Stream<Iterable<CloudOrder>> userAllReceivedOrders(String userId) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_orders)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudOrder.fromSnapshot(doc),
          ),
        );
  }
}
