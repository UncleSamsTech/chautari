import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuktak/models/audio_file_model.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/secondary_buttton.dart';
import 'package:tuktak/views/video_creation/audio_confirmation.dart';
import 'package:tuktak/views/video_creation/audio_trimmer.dart';
import 'package:tuktak/views/video_creation/video_confirmation.dart';
import 'package:media_kit/media_kit.dart';

import '../../services/feed_manager.dart';

enum RecordingState { STATE_RECORDING_ENDED, STATE_RECORDING_STARTED }

class VideoCreation extends StatefulWidget {
  const VideoCreation({super.key});

  @override
  State<VideoCreation> createState() => _VideoCreationState();
}

class _VideoCreationState extends State<VideoCreation> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isFront = true;
  bool isRecordingStarted = false;
  FileModal? selectedMusic;
  late Player audioPlayer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = Player();
    _initializeController();
  }

  Future<void> loadMusic(String musicUrl) async {
    await audioPlayer.open(Media("file:///${musicUrl}"));
    await audioPlayer.pause();
  }

  Future<bool> showMusicListModal() async {
    //Why? get the isNewMusic
    //Because if it is clipped have to give the backend it is new or not
    bool isNewMusic = await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) {
          final viewHeight = MediaQuery.sizeOf(context).height * 0.8;
          return SizedBox(
            height: viewHeight,
            child: MusicList(
              onMusicSelected: (String? filePath) async {
                if (filePath != null) {
                  await loadMusic(filePath!);
                }
              },
            ),
          );
        });
    return isNewMusic;
  }

  void showEffectListModal() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final viewHeight = MediaQuery.sizeOf(context).height * 0.8;
          return SizedBox(
            height: viewHeight,
            child: EffectList(),
          );
        });
  }

  Future<void> handleRecording() async {
    if (isRecordingStarted) {
      final file = await controller?.stopVideoRecording();
      await audioPlayer?.pause();
      if (file != null) {
        final fileName = file.name;
        final filePath = file.path;
        final fileSize = await file.length();

        final fileModal = FileModal(fileName, filePath, fileSize,
            "video/" + getFileExtension(fileName));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoConfirmation(
                  videoFile: fileModal,
                )));
      }

      setState(() {
        isRecordingStarted = false;
      });
    } else {
      await controller?.startVideoRecording();
      await audioPlayer?.play();
      setState(() {
        isRecordingStarted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller == null || !controller!.value.isInitialized
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Align(
                    child: CameraPreview(controller!),
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                showMusicListModal();
                              },
                              child: Text(
                                "♫ Sounds",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFront = !isFront;
                                  });
                                  _initializeController();
                                },
                                icon: Icon(Icons.cameraswitch_outlined,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEffectListModal();
                                },
                                icon: SvgPicture.asset(
                                    "assets/icons/Effects.svg"),
                              ),
                              Text(
                                "Effects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                await handleRecording();
                              },
                              icon: CameraButton(
                                radius: 25,
                                isRecording: isRecordingStarted,
                              )),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final file = await selectFile();

                                    if (file.a != null) {
                                      showSucessToast(context,
                                          "File is selected ${file.b}");

                                      switch (file.b) {
                                        // case "image":
                                        //   break;
                                        case "audio":
                                          print("Audio file is selected!");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AudioUploadConfirmation(
                                                          audioFile: file.a!)));
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             AudioTrimmer(
                                          //               file: File(
                                          //                   file.a!.filePath),
                                          //               onSaved: (value) {},
                                          //             )));
                                          // showAudioTrimmerModal(
                                          //     file.a!.filePath);
                                          break;
                                        case "video":
                                          print("Video file is selected!");

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoConfirmation(
                                                          videoFile: file.a!)));

                                          break;
                                        default:
                                          print(
                                              "Unsopperted file is selected!");

                                          showErrorToast(context,
                                              "Unsupported file format");
                                      }
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/icons/Upload.svg")),
                              Text(
                                "Upload",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
  }

  Future<void> _initializeController() async {
    await _initializeCamera();
    if (cameras.isNotEmpty) {
      controller = CameraController(
        cameras[isFront ? 1 : 0],
        ResolutionPreset.max,
      );
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        if (error is CameraException) {
          switch (error.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    if (controller != null) controller!.dispose();
    super.dispose();
  }
}

class MusicListTileModal {
  String title;
  String subtitle;
  String thumbnailUrl;
  bool isSaved;
  String musicUrl;
  MusicListTileModal(this.title, this.subtitle, this.thumbnailUrl,
      this.musicUrl, this.isSaved);
}

// class MusicList extends StatefulWidget {
//   MusicList({super.key, required this.onMusicSelected});
//   void Function(String?) onMusicSelected;
//   @override
//   State<MusicList> createState() => _MusicListState();
// }

// class _MusicListState extends State<MusicList> {
//   bool isLoading = true;
//   late List<MusicListTileModal> musicList;
//   //  = [
//   //   MusicListTileModal(
//   //       'Song A', 'Artist A', 'https://placehold.co/600x400', true),
//   //   MusicListTileModal(
//   //       'Song B', 'Artist B', 'https://placehold.co/600x400', false),
//   //   MusicListTileModal(
//   //       'Song C', 'Artist C', 'https://placehold.co/600x400', true),
//   //   MusicListTileModal(
//   //       'Song D', 'Artist D', 'https://placehold.co/600x400', false),
//   // ];

//   TextEditingController search = TextEditingController(text: "");
//   int currentPage = 1;

//   File selectedFile

//   Future<void> fetchMusicData() async {
//     setState(() {
//       isLoading = true;
//     });
//     final searchData =
//         await FeedManager().getAllMusicAndSearch(search.text, currentPage);

//     setState(() {
//       musicList = searchData
//           .map((e) => MusicListTileModal(e.title, e.author.username,
//               e.thumbnail, e.musicUrl, e.extras.bookmarked))
//           .toList();
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchMusicData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//         child: PageView(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8)),
//                   child: TextFormField(
//                     controller: search,
//                     onFieldSubmitted: (value) {
//                       fetchMusicData();
//                     },
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search),
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               search.text = "";
//                             },
//                             icon: Icon(Icons.close)),
//                         hintText: "Search music",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8))),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 SecondaryButtton(
//                     label: "Saved",
//                     icon: Icon(Icons.bookmark_outline_outlined),
//                     onPressed: () {}),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Expanded(
//                     child: isLoading
//                         ? Center(
//                             child: CircularProgressIndicator.adaptive(),
//                           )
//                         : SingleChildScrollView(
//                             child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Text("For You"),
//                                   Spacer(),
//                                   TextButton(
//                                       onPressed: () {}, child: Text("See more"))
//                                 ],
//                               ),
//                               ...musicList.map((music) {
//                                 return ListTile(
//                                   leading: SizedBox(
//                                     height: 50,
//                                     width: 50,
//                                     child: Image.network(
//                                       music.thumbnailUrl,
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   title: Text(music.title),
//                                   subtitle: Text(music.subtitle),
//                                   trailing: Icon(
//                                     music.isSaved
//                                         ? Icons.bookmark
//                                         : Icons.bookmark_border,
//                                     color: music.isSaved ? Colors.blue : null,
//                                   ),
//                                   onTap: () async {
//                                     // Handle tap event
//                                     setState(() {
//                                       isLoading = true;
//                                     });
//                                     final musicFile =
//                                         await downloadAndSaveTempFile(
//                                             music.musicUrl, "music.mp3");
//                                     setState(() {
//                                       isLoading = false;
//                                     });
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) => AudioTrimmer(
//                                                 file: musicFile,
//                                                 onSaved:
//                                                     widget.onMusicSelected)));
//                                   },
//                                 );
//                               }).toList(),
//                             ],
//                           )))
//               ],
//             ),

//             AudioTrimmer(file: , onSaved: onSaved)
//           ],
//         ));
//   }
// }

class MusicList extends StatefulWidget {
  MusicList({super.key, required this.onMusicSelected});
  final void Function(String?) onMusicSelected;

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  bool isLoading = true;
  late List<MusicListTileModal> musicList;
  TextEditingController search = TextEditingController(text: "");
  int currentPage = 1;
  File? selectedFile; // Stores the selected file for transfer
  final PageController _pageController = PageController();

  Future<void> fetchMusicData() async {
    setState(() {
      isLoading = true;
    });
    final searchData =
        await FeedManager().getAllMusicAndSearch(search.text, currentPage);

    setState(() {
      musicList = searchData
          .map((e) => MusicListTileModal(e.title, e.author.username,
              e.thumbnail, e.musicUrl, e.extras.bookmarked))
          .toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          // Page 1: Music List
          Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: search,
                  onFieldSubmitted: (value) {
                    fetchMusicData();
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            search.text = "";
                          },
                          icon: const Icon(Icons.close)),
                      hintText: "Search music",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(height: 12),
              SecondaryButtton(
                  label: "Saved",
                  icon: const Icon(Icons.bookmark_outline_outlined),
                  onPressed: () {}),
              const SizedBox(height: 12),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("For You"),
                                const Spacer(),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("See more")),
                              ],
                            ),
                            ...musicList.map((music) {
                              return ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                    music.thumbnailUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(music.title),
                                subtitle: Text(music.subtitle),
                                trailing: Icon(
                                  music.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: music.isSaved ? Colors.blue : null,
                                ),
                                onTap: () async {
                                  // Download the music file
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final musicFile =
                                      await downloadAndSaveTempFile(
                                          music.musicUrl, "music.mp3");
                                  setState(() {
                                    selectedFile = musicFile;
                                    isLoading = false;
                                  });

                                  // Navigate to the AudioTrimmer page
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
              ),
            ],
          ),

          // Page 2: AudioTrimmer
          if (selectedFile != null)
            AudioTrimmer(
              file: selectedFile!,
              onBacked: () {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              onSaved: (path) {
                widget.onMusicSelected(path);
              },
            )
          else
            const Center(child: Text("No file selected")),
        ],
      ),
    );
  }
}

