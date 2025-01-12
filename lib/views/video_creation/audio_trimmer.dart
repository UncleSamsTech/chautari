import 'dart:io';

import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class AudioTrimmer extends StatefulWidget {
  const AudioTrimmer(
      {super.key,
      required this.file,
      required this.onSaved,
      required this.onBacked});
  final File file;
  final void Function(String?) onSaved;
  final void Function() onBacked;

  @override
  State<AudioTrimmer> createState() => _AudioTrimmerState();
}

class _AudioTrimmerState extends State<AudioTrimmer> {
  bool isLoading = true;

  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;

  void loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await _trimmer.loadAudio(audioFile: widget.file);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveAudio() async {
    setState(() {
      isLoading = true;
    });
    String? outputPath;
    await _trimmer.saveTrimmedAudio(
      storageDir: StorageDir.temporaryDirectory,
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) {
        widget.onSaved!(outputPath);
        setState(() {
          isLoading = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: widget.onBacked,
        ),
        automaticallyImplyLeading: false,
        title: Text("Audio Trimmer"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 100,
                    viewerWidth: MediaQuery.of(context).size.width,
                    durationStyle: DurationStyle.FORMAT_MM_SS,
                    backgroundColor: Colors.white,
                    barColor: Theme.of(context).primaryColor,
                    durationTextStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    allowAudioSelection: true,
                    editorProperties: TrimEditorProperties(
                      circleSize: 10,
                      borderPaintColor: Colors.pink,
                      borderWidth: 4,
                      borderRadius: 5,
                      circlePaintColor: Colors.pink.shade800,
                    ),
                    areaProperties:
                        TrimAreaProperties.edgeBlur(blurEdges: true),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) {
                      if (mounted) {
                        setState(() => _isPlaying = value);
                      }
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  IconButton(
                    icon: _isPlaying
                        ? Icon(
                            Icons.pause,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).primaryColor,
                          ),
                    onPressed: () async {
                      bool playbackState = await _trimmer.audioPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() => _isPlaying = playbackState);
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                      label: "Save",
                      onPressed: () async {
                        await _saveAudio();

                        // Fetch the total duration of the audio
                        final Duration? totalDuration =
                            await _trimmer.audioPlayer?.getDuration();

                        if (totalDuration != null) {
                          // Calculate whether the audio has been clipped
                          final bool isClipped = (_endValue - _startValue) <
                              totalDuration.inMilliseconds;

                          // Pass the clipped status back to the previous screen
                          Navigator.of(context).pop(isClipped);
                        } else {
                          // Handle the case where the total duration is null
                          debugPrint("Failed to retrieve total audio duration");
                          Navigator.of(context).pop(false);
                        }
                      })
                ],
              ),
            ),
    );
  }
}

// class AudioTrimmerView extends StatefulWidget {
//   final File file;

//   const AudioTrimmerView(this.file, {Key? key}) : super(key: key);
//   @override
//   State<AudioTrimmerView> createState() => _AudioTrimmerViewState();
// }

// class _AudioTrimmerViewState extends State<AudioTrimmerView> {
//   final Trimmer _trimmer = Trimmer();

//   double _startValue = 0.0;
//   double _endValue = 0.0;

//   bool _isPlaying = false;
//   bool _progressVisibility = false;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();

//     _loadAudio();
//   }

//   void _loadAudio() async {
//     setState(() {
//       isLoading = true;
//     });
//     await _trimmer.loadAudio(audioFile: widget.file);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   _saveAudio() {
//     setState(() {
//       _progressVisibility = true;
//     });

//     _trimmer.saveTrimmedAudio(
//       startValue: _startValue,
//       endValue: _endValue,
//       audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
//       onSave: (outputPath) {
//         setState(() {
//           _progressVisibility = false;
//         });
//         debugPrint('OUTPUT PATH: $outputPath');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (Navigator.of(context).userGestureInProgress) {
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text("Audio Trimmer"),
//         ),
//         body: isLoading
//             ? const CircularProgressIndicator()
//             : Center(
//                 child: Container(
//                   padding: const EdgeInsets.only(bottom: 30.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       Visibility(
//                         visible: _progressVisibility,
//                         child: LinearProgressIndicator(
//                           backgroundColor:
//                               Theme.of(context).primaryColor.withOpacity(0.5),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed:
//                             _progressVisibility ? null : () => _saveAudio(),
//                         child: const Text("SAVE"),
//                       ),
//                       // AudioTrimmerViewer(trimmer: _trimmer),
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TrimViewer(
//                             trimmer: _trimmer,
//                             viewerHeight: 100,
//                             viewerWidth: MediaQuery.of(context).size.width,
//                             durationStyle: DurationStyle.FORMAT_MM_SS,
//                             backgroundColor: Theme.of(context).primaryColor,
//                             barColor: Colors.white,
//                             durationTextStyle: TextStyle(
//                                 color: Theme.of(context).primaryColor),
//                             allowAudioSelection: true,
//                             editorProperties: TrimEditorProperties(
//                               circleSize: 10,
//                               borderPaintColor: Colors.pink,
//                               borderWidth: 4,
//                               borderRadius: 5,
//                               circlePaintColor: Colors.pink.shade800,
//                             ),
//                             areaProperties:
//                                 TrimAreaProperties.edgeBlur(blurEdges: true),
//                             onChangeStart: (value) => _startValue = value,
//                             onChangeEnd: (value) => _endValue = value,
//                             onChangePlaybackState: (value) {
//                               if (mounted) {
//                                 setState(() => _isPlaying = value);
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         child: _isPlaying
//                             ? Icon(
//                                 Icons.pause,
//                                 size: 80.0,
//                                 color: Theme.of(context).primaryColor,
//                               )
//                             : Icon(
//                                 Icons.play_arrow,
//                                 size: 80.0,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                         onPressed: () async {
//                           bool playbackState =
//                               await _trimmer.audioPlaybackControl(
//                             startValue: _startValue,
//                             endValue: _endValue,
//                           );
//                           setState(() => _isPlaying = playbackState);
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
