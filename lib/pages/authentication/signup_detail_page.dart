import 'dart:io';
import 'package:fiwork/constants/routes.dart';
import 'package:fiwork/pages/authentication/widget/text_field_input.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:fiwork/services/storage/firebase_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignupDetailPage extends StatefulWidget {
  const SignupDetailPage({super.key});

  @override
  State<SignupDetailPage> createState() => _SignupDetailPageState();
}

class _SignupDetailPageState extends State<SignupDetailPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _professionController;
  late final TextEditingController _descriptionController;

  XFile? _image;

  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        return image;
      } else {
        return null;
      }
    } on PlatformException catch (_) {
      throw Exception;
    }
  }

  @override
  void initState() {
    _fullNameController = TextEditingController();
    _userNameController = TextEditingController();
    _professionController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _professionController.dispose();
    _descriptionController.dispose();
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
                    _image == null
                        ? IconButton(
                            iconSize: 130,
                            onPressed: () async {
                              final image =
                                  await pickImage(ImageSource.gallery);
                              if (image != null) {
                                setState(() {
                                  _image = image;
                                });
                              } else {
                                // throw exception in ui
                              }
                            },
                            icon: Image.asset(
                              'assets/icons/add-profile.png',
                              color: Colors.grey,
                            ),
                          )
                        : CircleAvatar(
                            radius: 65,
                            backgroundImage: FileImage(
                              File(_image!.path),
                            ),
                          ),
                    const Divider(
                      height: 30,
                      color: Colors.transparent,
                    ),
                    SizedBox(
                      child: TextFieldInput(
                        textEditingController: _fullNameController,
                        textInputType: TextInputType.name,
                        hintText: 'Full name',
                      ),
                    ),
                    const Divider(
                      height: 14,
                    ),
                    TextFieldInput(
                      textEditingController: _userNameController,
                      textInputType: TextInputType.text,
                      hintText: 'Username',
                    ),
                    const Divider(
                      height: 14,
                    ),
                    TextFieldInput(
                      textEditingController: _professionController,
                      textInputType: TextInputType.text,
                      hintText: 'Profession',
                    ),
                    const Divider(
                      height: 14,
                    ),
                    TextFieldInput(
                      textEditingController: _descriptionController,
                      textInputType: TextInputType.text,
                      hintText: 'Description',
                      maxLine: 3,
                    ),
                    const Divider(
                      height: 14,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final fullName = _fullNameController.text;
                        final userName = _userNameController.text;
                        final profession = _professionController.text;
                        final description = _descriptionController.text;

                        final currentUser = AuthService.firebase().currentUser!;
                        final userId = currentUser.id;
                        final email = currentUser.email;
                        String profileUrl = '';

                        try {
                          if (_image != null) {
                            profileUrl =
                                await FirebaseFileStorage().uploadProfileImage(
                              userId: userId,
                              image: File(_image!.path),
                              imageName: _image!.name,
                            );
                          }

                          CloudUser cloudUser = CloudUser(
                            userId: userId,
                            email: email,
                            fullName: fullName,
                            userName: userName,
                            profileUrl: profileUrl,
                            profession: profession,
                            description: description,
                            following: const [],
                            follower: const [],
                          );
                          CloudUserService.firebase().createNewUser(cloudUser);

                          if(!mounted) return;
                            Navigator.of(context).popAndPushNamed(
                            rootRoute,
                            // (Route<dynamic> route) => false,
                          );
                        } on Exception {
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
                        'Finish',
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
            ],
          ),
        ),
      ),
    );
  }
}
