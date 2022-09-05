import 'package:fiwork/pages/authentication/login_page.dart';
import 'package:fiwork/screens/home_screen.dart';
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
              return const HomeScreen();
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
