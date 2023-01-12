import 'package:fiwork/pages/activity/tabs/offers_tab.dart';
import 'package:fiwork/pages/activity/tabs/orders_tab.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<String> tabs = <String>[
    'Received orders',
    'Placed orders',
    'Received Offer',
    'Sent Offer'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.black,
                  centerTitle: true,
                  elevation: 0,
                  title: const Text('Activity'),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(58),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 6),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TabBar(
                          isScrollable: true,
                          labelPadding:
                              const EdgeInsets.only(left: 8, right: 8),
                          indicatorColor: Colors.transparent,
                          tabs: tabs
                              .map(
                                (String name) => Tab(
                                  child: Container(
                                    height: 44,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: const Color(0xff242424),
                                    ),
                                    child: Text(name),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: TabBarView(
              children: [
                OrdersTab(
                  isPlacedOrder: false,
                ),
                OrdersTab(
                  isPlacedOrder: true,
                ),
                OffersTab(
                  isReceivedOrder: true,
                ),
                OffersTab(
                  isReceivedOrder: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
