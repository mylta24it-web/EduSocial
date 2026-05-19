import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tạo conversation ID từ 2 user IDs
  String _getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  // Gửi tin nhắn
  Future<void> sendMessage({
    required String recipientId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final chatId = _getChatId(_auth.currentUser!.uid, recipientId);
      final timestamp = DateTime.now();

      // Lưu tin nhắn vào collection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': _auth.currentUser!.uid,
        'recipientId': recipientId,
        'content': content,
        'imageUrl': imageUrl,
        'timestamp': timestamp,
        'isRead': false,
      });

      // Cập nhật last message
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': content,
        'lastMessageTime': timestamp,
        'user1': _auth.currentUser!.uid,
        'user2': recipientId,
      });
    } catch (e) {
      throw 'Gửi tin nhắn thất bại: $e';
    }
  }

  // Lấy messages real-time
  Stream<List<Message>> getMessages(String recipientId) {
    final chatId = _getChatId(_auth.currentUser!.uid, recipientId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message(
          id: doc.id,
          content: doc['content'] ?? '',
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
          isFromMe: doc['senderId'] == _auth.currentUser!.uid,
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    });
  }

  // Lấy danh sách conversations
  Stream<List<Conversation>> getConversations() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection('chats')
        .where('user1', isEqualTo: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Conversation> conversations = [];

      for (var doc in snapshot.docs) {
        final otherUserId = doc['user2'];
        final userDoc =
            await _firestore.collection('users').doc(otherUserId).get();
        final userData = userDoc.data() as Map<String, dynamic>;

        conversations.add(
          Conversation(
            id: doc.id,
            user: User(
              id: otherUserId,
              name: userData['name'] ?? 'Unknown',
              avatar: userData['avatar'] ?? '',
              status: userData['status'] ?? '',
              isOnline: userData['isOnline'] ?? false,
            ),
            lastMessage: doc['lastMessage'] ?? '',
            lastMessageTime: (doc['lastMessageTime'] as Timestamp).toDate(),
            unreadCount: 0,
            messages: [],
          ),
        );
      }

      return conversations;
    });
  }

  // Lấy danh sách users online
  Stream<List<User>> getOnlineUsers() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection('users')
        .where('isOnline', isEqualTo: true)
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          avatar: data['avatar'] ?? '',
          status: data['status'] ?? 'Đang hoạt động',
          isOnline: data['isOnline'] ?? false,
        );
      }).toList();
    });
  }

  // Đánh dấu tin nhắn là đã đọc
  Future<void> markMessagesAsRead(String recipientId) async {
    try {
      final chatId = _getChatId(_auth.currentUser!.uid, recipientId);

      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('recipientId', isEqualTo: _auth.currentUser!.uid)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }
}
