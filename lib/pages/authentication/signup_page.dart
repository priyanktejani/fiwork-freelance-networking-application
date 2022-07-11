import 'package:fiwork/pages/authentication/login_page.dart';
import 'package:fiwork/pages/authentication/widget/text_field_input.dart';
import 'package:fiwork/pages/home/home_page.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final FirebaseCloudStorage _usersService;
  late final TextEditingController _emailController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usersService = FirebaseCloudStorage();
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _userNameController.dispose();
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
                textEditingController: _fullNameController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Full Name',
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                textEditingController: _userNameController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Username',
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
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                  } on WeekPasswordException {
                    'Weak password';
                  } on EmailAlreadyInUseException {
                    'Email already registered';
                  } on InvalidEmailException {
                    'Invalid email';
                  } on GenericAuthException {
                    'Failed to register';
                  }

                  final currentUser = AuthService.firebase().currentUser!;
                  final userId = currentUser.id;
                  final fullName = _fullNameController.text;
                  final userName = _userNameController.text;

                  // check for error
                  _usersService.createNewUser(
                    email: email,
                    userId: userId,
                    fullName: fullName,
                    userName: userName,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );

                  // print(user1.userId + " " + user1.email + " " + user1.fullName + " " + user1.email);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    44,
                  ),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(
                height: 18,
              ),
              RichText(
                text: TextSpan(
                  text: 'Have an account? ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogInPage(),
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
