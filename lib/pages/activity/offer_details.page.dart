import 'package:fiwork/pages/order/order_success_page.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_order.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';

class OfferDetailsPage extends StatefulWidget {
  const OfferDetailsPage({
    super.key,
    required this.cloudOrder,
    required this.isRecivedOffer,
  });
  final CloudCustomOffer cloudOrder;
  final bool isRecivedOffer;

  @override
  State<OfferDetailsPage> createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  late final FirebaseCloudStorage _firebaseCloudService;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;
  late final TextEditingController _projectRequirementController;

  bool isDelivered = false;
  bool isDeliveryAccepted = false;
  bool isOrderAccepted = false;
  bool isOrderRejected = false;

  @override
  void initState() {
    _firebaseCloudService = FirebaseCloudStorage();


    _projectRequirementController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _projectRequirementController.dispose();
    super.dispose();
  }

  Future<void> createOrder() async {
    String orderId = const Uuid().v1();

    CloudOrder cloudOrder = CloudOrder(
      orderId: orderId,
      userId: widget.cloudOrder.userId,
      gigId: widget.cloudOrder.gigId,
      gigTitle: widget.cloudOrder.gigTitle,
      gigCoverUrl: widget.cloudOrder.gigCoverUrl,
      employerId: widget.cloudOrder.employerId,
      employerName: widget.cloudOrder.employerName,
      employerProfileUrl: widget.cloudOrder.employerProfileUrl,
      gigPrice: widget.cloudOrder.gigPrice,
      serviceSpecifications: widget.cloudOrder.serviceSpecifications,
      serviceCharge: widget.cloudOrder.serviceCharge,
      totalPrice: widget.cloudOrder.totalPrice,
      projectRequirement: _projectRequirementController.text,
      createdAt: DateTime.now(),
      deliveryTime: widget.cloudOrder.deliveryTime,
    );
    await _firebaseCloudService.createNewOrder(cloudOrder);
    await _firebaseCloudService.deleteOffer(widget.cloudOrder.orderId);
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
              'Offer Details',
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
                            // fontWeight: FontWeight.w600,
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
                            style: const TextStyle(
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
            child: widget.isRecivedOffer? Padding(
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
                    const Text(
                      'Payment Method',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/credit-card.png',
                            height: 38,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Credit or Debit card',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 2.0,
                              bottom: 3.0,
                            ),
                            child: Text(
                              'Card number',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              contentPadding: const EdgeInsets.all(8),
                              hintText: '0000-0000-0000-0000',
                              enabled: true,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Cardholder\'s name',
                              enabled: true,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 2.0,
                                  bottom: 3.0,
                                ),
                                child: Text(
                                  'Expiry date',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    fillColor: Colors.black,
                                    contentPadding: const EdgeInsets.all(8),
                                    hintText: 'MM/YY',
                                    enabled: true,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VerticalDivider(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 2.0,
                                  bottom: 3.0,
                                ),
                                child: Text(
                                  'CVV',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    fillColor: Colors.black,
                                    contentPadding: const EdgeInsets.all(8),
                                    hintText: '000',
                                    enabled: true,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ): const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: widget.isRecivedOffer? Padding(
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
                    const Text(
                      'Requirements',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 2.0,
                              bottom: 3.0,
                            ),
                          ),
                          TextField(
                            controller: _projectRequirementController,
                            keyboardType: TextInputType.text,
                            maxLines: 8,
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Specify your requirements',
                              enabled: true,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ): const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: widget.isRecivedOffer? Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  elevation: 1,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  createOrder();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderSuccessPage()
                    ),
                  );
                },
                child: const Text(
                  'Make payment',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ): const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
