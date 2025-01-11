import 'package:flutter/material.dart';
import 'package:tuktak/services/interaction_manager.dart';
import 'package:tuktak/services/shared_preference_service.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(
      {super.key,
      this.isFollowed = false,
      required this.onPressed,
      required this.userId});
  final bool isFollowed;
  final void Function() onPressed;
  final String userId;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool isFollowed;

  @override
  void initState() {
    isFollowed = widget.isFollowed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const foregroundColor = Colors.white;

    // return ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //         foregroundColor: isFollowed ? Color(0xff475569) : foregroundColor,
    //         backgroundColor:
    //             isFollowed ? Color(0xffCBD5E1) : Theme.of(context).primaryColor,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    //     onPressed: () {
    //       setState(() {
    //         isFollowed = !isFollowed;
    //       });
    //       widget.onPressed();
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //           horizontal: paddingHorizontal, vertical: paddingVertical),
    //       child: Center(
    //         child: Text(
    //           isFollowed ? "Following" : "Follow",
    //           style: TextStyle(color: isFollowed ? Colors.white : Colors.white),
    //         ),
    //       ),
    //     ));
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor:
              isFollowed ? const Color(0xff475569) : foregroundColor,
          backgroundColor: isFollowed
              ? const Color(0xffCBD5E1)
              : Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onPressed: () async {
        if (isFollowed) {
          await InteractionManager.unfollowUser(widget.userId);
        } else {
          await InteractionManager.followUser(widget.userId);
        }
        setState(() {
          isFollowed = !isFollowed;
        });
        widget.onPressed();
      },
      child: Text(isFollowed ? "Following" : "Follow"),
    );
  }
}
