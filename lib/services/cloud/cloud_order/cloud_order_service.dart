// 4
import 'package:fiwork/services/cloud/cloud_order/cloud_order.dart';
import 'package:fiwork/services/cloud/cloud_order/cloud_order_provider.dart';
import 'package:fiwork/services/cloud/cloud_order/firebase_cloud_order_provder.dart';

class CloudOrderService implements CloudOrderProvider {
  final CloudOrderProvider provider;

  const CloudOrderService(this.provider);

  factory CloudOrderService.firebase() =>
      CloudOrderService(FirebaseCloudOrderProvider());

  @override
  Future<void> acceptDelivery(String orderId, bool isDeliveryAccepted) =>
      provider.acceptDelivery(orderId, isDeliveryAccepted);

  @override
  Future<void> acceptOrder(String orderId, bool isOrderAccepted) =>
      provider.acceptOrder(orderId, isOrderAccepted);

  @override
  Future<void> createNewOrder(CloudOrder cloudOrder) =>
      provider.createNewOrder(cloudOrder);

  @override
  Future<CloudOrder> getOrder({required String orderId}) =>
      provider.getOrder(orderId: orderId);

  @override
  Future<void> rejectOrder(String orderId, bool isOrderRejected) =>
      provider.rejectOrder(orderId, isOrderRejected);

  @override
  Future<void> updateOrder(String orderId, String filePath,
          String deliveryMessage, bool isDelivered) =>
      provider.updateOrder(orderId, filePath, deliveryMessage, isDelivered);

  @override
  Stream<Iterable<CloudOrder>> userAllPlacedOrders(String employerId) =>
      provider.userAllPlacedOrders(employerId);

  @override
  Stream<Iterable<CloudOrder>> userAllReceivedOrders(String userId) =>
      provider.userAllReceivedOrders(userId);
}