class EffectListModal {
  String effectAvatarUrl;
  String effectName;

  EffectListModal(this.effectName, this.effectAvatarUrl);
}

class EffectList extends StatelessWidget {
  EffectList({super.key});

  final effectList = [
    EffectListModal(
      'Fire Blast',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Thunder Shock',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Ice Wave',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Earthquake',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Wind Gust',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Healing Light',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Shadow Strike',
      'https://placehold.co/600x400',
    ),
    EffectListModal(
      'Water Surge',
      'https://placehold.co/600x400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Effects"),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: GridView.builder(
              itemCount: effectList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          effectList[index].effectAvatarUrl,
                        ),
                      ),
                      Text(effectList[index].effectName)
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton(
      {super.key, required this.radius, required this.isRecording});
  final double radius;
  final bool isRecording;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 3,
      width: radius * 3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius * 3 / 2),
          border: Border.all(
              // color: isRecording ? Colors.redAccent : Colors.redAccent,
              color: Colors.white,
              width: 5),
          color: Colors.transparent),
      child: Center(
        child: isRecording
            ? Container(
                height: radius,
                width: radius,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(2)),
              )
            : Container(
                height: radius * 3 - 15,
                width: radius * 3 - 15,
                decoration: BoxDecoration(
                    // color: isRecording ? Colors.redAccent : Colors.white,
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular((radius * 3 - 5) / 2)),
              ),
      ),
    );
  }
}

// class TimeSelectionScroll extends StatefulWidget {
//   const TimeSelectionScroll({super.key});

//   @override
//   State<TimeSelectionScroll> createState() => _TimeSelectionScrollState();
// }

// class _TimeSelectionScrollState extends State<TimeSelectionScroll> {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

