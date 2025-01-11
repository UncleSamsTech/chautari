import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/services/shared_preference_service.dart';

class User {
  final Metrics metrics;
  final String id;
  final String email;
  final String avatar;
  final String name;
  final String bio;
  final String username;
  final String visibility;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  User({
    required this.metrics,
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.bio,
    required this.username,
    required this.visibility,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      metrics: Metrics.fromJson(json['metrics']),
      id: json['_id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      bio: json['bio'],
      username: json['username'],
      visibility: json['visibility'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(),
      '_id': id,
      'email': email,
      'avatar': avatar,
      'name': name,
      'bio': bio,
      'username': username,
      'visibility': visibility,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}

class Metrics {
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final int bookmarksCount;

  Metrics({
    required this.followersCount,
    required this.followingCount,
    required this.likesCount,
    required this.bookmarksCount,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
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

class UserManager {
  UserManager._privateConstructor();

  static final _instance = UserManager._privateConstructor();

  factory UserManager() {
    return _instance;
  }
  User? user;

  Future<User> getOtherUserProfile(String userName) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface
        .get("auth/get-profile", body: {"username": userName});

    return User.fromJson(response.data);
  }

  Future<void> load() async {
    final isUserLoginned = SharedPreferenceService().isLogin;

    if (isUserLoginned) {
      final backendInterface = BackendInterface();
      final response = await backendInterface.get("auth/profile");

      //Check the user is authenticated or not
      //This also verify the cookie expires or not
      if (response.status != 200) {
        await SharedPreferenceService().setIsLogin(false);
        await SharedPreferenceService().setCookie("");
      } else {
        user = User.fromJson(response.data);
      }
    }
  }

  Future<void> follow(String userId) async {
    final backendInterface = BackendInterface();
    final _ =
        backendInterface.post("engagement/follow", body: {"userId": userId});
  }

  Future<void> unfollow(String userId) async {
    final backendInterface = BackendInterface();
    final _ =
        backendInterface.post("engagement/unfollow", body: {"userId": userId});
  }

  Future<void> getFollower() async {
    final backendInterface = BackendInterface();
    final response = backendInterface.get("engagement/followers");
  }

  Future<void> getFollowing() async {
    final backendInterface = BackendInterface();
    final response = backendInterface.get("engagement/following");
  }
}
