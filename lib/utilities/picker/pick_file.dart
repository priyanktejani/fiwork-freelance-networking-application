import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

Future<PlatformFile?> pickFile() async {
  try {
    final file = await FilePicker.platform.pickFiles();
    if (file != null) {
      return file.files.first;
    } else {
      return null;
    }
  } on PlatformException catch (_) {
    throw Exception;
  }
}
