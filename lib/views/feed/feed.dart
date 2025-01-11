import 'package:flutter/material.dart';
import 'package:tuktak/views/feed/audio_feed.dart';
import 'package:tuktak/views/feed/video_feed.dart';
import 'package:tuktak/views/notification/notification.dart';
import 'package:tuktak/views/search/search.dart';

class Feed extends StatelessWidget {
  Feed({super.key});

  final pageViewController = PageController();
  int initialPage = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.black,
        ),
        PageView(
          controller: pageViewController,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: [
            //This is the video feed
            // PageView.builder(
            //   itemBuilder: (context, index) {
            //     return const VideoView();
            //   },
            //   itemCount: 5,
            //   scrollDirection: Axis.vertical,
            // ),
            // PageView.builder(
            //   itemBuilder: (context, index) {
            //     return AudioView();
            //   },
            //   itemCount: 5,
            //   scrollDirection: Axis.vertical,
            // ),
            VideoFeed(),
            AudioFeed()
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 24, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Search()));
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: EdgeInsets.only(top: 38),
              child: FeedToggler(
                onChanged: (index) {
                  pageViewController.animateToPage(index,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut);
                },
              )),
        )
      ]),
    );
  }
}

class FeedToggler extends StatefulWidget {
  const FeedToggler({super.key, this.onChanged});
  final void Function(int)? onChanged;
  @override
  State<FeedToggler> createState() => _FeedTogglerState();
}

class _FeedTogglerState extends State<FeedToggler> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //This contoleer is used to switch from songs feed to reels feed
    const toggleTextStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              currentIndex = 0;
            });
            if (widget.onChanged != null) widget.onChanged!(0);
          },
          child: Opacity(
            opacity: currentIndex != 0 ? 0.6 : 1,
            child: Text(
              "Reels",
              style: toggleTextStyle,
            ),
          ),
        ),
        SizedBox(
          width: 24,
        ),
        InkWell(
          onTap: () {
            setState(() {
              currentIndex = 1;
            });
            if (widget.onChanged != null) widget.onChanged!(1);
          },
          child: Opacity(
            opacity: currentIndex != 1 ? 0.6 : 1,
            child: Text(
              "Songs",
              style: toggleTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
