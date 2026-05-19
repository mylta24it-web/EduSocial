class User {
  final String id;
  final String name;
  final String avatar;
  final String status;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.isOnline,
  });
}

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromMe;
  final String? imageUrl;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
    this.imageUrl,
  });
}

class Conversation {
  final String id;
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.messages,
  });
}
