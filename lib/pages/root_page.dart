import 'package:fiwork/pages/activity/activity_page.dart';
import 'package:fiwork/pages/profile/profile_page.dart';
import 'package:fiwork/pages/serach/search_page.dart';
import 'package:fiwork/pages/gig/gigs_page.dart';
import 'package:fiwork/pages/home/home_screen.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int index = 0;
  final pages = [
    const HomeScreen(),
    const SearchPage(),
    const ActivityPage(),
    const ProfilePage(),
    const GigsPage(selectedTab: 0,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: NavigationBarTheme(
          data: const NavigationBarThemeData(
            indicatorColor: Colors.transparent,
          ),
          child: NavigationBar(
            height: 65,
            backgroundColor: Colors.black,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: [
              NavigationDestination(
                icon: Image.asset(
                  'assets/icons/home.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                selectedIcon: Image.asset(
                  'assets/icons/home-2.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/icons/magnifying-glass-4.png',
                  color: Colors.white,
                  width: 22,
                ),
                selectedIcon: Image.asset(
                  'assets/icons/magnifying-glass-3.png',
                  color: Colors.white,
                  width: 22,
                ),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/icons/notification-2.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                selectedIcon: Image.asset(
                  'assets/icons/notification-3.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                label: 'Notification',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/icons/user.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                selectedIcon: Image.asset(
                  'assets/icons/user-2.png',
                  color: Colors.white,
                  width: 22,
                  height: 22,
                ),
                label: 'Profile',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/icons/suitcase-2.png',
                  color: Colors.white,
                  width: 23,
                  height: 23,
                ),
                selectedIcon: Image.asset(
                  'assets/icons/suitcase.png',
                  color: Colors.white,
                  width: 23,
                  height: 23,
                ),
                label: 'Gigs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
