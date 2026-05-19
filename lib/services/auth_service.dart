import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Đăng ký
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    String? avatar,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin user vào Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'avatar': avatar ?? '',
        'status': 'Đang hoạt động',
        'isOnline': true,
        'createdAt': DateTime.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Đăng ký thất bại';
    }
  }

  // Đăng nhập
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cập nhật trạng thái online
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'isOnline': true,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Đăng nhập thất bại';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    try {
      if (_auth.currentUser != null) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'isOnline': false,
        });
      }
      await _auth.signOut();
    } catch (e) {
      throw 'Đăng xuất thất bại';
    }
  }
}
