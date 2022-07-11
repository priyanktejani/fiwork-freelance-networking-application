import 'dart:io';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/storage/firebase_file_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File? _image;
  String? _imageName;

  Future pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        final image = File(pickedImage.path);
        setState(() {
          _imageName = pickedImage.name;
          _image = image;
        });
      }
    } on PlatformException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
        title: const Text('Add post'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const TextField(
            maxLength: 8,
            decoration: InputDecoration(
              hintText: 'Share an article, photo, gigs',
            ),
          ),
          _image != null ? Image.file(_image!) : const SizedBox.shrink(),
          TextButton(
            onPressed: (() async {
              await pickImage(ImageSource.gallery);
              final currentUser = AuthService.firebase().currentUser!;
              final userId = currentUser.id;
              await FirebaseFileStorage().uploadPostImage(
                userId: userId,
                image: _image!,
                imageName: _imageName!,
              );
            }),
            child: const Text('Choose Image'),
          ),
        ],
      ),
    );
  }
}
