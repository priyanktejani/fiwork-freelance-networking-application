import 'package:fiwork/pages/gig_details/gig_details_page.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CloudGigService.firebase().allGigs(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allGigs = snapshot.data as Iterable<CloudGig>;
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
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                              top: 12,
                              right: 18,
                            ),
                            child: Container(
                              height: 389,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment(1, 0.0),
                                  colors: <Color>[
                                    Color(0xFF9288E4),
                                    Color(0xFF534EA7),
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 15,
                                    left: 11,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 39,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFAFA8EE),
                                        borderRadius: BorderRadius.circular(36),
                                      ),
                                      child: const Text(
                                        'Welcome to Fiwork Store',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 80,
                                    left: 14,
                                    child: Text(
                                      'EXPLORE OUR DIGITAL \nSERVICES PICKED \nFOR YOU',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/img_saly10.png',
                                      scale: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 78,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 26, 16, 16),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Popular Services',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                      text: '\nOver 50+ varieties',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 90),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                childCount: allGigs.length, (context, index) {
                              final gig = allGigs.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GigDetailsPage(cloudGig: gig),
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
                                                gig.gigCoverUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 2,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  gig.gigTitle,
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
                                                  'From \$${gig.gigStartingPrice}',
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                RatingBar.builder(
                                                  minRating: 1,
                                                  maxRating: 5,
                                                  initialRating: gig.gigRating,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemSize: 18,
                                                  allowHalfRating: true,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 1,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return const Icon(
                                                      Icons.star,
                                                      color: Color(0xfff4c465),
                                                    );
                                                  },
                                                  onRatingUpdate: ((value) =>
                                                      print('rating')),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('No Recommendation'),
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
