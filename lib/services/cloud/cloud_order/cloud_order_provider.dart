// 2
import 'package:fiwork/services/cloud/cloud_order/cloud_order.dart';

abstract class CloudOrderProvider {
  // for order
  Future<void> createNewOrder(CloudOrder cloudOrder);

  Future<CloudOrder> getOrder({
    required String orderId,
  });

  Stream<Iterable<CloudOrder>> userAllReceivedOrders(String userId);

  Stream<Iterable<CloudOrder>> userAllPlacedOrders(String employerId);

  Future<void> updateOrder(
    String orderId,
    String filePath,
    String deliveryMessage,
    bool isDelivered,
  );

  Future<void> acceptDelivery(
    String orderId,
    bool isDeliveryAccepted,
  );
  Future<void> acceptOrder(
    String orderId,
    bool isOrderAccepted,
  );

  Future<void> rejectOrder(
    String orderId,
    bool isOrderRejected,
  );
}
