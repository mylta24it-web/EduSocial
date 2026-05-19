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
  final DateTime createdAt;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.hashtags,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });
}
