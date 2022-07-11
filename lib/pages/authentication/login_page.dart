import 'package:fiwork/pages/authentication/signup_page.dart';
import 'package:fiwork/pages/authentication/widget/text_field_input.dart';
import 'package:fiwork/pages/home/home_page.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          width: double.infinity,
          child: Column(
            children: [
              const Text(
                'fiwork',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 32,
              ),
              TextFieldInput(
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Email address',
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () async {
                  // login
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  try {
                    await AuthService.firebase().logIn(
                      email: email,
                      password: password,
                    );
                    // final user = AuthService.firebase().currentUser;
                    
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );

                  } on UserNotFoundException {
                    "User not found";
                  } on WrongPasswordException {
                    "Wrong password";
                  } on GenericAuthException {
                    'Authentication error';
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    44,
                  ),
                ),
                child: const Text('Log in'),
              ),
              const SizedBox(
                height: 18,
              ),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
