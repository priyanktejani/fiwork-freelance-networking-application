import 'package:fiwork/constants/routes.dart';
import 'package:fiwork/pages/authentication/widget/text_field_input.dart';
import 'package:fiwork/services/auth/auth_exceptions.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Create ',
                          style: TextStyle(
                            fontSize: 52,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: 'account',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 14,
                    ),
                    SizedBox(
                      child: TextFieldInput(
                        textEditingController: _emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email address',
                      ),
                    ),
                    const Divider(
                      height: 14,
                    ),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Password',
                      isPassword: true,
                    ),
                    const Divider(
                      height: 14,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // register
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        try {
                          await AuthService.firebase().createUser(
                            email: email,
                            password: password,
                          );
                          if (!mounted) return;
                          Navigator.of(context).popAndPushNamed(
                            signupDetailRoute,
                            // (Route<dynamic> route) => false,
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
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            56,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: Colors.blue.shade800),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(
                      height: 14,
                    ),
                    const Text(
                      'You will recive Email notification from us for security and login purposes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(
                    height: 30,
                    color: Colors.grey,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).popAndPushNamed(
                                loginRoute,
                                // (Route<dynamic> route) => false,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
