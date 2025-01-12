import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tuktak/models/audio_file_model.dart';
import 'package:tuktak/services/file_uploader.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/wrapper.dart';

class AudioUploadConfirmation extends StatefulWidget {
  const AudioUploadConfirmation({super.key, required this.audioFile});
  final FileModal audioFile;
  @override
  State<AudioUploadConfirmation> createState() =>
      _AudioUploadConfirmationState();
}

class _AudioUploadConfirmationState extends State<AudioUploadConfirmation> {
  TextEditingController artistNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController musicTitleController = TextEditingController();

  final pageController = PageController();

  FileModal? audioThumbnail;
  FileModal? audioFile;

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  String? errorMessage;

  Future<void> selectAudioThumbnail() async {
    final audioThumbnailImage = await selectImageFile();
    if (audioThumbnailImage != null) {
      setState(() {
        audioThumbnail = audioThumbnailImage;
      });
    }
  }

  Future<void> uploadAudio() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      // Handle form submission
      String musicTitle = musicTitleController.text;
      String artistName = artistNameController.text;
      String description = descriptionController.text;

      // Debug print values
      print('Music Title: $musicTitle');
      print('Artist Name: $artistName');
      print('Description: $description');
      setState(() {
        isLoading = true;
      });
      try {
        final fileUploader = FileUploader();
        final thumbnailUrl =
            await fileUploader.uploadThumbnail(audioThumbnail!);
        await fileUploader.uploadMusic(
            musicTitle, description, widget.audioFile!,
            thumbnailUrl: thumbnailUrl);
        showSucessToast(context, "Successfully uploaded the song!");
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
        showErrorToast(context, e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildAudioDetailForm() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 24,
            ),

            // ListTile(

            //   leading: GestureDetector(
            //     onTap: () async {
            //       await selectAudioThumbnail();
            //     },
            //     child: Container(
            //       height: MediaQuery.sizeOf(context).height * 0.3,
            //       width: MediaQuery.sizeOf(context).width * 0.4,
            //       decoration: BoxDecoration(
            //         color: Colors.grey[300],
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: audioThumbnail == null
            //           ? Icon(Icons.music_note_outlined)
            //           : Image.file(
            //               File(audioThumbnail!.filePath),
            //               fit: BoxFit.contain,
            //             ),
            //     ),
            //   ),
            //   title: Text(audioFile!.fileName),
            //   subtitle: Text("${audioFile!.size}"),
            // ),

            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await selectAudioThumbnail();
                    },
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.15,
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: audioThumbnail == null
                          ? Icon(Icons.music_note_outlined)
                          : Image.file(
                              File(audioThumbnail!.filePath),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  SizedBox(
                      width:
                          16), // Add some spacing between the thumbnail and the text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        audioFile?.fileName ?? "No Audio File",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${audioFile?.size ?? 0} bytes",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),

            // Music Title Input
            TextFormField(
              controller: musicTitleController,
              decoration: InputDecoration(
                labelText: 'Music Title',
                hintText: 'Pahaar [Official Release]',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please provide the music title";
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            // Artist Name Input
            TextFormField(
              controller: artistNameController,
              decoration: InputDecoration(
                labelText: 'Artist Name',
                hintText: 'Sajjan Raj Vaidhya',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please provide the artist name";
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            // Description Input
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'An Official Release from Vaidya.',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please provide the music desciption";
                }
                return null;
              },
            ),
            SizedBox(height: 20),

            // Submit Button
            PrimaryButton(
              onPressed: () async {
                if (audioThumbnail == null) {
                  setState(() {
                    errorMessage = "Please upload thumbnail!";
                  });
                  return;
                }
                setState(() {
                  errorMessage = null;
                });
                if (formKey.currentState != null &&
                    formKey.currentState!.validate() &&
                    audioFile != null) {
                  setState(() {
                    errorMessage = null;
                  });
                  // await uploadAudio();
                  showUpdatingStatusToast(context, uploadAudio());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Wrapper()),
                      (route) => false);
                }
              },
              label: 'Upload',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    audioFile = widget.audioFile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload audio details"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: viewWidth * 0.05, vertical: 12),
              child: buildAudioDetailForm()),
    );
  }
}
