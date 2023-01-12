import 'package:fiwork/constants/routes.dart';
import 'package:fiwork/enums/menu_actions.dart';
import 'package:fiwork/gigs.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_models/cloud_post.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirebaseCloudStorage _postService;
  final PageController pageController = PageController(viewportFraction: 0.75);
  int currentPage = 0;

  final currentUser = AuthService.firebase().currentUser!;
  String get currentUserId => currentUser.id;

  @override
  void initState() {
    super.initState();
    _postService = FirebaseCloudStorage();
    pageController.addListener(() {
      int position = pageController.page!.round();
      if (currentPage != position) {
        {
          setState(() {
            currentPage = position;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 7),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                addPostRoute,
                // (Route<dynamic> route) => false,
              );
            },
            icon: Image.asset(
              'assets/icons/plus.png',
              color: Colors.grey.shade300,
            ),
          ),
        ),
        title: Text(
          'fiwork',
          style: GoogleFonts.dancingScript(
            fontSize: 30.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 9, 9, 9),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  chatRoute,
                  // (Route<dynamic> route) => false,
                );
              },
              icon: Image.asset(
                'assets/icons/chat-6.png',
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        primary: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 400,
              child: PageView.builder(
                padEnds: false,
                controller: pageController,
                itemCount: gigs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  bool active = index == currentPage;
                  return GigsCard(
                    active: active,
                    index: index,
                    gigs: gigs[index],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //
          StreamBuilder(
            stream: _postService.allPosts(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allPosts = snapshot.data as Iterable<CloudPost>;
                    if (allPosts.isEmpty) {
                      return Center(
                        child: Image.asset(
                          'assets/icons/nothing.png',
                          height: 68,
                          color: Colors.white,
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allPosts.length,
                      itemBuilder: (context, index) {
                        final post = allPosts.elementAt(index);
                        return Align(
                          heightFactor: 0.9,
                          alignment: Alignment.topCenter,
                          child: PostCard(
                            userName: post.fullName,
                            userImage: post.profileUrl,
                            profession: post.profession,
                            feedTime: post.publishedTime.toIso8601String(),
                            feedText: post.caption,
                            feedImage: post.postUrl,
                            like: () {
                              _postService.likePost(
                                post.postId,
                                post.userId,
                                post.likes,
                              );
                            },
                            likeCount: post.likes.length,
                            isLiked: true,
                            comment: () {
                              Navigator.pushNamed(
                                context,
                                postCommentRoute,
                                arguments: post,
                              );
                            },
                            postMenu: (PostMenu item) {
                              // edit post
                              if (item == PostMenu.edit) {
                              } else {
                                // delete post
                                _postService.deletePost(post.postId);
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    // show no post message
                    return const Center(child: Text('No Post'));
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

class GigsCard extends StatelessWidget {
  const GigsCard({Key? key, this.active, this.index, this.gigs})
      : super(key: key);

  final bool? active;
  final int? index;
  final Gigs? gigs;

  @override
  Widget build(BuildContext context) {
    final double blur = active! ? 16 : 0;
    final double offset = active! ? 4 : 0;
    final double top = active! ? 0 : 39;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: 0,
        right: 15.5,
        left: active! ? 16.0 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: gigs!.startColor!,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: blur,
            offset: Offset(0, offset),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/${gigs!.recipeImage}'),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  gigs!.startColor!,
                  gigs!.endColor!.withOpacity(0.3),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                tileMode: TileMode.clamp,
                stops: const [0.3, 0.6],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
                top: 10,
              ),
              height: 87,
              decoration: BoxDecoration(
                  color: gigs!.startColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  )),
              child: Text(
                gigs!.recipeName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 84.75,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.5,
                      vertical: 5,
                    ),
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Text(
                      gigs!.category,
                      style: TextStyle(
                        fontSize: 13,
                        color: gigs!.startColor,
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      // Image.asset('assets/icons/messenger.png'),
                      SizedBox(
                        width: 8.65,
                      ),
                      // Image.asset('assets/icons/messenger.png'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String userName;
  final String userImage;
  final String profession;
  final String feedTime;
  final String feedText;
  final String feedImage;
  final VoidCallback? like;
  int likeCount = 0;
  bool isLiked = false;
  final VoidCallback? comment;

  final Function(PostMenu)? postMenu;
  PostCard({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.profession,
    required this.feedTime,
    required this.feedText,
    required this.feedImage,
    required this.like,
    required this.comment,
    required this.postMenu,
    required this.likeCount,
    required this.isLiked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 16),
      height: 550,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(36),
        ),
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            feedImage,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userImage),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(profession)
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  onSelected: postMenu,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<PostMenu>>[
                    const PopupMenuItem<PostMenu>(
                      value: PostMenu.edit,
                      child: Text('edit'),
                    ),
                    const PopupMenuItem<PostMenu>(
                      value: PostMenu.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 54,
            left: 15,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: comment,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                        backgroundColor: Colors.white24,
                      ),
                      child: Image.asset(
                        'assets/icons/comment.png',
                        color: Colors.white70,
                        width: 25,
                        height: 25,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                        backgroundColor: Colors.white24,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          'assets/icons/send.png',
                          color: Colors.white70,
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: like,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.black,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        likeCount.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade900,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
