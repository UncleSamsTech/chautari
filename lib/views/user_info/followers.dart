import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common_components/follow_btn.dart';

class FollowerDataModal {
  String userName;
  String? name;
  String id;
  String avatarUrl;
  bool isFollowing;

  FollowerDataModal(
      this.userName, this.name, this.id, this.avatarUrl, this.isFollowing);
}

class Followers extends StatelessWidget {
  const Followers({super.key, required this.followers});
  final List<FollowerDataModal> followers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: followers.isNotEmpty
            ? Column(children: [
                ...followers
                    .map((e) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: e.avatarUrl.isNotEmpty
                                ? NetworkImage(e.avatarUrl)
                                : null,
                          ),
                          title: Text(e.userName),
                          subtitle: e.name != null && e.name!.isNotEmpty
                              ? Text(e.name!)
                              : null,
                          trailing: FollowButton(
                            userId: e.id,
                            onPressed: () {},
                            isFollowed: e.isFollowing,
                          ),
                        ))
                    .toList(),
              ])
            : Center(
                child: Text("Nobody is following you!"),
              ),
      ),
    );
  }
}
