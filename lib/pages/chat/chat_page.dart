import 'package:fiwork/pages/chat/chat_detail_page.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_chat.dart';
import 'package:fiwork/services/cloud/cloud_message/cloud_message_service.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CloudUserService.firebase().getUser(userId: userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final user = snapshot.data as CloudUser;
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  centerTitle: false,
                  elevation: 0,
                  title: Text('@${user.userName}'),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(58.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xff242424),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            setState(() {
                              // keyword = value;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 13, 0, 14),
                              child: Image.asset(
                                'assets/icons/search.png',
                                color: Colors.white,
                              ),
                            ),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText: "Search",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FutureBuilder(
                    future: CloudMessageService.firebase().userAllChats(user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final allChatsUsers =
                                snapshot.data as List<CloudChat>;
                            return ListView.builder(
                              itemCount: allChatsUsers.length,
                              itemBuilder: (context, index) {
                                final chatsUser = allChatsUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: InkWell(
                                    onTap: () async {
                                      final sendToUser =
                                          await CloudUserService.firebase().getUser(
                                        userId: chatsUser.userId,
                                      );
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatDetailPage(
                                            sendToUser: sendToUser!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
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
                                                  chatsUser.profileUrl,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chatsUser.fullNmae,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  '@${chatsUser.userName}',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('No user found'),
                            );
                          }
                        default:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    },
                  ),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('No user found'),
                ),
              );
            }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
