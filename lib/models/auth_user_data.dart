import 'dart:convert';

class AuthUserData {
  final Metrics metrics;
  final String id;
  final String email;
  final String avatar;
  final String name;
  final String bio;
  final String username;
  final String visibility;
  final bool verified;
  //TODO: what the field is this ??
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final int v;

  AuthUserData({
    required this.metrics,
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.bio,
    required this.username,
    required this.visibility,
    required this.verified,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.v,
  });

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    return AuthUserData(
      metrics: Metrics.fromJson(json['metrics']),
      id: json['_id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      bio: json['bio'],
      username: json['username'],
      visibility: json['visibility'],
      verified: json['verified'],
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
      // v: json['__v'],
    );
  }

// Override toString for easy printing
  @override
  String toString() {
    return '''
    User Profile:
    ID: $id
    Email: $email
    Name: $name
    Username: $username
    Avatar: $avatar
    Bio: $bio
    Visibility: $visibility
    Verified: $verified
    Followers: ${metrics.followersCount}
    Following: ${metrics.followingCount}
    Likes: ${metrics.likesCount}
    Bookmarks: ${metrics.bookmarksCount}
    ''';
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
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt.toIso8601String(),
      // '__v': v,
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
