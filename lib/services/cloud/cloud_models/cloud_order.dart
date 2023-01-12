import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiwork/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudOrder {
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
  final String projectRequirement;
  final List serviceSpecifications;
  final String? deliveryMessage;
  final String? filePathUrl;
  final bool isdelivered;
  final bool isOrderAccepted;
  final bool isOrderRejected;
  final bool isDeliveryAccepted;
  final DateTime createdAt;
  final String deliveryTime;

  const CloudOrder({
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
    this.projectRequirement = '',
    required this.serviceSpecifications,
    this.isOrderAccepted = false,
    this.isOrderRejected = false,
    this.deliveryMessage = '',
    this.filePathUrl = '',
    this.isdelivered = false,
    this.isDeliveryAccepted = false,
    required this.createdAt,
    required this.deliveryTime,
  });

  CloudOrder.fromJson(Map<String, dynamic> json)
      : orderId = json[orderIdFieldName],
        userId = json[userIdFieldName],
        gigId = json[gigIdFieldName],
        gigCoverUrl = json[gigCoverUrlFieldName],
        gigTitle = json[gigTitleFieldName],
        employerName = json[employerNameFieldName],
        employerId = json[employerIdFieldName],
        employerProfileUrl = json[employerProfileUrlFieldName],
        gigPrice = json[gigPriceFieldName],
        serviceCharge = json[serviceChargeFieldName],
        totalPrice = json[totalPriceFieldName],
        projectRequirement = json[projectRequirementFieldName],
        serviceSpecifications = json[serviceSpecificationsFieldName],
        deliveryMessage = json[deliveryMessageFieldName],
        filePathUrl = json[filePathUrlFieldName],
        isOrderAccepted = json[isOrderAcceptedFieldName],
        isOrderRejected = json[isOrderRejectedFieldName],
        isdelivered = json[isDeliveredFieldName],
        isDeliveryAccepted = json[isDeliveryAcceptedFieldName],
        createdAt = json[createdAtFieldName],
        deliveryTime = json[deliveryTimeFieldName];

  CloudOrder.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
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
        projectRequirement =
            snapshot.data()[projectRequirementFieldName] as String,
        serviceSpecifications =
            snapshot.data()[serviceSpecificationsFieldName] as List,
        deliveryMessage = snapshot.data()[deliveryMessageFieldName] as String,
        filePathUrl = snapshot.data()[filePathUrlFieldName] as String,
        isOrderAccepted = snapshot.data()[isOrderAcceptedFieldName] as bool,
        isOrderRejected = snapshot.data()[isOrderRejectedFieldName] as bool,
        isdelivered = snapshot.data()[isDeliveredFieldName] as bool,
        isDeliveryAccepted =
            snapshot.data()[isDeliveryAcceptedFieldName] as bool,
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
        projectRequirementFieldName: projectRequirement,
        serviceSpecificationsFieldName: serviceSpecifications,
        deliveryMessageFieldName: deliveryMessage,
        filePathUrlFieldName: filePathUrl,
        isOrderAcceptedFieldName: isOrderAccepted,
        isOrderRejectedFieldName: isOrderRejected,
        isDeliveredFieldName: isdelivered,
        isDeliveryAcceptedFieldName: isDeliveryAccepted,
        createdAtFieldName: createdAt.toIso8601String(),
        deliveryTimeFieldName: deliveryTime,
      };

  @override
  bool operator ==(covariant CloudOrder other) => gigId == other.orderId;

  @override
  int get hashCode => orderId.hashCode;
}
