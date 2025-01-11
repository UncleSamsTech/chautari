import 'package:flutter/material.dart';
import 'package:tuktak/services/feed_manager.dart';
import 'package:tuktak/views/common_components/player_view.dart';

class PostViewer extends StatelessWidget {
  const PostViewer({super.key, required this.feedData, required this.type});
  final FeedData feedData;
  final PostType type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: PlayerView(feedData: feedData, type: type),
    );
  }
}
