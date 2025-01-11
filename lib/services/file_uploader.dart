import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tuktak/models/audio_file_model.dart';
import 'package:tuktak/services/backend_interface.dart';

class MediaUrls {
  final String putUrl;
  final String getUrl;

  MediaUrls({required this.putUrl, required this.getUrl});

  // Factory method to create an instance from JSON
  factory MediaUrls.fromJson(Map<String, dynamic> json) {
    return MediaUrls(
      putUrl: json['putUrl'],
      getUrl: json['getUrl'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'putUrl': putUrl,
      'getUrl': getUrl,
    };
  }
}

class FileUploader {
  Future<MediaUrls> _getSignedUrlForAudio(FileModal audioFile) async {
    return _getSignedUrl(
        audioFile.fileName, audioFile.size, audioFile.mimeType, "SONG");
  }

  Future<MediaUrls> _getSignedUrl(
      String fileName, int fileSize, String mimeType, String objectType) async {
// {
//   "filename": "Screenshot 2024-12-29 091310.png",
//   "fileSizeInBytes": 182469,
//   "folder": "/media/uploads",
//   "mimeType": "image/png",
//   "objectType": "THUMBNAIL"
// }
    final body = {
      "filename": fileName,
      "fileSizeInBytes": fileSize,
      "folder": "/media/uploads",
      "mimeType": mimeType,
      "objectType": objectType
    };

    final backendInterface = BackendInterface();
    final serverResponse = await backendInterface.post("bucket", body: body);

//     Result
//     {
//     "message": "Operation successful!",
//     "status": 200,
//     "statusText": "OK",
//     "data": {
//         "putUrl": "https://social-media-app.3339819468284bbfd00eb447167a847b.r2.cloudflarestorage.com/social-media-app/dev-env/media/uploads/Screenshot%202024-12-29%20091310.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=e3c32d2821f11bdec07f5552eb3cb078%2F20241231%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20241231T114521Z&X-Amz-Expires=1800&X-Amz-Signature=610993969687066765eb978b5ec5be8ef1dcbbc0af5c54ed1a1000e1005b151e&X-Amz-SignedHeaders=host&x-amz-acl=public-read&x-amz-meta-filename=Screenshot%202024-12-29%20091310.png&x-id=PutObject",
//         "getUrl": "https://bucket.dev.unclesamstech.com/social-media-app/dev-env%2Fmedia%2Fuploads%2FScreenshot%202024-12-29%20091310.png"
//        }
//     }

    if (serverResponse.status != 200) {
      throw HttpException(
          message: "Error while uploading song : ${serverResponse.message}");
    }

    return MediaUrls.fromJson(serverResponse.data);
  }

  Future<void> uploadTheFile(
      String putUrl, String filePath, int fileSize) async {
    final backendInterface = BackendInterface();

    const contentType = "application/x-www-form-urlencoded";
    final HashMap<String, dynamic> header = HashMap();
    header['Content-Type'] = contentType;

    final file = File(filePath);
    header[Headers.contentLengthHeader] = fileSize;
    try {
      await backendInterface.sendPutRequest(
        putUrl,
        body: file.openRead(),
        headers: header,
      );
    } catch (e) {
      throw HttpException(
          message: "Error while uploading file to S3:${e.toString()}");
    }
  }

  Future<void> uploadMusic(
      String title, String description, FileModal audioFile,
      {String visibility = "PUBLIC",
      String thumbnailUrl =
          "https://fastly.picsum.photos/id/49/200/300.jpg?hmac=mC_cJaZJfrb4JZcnITvz0OOwLCyOTLC0QXH4vTo9syY"}) async {
    try {
      final signedUrl = await _getSignedUrlForAudio(audioFile);
      await uploadTheFile(signedUrl.putUrl, audioFile.filePath, audioFile.size);

      final backendInterface = BackendInterface();
      final body = {
        "title": title,
        "description": description,
        "thumbnail": thumbnailUrl,
        "musicUrl": signedUrl.getUrl,
        "visibility": visibility //or private : optional
      };

      backendInterface.post(
        "music",
        body: body,
      );
    } catch (e) {
      rethrow;
    }

//     {
//   "title": "Relaxing Beats",
//   "description": "A smooth track to relax and unwind.",
//   "thumbnail": "https://example.com/images/relaxing-beats.jpg",
//   "musicUrl": "https://example.com/audio/relaxing-beats.mp3",
//   "visibility": "PUBLIC" //or private : optional
// }
  }

  Future<void> uploadVideo(
      String title, String description, FileModal videoFile,
      {String visibility = "PUBLIC", String thumbnailUrl = ""}) async {
    try {
      final mediaUrls = await _getSignedUrl(
          videoFile.fileName, videoFile.size, videoFile.mimeType, "VIDEO");
      await uploadTheFile(mediaUrls.putUrl, videoFile.filePath, videoFile.size);

      final backendInterface = BackendInterface();
      final body = {
        "title": title,
        "description": description,
        "thumbnail": thumbnailUrl,
        "videoUrl": mediaUrls.getUrl,
        "visibility": visibility //or private : optional
      };

      backendInterface.post(
        "video",
        body: body,
      );
    } catch (e) {
      rethrow;
    }

//       {
//   "title": "New upload video",
//   "description": "A smooth track to relax and unwind.",
//   "thumbnail": "https://example.com/images/relaxing-beats.jpg",
//   "videoUrl": "https://bucket.dev.unclesamstech.com/social-media-app/dev-env%2Fmedia%2Fuploads%2FSnaptik.app_7021460162271628549.mp4",
//   "visibility": "PUBLIC" //or private : optional,
// //   "music": "" // id of the music if the user is adding other music in the video //optional
// }
  }

  Future<String> uploadThumbnail(FileModal thumbnailFile) async {
    try {
      final mediaUrls = await _getSignedUrl(thumbnailFile.fileName,
          thumbnailFile.size, thumbnailFile.mimeType, "THUMBNAIL");
      await uploadTheFile(
          mediaUrls.putUrl, thumbnailFile.filePath, thumbnailFile.size);
      return mediaUrls.getUrl;
    } catch (e) {
      rethrow;
    }
  }
}
