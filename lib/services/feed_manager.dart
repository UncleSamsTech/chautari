import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/services/interaction_manager.dart';

class FeedItem {
  final String id;
  final String title;
  final String thumbnail;

  FeedItem({
    required this.id,
    required this.title,
    required this.thumbnail,
  });

  // Factory constructor to create an instance from JSON
  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['_id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'thumbnail': thumbnail,
    };
  }

  static List<FeedItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FeedItem.fromJson(json)).toList();
  }
}

class Metrics {
  int likesCount;
  int commentsCount;
  final int bookmarksCount;
  final int shareCount;
  final int viewsCount;

  Metrics({
    required this.likesCount,
    required this.commentsCount,
    required this.bookmarksCount,
    required this.shareCount,
    required this.viewsCount,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      bookmarksCount: json['bookmarksCount'],
      shareCount: json['shareCount'],
      viewsCount: json['viewsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'bookmarksCount': bookmarksCount,
      'shareCount': shareCount,
      'viewsCount': viewsCount,
    };
  }
}

class Author {
  final String id;
  final String email;
  final String avatar;
  final String name;
  final String username;
  final String visibility;
  final bool verified;

  Author({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.username,
    required this.visibility,
    required this.verified,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      username: json['username'],
      visibility: json['visibility'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'avatar': avatar,
      'name': name,
      'username': username,
      'visibility': visibility,
      'verified': verified,
    };
  }
}

class Extras {
  bool liked;
  bool bookmarked;
  final bool isFollowing;

  Extras({
    required this.liked,
    required this.bookmarked,
    required this.isFollowing,
  });

  factory Extras.fromJson(Map<String, dynamic> json) {
    return Extras(
      liked: json['liked'],
      bookmarked: json['bookmarked'],
      isFollowing: json['isFollowing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liked': liked,
      'bookmarked': bookmarked,
      'isFollowing': isFollowing,
    };
  }
}

class FeedData {
  final String id;
  final String title;
  final String description;
  final Author author;
  final String thumbnail;
  final String musicUrl;
  final String visibility;
  final String createdAt;
  final String updatedAt;
  final int version;
  final Metrics metrics;
  final Extras extras;

  FeedData({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.thumbnail,
    required this.musicUrl,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.metrics,
    required this.extras,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      author: Author.fromJson(json['author']),
      thumbnail: json['thumbnail'],
      musicUrl: json['videoUrl'] ?? json['musicUrl'] ?? "",
      visibility: json['visibility'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
      metrics: Metrics.fromJson(json['metrics']),
      extras: Extras.fromJson(json['extras']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'author': author.toJson(),
      'thumbnail': thumbnail,
      'videoUrl': musicUrl,
      'visibility': visibility,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'metrics': metrics.toJson(),
      'extras': extras.toJson(),
    };
  }
}

enum PostType { Song, Reals }

class FeedManager {
  FeedManager._privateCOnstructor();

  static final _instance = FeedManager._privateCOnstructor();

//Track the fetched data
  List<FeedItem> musicFeed = [];
  List<FeedItem> videoFeed = [];

  List<FeedData> musicFetchedData = [];
  List<FeedData> videoFetchedData = [];

  int currentMusicFeed = 0;
  int currentVideoFeed = 0;

  factory FeedManager() {
    return _instance;
  }

  void clearCache() {
    musicFeed = [];
    videoFeed = [];
    musicFetchedData = [];
    videoFetchedData = [];

    currentMusicFeed = 0;
    currentVideoFeed = 0;
  }

  Future<List<FeedItem>> _getMusicFeed() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("music/feed");
    final musicItems = FeedItem.fromJsonList(response.data);

    return musicItems;
  }

  Future<FeedData> getMusicById(String musicId) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("music/id/$musicId");
    final musicData = FeedData.fromJson(response.data);

    return musicData;
  }

  Future<List<FeedItem>> _getVideoFeed() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("video/feed");
    final feedItems = FeedItem.fromJsonList(response.data);

    return feedItems;
  }

  Future<FeedData> getVideoById(String videoId) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("video/id/$videoId");
    final videoData = FeedData.fromJson(response.data);

    return videoData;
  }

  Future<FeedData> getCurrentMusicData(int currentMusicFeed) async {
    this.currentMusicFeed = currentMusicFeed;

    //ERROR Big error this works only for pagination
    //if current music is equal to length of the cached feed fetch the new data
    // if (currentMusicFeed >= musicFeed.length) {
    // final fetchedFeed = await _getMusicFeed();
    // print("Fetched data is : ${fetchedFeed}");
    // musicFeed.addAll(fetchedFeed);
    // }

    if (musicFeed.length == 0 || currentMusicFeed >= musicFeed.length) {
      final fetchedFeed = await _getMusicFeed();
      print("Fetched data is : ${fetchedFeed}");
      // musicFeed.addAll(fetchedFeed);
      musicFeed = fetchedFeed;
    }

    print(
        "Requested feed number is $currentMusicFeed and music feed length is ${musicFeed.length}");

//check the feed is available or not
    if (currentMusicFeed >= musicFeed.length) {
      throw Exception("There is no more feed available");
    }

    //if current music feed is equal to lenght of fetched data
    // Then fetch the new 3 data
    //Lets suppose firstly we only fetched the first 3 feed data
    if (currentMusicFeed >= musicFetchedData.length) {
      for (int i = 0; i < 3; i++) {
        if (currentMusicFeed + i < musicFeed.length) {
          final fetchedData =
              await getMusicById(musicFeed[currentMusicFeed + i].id);
          musicFetchedData.add(fetchedData);
        }
      }
    }
    return musicFetchedData[currentMusicFeed];
  }

