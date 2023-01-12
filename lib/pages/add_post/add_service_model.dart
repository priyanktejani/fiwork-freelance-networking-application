import 'package:flutter/material.dart';

@immutable
class AddServiceModel {
  final String specificationName;
  final String shortDetail;

  const AddServiceModel({
    required this.specificationName,
    required this.shortDetail,
  });
}
