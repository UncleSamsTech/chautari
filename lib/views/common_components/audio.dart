import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
//Use alias because name of component of project Video collide with internal mediakit video
import 'package:media_kit_video/media_kit_video.dart' as internal;

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);
  @override
  State<Audio> createState() => AudioState();
}

class AudioState extends State<Audio> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = internal.VideoController(player);

  bool isPlayed = true;
  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media('https://samplelib.com/lib/preview/mp3/sample-3s.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (isPlayed) {
      await player.pause();
    } else {
      await player.play();
    }
    setState(() {
      isPlayed = !isPlayed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        // Video Layer
        internal.Video(
          controller: controller,
          fit: BoxFit.cover,
        ),

        // Custom Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: !isPlayed
              ? Center(
                  child: Icon(
                    Icons.play_arrow_outlined,
                    size: screenWidth * 0.2,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        GestureDetector(
          onTap: () async {
            await togglePlayPause();
          },
        )
      ],
    );
  }
}
