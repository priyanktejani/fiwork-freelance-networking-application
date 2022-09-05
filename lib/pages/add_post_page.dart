import 'dart:io';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';
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
  late final FirebaseCloudStorage _cloudService;
  late final TextEditingController _captionController;

  final currentUser = AuthService.firebase().currentUser!;

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
    _cloudService = FirebaseCloudStorage();
    _captionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Add post',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              onPressed: () async {
                final userId = currentUser.id;

                if (_image != null) {
                  final profileUrl =
                      await FirebaseFileStorage().uploadPostImage(
                    userId: userId,
                    image: File(_image!.path),
                    imageName: _image!.name,
                  );

                  final user = await _cloudService.getUser(userId: userId);

                  _cloudService.createNewPost(
                    userId: userId,
                    profileUrl: profileUrl,
                    fullName: user!.fullName,
                    postUrl: profileUrl,
                    caption: _captionController.text,
                    likes: [],
                  );
                }
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          AssetImage('assets/images/aiony-haust.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Priyank Tejani',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          height: 23,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                              minimumSize: Size.zero,
                              side: const BorderSide(
                                  width: 2.0, color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.public,
                                  size: 17,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                const Text(
                                  'Everyone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: Colors.grey.shade400,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to talk about?',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _image != null
                    ? Stack(
                        children: [
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade700),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                  File(_image!.path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 1.0,
                            right: 1.0,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_circle),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    final image = await pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.photo_camera),
                ),
                IconButton(
                  onPressed: () async {
                    final image = await pickImage(ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _image = image;
                      });
                    } else {
                      // throw exception in ui
                    }
                  },
                  icon: const Icon(Icons.photo_album),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_camera_back),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.sell),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: ListTile.divideTiles(
                                  context: context,
                                  tiles: [
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      leading: Icon(Icons.photo_camera),
                                      title: Text('Camara'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.photo_album),
                                      title: Text('Add a photo/video'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.video_camera_back),
                                      title: Text('Take a video'),
                                    ),
                                    const ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      minLeadingWidth: 5,
                                      minVerticalPadding: 5,
                                      leading: Icon(Icons.sell),
                                      title: Text('Create a gig'),
                                    ),
                                  ]).toList(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_horiz_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
