// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tuktak/models/audio_file_model.dart';
// import 'package:tuktak/services/file_uploader.dart';
// import 'package:tuktak/utils.dart';
// import 'package:tuktak/views/common_components/primary_button.dart';
// import 'package:tuktak/views/common_components/video.dart';

// class PrivacyPickerBottomSheet extends StatefulWidget {
//   const PrivacyPickerBottomSheet({super.key});

//   @override
//   State<PrivacyPickerBottomSheet> createState() =>
//       _PrivacyPickerBottomSheetState();
// }

// class _PrivacyPickerBottomSheetState extends State<PrivacyPickerBottomSheet> {
//   String _selectedPolicy = "PUBLIC";
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 12,
//         ),
//         Text("Select the privacy setting"),
//         SizedBox(
//           height: 24,
//         ),
//         ListTile(
//           title: Text("Public"),
//           leading: Radio<String>(
//             value: "PUBLIC",
//             groupValue: _selectedPolicy,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPolicy = value!;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: Text("Private"),
//           leading: Radio<String>(
//             value: "PRIVATE",
//             groupValue: _selectedPolicy,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPolicy = value!;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class VideoConfirmation extends StatelessWidget {
//   VideoConfirmation({super.key, required this.videoFile});

//   final FileModal videoFile;
//   Uint8List? thumbnailData;
//   void showPrivacyPickerBottomSheet(BuildContext context) {
//     showBottomSheet(
//         context: context,
//         showDragHandle: true,
//         builder: (context) {
//           final viewHeight = MediaQuery.sizeOf(context).height * 0.3;
//           return SizedBox(
//               height: viewHeight, child: PrivacyPickerBottomSheet());
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: MediaQuery.sizeOf(context).height * 0.07,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: MediaQuery.sizeOf(context).height * 0.3,
//                     width: MediaQuery.sizeOf(context).width * 0.4,
//                     decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8)),
//                     child: FutureBuilder(
//                         future: generateThumbnail(videoFile),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(
//                                 child: CircularProgressIndicator.adaptive());
//                           }
//                           if (snapshot.hasError) {
//                             return Text(
//                                 "Error occured! Please provide custom thumbnail");
//                           }

//                           final data = snapshot.data!;
//                           thumbnailData = data;
//                           return Image.memory(
//                             data,
//                             fit: BoxFit.fill,
//                           );
//                         }),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 12,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 12),
//                       child: Column(
//                         children: [
//                           Container(
//                             child: TextField(
//                               decoration: InputDecoration(
//                                   hintText: "Write the description of video"),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 12,
//                           ),
//                           ListTile(
//                             onTap: () {
//                               showPrivacyPickerBottomSheet(context);
//                             },
//                             title: Text("Reels privacy"),
//                             subtitle: Text("PUBLIC"),
//                             trailing: Icon(Icons.arrow_forward_ios_outlined),
//                             leading: Icon(Icons.lock),
//                           ),
//                           Spacer(),
//                           PrimaryButton(
//                               label: "Upload",
//                               onPressed: () async {
//                                 if (thumbnailData != null) {
//                                   final fileUploader = FileUploader();
//                                   final getTempPath= getTe
//                                   final thumbnailModal= FileModal("thumbnail", tempPath, size, mimeType)
//                                   fileUploader.uploadThumbnail();
//                                 }
//                               })
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuktak/services/file_uploader.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/wrapper.dart';

import '../../models/audio_file_model.dart';

class PrivacyPickerBottomSheet extends StatefulWidget {
  const PrivacyPickerBottomSheet({super.key});

  @override
  State<PrivacyPickerBottomSheet> createState() =>
      _PrivacyPickerBottomSheetState();
}

class _PrivacyPickerBottomSheetState extends State<PrivacyPickerBottomSheet> {
  String _selectedPolicy = "PUBLIC";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Text("Select the privacy setting"),
        SizedBox(
          height: 24,
        ),
        ListTile(
          title: Text("Public"),
          leading: Radio<String>(
            value: "PUBLIC",
            groupValue: _selectedPolicy,
            onChanged: (value) {
              setState(() {
                _selectedPolicy = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text("Private"),
          leading: Radio<String>(
            value: "PRIVATE",
            groupValue: _selectedPolicy,
            onChanged: (value) {
              setState(() {
                _selectedPolicy = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

class VideoConfirmation extends StatelessWidget {
  VideoConfirmation({super.key, required this.videoFile});

  final FileModal videoFile;
  Uint8List? thumbnailData;
  final GlobalKey<FormState> globalFormKey = GlobalKey();
  final titleTextEditingController = TextEditingController();
  final descriptionTextEditingController = TextEditingController();

  Future<String> getTempFilePath(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/thumbnail.png';
    final file = File(tempPath);
    await file.writeAsBytes(data);
    return tempPath;
  }

  void showPrivacyPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final viewHeight = MediaQuery.sizeOf(context).height * 0.3;
        return SizedBox(
          height: viewHeight,
          child: PrivacyPickerBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FutureBuilder<Uint8List?>(
                      future: generateThumbnail(videoFile),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                            "Error occurred! Please provide custom thumbnail",
                          );
                        }

                        final data = snapshot.data!;
                        thumbnailData = data;
                        return Image.memory(
                          data,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Title of video",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please provide the title";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: descriptionTextEditingController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Write the description of the video",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please provide description";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            ListTile(
                              onTap: () {
                                showPrivacyPickerBottomSheet(context);
                              },
                              title: Text("Reels privacy"),
                              subtitle: Text("PUBLIC"),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                              leading: Icon(Icons.lock),
                            ),
                            Spacer(),
                            PrimaryButton(
                              label: "Upload",
                              onPressed: () async {
                                if (thumbnailData != null) {
                                  final fileUploader = FileUploader();
                                  final tempPath =
                                      await getTempFilePath(thumbnailData!);
                                  final thumbnailFile = File(tempPath);
                                  final thumbnailModal = FileModal(
                                    "thumbnail.jpeg",
                                    tempPath,
                                    thumbnailFile.lengthSync(),
                                    "image/png",
                                  );

                                  final thumbnailUrl = await fileUploader
                                      .uploadThumbnail(thumbnailModal);
                                  if (globalFormKey.currentState != null ||
                                          globalFormKey.currentState!
                                              .validate() ??
                                      false) {
                                    try {
                                      // await fileUploader.uploadVideo(
                                      //     titleTextEditingController.text,
                                      //     descriptionTextEditingController.text,
                                      //     videoFile,
                                      //     thumbnailUrl: thumbnailUrl);
                                      // showSucessToast(context,
                                      //     "Video Uploaded Successfully !");
                                      showUpdatingStatusToast(
                                          context,
                                          fileUploader.uploadVideo(
                                              titleTextEditingController.text,
                                              descriptionTextEditingController
                                                  .text,
                                              videoFile,
                                              thumbnailUrl: thumbnailUrl));
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()),
                                          (route) => false);
                                    } catch (e) {
                                      showErrorToast(context,
                                          "Error occured while uploading video");
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("No thumbnail to upload!")),
                                  );
                                }
                              },
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
