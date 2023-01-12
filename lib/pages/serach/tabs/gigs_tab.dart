import 'package:fiwork/pages/gig_details/gig_details_page.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_gig.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GigsTab extends StatefulWidget {
  const GigsTab({super.key, required this.keyword});
  final String keyword;

  @override
  State<GigsTab> createState() => _GigsTabState();
}

class _GigsTabState extends State<GigsTab> {
  late final FirebaseCloudStorage _firebaseCloudService;

  @override
  void initState() {
    _firebaseCloudService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseCloudService.searchGigs(widget.keyword),
      builder: (BuildContext context, AsyncSnapshot<List<CloudGig>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final searchGigs = snapshot.data;
              if (searchGigs!.isEmpty) {
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
                            childCount: searchGigs.length,
                            (context, index) {
                              final userGig = searchGigs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GigDetailsPage(
                                          cloudGig: userGig,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 94,
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
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                userGig.gigCoverUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, right: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userGig.gigTitle,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'From \$${userGig.gigStartingPrice}',
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                RatingBar.builder(
                                                  minRating: 1,
                                                  maxRating: 5,
                                                  initialRating:
                                                      userGig.gigRating,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemSize: 18,
                                                  allowHalfRating: true,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return const Icon(
                                                      Icons.star,
                                                      color: Color(0xfff4c465),
                                                    );
                                                  },
                                                  onRatingUpdate: ((value) =>
                                                      print('rating')),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
