import 'package:flutter/material.dart';
import 'package:tuktak/services/shared_preference_service.dart';
import 'package:tuktak/views/common_components/follow_btn.dart';
import 'package:tuktak/views/user_info/user.dart';

class CreaterInfo extends StatelessWidget {
  const CreaterInfo(
      {super.key,
      required this.userName,
      required this.description,
      required this.authorId,
      required this.isFollowing});

  final String userName;
  final String description;
  final String authorId;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    // return Padding(
    //   padding: const EdgeInsets.only(left: 12, bottom: 24),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         // crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           GestureDetector(
    //             child: CircleAvatar(),
    //             onTap: () {},
    //           ),
    //           SizedBox(
    //             width: 12,
    //           ),
    //           Column(
    //             // mainAxisAlignment: MainAxisAlignment.end,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 children: [
    //                   Text(
    //                     userName,
    //                     style: TextStyle(color: textColor),
    //                   ),
    //                   SizedBox(
    //                     width: 24,
    //                   ),
    //                   FollowButton(
    //                     onPressed: () {},
    //                     isFollowed: isFollowing,
    //                     userId: authorId,
    //                   )
    //                 ],
    //               ),
    //               Text(
    //                 description,
    //                 style: TextStyle(color: textColor),
    //               )
    //             ],
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    print("UserId is :$authorId");
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.sizeOf(context).width * 0.2, bottom: 24),
      child: ListTile(
        title: Text(
          userName,
          style: TextStyle(color: textColor),
        ),
        subtitle: description.isNotEmpty
            ? Text(description, style: TextStyle(color: textColor))
            : null,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfile(
                      isOwnProfile: false,
                      userId: authorId,
                      userName: userName,
                    )));
          },
          child: CircleAvatar(),
        ),
        trailing: SharedPreferenceService().isLogin
            ? FollowButton(
                userId: authorId,
                onPressed: () {},
                isFollowed: isFollowing,
              )
            : null,
      ),
    );
  }
}
