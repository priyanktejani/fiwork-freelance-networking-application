import 'package:fiwork/tabs/services_tab.dart';
import 'package:flutter/material.dart';

class ProgilePage extends StatefulWidget {
  const ProgilePage({Key? key}) : super(key: key);

  @override
  State<ProgilePage> createState() => _ProgilePageState();
}

class _ProgilePageState extends State<ProgilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 0, 5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              )),
          title: const Text(
            'Priyank Tejani',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 12, 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(44, 44),
                  primary: const Color(0xff242424),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: const Icon(
                  Icons.menu,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // profile
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/lucas-sankey.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // username
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Text(
                    '@priyanktejani',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Mobile app developer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // number of follower, following, like
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: const [
                        Text(
                          '144',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Following',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '80',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: const [
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Rating',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // buttons
            const SizedBox(
              height: 12,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(136, 44),
                    // primary: Colors.grey.shade300,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Follow'),
                ),
                const SizedBox(
                  width: 6,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    primary: const Color(0xff242424),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {},
                  child: const Icon(
                    Icons.arrow_drop_down,
                  ),
                ),
              ],
            ),

            // bio
            const SizedBox(
              height: 12,
            ),

            const Text(
              'We buid digital Products',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),

            // tabs
            const SizedBox(
              height: 14,
            ),
            TabBar(
              // indicatorColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              tabs: [
                const Tab(
                  icon: Icon(
                    Icons.grid_4x4,
                  ),
                ),
                const Tab(
                  icon: Icon(
                    Icons.sell,
                  ),
                ),
                Tab(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                     border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: const Icon(Icons.sell),
                  ),
                ),
              ],
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  Text('Image'),
                  ServicesTab(),
                  ServicesTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
