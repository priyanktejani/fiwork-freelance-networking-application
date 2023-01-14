import 'dart:io';
import 'package:fiwork/pages/profile/profile_page.dart';
import 'package:fiwork/services/auth/auth_service.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig_service.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:fiwork/services/storage/firebase_file_storage.dart';
import 'package:fiwork/utilities/picker/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateGigPage extends StatefulWidget {
  const CreateGigPage({super.key});

  @override
  State<CreateGigPage> createState() => _CreateGigPageState();
}

class _CreateGigPageState extends State<CreateGigPage> {
  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _gigTitleController;
  late final TextEditingController _gigDescriptionController;
  late final TextEditingController _specificationTitleController;
  late final TextEditingController _shortDetailController;
  late final TextEditingController _gigStartingPriceController;
  late final TextEditingController _gigDeliveryTimeController;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  String? _selectedCategory;
  String keyword = '';
  bool isChecked = false;
  XFile? _image;

  List<String> teamMembersId = [];
  List<CloudUser> teamMembers = [];

  List<Map> services = [];

  final gigCategories = [
    'Home',
    'Graphics & Design',
    'Digital Marketing',
    'Writing & Translation',
    'Video & Animation',
    'Music & Audio',
    'Programming & Tech',
    'Business',
    'Lifestyle',
  ];

  @override
  void initState() {
    _gigTitleController = TextEditingController();
    _gigDescriptionController = TextEditingController();
    _specificationTitleController = TextEditingController();
    _shortDetailController = TextEditingController();
    _gigStartingPriceController = TextEditingController();
    _gigDeliveryTimeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _gigTitleController.dispose();
    _gigDescriptionController.dispose();
    _specificationTitleController.dispose();
    _shortDetailController.dispose();
    _gigStartingPriceController.dispose();
    _gigDeliveryTimeController.dispose();

    super.dispose();
  }

  showTeamMembersBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      backgroundColor: const Color(0xff242424),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 800,
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.white12,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      hintText: 'Search members',
                      border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      filled: true,
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        keyword = value;
                      });
                    },
                  ),
                  const Divider(
                    height: 12,
                    color: Colors.transparent,
                  ),
                  FutureBuilder(
                    future: CloudUserService.firebase().searchUsers(keyword),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CloudUser>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final searchUsers = snapshot.data;
                            return Expanded(
                              child: ListView.separated(
                                itemCount: searchUsers!.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: Colors.transparent,
                                  height: 12,
                                ),
                                itemBuilder: (context, index) {
                                  final user = searchUsers[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                            userId: user.userId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.white12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  user.profileUrl!,
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
                                                  user.fullName,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  color: Colors.transparent,
                                                ),
                                                Text(
                                                  '@${user.userName}',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(0, 40),
                                                backgroundColor:
                                                    const Color(0xff242424),
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                              ),
                                              onPressed: () {
                                                final isTeamMemberExist =
                                                    teamMembersId.contains(
                                                            user.userId) &&
                                                        teamMembers
                                                            .contains(user);

                                                if (isTeamMemberExist) {
                                                  teamMembersId
                                                      .remove(user.userId);
                                                  teamMembers.remove(user);
                                                } else {
                                                  teamMembersId
                                                      .add(user.userId);

                                                  teamMembers.add(user);
                                                }

                                                setState(() {});
                                              },
                                              child: Text(teamMembersId
                                                      .contains(user.userId)
                                                  ? 'Selected'
                                                  : 'Select'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('No Recommendation'),
                            );
                          }
                        default:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  showServiceSpecificationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      backgroundColor: const Color(0xff242424),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final formKeyServiceBottomSheet = GlobalKey<FormState>();
            return Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKeyServiceBottomSheet.currentState!
                                .validate()) {
                              formKeyServiceBottomSheet.currentState!.save();
                              final specificationTitle =
                                  _specificationTitleController.text;
                              final shortDetail = _shortDetailController.text;
                              final addServiceMap = {
                                'specificationName': specificationTitle,
                                'shortDetail': shortDetail
                              };

                              setState(() {
                                services.add(addServiceMap);
                              });
                              _specificationTitleController.clear();
                              _shortDetailController.clear();
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Form(
                    key: formKeyServiceBottomSheet,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _specificationTitleController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            fillColor: Colors.white12,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            hintText: 'Specification name',
                            border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          },
                        ),
                        const Divider(
                          height: 14,
                          color: Colors.transparent,
                        ),
                        TextFormField(
                          controller: _shortDetailController,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            fillColor: Colors.white12,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            hintText: 'Short detail',
                            border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> addGig() async {
    String gigId = const Uuid().v1();
    String gigTitle = _gigTitleController.text;
    String gigDescription = _gigDescriptionController.text;
    String deliveryTime = _gigDeliveryTimeController.text;
    double gigStartingPrice = double.parse(_gigStartingPriceController.text);

    if (_image != null) {
      final gigCoverUrl = await FirebaseFileStorage().uploadGigCoverImage(
        userId: userId,
        image: File(_image!.path),
        imageName: _image!.name,
      );

      CloudGig cloudGig = CloudGig(
        userId: userId,
        gigId: gigId,
        gigRating: 0.0,
        gigCoverUrl: gigCoverUrl,
        gigTitle: gigTitle,
        gigCategory: _selectedCategory!,
        gigDescription: gigDescription,
        teamMembers: teamMembersId,
        serviceSpecifications: services,
        gigStartingPrice: gigStartingPrice,
        deliveryTime: deliveryTime,
        createdAt: DateTime.now(),
      );

      CloudGigService.firebase().createNewGig(cloudGig);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        elevation: 0,
        title: const Text('Create Gig'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  addGig();
                  if (!mounted) return;
                    Navigator.pop(context);
                  
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                IconButton(
                  iconSize: 180,
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
                  icon: Image.asset(
                    _image != null
                        ? _image!.path.toString()
                        : 'assets/icons/gig_cover.png',
                    color: _image != null ? null : const Color(0xff242424),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextFormField(
                  controller: _gigTitleController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: const Color(0xff242424),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Gig title',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    return null;
                  },
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xff242424),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    hint: const Text("Select gig category"),
                    borderRadius: BorderRadius.circular(22),
                    isExpanded: true,
                    value: _selectedCategory,
                    items: gigCategories.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          _selectedCategory = value.toString();
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Select gig category';
                      }
                      return null;
                    },
                  ),
                ),
                teamMembers.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                          decoration: BoxDecoration(
                            color: const Color(0xff242424),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Team Members :',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: teamMembers.length,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.transparent,
                                    height: 12,
                                  ),
                                  itemBuilder: (context, index) {
                                    final teamMember = teamMembers[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                              userId: teamMember.userId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Colors.white12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
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
                                                    teamMember.profileUrl!,
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
                                                    teamMember.fullName,
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      // color: Colors.grey,
                                                    ),
                                                  ),
                                                  const Divider(
                                                    height: 2,
                                                    color: Colors.transparent,
                                                  ),
                                                  Text(
                                                    '@${teamMember.userName}',
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    showTeamMembersBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: const Color(0xff242424),
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Add Team Members',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextFormField(
                  controller: _gigDescriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 6,
                  decoration: InputDecoration(
                    fillColor: const Color(0xff242424),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return 'Select gig category';
                    }
                    return null;
                  },
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextFormField(
                  controller: _gigStartingPriceController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: const Color(0xff242424),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Starting price',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    return null;
                  },
                ),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                TextFormField(
                  controller: _gigDeliveryTimeController,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: const Color(0xff242424),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    hintText: 'Delivery Time (Days)',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    return null;
                  },
                ),
                services.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                          decoration: BoxDecoration(
                            color: const Color(0xff242424),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Service specifications :',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: services.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${service['specificationName']}:',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          service['shortDetail'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const Divider(
                  height: 14,
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    showServiceSpecificationBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: const Color(0xff242424),
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Add service specification',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(
      item,
    ),
  );
}
