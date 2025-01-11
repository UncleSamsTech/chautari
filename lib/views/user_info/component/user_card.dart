import 'package:flutter/material.dart';
import 'package:tuktak/services/interaction_manager.dart';
import 'package:tuktak/services/user_manager.dart';
import 'package:tuktak/views/common_components/secondary_buttton.dart';
import 'package:tuktak/views/setting/edit_profile.dart';
import 'package:tuktak/views/user_info/followers.dart';
import 'package:tuktak/views/user_info/following.dart';

class UserCardModel {
  String userId;
  String userName;
  String avatar;
  int followingCount;
  int followerCount;
  int likesCount;
  String bio;

  UserCardModel(this.userId, this.userName, this.avatar, this.followerCount,
      this.followingCount, this.likesCount, this.bio);
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.data, this.isOwnProfile = true});
  final bool isOwnProfile;
  final UserCardModel data;
  final videoCount = 23;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: data.avatar.isEmpty
              ? Icon(Icons.person_2_outlined)
              : Image.network(data.avatar),
        ),
        Text(data.userName),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                if (isOwnProfile) {
                  final following = await InteractionManager.getAllFollowings();

                  final followingModal = following
                      .map((e) => FollowingDataModal(
                            e.accountId.username,
                            e.accountId.name,
                            e.accountId.id,
                            e.accountId.avatar,
                          ))
                      .toList();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Following(
                            followings: followingModal,
                          )));
                }
              },
              child: Column(
                children: [Text("${data.followingCount}"), Text("Following")],
              ),
            ),
            GestureDetector(
              onTap: () async {
                //TODO: FOr now we only show folowers of own profile
                if (isOwnProfile) {
                  final followers = await InteractionManager.getAllFollowers();

                  final followersModal = followers
                      .map((e) => FollowerDataModal(
                          e.accountId.username,
                          e.accountId.name,
                          e.accountId.id,
                          e.accountId.avatar,
                          true))
                      .toList();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Followers(
                            followers: followersModal,
                          )));
                }
              },
              child: Column(
                children: [Text("${data.followerCount}"), Text("Followers")],
              ),
            ),
            Column(
              children: [Text("${data.likesCount}"), Text("Likes")],
            )
          ],
        ),
        SizedBox(
          height: 12,
        ),
        if (isOwnProfile)
          SecondaryButtton(
              label: "Edit Profile",
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfile()));
              }),
        if (data.bio.isNotEmpty)
          // TextButton(onPressed: () {}, child: Text("CLick to add bio"))
          Text(data.bio)
      ],
    );
  }
}
