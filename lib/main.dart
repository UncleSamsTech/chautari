import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tuktak/constants/theme.dart';
import 'package:tuktak/services/shared_preference_service.dart';
import 'package:tuktak/services/user_manager.dart';
import 'package:tuktak/test.dart';
import 'package:tuktak/wrapper.dart';

void main(List<String> args) async {
//Initialize the media kit for video and audio
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  await SharedPreferenceService().load();
  await UserManager().load();

  // test_userDataSerialization();
  // await test_feed_manager();
  // await test_follower_and_following();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const Wrapper());
  }
}
