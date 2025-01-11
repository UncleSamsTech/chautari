import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuktak/models/custom_navigation_bar_item.dart';
import 'package:tuktak/services/file_uploader.dart';
import 'package:tuktak/utils.dart' as utils;
import 'package:tuktak/views/auth/register/ask_account_creation.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/views/feed/feed.dart';
import 'package:tuktak/views/user_info/user.dart';
import 'package:tuktak/views/video_creation/video_creation.dart';

import '../models/audio_file_model.dart';
import '../services/shared_preference_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final PageController pageController = PageController();

  void showCreationFormatSelector(BuildContext context) {
    showBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: Scaffold(
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      "Choose Format",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VideoCreation()));
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.video_file_outlined),
                                    Text("Reels"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                showAudioUploadButtomSheet(context);
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.audio_file_outlined),
                                    Text("Song"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showAudioUploadButtomSheet(BuildContext context) {
    showBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final viewHeight = MediaQuery.sizeOf(context).height * 0.5;
          final viewWidth = MediaQuery.sizeOf(context).width;

          return SizedBox(
              height: viewHeight,
              width: viewWidth,
              child: AudioUploadButtomSheet());
        });
  }

  @override
  Widget build(BuildContext context) {
    final isUserLogin = utils.isUserLoggedIn();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Feed(),
              isUserLogin ? VideoCreation() : AskAccountCreation(),
              isUserLogin
                  ? UserProfile(
                      isOwnProfile: true,
                    )
                  : AskAccountCreation()
            ],
          )),
          CustomNavigationBar(
            onChange: (index) async {
              if (index == 1) {
                if (SharedPreferenceService().isLogin) {
                  // showCreationFormatSelector(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VideoCreation()));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AskAccountCreation(),
                      fullscreenDialog: true));
                }
              } else {
                await pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            items: [
              CustomNavigationBarItem("assets/icons/home.svg"),
              CustomNavigationBarItem("assets/icons/plus.svg"),
              CustomNavigationBarItem("assets/icons/user-round.svg"),
            ],
          ),
        ],
      )),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {super.key,
      required this.items,
      required this.onChange,
      this.selectedColor = Colors.redAccent,
      this.iconSize = 25});
  final List<CustomNavigationBarItem> items;
  final Color selectedColor;
  final double iconSize;
  final void Function(int) onChange;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = widget.selectedColor;
    final iconSize = widget.iconSize;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 8, // Blur radius
            offset: Offset(0, -3), // Offset in x and y direction
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...widget.items
              .asMap()
              .entries
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = e.key != 1 ? e.key : selectedIndex;
                        widget.onChange(e.key);
                      });
                    },
                    child: SizedBox(
                        height: iconSize,
                        width: iconSize,
                        child: SvgPicture.asset(e.value.svgIconPath,
                            colorFilter: selectedIndex == e.key
                                ? ColorFilter.mode(
                                    selectedColor, BlendMode.srcIn)
                                : null)),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

class AudioUploadButtomSheet extends StatefulWidget {
  const AudioUploadButtomSheet({super.key});

  @override
  State<AudioUploadButtomSheet> createState() => _AudioUploadButtomSheetState();
}

class _AudioUploadButtomSheetState extends State<AudioUploadButtomSheet> {
  Future<void> selectAudioFile() async {
    final audioFile = await utils.selectAudioFile();
    if (audioFile != null) {
      setState(() {
        this.audioFile = audioFile;
      });
    }
  }

  Future<void> selectAudioThumbnail() async {
    final audioThumbnailImage = await utils.selectImageFile();
    if (audioThumbnail != null) {
      setState(() {
        audioThumbnail = audioThumbnailImage;
      });
    }
  }

  TextEditingController artistNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController musicTitleController = TextEditingController();

  final pageController = PageController();

  FileModal? audioFile;
  FileModal? audioThumbnail;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  String? errorMessage;

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
        await fileUploader.uploadMusic(musicTitle, description, audioFile!,
            thumbnailUrl: thumbnailUrl);
        utils.showSucessToast(context, "Successfully uploaded the song!");
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
        utils.showErrorToast(context, e.toString());
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
            Text(
              "Upload audio details",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 24,
            ),
            audioFile != null
                ? ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.music_note_outlined),
                    ),
                    title: Text(audioFile!.fileName),
                    subtitle: Text("${audioFile!.size}"),
                  )
                : GestureDetector(
                    onTap: () async {
                      await selectAudioFile();
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red[100],
                      child: Icon(Icons.upload, color: Colors.red, size: 25),
                    ),
                  ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
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
                if (audioFile == null) {
                  setState(() {
                    errorMessage = "Please provide the song!";
                  });
                }
                if (formKey.currentState != null &&
                    formKey.currentState!.validate() &&
                    audioFile != null) {
                  setState(() {
                    errorMessage = null;
                  });
                  pageController.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut);
                }
              },
              label: 'Next',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAudioThumbnailForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 24,
        ),
        Text(
          "Please provide the thumbnail ",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        Text("for your song",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        Spacer(),
        GestureDetector(
          onTap: () async {
            await selectAudioThumbnail();
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: audioThumbnail != null
                ? FileImage(File(audioThumbnail!.filePath))
                : null,
          ),
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        Spacer(),
        PrimaryButton(
            label: "Upload",
            onPressed: () async {
              if (audioThumbnail != null) {
                await uploadAudio();
              } else {
                setState(() {
                  errorMessage = "Please upload thumbnail!";
                });
              }
            }),
        SizedBox(
          height: 12,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.sizeOf(context).width;
    return isLoading
        ? Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: viewWidth * 0.05, vertical: 12),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [buildAudioDetailForm(), buildAudioThumbnailForm()],
            ),
          );
  }
}
