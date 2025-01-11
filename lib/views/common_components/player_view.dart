import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tuktak/services/feed_manager.dart';
import 'package:tuktak/views/common_components/actions_group.dart';
import 'package:tuktak/views/common_components/creater_info.dart';
import 'package:tuktak/views/common_components/player.dart';

class PlayerView extends StatelessWidget {
  const PlayerView(
      {super.key, required this.feedData, this.id, required this.type});
  final FeedData feedData;
  final String? id;
  final PostType type;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Player(
        url: feedData.musicUrl,
        // player: InternalPlayer.Player(),
        type: type,
        thumbnailUrl: feedData.thumbnail,
      ),
      // VideoApp(),
      Align(
        alignment: Alignment.bottomRight,
        child: ActionsGroup(
          likeCount: feedData.metrics.likesCount,
          commentCount: feedData.metrics.commentsCount,
          feedId: feedData.id,
          isLiked: feedData.extras.liked,
          isSaved: feedData.extras.bookmarked,
          type: type,
        ),
      ),
      Align(
          alignment: Alignment.bottomLeft,
          child: CreaterInfo(
            userName: feedData.author.username,
            description: feedData.description,
            authorId: feedData.author.id,
            isFollowing: feedData.extras.isFollowing,
          ))
    ]);
  }
}
