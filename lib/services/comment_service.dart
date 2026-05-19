import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
  });
}

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Thêm comment
  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'authorId': _auth.currentUser!.uid,
        'authorName': userData['name'],
        'authorAvatar': userData['avatar'],
        'content': content,
        'createdAt': DateTime.now(),
        'likes': 0,
      });

      // Cập nhật số comments
      await _firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.increment(1),
      });
    } catch (e) {
      throw 'Thêm comment thất bại: $e';
    }
  }

  // Lấy comments real-time
  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment(
          id: doc.id,
          authorId: doc['authorId'],
          authorName: doc['authorName'],
          authorAvatar: doc['authorAvatar'],
          content: doc['content'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Xóa comment
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      // Cập nhật số comments
      await _firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.increment(-1),
      });
    } catch (e) {
      throw 'Xóa comment thất bại: $e';
    }
  }
}
