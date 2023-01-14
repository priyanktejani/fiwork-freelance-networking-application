import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CloudPostService.firebase().userAllPosts(userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final userPosts = snapshot.data as Iterable<CloudPost>;
                if (userPosts.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/icons/nothing.png',
                    height: 68,
                    color: Colors.white,
                  ),
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: const [
                      QuiltedGridTile(2, 2),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final userPost = userPosts.elementAt(index);
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              userPost.postUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    childCount: userPosts.length,
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('No Post'),
              );
            }

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
