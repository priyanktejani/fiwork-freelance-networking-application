import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudGig {
  final String userId;
  final String gigId;
  final double gigRating;
  final String gigCoverUrl;
  final String gigTitle;
  final String gigCategory;
  final String gigDescription;
  final List<dynamic> teamMembers;
  final List serviceSpecifications;
  final double gigStartingPrice;
  final String deliveryTime;
  final DateTime createdAt;

  const CloudGig({
    required this.userId,
    required this.gigId,
    required this.gigRating,
    required this.gigCoverUrl,
    required this.gigTitle,
    required this.gigCategory,
    required this.gigDescription,
    required this.teamMembers,
    required this.serviceSpecifications,
    required this.gigStartingPrice,
    required this.deliveryTime,
    required this.createdAt,
  });

  CloudGig.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        gigId = snapshot.data()[gigIdFieldName],
        gigRating = snapshot.data()[gigRatingFieldName] as double,
        gigCoverUrl = snapshot.data()[gigCoverUrlFieldName] as String,
        gigTitle = snapshot.data()[gigTitleFieldName] as String,
        gigCategory = snapshot.data()[gigCategoryFieldName] as String,
        gigDescription = snapshot.data()[gigDescriptionFieldName] as String,
        teamMembers = snapshot.data()[teamMembersFieldName] as List<dynamic>,
        serviceSpecifications =
            snapshot.data()[serviceSpecificationsFieldName] as List,
        gigStartingPrice = snapshot.data()[gigStartingPriceFieldName] as double,
        deliveryTime = snapshot.data()[deliveryTimeFieldName] as String,
        createdAt =
            DateTime.parse(snapshot.data()[createdAtFieldName] as String);

  Map<String, dynamic> toJson() => {
        userIdFieldName: userId,
        gigIdFieldName: gigId,
        gigRatingFieldName: gigRating,
        gigCoverUrlFieldName: gigCoverUrl,
        gigTitleFieldName: gigTitle,
        gigCategoryFieldName: gigCategory,
        gigDescriptionFieldName: gigDescription,
        teamMembersFieldName: teamMembers,
        serviceSpecificationsFieldName: serviceSpecifications,
        gigStartingPriceFieldName: gigStartingPrice,
        deliveryTimeFieldName: deliveryTime,
        createdAtFieldName: createdAt.toIso8601String(),
      };

  @override
  bool operator ==(covariant CloudGig other) => gigId == other.gigId;

  @override
  int get hashCode => gigId.hashCode;
}
