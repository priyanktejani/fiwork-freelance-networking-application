import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 34,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Add post',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),),
              child: const Text(
                'Post',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage('assets/images/aiony-haust.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Priyank Tejani',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          height: 23,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                              minimumSize: Size.zero,
                              side: const BorderSide(width: 1.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.public,
                                  size: 17,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                const Text(
                                  'Everyone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'What do you want to talk about?',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/michael-frattaroli.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.0,
                      right: 1.0,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_camera),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_album),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_camera_back),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.sell),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: ListTile.divideTiles(
                                  context: context,
                                  tiles: [
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      leading: Icon(Icons.photo_camera),
                                      title: Text('Camara'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.photo_album),
                                      title: Text('Add a photo/video'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.video_camera_back),
                                      title: Text('Take a video'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.sell),
                                      title: Text('Create a gig'),
                                    ),
                                  ]).toList(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_horiz_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
