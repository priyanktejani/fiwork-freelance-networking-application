import 'package:fiwork/pages/authentication/widget/text_field_input.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_comment.dart';
import 'package:fiwork/services/cloud/cloud_post/cloud_post_service.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:fiwork/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late final TextEditingController _commentController;

  late CloudPost cloudPost;
  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future addComment(BuildContext context) async {
    String commentId = const Uuid().v1();
    final user = await CloudUserService.firebase().getUser(userId: userId);
    final profileUrl = user!.profileUrl;

    CloudPostComment cloudPostComment = CloudPostComment(
      userId: userId,
      postId: cloudPost.postId,
      commentId: commentId,
      profileUrl: profileUrl!,
      fullName: user.fullName,
      publishedTime: DateTime.now(),
      commentText: _commentController.text,
    );

     CloudPostService.firebase().createNewComment(cloudPostComment);
  }

  @override
  Widget build(BuildContext context) {
    final widgetCloudPost = context.getArgument<CloudPost>();

    if (widgetCloudPost != null) {
      cloudPost = widgetCloudPost;
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: const Text('Comments'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              onPressed: () {
                addComment(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: StreamBuilder(
          stream: CloudPostService.firebase().allPostComment(cloudPost),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allComments =
                      snapshot.data as Iterable<CloudPostComment>;
                  return ListView.separated(
                    itemCount: allComments.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      final comment = allComments.elementAt(index);
                      final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      final String publishedTime = formatter.format(comment.publishedTime);
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xff242424),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    comment.profileUrl,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${comment.fullName} | $publishedTime',
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.grey,
                                    ),
                                  ),
                                  const Divider(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  Text(
                                    comment.commentText,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  // show no post message
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33),
          color: const Color(0xff242424),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: FutureBuilder(
                  future: CloudUserService.firebase().getUser(userId: userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cloudUser = snapshot.data as CloudUser;
                      return cloudUser.profileUrl != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(cloudUser.profileUrl!),
                            )
                          : const SizedBox.shrink();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const VerticalDivider(
                color: Colors.transparent,
                width: 10,
              ),
              Expanded(
                child: TextFieldInput(
                  textEditingController: _commentController,
                  textInputType: TextInputType.text,
                  hintText: 'Add a comment...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
