import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuktak/views/common_components/follow_btn.dart';

class FollowingDataModal {
  String userName;
  String? name;
  String id;
  String avatarUrl;

  FollowingDataModal(this.userName, this.name, this.id, this.avatarUrl);
}

class Following extends StatelessWidget {
  const Following({super.key, required this.followings});
  final List<FollowingDataModal> followings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Following"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: followings.isNotEmpty
            ? Column(
                children: followings
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
                        ))
                    .toList(),
              )
            : Center(
                child: Text("You are not following anyone!"),
              ),
      ),
    );
  }
}
