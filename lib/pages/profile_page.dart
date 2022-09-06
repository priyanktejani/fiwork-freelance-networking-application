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
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 7),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/plus.png',
                color: Colors.grey.shade300,
              ),
            ),
          ),
          title: const Text(
            '@priyanktejani',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 9, 9, 9),
              child: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/icons/menu.png',
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
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
                    padding: const EdgeInsets.all(2),
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/averie-woodard.jpg'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: const [
                        Text(
                          '20.5K',
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
              ],
            ),

            // username
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 18, 26, 0),
              child: Column(
                children: const [
                  Text(
                    'Priyank Tejani | Photorapher',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    'Mobile app developer Mobile app developer Mobile app developer Mobile app developer Mobile app developer ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // buttons
            const SizedBox(
              height: 14,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 40),
                    backgroundColor: const Color(0xff242424),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 40),
                    backgroundColor: const Color(0xff242424),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Contact'),
                ),
              ],
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
