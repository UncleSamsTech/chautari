// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart' as InternalPlayer;
// //Use alias because name of component of project Video collide with internal mediakit video
// import 'package:media_kit_video/media_kit_video.dart' as internal;
// import 'package:tuktak/services/feed_manager.dart';

// class Player extends StatefulWidget {
//   const Player(
//       {Key? key,
//       required this.url,
//       required this.player,
//       required this.type,
//       required this.thumbnailUrl})
//       : super(key: key);

//   final String url;
//   final InternalPlayer.Player player;
//   final PostType type;
//   final String thumbnailUrl;

//   @override
//   State<Player> createState() => PlayerState();
// }

// class PlayerState extends State<Player> {
//   // Create a [Player] to control playback.
//   late final InternalPlayer.Player player;
//   // Create a [VideoController] to handle video output from [Player].
//   late final controller = internal.VideoController(player);

//   bool isPlayed = true;
//   @override
//   void initState() {
//     super.initState();
//     player = widget.player;
//     // Play a [Media] or [Playlist].
//     player.open(InternalPlayer.Media(widget.url));
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   Future<void> togglePlayPause() async {
//     if (isPlayed) {
//       await player.pause();
//     } else {
//       await player.play();
//     }
//     setState(() {
//       isPlayed = !isPlayed;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.sizeOf(context).width;

//     return Stack(
//       children: [
//         // Video Layer
//         internal.Video(
//           controller: controller,
//           fit: BoxFit.cover,
//           pauseUponEnteringBackgroundMode: true,
//         ),
//         if (widget.type == PostType.Song)
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               height: MediaQuery.sizeOf(context).width * 0.5,
//               width: MediaQuery.sizeOf(context).width * 0.5,
//               child: Image.network(
//                 widget.thumbnailUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//         // Custom Gradient Overlay
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: !isPlayed
//               ? Center(
//                   child: Icon(
//                     Icons.play_arrow_outlined,
//                     size: screenWidth * 0.2,
//                     color: Colors.white,
//                   ),
//                 )
//               : null,
//         ),
//         GestureDetector(
//           onTap: () async {
//             await togglePlayPause();
//           },
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as InternalPlayer;
import 'package:video_player/video_player.dart'; // For handling video playback
import 'package:tuktak/services/feed_manager.dart';

class Player extends StatefulWidget {
  const Player({
    Key? key,
    required this.url,
    required this.type,
    required this.thumbnailUrl,
  }) : super(key: key);

  final String url;
  final PostType type;
  final String thumbnailUrl;

  @override
  State<Player> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  InternalPlayer.Player? audioPlayer;
  VideoPlayerController? videoPlayerController;
  bool isPlayed = true;

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.type == PostType.Song) {
  //     // Initialize media_kit for songs
  //     audioPlayer = InternalPlayer.Player();
  //     audioPlayer?.open(InternalPlayer.Media(widget.url));
  //   } else {
  //     // Initialize video_player for videos
  //     videoPlayerController = VideoPlayerController.network(widget.url)
  //       ..initialize().then((_) {
  //         setState(() {}); // Refresh to show the first frame
  //       });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (widget.type == PostType.Song) {
      // Initialize media_kit for songs
      audioPlayer = InternalPlayer.Player();
      audioPlayer?.open(InternalPlayer.Media(widget.url));
      audioPlayer?.play(); // Start playback
    } else {
      // Initialize video_player for videos
      videoPlayerController = VideoPlayerController.network(
        widget.url,
      )..initialize().then((_) {
          setState(() {}); // Refresh to show the first frame
          videoPlayerController?.play(); // Start playback
        });

      // Add a listener to loop the video
      videoPlayerController?.addListener(() {
        if (videoPlayerController!.value.position >=
            videoPlayerController!.value.duration) {
          videoPlayerController?.seekTo(Duration.zero); // Reset to the start
          videoPlayerController?.play(); // Replay the video
        }
      });
    }
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (widget.type == PostType.Song) {
      if (isPlayed) {
        await audioPlayer?.pause();
      } else {
        await audioPlayer?.play();
      }
    } else {
      if (isPlayed) {
        await videoPlayerController?.pause();
      } else {
        await videoPlayerController?.play();
      }
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
        if (widget.type == PostType.Reals && videoPlayerController != null) ...[
          // Video Layer using video_player
          VideoPlayer(videoPlayerController!),
        ] else if (widget.type == PostType.Song) ...[
          // Thumbnail for audio
          Align(
            alignment: Alignment.center,
            child: Container(
              height: screenWidth * 0.5,
              width: screenWidth * 0.5,
              child: Image.network(
                widget.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
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
        ),
      ],
    );
  }
}
