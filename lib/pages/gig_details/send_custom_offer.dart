import 'package:fiwork/pages/profile/profile_page.dart';
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer_service.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user.dart';
import 'package:fiwork/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';

class SendCustomeOfferPage extends StatefulWidget {
  const SendCustomeOfferPage({super.key, required this.cloudGig});
  final CloudGig cloudGig;

  @override
  State<SendCustomeOfferPage> createState() => _SendCustomeOfferPageState();
}

class _SendCustomeOfferPageState extends State<SendCustomeOfferPage> {
  late final TextEditingController _specificationTitleController;
  late final TextEditingController _shortDetailController;
  late final TextEditingController _gigStartingPriceController;
  late final TextEditingController _gigDeliveryTimeController;

  String keyword = '';

  List<Map> services = [];
  List<CloudUser> employers = [];
  List<String> employersId = [];

  @override
  void initState() {
    _specificationTitleController = TextEditingController();
    _shortDetailController = TextEditingController();
    _gigStartingPriceController = TextEditingController();
    _gigDeliveryTimeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      hintText: 'Search accounts',
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
                                                    employersId.contains(
                                                          user.userId,
                                                        ) &&
                                                        employers
                                                            .contains(user);

                                                if (isTeamMemberExist) {
                                                  employersId
                                                      .remove(user.userId);
                                                  employers.remove(user);
                                                } else {
                                                  employersId.add(user.userId);

                                                  employers.add(user);
                                                }

                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                employersId
                                                        .contains(user.userId)
                                                    ? 'Selected'
                                                    : 'Select',
                                              ),
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

  Future<void> createCustomOffer() async {
    String orderId = const Uuid().v1();

    CloudCustomOffer cloudCustomOffer = CloudCustomOffer(
      orderId: orderId,
      userId: widget.cloudGig.userId,
      gigId: widget.cloudGig.gigId,
      gigTitle: widget.cloudGig.gigTitle,
      gigCoverUrl: widget.cloudGig.gigCoverUrl,
      employerId: employersId.first,
      employerName: employers.first.fullName,
      employerProfileUrl: employers.first.profileUrl!,
      gigPrice: widget.cloudGig.gigStartingPrice,
      serviceSpecifications: widget.cloudGig.serviceSpecifications,
      serviceCharge: widget.cloudGig.gigStartingPrice.toDouble() * 0.1,
      totalPrice: widget.cloudGig.gigStartingPrice +
          (widget.cloudGig.gigStartingPrice).toDouble() * 0.1,
      createdAt: DateTime.now(),
      deliveryTime: widget.cloudGig.deliveryTime,
    );
    CloudCustomOfferService.firebase().createNewCustomOffer(cloudCustomOffer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.black,
            title: const Text(
              'Send Offer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(102.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 94, //check
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xff212121),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 94,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.cloudGig.gigCoverUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cloudGig.gigTitle,
                                maxLines: 2,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              RatingBar.builder(
                                minRating: 1,
                                maxRating: 5,
                                initialRating: widget.cloudGig.gigRating,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 18,
                                allowHalfRating: true,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Color(0xfff4c465),
                                  );
                                },
                                onRatingUpdate: ((value) => print('rating')),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: employers.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
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
                            'Send Ro:',
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
                              itemCount: employers.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Colors.transparent,
                                height: 12,
                              ),
                              itemBuilder: (context, index) {
                                final teamMember = employers[index];
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
                                                  fontWeight: FontWeight.w600,
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
                                                  fontWeight: FontWeight.w400,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                children: [
                  employers.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ElevatedButton(
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
                                'Select Account',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                      )
                      : const SizedBox.shrink(),
                 
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
                      hintText: 'Offer price',
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 109),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 48),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  createCustomOffer();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Send Offer',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
