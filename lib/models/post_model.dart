import 'package:cloud_firestore/cloud_firestore.dart';

class PostUser {
  final String id;
  final String name;
  final String avatar;
  final String? title;
  final String? group;

  PostUser({
    required this.id,
    required this.name,
    required this.avatar,
    this.title,
    this.group,
  });
}

class Post {
  final String id;
  final PostUser author;
  final String content;
  final List<String> hashtags;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final DateTime createdAt;
  final List<String> likedBy;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.hashtags,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.likedBy = const [],
    this.shares = 0,
  });
}
