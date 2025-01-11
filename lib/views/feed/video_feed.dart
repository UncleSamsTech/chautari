import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuktak/services/feed_manager.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/player.dart';
import 'package:tuktak/views/common_components/player_view.dart';

class VideoFeed extends StatefulWidget {
  const VideoFeed({super.key});

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  final feedManager = FeedManager();
  final PageController _pageController = PageController();
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics:
          _isError ? BouncingScrollPhysics() : AlwaysScrollableScrollPhysics(),
      onPageChanged: (value) {
        if (_isError) {
          setState(() {
            _isError = true;
          });
          _pageController.previousPage(
              duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
        }
      },
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: feedManager.getCurrentVideoData(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              _isError = true;
              return Center(
                  child: Text(
                "You have covered up all the feed!",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ));
            }

            _isError = false;

            return PlayerView(
              feedData: snapshot.data!,
              type: PostType.Reals,
            );
          },
        );
      },
      scrollDirection: Axis.vertical,
    );
  }
}
