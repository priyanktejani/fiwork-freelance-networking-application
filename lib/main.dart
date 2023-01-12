import 'package:fiwork/constants/routes.dart';
import 'package:fiwork/pages/add_post/add_post_page.dart';
import 'package:fiwork/pages/add_post/create_gig_page.dart';
import 'package:fiwork/pages/authentication/login_page.dart';
import 'package:fiwork/pages/authentication/signup_detail_page.dart';
import 'package:fiwork/pages/authentication/signup_page.dart';
import 'package:fiwork/pages/chat/chat_page.dart';
import 'package:fiwork/pages/home/comments_page.dart';
import 'package:fiwork/pages/home/home_screen.dart';
import 'package:fiwork/pages/profile/profile_page.dart';
import 'package:fiwork/pages/root_page.dart';
import 'package:fiwork/pages/serach/search_page.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fiwork',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const AuthenticationWrapper(),
      routes: {
        loginRoute: (context) => const LogInPage(),
        signupRoute: (context) => const SignUpPage(),
        rootRoute:(context) => const RootPage(),
        signupDetailRoute:(context) => const SignupDetailPage(),
        homeRoute: (context) => const HomeScreen(),
        searchRoute: (context) => const SearchPage(),
        chatRoute:(context) => const ChatPage(),
        addPostRoute: (context) => const AddPostPage(),
        postCommentRoute: (context) => const CommentsPage(),
        profileRoute: (context) => const ProfilePage(),
        createGigRoute:(context) => const CreateGigPage(),
      },
    ),
  );
}


class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              return const RootPage();
            } else {
              return const LogInPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
