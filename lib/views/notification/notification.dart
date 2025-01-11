import 'package:flutter/material.dart';
import 'package:tuktak/views/common_components/follow_btn.dart';

class NotificationPage extends StatelessWidget {
  // const NotificationPage(
  //     {super.key, required this.todays, required this.thisWeeks});
  NotificationPage({super.key});

  final List<NotificationModal> todays = [
    NotificationModal(
      type: NotificationType.FOLLOWING,
      user: [
        UserModal(userName: "Alice"),
        UserModal(userName: "Bob"),
      ],
      time: "5m ago",
      isFollowing: true,
    ),
    NotificationModal(
      type: NotificationType.LIKED,
      user: [
        UserModal(userName: "Charlie"),
        UserModal(userName: "Dave"),
        UserModal(userName: "Eve"),
      ],
      time: "10m ago",
    ),
    NotificationModal(
      type: NotificationType.COMMENTED,
      user: [
        UserModal(userName: "Grace"),
      ],
      time: "15m ago",
    ),
  ];

  final List<NotificationModal> thisWeeks = [
    NotificationModal(
      type: NotificationType.LIKED,
      user: [
        UserModal(userName: "Henry"),
      ],
      time: "2 days ago",
    ),
    NotificationModal(
      type: NotificationType.FOLLOWING,
      user: [
        UserModal(userName: "Ivy"),
        UserModal(userName: "Jack"),
      ],
      time: "3 days ago",
      isFollowing: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios));
    return Scaffold(
      appBar: AppBar(
        leading: backButton,
        title: const Text("Notification"),
      ),
      body: todays.isEmpty && thisWeeks.isEmpty
          ? const Center(
              child: Text("No Notification yet !"),
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            child: Column(
                children: [
                  if (todays.isNotEmpty) buildTodaysNotification(),
                  if (todays.isNotEmpty) buildThisWeekNotification()
                ],
              ),
          ),
    );
  }

  String getAssociatedUser(List<UserModal> users) {
    if (users.length == 1) {
      return "${users[0].userName}";
    } else if (users.length == 2) {
      return "${users[0].userName},${users[1].userName}";
    } else {
      return "${users[0].userName},${users[1].userName} and ${users.length - 2} others";
    }
  }

  List<Widget> buildNotificationTiles(List<NotificationModal> notifications) {
    return notifications.map((e) {
      //TODO: Add the overlapping effect

      final stackedUser = Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: e.user.asMap().entries.map((entry) {
          int index = entry.key;
          // String imageUrl = entry.value;
          return Positioned(
            // left: index + 1, // Overlap effect
            child: CircleAvatar(
              radius: 20,
              // backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[200],
            ),
          );
        }).toList(),
      );
      final associstedUser = getAssociatedUser(e.user);

      if (e.type == NotificationType.FOLLOWING) {
        return ListTile(
          leading: stackedUser,
          // leading: CircleAvatar(),
          title: Text(associstedUser),
          subtitle: const Text("Started following you"),
          trailing: FollowButton(
            userId: "",
            onPressed: () {},
            isFollowed: e.isFollowing ?? false,
          ),
        );
      } else if (e.type == NotificationType.LIKED) {
        return ListTile(
          leading: stackedUser,
          // leading: CircleAvatar(),

          title: Text(associstedUser),
          subtitle: const Text("Liked your post"),
        );
      } else {
        return ListTile(
          leading: stackedUser,
          // leading: CircleAvatar(),

          title: Text(associstedUser),
          subtitle: const Text("Commented on your post"),
        );
      }
    }).toList();
  }

  Widget buildTodaysNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Todays"),
        const SizedBox(
          height: 12,
        ),
        ...buildNotificationTiles(todays)
      ],
    );
  }

  Widget buildThisWeekNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("This Weeks"),
        const SizedBox(
          height: 12,
        ),
        ...buildNotificationTiles(thisWeeks)
      ],
    );
  }
}

enum NotificationType { FOLLOWING, LIKED, COMMENTED }

enum PostType { REEL, SONG }

class UserModal {
  String userName;
  String? userProfile;
  UserModal({required this.userName, this.userProfile});
}

class PostModal {
  PostType type;
  String postPreviewUrl;
  double viewCount;

  PostModal(
      {required this.type,
      required this.postPreviewUrl,
      required this.viewCount});
}

class NotificationModal {
  NotificationType type;
  List<UserModal> user;
  PostModal? post;
  bool? isFollowing;
  String time;

  NotificationModal(
      {required this.type,
      required this.user,
      required this.time,
      this.post,
      this.isFollowing});
}