  Future<FeedData> getCurrentVideoData(int currentVideoFeed) async {
    this.currentVideoFeed = currentVideoFeed;

    //ERROR Big error this works only for pagination
    //if current video is equal to length of the cached feed fetch the new data
    // if (currentVideoFeed >= videoFeed.length) {
    // final fetchedFeed = await _getVideoFeed();
    // videoFeed.addAll(fetchedFeed);
    // }

    if (videoFeed.length == 0 || currentVideoFeed >= videoFeed.length) {
      final fetchedFeed = await _getVideoFeed();
      videoFeed = fetchedFeed;
    }

//check the feed is available or not
    if (currentVideoFeed >= videoFeed.length) {
      throw Exception("There is no more feed available");
    }

    //if current video feed is equal to lenght of fetched data
    // Then fetch the new 3 data
    //Lets suppose firstly we only fetched the first 3 feed data
    if (currentVideoFeed >= videoFetchedData.length) {
      for (int i = 0; i < 3; i++) {
        if (currentVideoFeed + i < videoFeed.length) {
          final fetchedData =
              await getVideoById(videoFeed[currentVideoFeed + i].id);
          videoFetchedData.add(fetchedData);
        }
      }
    }
    return videoFetchedData[currentVideoFeed];
  }

  Future<void> likePost(PostType type) async {
    if (type == PostType.Reals) {
      videoFetchedData[currentVideoFeed].extras.liked = true;
      videoFetchedData[currentVideoFeed].metrics.likesCount++;
      await InteractionManager.likePost(videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      musicFetchedData[currentMusicFeed].extras.liked = true;
      musicFetchedData[currentMusicFeed].metrics.likesCount++;

      await InteractionManager.likePost(musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<void> unlikePost(PostType type) async {
    if (type == PostType.Reals) {
      videoFetchedData[currentVideoFeed].extras.liked = false;
      videoFetchedData[currentVideoFeed].metrics.likesCount--;

      await InteractionManager.unlikePost(videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      musicFetchedData[currentMusicFeed].extras.liked = false;
      musicFetchedData[currentMusicFeed].metrics.likesCount--;

      await InteractionManager.unlikePost(
          musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<void> savePost(PostType type) async {
    if (type == PostType.Reals) {
      videoFetchedData[currentVideoFeed].extras.bookmarked = true;
      await InteractionManager.savePost(videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      musicFetchedData[currentMusicFeed].extras.bookmarked = true;
      await InteractionManager.savePost(musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<void> unsavePost(PostType type) async {
    if (type == PostType.Reals) {
      videoFetchedData[currentVideoFeed].extras.bookmarked = false;
      await InteractionManager.unsavePost(videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      musicFetchedData[currentMusicFeed].extras.bookmarked = false;
      await InteractionManager.unsavePost(
          musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<void> sharePost(PostType type) async {
    if (type == PostType.Reals) {
      await InteractionManager.sharePost(videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      await InteractionManager.sharePost(musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<List<Comment>> getAllCommentOfPost(PostType type) async {
    if (type == PostType.Reals) {
      return await InteractionManager.getAllCommentOfPost(
          videoFetchedData[currentVideoFeed].id,
          type: PostType.Reals);
    } else {
      return await InteractionManager.getAllCommentOfPost(
          musicFetchedData[currentMusicFeed].id);
    }
  }

  Future<void> postTheComment(PostType type, String comment) async {
    if (type == PostType.Reals) {
      videoFetchedData[currentVideoFeed].metrics.commentsCount++;
      await InteractionManager.postTheComment(
          videoFetchedData[currentVideoFeed].id, comment,
          type: PostType.Reals);
    } else {
      musicFetchedData[currentMusicFeed].metrics.commentsCount++;
      await InteractionManager.postTheComment(
          musicFetchedData[currentMusicFeed].id, comment);
    }
  }

  Future<void> likeTheComment(PostType type, String commentId) async {
    if (type == PostType.Reals) {
      await InteractionManager.likeTheComment(
          videoFetchedData[currentVideoFeed].id, commentId,
          type: PostType.Reals);
    } else {
      await InteractionManager.likeTheComment(
          musicFetchedData[currentMusicFeed].id, commentId);
    }
  }

  Future<void> unlikeTheComment(PostType type, String commentId) async {
    if (type == PostType.Reals) {
      await InteractionManager.unlikeTheComment(
          videoFetchedData[currentVideoFeed].id, commentId,
          type: PostType.Reals);
    } else {
      await InteractionManager.unlikeTheComment(
          musicFetchedData[currentMusicFeed].id, commentId);
    }
  }
}
