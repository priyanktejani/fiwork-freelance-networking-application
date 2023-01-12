import 'package:fiwork/services/cloud/cloud_models/cloud_post.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RecommendationsTab extends StatefulWidget {
  const RecommendationsTab({super.key, required this.keyword});
  final String keyword;

  @override
  State<RecommendationsTab> createState() => _RecommendationsTabState();
}

class _RecommendationsTabState extends State<RecommendationsTab> {
  late final FirebaseCloudStorage _firebaseCloudStorageService;

  @override
  void initState() {
    _firebaseCloudStorageService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseCloudStorageService.searchPosts(widget.keyword),
      builder: (BuildContext context, AsyncSnapshot<List<CloudPost>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final allPosts = snapshot.data;
              if (allPosts!.isEmpty) {
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
                        SliverMasonryGrid.count(
                          childCount: allPosts!.length,
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          itemBuilder: (context, index) {
                            final post = allPosts[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                post.postUrl,
                              ),
                            );
                          },
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
