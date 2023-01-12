import 'package:fiwork/pages/activity/offer_details.page.dart';
import 'package:fiwork/pages/activity/order_details.page.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_order.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({super.key, required this.isReceivedOrder});
  final bool isReceivedOrder;

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  late final FirebaseCloudStorage _firebaseCloudService;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  void initState() {
    _firebaseCloudService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.isReceivedOrder
          ? _firebaseCloudService.userAllReceivedOffers(userId)
          : _firebaseCloudService.userAllSentOffers(userId),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allOrders = snapshot.data as Iterable<CloudCustomOffer>;
              if (allOrders.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/icons/nothing.png',
                    height: 68,
                    color: Colors.white,
                  ),
                );
              }
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = allOrders.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OfferDetailsPage(
                                          cloudOrder: order,
                                          isRecivedOffer: widget.isReceivedOrder,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: const Color(0xff242424),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                order.employerProfileUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '\$${order.gigPrice}',
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const Divider(
                                                height: 2,
                                                color: Colors.transparent,
                                              ),
                                    
                                              Text(
                                                order.employerName,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const Divider(
                                                height: 3,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                'Ordered at: ${DateFormat.yMMMd().format(order.createdAt).toString()}',
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  // color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Divider(
                                                height: 3,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                'Delivery in: ${order.deliveryTime}',
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  // color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 4),
                                          child: Container(
                                            height: 82,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  order.gigCoverUrl,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: allOrders.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('Gig Not found'),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
