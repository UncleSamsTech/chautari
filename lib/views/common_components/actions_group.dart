import 'package:flutter/material.dart';
import 'package:tuktak/services/feed_manager.dart';
import 'package:tuktak/services/interaction_manager.dart';
import 'package:tuktak/services/shared_preference_service.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/comment_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActionsGroup extends StatefulWidget {
  const ActionsGroup(
      {super.key,
      required this.likeCount,
      required this.commentCount,
      required this.feedId,
      required this.type,
      this.isLiked = false,
      this.isSaved = false});
  final int likeCount;
  final int commentCount;
  final String feedId;
  final bool isLiked;
  final bool isSaved;
  final PostType type;
  @override
  State<ActionsGroup> createState() => _ActionsGroupState();
}

class _ActionsGroupState extends State<ActionsGroup> {
  final iconSize = 25.0;

  final iconColor = Colors.white;
  final textColor = Colors.white;

  late bool isLiked;
  late bool isBookMarked;
  late int likeCount;
  late int commentCount;

  final feedManager = FeedManager();

  @override
  void initState() {
    isLiked = widget.isLiked;
    isBookMarked = widget.isSaved;
    likeCount = widget.likeCount;
    commentCount = widget.commentCount;
    super.initState();
  }

  void showCommentSection(BuildContext context, List<Comment> comments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => CommentSection(
        comments: comments,
        feedId: widget.feedId,
        type: widget.type,
      ),
    );
  }

  Future<void> toggleLike() async {
    if (isLiked) {
      setState(() {
        likeCount--;
        isLiked = !isLiked;
      });
      await feedManager.unlikePost(widget.type);
    } else {
      setState(() {
        likeCount++;
        isLiked = !isLiked;
      });
      await feedManager.likePost(widget.type);
    }
  }

  Future<void> toggleBookMark() async {
    if (isBookMarked) {
      setState(() {
        isBookMarked = false;
      });
      // await InteractionManager.unsavePost(widget.feedId);
      await feedManager.unsavePost(widget.type);
    } else {
      setState(() {
        isBookMarked = true;
      });
      // await InteractionManager.savePost(widget.feedId);
      await feedManager.savePost(widget.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              onPressed: () async {
                await toggleLike();
              },
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: iconSize,
                color: isLiked ? Theme.of(context).primaryColor : iconColor,
              )),
          Text(
            '${formatNumber(likeCount)}',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
          SizedBox(
            height: iconSize,
          ),
          IconButton(
              onPressed: () async {
                // final allComments =
                //     await InteractionManager.getAllCommentOfPost(widget.feedId);
                final allComments =
                    await feedManager.getAllCommentOfPost(widget.type);

                showCommentSection(context, allComments);
              },
              icon: Icon(
                Icons.comment_outlined,
                size: iconSize,
                color: iconColor,
              )),
          Text(
            '${formatNumber(commentCount)}',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
          SizedBox(
            height: iconSize,
          ),
          IconButton(
              onPressed: () async {
                await toggleBookMark();
              },
              icon: Icon(
                isBookMarked ? Icons.bookmark : Icons.bookmark_outline,
                size: iconSize,
                color: iconColor,
              )),
          SizedBox(
            height: iconSize,
          ),
          IconButton(
              onPressed: () async {
                // InteractionManager.sharePost(widget.feedId);
                await feedManager.sharePost(widget.type);
              },
              icon: Icon(
                Icons.share_outlined,
                size: iconSize,
                color: iconColor,
              )),
          SizedBox(
            height: iconSize,
          ),
          CircleAvatar(
            child: Icon(Icons.music_note_outlined),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection(
      {Key? key,
      required this.comments,
      required this.feedId,
      required this.type})
      : super(key: key);
  final List<Comment> comments;
  final String feedId;
  final PostType type;
  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _commentFocusNode = FocusNode();
  late List<CommentTileModel> comments;
  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    comments = widget.comments.map((element) {
      return CommentTileModel(
          avatarUrl: element.user.avatar,
          userName: element.user.username,
          commentBody: element.body,
          isLiked: element.hasLiked,
          time: timeago.format(DateTime.now()
              .subtract(DateTime.now().difference(element.createdAt))));
    }).toList();
    _commentFocusNode.addListener(() {
      if (_commentFocusNode.hasFocus) {
        // Scroll to bottom when the comment box is focused
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      minChildSize: 0.80,
      maxChildSize: .95,
      expand: false,
      builder: (context, scrollController) {
        return Scaffold(
          body: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text(
                  "${formatNumber(comments.length)} comments",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: comments.isEmpty
                      ? Center(
                          child: Text("There is no comment yet!"),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CommentTile(comment: comments[index]),
                            );
                          },
                          itemCount: comments.length,
                        ),
                ),
                SharedPreferenceService().isLogin
                    ? Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Form(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: commentTextController,
                                  focusNode: _commentFocusNode,
                                  decoration: InputDecoration(
                                    hintText: "Add comment",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  if (commentTextController.text.isNotEmpty) {
                                    // await InteractionManager.postTheComment(
                                    //     widget.feedId, commentTextController.text);
                                    await FeedManager().postTheComment(
                                        widget.type,
                                        commentTextController.text);
                                    setState(() {
                                      comments.add(CommentTileModel(
                                          avatarUrl: "",
                                          userName: "userdon",
                                          commentBody:
                                              commentTextController.text,
                                          isLiked: false,
                                          time: "Just now"));
                                    });
                                  }
                                },
                                icon: const Icon(Icons.send_sharp),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 4),
                        child: Text(
                          "You haven't logged in. Please login first",
                          textAlign: TextAlign.center,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
