import 'package:fiwork/pages/gig/tabs/gig_category_tab.dart';
import 'package:fiwork/pages/gig/tabs/home_tab.dart';
import 'package:flutter/material.dart';

class GigsPage extends StatefulWidget {
  const GigsPage({super.key, required this.selectedTab,});
  final int selectedTab;

  @override
  State<GigsPage> createState() => _GigsPageState();
}

class _GigsPageState extends State<GigsPage> {

  final List<String> tabs = <String>[
    'Home',
    'Graphics & Design',
    'Digital Marketing',
    'Writing & Translation',
    'Video & Animation',
    'Music & Audio',
    'Programming & Tech',
    'Business',
    'Lifestyle',
  ];

 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedTab,
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
                  centerTitle: false,
                  elevation: 0,
                  title: const Text(
                    'Gig\'s Store',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
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
          body: const TabBarView(
            children: [
              HomeTab(),
              GigCategoryTab(
                category: 'Graphics & Design',
              ),
              GigCategoryTab(
                category: 'Digital Marketing',
              ),
              GigCategoryTab(
                category: 'Writing & Translation',
              ),
              GigCategoryTab(
                category: 'Video & Animation',
              ),
              GigCategoryTab(
                category: 'Music & Audio',
              ),
              GigCategoryTab(
                category: 'Programming & Tech',
              ),
              GigCategoryTab(
                category: 'Business',
              ),
              GigCategoryTab(
                category: 'Lifestyle',
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
