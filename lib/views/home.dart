import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuktak/models/custom_navigation_bar_item.dart';
import 'package:tuktak/services/file_uploader.dart';
import 'package:tuktak/utils.dart' as utils;
import 'package:tuktak/views/auth/register/ask_account_creation.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/views/feed/feed.dart';
import 'package:tuktak/views/user_info/user.dart';
import 'package:tuktak/views/video_creation/video_creation.dart';

import '../models/audio_file_model.dart';
import '../services/shared_preference_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final PageController pageController = PageController();

  void showCreationFormatSelector(BuildContext context) {
    showBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: Scaffold(
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      "Choose Format",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VideoCreation()));
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.video_file_outlined),
                                    Text("Reels"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                showAudioUploadButtomSheet(context);
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.audio_file_outlined),
                                    Text("Song"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showAudioUploadButtomSheet(BuildContext context) {
    // showBottomSheet(
    //     context: context,
    //     showDragHandle: true,
    //     builder: (context) {
    //       final viewHeight = MediaQuery.sizeOf(context).height * 0.5;
    //       final viewWidth = MediaQuery.sizeOf(context).width;

    //       return SizedBox(
    //           height: viewHeight,
    //           width: viewWidth,
    //           child: AudioUploadButtomSheet());
    //     });
  }

  @override
  Widget build(BuildContext context) {
    final isUserLogin = utils.isUserLoggedIn();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Feed(),
              isUserLogin ? VideoCreation() : AskAccountCreation(),
              isUserLogin
                  ? UserProfile(
                      isOwnProfile: true,
                    )
                  : AskAccountCreation()
            ],
          )),
          CustomNavigationBar(
            onChange: (index) async {
              if (index == 1) {
                if (SharedPreferenceService().isLogin) {
                  // showCreationFormatSelector(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VideoCreation()));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AskAccountCreation(),
                      fullscreenDialog: true));
                }
              } else {
                await pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            items: [
              CustomNavigationBarItem("assets/icons/home.svg"),
              CustomNavigationBarItem("assets/icons/plus.svg"),
              CustomNavigationBarItem("assets/icons/user-round.svg"),
            ],
          ),
        ],
      )),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {super.key,
      required this.items,
      required this.onChange,
      this.selectedColor = Colors.redAccent,
      this.iconSize = 25});
  final List<CustomNavigationBarItem> items;
  final Color selectedColor;
  final double iconSize;
  final void Function(int) onChange;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = widget.selectedColor;
    final iconSize = widget.iconSize;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 8, // Blur radius
            offset: Offset(0, -3), // Offset in x and y direction
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...widget.items
              .asMap()
              .entries
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = e.key != 1 ? e.key : selectedIndex;
                        widget.onChange(e.key);
                      });
                    },
                    child: SizedBox(
                        height: iconSize,
                        width: iconSize,
                        child: SvgPicture.asset(e.value.svgIconPath,
                            colorFilter: selectedIndex == e.key
                                ? ColorFilter.mode(
                                    selectedColor, BlendMode.srcIn)
                                : null)),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

