import 'package:flutter/material.dart';




class CommentTileModel {
  String avatarUrl;
  String userName;
  String commentBody;
  bool isLiked;

  String time;

  CommentTileModel(
      {required this.avatarUrl,
      required this.userName,
      required this.commentBody,
      required this.isLiked,
      required this.time});
}

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final CommentTileModel comment;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Row(
        children: [
          Text(comment.userName),
          SizedBox(
            width: 12,
          ),
          Text(comment.time)
        ],
      ),
      subtitle: Text(comment.commentBody),
      trailing:
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
    );
  }
}
