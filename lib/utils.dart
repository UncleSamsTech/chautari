import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:tuktak/models/audio_file_model.dart';
import 'package:tuktak/services/shared_preference_service.dart';

bool isUserLoggedIn() {
  return SharedPreferenceService().isLogin;
}

void showErrorToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red, // Customize color for error
    duration: Duration(seconds: 2), // Duration of the toast
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSucessToast(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.green, // Customize color for error
    duration: Duration(seconds: 2), // Duration of the toast
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your email.";
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return "Please enter a valid email.";
  }
  return null;
}

String formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M'; // e.g., 1.5M
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K'; // e.g., 1.2K
  } else {
    return number.toString(); // Less than 1000, show the number as is
  }
}

String getFileExtension(String fileName) {
  return ".${fileName.split('.').last}".toLowerCase();
}

Future<Uint8List?> generateThumbnail(FileModal videoFile) async {
  final uint8list = await VideoThumbnail.thumbnailData(
    video: videoFile.filePath,
    imageFormat: ImageFormat.JPEG,
    maxWidth:
        128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
    quality: 25,
  );

  return uint8list;
}

Future<FileModal?> selectAudioFile() async {
  final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
      allowMultiple: false);
  if (fileResult != null && fileResult.files.single.path != null) {
    String filePath = fileResult.files.single.path!;
    String fileName = fileResult.files.single.name;
    int fileSize = fileResult.files.single.size;
    String mimeType = "audio/${getFileExtension(fileName)}";
    //Can be done any
    // String mimeType = fileResult.files.single.xFile.mimeType!;

    Uint8List? bytes = fileResult.files.single.bytes;

    return FileModal(fileName, filePath, fileSize, mimeType, bytes: bytes);
  }
  return null;
}

Future<FileModal?> selectImageFile() async {
  final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false);
  if (fileResult != null && fileResult.files.single.path != null) {
    String filePath = fileResult.files.single.path!;
    String fileName = fileResult.files.single.name;
    int fileSize = fileResult.files.single.size;
    String mimeType = "image/${getFileExtension(fileName)}";
    //Can be done any
    // String mimeType = fileResult.files.single.xFile.mimeType!;
    Uint8List? bytes = fileResult.files.single.bytes;

    return FileModal(fileName, filePath, fileSize, mimeType, bytes: bytes);
  }
  return null;
}

Future<FileModal?> selectVideoFile() async {
  final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['mp4'], allowMultiple: false);
  if (fileResult != null && fileResult.files.single.path != null) {
    String filePath = fileResult.files.single.path!;
    String fileName = fileResult.files.single.name;
    int fileSize = fileResult.files.single.size;
    String mimeType = "video/${getFileExtension(fileName)}";
    //Can be done any
    // String mimeType = fileResult.files.single.xFile.mimeType!;
    print("Selected file");

    Uint8List? bytes = fileResult.files.single.bytes;
    FileModal videoFile =
        FileModal(fileName, filePath, fileSize, mimeType, bytes: bytes);
    return videoFile;
  }
  return null;
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}
