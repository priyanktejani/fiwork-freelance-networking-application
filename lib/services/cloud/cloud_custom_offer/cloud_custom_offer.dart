import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudCustomOffer {
  final String orderId;
  final String userId;
  final String gigId;
  final String gigCoverUrl;
  final String employerName;
  final String employerProfileUrl;
  final String gigTitle;
  final String employerId;
  final double gigPrice;
  final double serviceCharge;
  final double totalPrice;
  final List serviceSpecifications;
  final DateTime createdAt;
  final String deliveryTime;

  const CloudCustomOffer({
    required this.orderId,
    required this.userId,
    required this.gigId,
    required this.gigTitle,
    required this.gigCoverUrl,
    required this.employerName,
    required this.employerProfileUrl,
    required this.employerId,
    required this.gigPrice,
    required this.serviceCharge,
    required this.totalPrice,
    required this.serviceSpecifications,
    required this.createdAt,
    required this.deliveryTime,
  });

  CloudCustomOffer.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : orderId = snapshot.data()[orderIdFieldName],
        userId = snapshot.data()[userIdFieldName],
        gigId = snapshot.data()[gigIdFieldName],
        gigCoverUrl = snapshot.data()[gigCoverUrlFieldName] as String,
        gigTitle = snapshot.data()[gigTitleFieldName] as String,
        employerName = snapshot.data()[employerNameFieldName] as String,
        employerProfileUrl =
            snapshot.data()[employerProfileUrlFieldName] as String,
        employerId = snapshot.data()[employerIdFieldName],
        gigPrice = snapshot.data()[gigPriceFieldName] as double,
        serviceCharge = snapshot.data()[serviceChargeFieldName] as double,
        totalPrice = snapshot.data()[totalPriceFieldName] as double,
        serviceSpecifications =
            snapshot.data()[serviceSpecificationsFieldName] as List,
        createdAt =
            DateTime.parse(snapshot.data()[createdAtFieldName] as String),
        deliveryTime = snapshot.data()[deliveryTimeFieldName] as String;

  Map<String, dynamic> toJson() => {
        orderIdFieldName: orderId,
        userIdFieldName: userId,
        gigIdFieldName: gigId,
        gigTitleFieldName: gigTitle,
        gigCoverUrlFieldName: gigCoverUrl,
        employerNameFieldName: employerName,
        employerProfileUrlFieldName: employerProfileUrl,
        employerIdFieldName: employerId,
        gigPriceFieldName: gigPrice,
        serviceChargeFieldName: serviceCharge,
        totalPriceFieldName: totalPrice,
        serviceSpecificationsFieldName: serviceSpecifications,
        createdAtFieldName: createdAt.toIso8601String(),
        deliveryTimeFieldName: deliveryTime,
      };

  @override
  bool operator ==(covariant CloudCustomOffer other) => gigId == other.orderId;

  @override
  int get hashCode => orderId.hashCode;
}
