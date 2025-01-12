import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:tuktak/models/audio_file_model.dart';
import 'package:tuktak/services/shared_preference_service.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadAndSaveTempFile(String url, String fileName) async {
  try {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Set the file path
    final filePath = '$tempPath/$fileName';
    print("Url is $url");
    // Download the file using Dio
    final dio = Dio();
    await dio.download(
      url,
      filePath,
      // onReceiveProgress: (received, total) {
      //   if (total != -1) {
      //     print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
      //   }
      // },
    );

    print('File downloaded and saved at: $filePath');
    return File(filePath);
  } catch (e) {
    print('Error downloading file: $e');
    throw Exception('Failed to download file');
  }
}

bool isUserLoggedIn() {
  return SharedPreferenceService().isLogin;
}

final audioFileExtension = ['mp3', 'wav', 'm4a'];
final imageFileExtension = ['jpg', 'jpeg', 'png'];
final videoFileExtension = ['mp4'];

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

void showUpdatingStatusToast(BuildContext context, Future updatingStatus) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: FutureBuilder(
        future: updatingStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(
                  width: 4,
                ),
                Text('Uploading....'),
              ],
            );
          }
          if (snapshot.hasError) {
            return Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Text("Error has occured while uploading!."),
              ],
            );
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          return Row(
            children: [
              Icon(
                Icons.check_circle_sharp,
                color: Colors.green,
              ),
              Text("Uploaded."),
            ],
          );
        }),

    duration: Duration(days: 1), // Duration of the toast
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
  return "${fileName.split('.').last}".toLowerCase();
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
      allowedExtensions: audioFileExtension,
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
      allowedExtensions: imageFileExtension,
      allowMultiple: false);
  if (fileResult != null && fileResult.files.single.path != null) {
    String filePath = fileResult.files.single.path!;
    String fileName = fileResult.files.single.name;
    int fileSize = fileResult.files.single.size;
    String mimeType = "image/${getFileExtension(fileName)}";
    //Can be done any
    // String mimeType = fileResult.files.single.xFile.mimeType!;
    Uint8List? bytes = fileResult.files.single.bytes;

    print("ERROR custom file is selected");

    return FileModal(fileName, filePath, fileSize, mimeType, bytes: bytes);
  }

  print("ERROR custom file is not selected");
  return null;
}

Future<FileModal?> selectVideoFile() async {
  final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: videoFileExtension,
      allowMultiple: false);
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

Future<Pair<FileModal?, String>> selectFile() async {
  final fileResult = await FilePicker.platform.pickFiles(allowMultiple: false);
  if (fileResult != null && fileResult.files.single.path != null) {
    print(" ERROR Custom : file is picked");
    String filePath = fileResult.files.single.path!;
    String fileName = fileResult.files.single.name;
    int fileSize = fileResult.files.single.size;
    String fileType = getFileExtension(fileName);

    print("Error Custom file extension is $fileType");

// Determine file type (audio, video, or image)
    if (audioFileExtension.contains(fileType)) {
      print("Audio file selected: $fileName");

      // Create FileModal for audio file
      return Pair<FileModal?, String>(
          FileModal(fileName, filePath, fileSize, "audio/$fileType",
              bytes: fileResult.files.single.bytes),
          "audio");
    } else if (imageFileExtension.contains(fileType)) {
      print("Image file selected: $fileName");

      // Create FileModal for image file
      return Pair<FileModal?, String>(
          FileModal(fileName, filePath, fileSize, "image/$fileType",
              bytes: fileResult.files.single.bytes),
          "image");
    } else if (videoFileExtension.contains(fileType)) {
      print("Video file selected: $fileName");

      // Create FileModal for video file
      return Pair<FileModal?, String>(
          FileModal(fileName, filePath, fileSize, "video/$fileType",
              bytes: fileResult.files.single.bytes),
          "video");
    } else {
      return Pair<FileModal?, String>(null, "unsupported");
    }
  } else {
    return Pair<FileModal?, String>(null, "no_file_selected");
  }
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}
