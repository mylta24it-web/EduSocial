import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tạo bài viết mới
  Future<void> createPost({
    required String content,
    required List<String> hashtags,
    String? imageUrl,
  }) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      await _firestore.collection('posts').add({
        'authorId': _auth.currentUser!.uid,
        'authorName': userData['name'],
        'authorAvatar': userData['avatar'],
        'authorTitle': userData['title'] ?? '',
        'authorGroup': userData['group'] ?? '',
        'content': content,
        'imageUrl': imageUrl,
        'hashtags': hashtags,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'likedBy': [],
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw 'Tạo bài viết thất bại: $e';
    }
  }

  // Lấy tất cả posts real-time
  Stream<List<Post>> getAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          author: PostUser(
            id: data['authorId'] ?? '',
            name: data['authorName'] ?? 'Unknown',
            avatar: data['authorAvatar'] ?? '',
            title: data['authorTitle'],
            group: data['authorGroup'],
          ),
          content: data['content'] ?? '',
          hashtags: List<String>.from(data['hashtags'] ?? []),
          imageUrl: data['imageUrl'],
          likes: data['likes'] ?? 0,
          comments: data['comments'] ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          likedBy: List<String>.from(data['likedBy'] ?? []),
          shares: data['shares'] ?? 0,
        );
      }).toList();
    });
  }

  // Lấy posts theo hashtag
  Stream<List<Post>> getPostsByHashtag(String hashtag) {
    return _firestore
        .collection('posts')
        .where('hashtags', arrayContains: hashtag)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          author: PostUser(
            id: data['authorId'] ?? '',
            name: data['authorName'] ?? 'Unknown',
            avatar: data['authorAvatar'] ?? '',
            title: data['authorTitle'],
            group: data['authorGroup'],
          ),
          content: data['content'] ?? '',
          hashtags: List<String>.from(data['hashtags'] ?? []),
          imageUrl: data['imageUrl'],
          likes: data['likes'] ?? 0,
          comments: data['comments'] ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          likedBy: List<String>.from(data['likedBy'] ?? []),
          shares: data['shares'] ?? 0,
        );
      }).toList();
    });
  }

  // Lấy posts của user
  Stream<List<Post>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          author: PostUser(
            id: data['authorId'] ?? '',
            name: data['authorName'] ?? 'Unknown',
            avatar: data['authorAvatar'] ?? '',
            title: data['authorTitle'],
            group: data['authorGroup'],
          ),
          content: data['content'] ?? '',
          hashtags: List<String>.from(data['hashtags'] ?? []),
          imageUrl: data['imageUrl'],
          likes: data['likes'] ?? 0,
          comments: data['comments'] ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          likedBy: List<String>.from(data['likedBy'] ?? []),
          shares: data['shares'] ?? 0,
        );
      }).toList();
    });
  }

  // Like post
  Future<void> likePost(String postId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final currentUserId = _auth.currentUser!.uid;

      final postDoc = await postRef.get();
      final likedBy = List<String>.from(postDoc['likedBy'] ?? []);

      if (!likedBy.contains(currentUserId)) {
        likedBy.add(currentUserId);
        await postRef.update({
          'likes': FieldValue.increment(1),
          'likedBy': likedBy,
        });
      }
    } catch (e) {
      throw 'Like post thất bại: $e';
    }
  }

  // Unlike post
  Future<void> unlikePost(String postId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final currentUserId = _auth.currentUser!.uid;

      final postDoc = await postRef.get();
      final likedBy = List<String>.from(postDoc['likedBy'] ?? []);

      if (likedBy.contains(currentUserId)) {
        likedBy.remove(currentUserId);
        await postRef.update({
          'likes': FieldValue.increment(-1),
          'likedBy': likedBy,
        });
      }
    } catch (e) {
      throw 'Unlike post thất bại: $e';
    }
  }

  // Kiểm tra user đã like post chưa
  Future<bool> isPostLiked(String postId) async {
    try {
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      final likedBy = List<String>.from(postDoc['likedBy'] ?? []);
      return likedBy.contains(_auth.currentUser!.uid);
    } catch (e) {
      return false;
    }
  }

  // Xóa post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw 'Xóa bài viết thất bại: $e';
    }
  }

  // Update post
  Future<void> updatePost({
    required String postId,
    required String content,
    required List<String> hashtags,
    String? imageUrl,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'content': content,
        'hashtags': hashtags,
        'imageUrl': imageUrl,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw 'Cập nhật bài viết thất bại: $e';
    }
  }
}
