import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fiwork/pages/activity/view_file_web_view.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_order.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:fiwork/services/storage/firebase_file_storage.dart';
import 'package:fiwork/utilities/picker/pick_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({
    super.key,
    required this.cloudOrder,
    required this.isPlacedOrder,
  });
  final CloudOrder cloudOrder;
  final bool isPlacedOrder;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late final FirebaseCloudStorage _firebaseCloudService;
  late final TextEditingController _deliveryMessageController;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  PlatformFile? _file;
  bool isDelivered = false;
  bool isDeliveryAccepted = false;
  bool isOrderAccepted = false;
  bool isOrderRejected = false;

  @override
  void initState() {
    _firebaseCloudService = FirebaseCloudStorage();
    _deliveryMessageController = TextEditingController();
    isDelivered = widget.cloudOrder.isdelivered;
    isDeliveryAccepted = widget.cloudOrder.isDeliveryAccepted;
    isOrderAccepted = widget.cloudOrder.isOrderAccepted;
    isOrderRejected = widget.cloudOrder.isOrderRejected;
    super.initState();
  }

  @override
  void dispose() {
    _deliveryMessageController.dispose();
    super.dispose();
  }

  Future<void> sendOrderDelivery() async {
    String filePathUrl = '';
    if (_file != null) {
      filePathUrl = await FirebaseFileStorage().uploadFile(
        userId: userId,
        file: File(_file!.path!),
        fileName: _file!.name,
      );
    }
    _firebaseCloudService.updateOrder(
      widget.cloudOrder.orderId,
      filePathUrl,
      _deliveryMessageController.text,
      true,
    );
    setState(() {
      isDelivered = true;
    });
  }

  Future<void> acceptDelivery() async {
    _firebaseCloudService.acceptDelivery(
      widget.cloudOrder.orderId,
      true,
    );
    setState(() {
      isDeliveryAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.black,
            title: const Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(102.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 94, //check
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xff212121),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 94,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.cloudOrder.gigCoverUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cloudOrder.gigTitle,
                                maxLines: 2,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              RatingBar.builder(
                                minRating: 1,
                                maxRating: 5,
                                initialRating: 0,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 18,
                                allowHalfRating: true,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Color(0xfff4c465),
                                  );
                                },
                                // ignore: avoid_print
                                onRatingUpdate: ((value) => print('rating')),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  color: const Color(0xff242424),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Order Summary',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '#10243654',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.cloudOrder.serviceSpecifications.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final service =
                            widget.cloudOrder.serviceSpecifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${service['specificationName']}:',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                service['shortDetail'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  color: const Color(0xff242424),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${widget.cloudOrder.gigPrice}',
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Service fees:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${widget.cloudOrder.serviceCharge}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${widget.cloudOrder.totalPrice}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Delivery Time:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.cloudOrder.deliveryTime,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: (!isOrderAccepted && !widget.isPlacedOrder)
                ? Padding(
                    padding: const EdgeInsets.only(top: 12, left: 4, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(160, 48),
                              elevation: 1,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            onPressed: () {
                              _firebaseCloudService.acceptOrder(
                                widget.cloudOrder.orderId,
                                true,
                              );
                              setState(() {
                                isOrderAccepted = true;
                              });
                            },
                            child: const Text(
                              'Accept',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 16,
                          color: Colors.transparent,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(140, 48),
                            elevation: 1,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          onPressed: () {
                            _firebaseCloudService.rejectOrder(
                              widget.cloudOrder.orderId,
                              false,
                            );
                            setState(() {
                              isOrderRejected = false;
                            });
                          },
                          child: const Text(
                            'Reject',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      !isDeliveryAccepted
                          ? SizedBox(
                              child: !widget.isPlacedOrder
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          12,
                                          12,
                                          12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff242424),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Delivery message',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 2.0,
                                                      bottom: 3.0,
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _deliveryMessageController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.black,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      hintText:
                                                          'Specify your message',
                                                      enabled: true,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : (widget.cloudOrder.deliveryMessage!
                                          .isNotEmpty)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                              12,
                                              12,
                                              12,
                                              16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff242424),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Message',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 2.0,
                                                          bottom: 3.0,
                                                        ),
                                                      ),
                                                      Text(widget.cloudOrder
                                                          .deliveryMessage!),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            )
                          : const SizedBox.shrink(),

                      // upload section
                      SizedBox(
                        child: !widget.isPlacedOrder
                            ? !isDeliveryAccepted
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 48,
                                            padding: const EdgeInsets.only(
                                                left: 18, top: 13, right: 18),
                                            decoration: const BoxDecoration(
                                              color: Color(0xff242424),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(22),
                                                bottomLeft: Radius.circular(22),
                                              ),
                                            ),
                                            child: Text(
                                              _file != null
                                                  ? _file!.name
                                                  : 'File name',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(0, 48),
                                            elevation: 1,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(22),
                                                bottomRight:
                                                    Radius.circular(22),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final file = await pickFile();
                                            if (file != null) {
                                              setState(() {
                                                _file = file;
                                              });
                                            } else {
                                              // throw exception in ui
                                            }
                                          },
                                          child: const Text(
                                            'Upload file',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink()
                            : (widget.cloudOrder.filePathUrl!.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 48),
                                        elevation: 1,
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewFileWebView(
                                              url: widget
                                                  .cloudOrder.filePathUrl!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'View File',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                      // button
                      !widget.isPlacedOrder
                          ? SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    elevation: 1,
                                    backgroundColor: isDelivered
                                        ? Colors.green
                                        : Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  onPressed: () {
                                    !isDeliveryAccepted
                                        ? sendOrderDelivery()
                                        : null;
                                  },
                                  child: Text(
                                    isDeliveryAccepted
                                        ? 'Congratulations delivery accepted'
                                        : (isDelivered)
                                            ? 'Update delivery'
                                            : 'Send delivery',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: (!isDeliveryAccepted && isDelivered)
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 48),
                                          elevation: 1,
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                          ),
                                        ),
                                        onPressed: () {
                                          acceptDelivery();
                                        },
                                        child: const Text(
                                          'Accept delivery',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                    ],
                  ),
          ),
          SliverToBoxAdapter(
            child: (widget.isPlacedOrder && !isDelivered)
                ? Column(
                    children: [
                      (isOrderAccepted && !isOrderRejected)
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                12,
                                12,
                                12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff242424),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: isOrderAccepted
                                    ? const Text(
                                        'Your order is in progress',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        'Order is not accepted yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                12,
                                12,
                                12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff242424),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: isOrderRejected
                                    ? const Text(
                                        'Your order is rejected',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        'Order is not accepted yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                    ],
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
