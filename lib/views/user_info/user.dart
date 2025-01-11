import 'package:flutter/material.dart';
import 'package:tuktak/services/interaction_manager.dart';
import 'package:tuktak/services/user_manager.dart';
import 'package:tuktak/views/setting/setting.dart';

import 'component/user_card.dart';
import 'component/video_preview.dart';

// class _UserProfileMoadal {
//   String name;
//   String userName;
//   int followingsCount;
//   int followersCount;

// }

class UserProfile extends StatefulWidget {
  const UserProfile(
      {super.key, required this.isOwnProfile, this.userId, this.userName});
  final bool isOwnProfile;
  final String? userId;
  final String? userName;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = true;
  List<VideoPreviewModal> postData = [];
  List<VideoPreviewModal> savedData = [];

  late UserCardModel userInfo;

  Future<void> loadData() async {
    if (widget.isOwnProfile) {
      UserManager().load().then((_) {
        setState(() {
          userInfo = UserCardModel(
              UserManager().user!.id,
              UserManager().user!.username,
              UserManager().user!.avatar,
              UserManager().user!.metrics.followersCount,
              UserManager().user!.metrics.followingCount,
              UserManager().user!.metrics.likesCount,
              UserManager().user!.bio);
        });
        isLoading = false;
      });

      final musicData =
          await InteractionManager.getAllMusicByUserId(UserManager().user!.id);
      final videoData =
          await InteractionManager.getAllVideoByUserId(UserManager().user!.id);

      postData = [
        ...videoData
            .map((e) => VideoPreviewModal(e.id, e.thumbnail, 212, false)),
        ...musicData.map((e) => VideoPreviewModal(e.id, e.thumbnail, 212, true))
      ];

      final savedMusicData = await InteractionManager.getAllSavedMusicPost();
      final savedVideoData = await InteractionManager.getAllSavedVideoPost();

      savedData = [
        ...savedMusicData.map((e) =>
            VideoPreviewModal(e.music.id, e.music.thumbnail, 1231, true)),
        ...savedVideoData.map((e) =>
            VideoPreviewModal(e.music.id, e.music.thumbnail, 1231, false))
      ];

      setState(() {
        isLoading = false;
      });
    } else {
      final otherUserData =
          await UserManager().getOtherUserProfile(widget.userName!);

      setState(() {
        userInfo = UserCardModel(
            otherUserData.id,
            otherUserData.username,
            otherUserData.avatar,
            otherUserData.metrics.followersCount,
            otherUserData.metrics.followingCount,
            otherUserData.metrics.likesCount,
            otherUserData.bio);
      });
      final musicData =
          await InteractionManager.getAllMusicByUserId(widget.userId!);
      final videoData =
          await InteractionManager.getAllVideoByUserId(widget.userId!);

      postData = [
        ...videoData
            .map((e) => VideoPreviewModal(e.id, e.thumbnail, 212, false)),
        ...musicData.map((e) => VideoPreviewModal(e.id, e.thumbnail, 212, true))
      ];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const componentGap = 24.0;
    final iconSize = screenWidth * 0.08;

    final moreMenu = IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Setting()));
        },
        icon: const Icon(Icons.settings_outlined));

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(UserManager().user!.name),
        centerTitle: true,
        actions: [if (widget.isOwnProfile) moreMenu],
      ),
      body: SafeArea(
          child:
              // isLoading
              //     ? Center(
              //         child: CircularProgressIndicator.adaptive(),
              //       )
              //     :
              Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserCard(
              data: userInfo,
              isOwnProfile: widget.isOwnProfile,
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Icon(
                        Icons.menu,
                        size: 30,
                      ),
                      if (widget.isOwnProfile)
                        Icon(
                          Icons.bookmark_outline,
                          size: 30,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                  postData.isNotEmpty
                                      ? GridView.builder(
                                          // physics: const NeverScrollableScrollPhysics(),
                                          itemCount: postData.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12),
                                          itemBuilder: (context, index) {
                                            return VideoPreview(
                                              data: postData[index],
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text("There is no any post !"),
                                        ),
                                  if (widget.isOwnProfile)
                                    savedData.isNotEmpty
                                        ? GridView.builder(
                                            itemCount: savedData.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 12,
                                                    mainAxisSpacing: 12),
                                            itemBuilder: (context, index) {
                                              return VideoPreview(
                                                  data: savedData[index]);
                                            },
                                          )
                                        : Center(
                                            child: Text(
                                                "There is no saved posts!"),
                                          )
                                ]))
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
