import 'package:tuktak/models/server_response.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/services/feed_manager.dart';

// Music Model
//TODO: Music and the feed data is same so will use same model later on
class Music {
  final String id;
  final String title;
  final String thumbnail;

  Music({
    required this.id,
    required this.title,
    required this.thumbnail,
  });

  // Factory constructor for creating a Music object from JSON
  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['_id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }

  // Convert a Music object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'thumbnail': thumbnail,
    };
  }
}

// Main Data Model
class MusicData {
  final String id;
  final DateTime date;
  final Music music;

  MusicData({
    required this.id,
    required this.date,
    required this.music,
  });

  // Factory constructor for creating a MusicData object from JSON
  factory MusicData.fromJson(Map<String, dynamic> json) {
    return MusicData(
      id: json['_id'] as String,
      date: DateTime.parse(json['date'] as String),
      music: Music.fromJson(json['music'] ?? json['video'] as Map<String, dynamic>),
    );
  }

  // Convert a MusicData object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'music': music.toJson(),
    };
  }

  static List<MusicData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MusicData.fromJson(json)).toList();
  }
}

// User Model
class User {
  final String id;
  final String email;
  final String avatar;
  final String name;
  final String username;

  User({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.username,
  });

  // Factory constructor for creating a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
    );
  }

  // Convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'avatar': avatar,
      'name': name,
      'username': username,
    };
  }
}

// Comment Model
class Comment {
  final String id;
  final String body;
  final int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final User user;
  final int repliesCount;
  final bool hasLiked;

  Comment({
    required this.id,
    required this.body,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.user,
    required this.repliesCount,
    required this.hasLiked,
  });

  // Factory constructor for creating a Comment object from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String,
      body: json['body'] as String,
      likes: json['likes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['__v'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      repliesCount: json['repliesCount'] as int,
      hasLiked: json['hasLiked'] as bool,
    );
  }

  // Convert a Comment object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'body': body,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'user': user.toJson(),
      'repliesCount': repliesCount,
      'hasLiked': hasLiked,
    };
  }

  static List<Comment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Comment.fromJson(json)).toList();
  }
}

class AccountMetrics {
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final int bookmarksCount;

  AccountMetrics({
    required this.followersCount,
    required this.followingCount,
    required this.likesCount,
    required this.bookmarksCount,
  });

  factory AccountMetrics.fromJson(Map<String, dynamic> json) {
    return AccountMetrics(
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      likesCount: json['likesCount'],
      bookmarksCount: json['bookmarksCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
      'bookmarksCount': bookmarksCount,
    };
  }
}

class Account {
  final String id;
  final String email;
  final String avatar;
  final bool isArtist;
  final String name;
  final String bio;
  final String username;
  final String visibility;
  final bool verified;
  final String createdAt;
  final String updatedAt;
  final int version;
  final AccountMetrics metrics;

  Account({
    required this.id,
    required this.email,
    required this.avatar,
    required this.isArtist,
    required this.name,
    required this.bio,
    required this.username,
    required this.visibility,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.metrics,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'],
      email: json['email'],
      avatar: json['avatar'],
      isArtist: json['isArtist'],
      name: json['name'],
      bio: json['bio'],
      username: json['username'],
      visibility: json['visibility'],
      verified: json['verified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
      metrics: AccountMetrics.fromJson(json['metrics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'avatar': avatar,
      'isArtist': isArtist,
      'name': name,
      'bio': bio,
      'username': username,
      'visibility': visibility,
      'verified': verified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'metrics': metrics.toJson(),
    };
  }
}

class FollowData {
  final Account accountId;
  final String followedAt;

  FollowData({
    required this.accountId,
    required this.followedAt,
  });

  factory FollowData.fromJson(Map<String, dynamic> json) {
    return FollowData(
      accountId: Account.fromJson(json['accountId']),
      followedAt: json['followedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId.toJson(),
      'followedAt': followedAt,
    };
  }

  static List<FollowData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FollowData.fromJson(json)).toList();
  }
}

//This is private class to be used by feedManager so dont use it directly
//Otherwise cache data cached by feed manager gives ambuigity
class InteractionManager {
  static Future<void> likePost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface.put("music/like/$id");
    } else {
      final _ = await backendInterface.put("video/like/$id");
    }
  }

  static Future<void> unlikePost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface.delete("music/like/$id");
    } else {
      final _ = await backendInterface.delete("video/like/$id");
    }
  }

  static Future<void> savePost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface.put("music/save/$id");
    } else {
      final _ = await backendInterface.put("video/save/$id");
    }
  }

  static Future<void> unsavePost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface.delete("music/save/$id");
    } else {
      final _ = await backendInterface.delete("video/save/$id");
    }
  }

  static Future<void> sharePost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface.put("music/share/$id");
    } else {
      final _ = await backendInterface.put("video/share/$id");
    }
  }

  static Future<List<Comment>> getAllCommentOfPost(String id,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    ServerResponse response;
    if (type == PostType.Song) {
      response = await backendInterface.get("music/comment/$id");
    } else {
      response = await backendInterface.get("video/comment/$id");
    }

    return Comment.fromJsonList(response.data);
  }

  static Future<void> postTheComment(String id, String comment,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      final _ = await backendInterface
          .post("music/comment/$id", body: {"body": comment});
    } else {
      final _ = await backendInterface
          .post("video/comment/$id", body: {"body": comment});
    }
  }

  static Future<void> likeTheComment(String postId, String commentId,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      await backendInterface.put("music/like-a-comment/$postId/$commentId");
    } else {
      await backendInterface.put("video/like-a-comment/$postId/$commentId");
    }
  }

  static Future<void> unlikeTheComment(String postId, String commentId,
      {PostType type = PostType.Song}) async {
    final backendInterface = BackendInterface();
    if (type == PostType.Song) {
      await backendInterface.delete("music/like-a-comment/$postId/$commentId");
    } else {
      await backendInterface.delete("video/like-a-comment/$postId/$commentId");
    }
  }

  static Future<List<FollowData>> getAllFollowers() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("engagement/followers");

    return FollowData.fromJsonList(response.data);
  }

  static Future<List<FollowData>> getAllFollowings() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("engagement/following");

    return FollowData.fromJsonList(response.data);
  }

  static Future<void> followUser(String userId) async {
    final backendInterface = BackendInterface();
    await backendInterface.post("engagement/follow", body: {"userId": userId});
  }

  static Future<void> unfollowUser(String userId) async {
    final backendInterface = BackendInterface();
    await backendInterface
        .post("engagement/unfollow", body: {"userId": userId});
  }

  static Future<List<FeedItem>> getAllMusicByUserId(String userId) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("music/user/$userId");
    if (response.data == null) return [];

    return FeedItem.fromJsonList(response.data);
  }

  static Future<List<FeedItem>> getAllVideoByUserId(String userId) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("/video/user/$userId");
    if (response.data == null) return [];

    return FeedItem.fromJsonList(response.data);
  }

  static Future<List<MusicData>> getAllSavedMusicPost() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("music/save/");
    if (response.data == null) return [];

    return MusicData.fromJsonList(response.data);
  }

  static Future<List<MusicData>> getAllSavedVideoPost() async {
    final backendInterface = BackendInterface();
    final response = await backendInterface.get("video/save/");
    if (response.data == null) return [];
    return MusicData.fromJsonList(response.data);
  }

  
  //TODO: Only fetch the comment and post the comment there is no features of replying for now
}
