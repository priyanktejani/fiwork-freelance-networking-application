import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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