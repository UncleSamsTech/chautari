import 'package:flutter/material.dart';
import 'package:tuktak/services/feed_manager.dart';
import 'package:tuktak/views/common_components/player_view.dart';
import 'package:tuktak/views/user_info/component/post_viewer.dart';

class VideoPreviewModal {
  final String videoId;
  final String thumbnailUrl;
  final int viewsCount;
  final bool isMusic;

  VideoPreviewModal(
      this.videoId, this.thumbnailUrl, this.viewsCount, this.isMusic);
}

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key, required this.data});

  final VideoPreviewModal data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        late final FeedData feedData;
        late final PostType type;
        if (data.isMusic) {
          feedData = await FeedManager().getMusicById(data.videoId);
          type = PostType.Song;
        } else {
          feedData = await FeedManager().getVideoById(data.videoId);
          type = PostType.Reals;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostViewer(feedData: feedData, type: type)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.black26),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // Apply rounded corners
            child: Image.network(
              data.thumbnailUrl,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
