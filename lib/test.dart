//For testing the internal api backend and function

import 'dart:convert';
import 'package:tuktak/services/feed_manager.dart';

import 'models/server_response.dart';
import 'services/interaction_manager.dart';

void test_userDataSerialization() {
  const jsonData =
      '''{"message": "Welcome home, vdbdfgbsg", "status": 201, "statusText": "Created"}''';

//  "data": {
//         "metrics": {
//             "followersCount": 0,
//             "followingCount": 0,
//             "likesCount": 0,
//             "bookmarksCount": 0
//         },
//         "_id": "676e1b47a8e71b14c3b21e65",
//         "email": "user@exa1mple.coqm",
//         "avatar": "",
//         "name": "",
//         "bio": "",
//         "username": "uqse1r123",
//         "visibility": "PUBLIC",
//         "verified": false,
//         "createdAt": "2024-12-27T03:13:11.684Z",
//         "updatedAt": "2024-12-27T03:13:11.684Z",
//         "__v": 0
//     }

  try {
    final json = jsonDecode(jsonData);
    final serverResponse = ServerResponse.fromJson(json);
    print(serverResponse.toString());
  } catch (e) {
    print("Error: ${e.toString()}");
  }
}

Future<void> test_feed_manager() async {
  final feedMnager = FeedManager();
  // try {
  //   final currentMusicFeed = await feedMnager.getCurrentMusicData();
  //   print("Data: ${currentMusicFeed.toString()}");
  // } catch (e) {
  //   print("Exception : ${e.toString()}");
  // }
}

Future<void> test_follower_and_following() async {
  // final responseFollowers = await InteractionManager.getAllFollowers();
  // final responseFollowing = await InteractionManager.getAllFollowings();

  // print("Followers format: ${responseFollowers.toString()}");
  // print("Following : ${responseFollowing.toString()}");
}
