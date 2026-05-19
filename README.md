# EduSocial - Educational Social Network App với Firebase Real-time Chat

Một ứng dụng mạng xã hội học tập được phát triển bằng Flutter và Dart với tính năng chat real-time bằng Firebase.

## 🎯 Tính Năng Chính

- **Chat & Messaging Real-time**: Gửi tin nhắn thời thực bằng Firebase Firestore
- **Firebase Authentication**: Đăng nhập/đăng ký an toàn
- **Feed & Posts**: Chia sẻ bài viết, hình ảnh với cộng đồng
- **User Profiles**: Xem thông tin người dùng và trạng thái hoạt động
- **Online Status**: Hiển thị trạng thái online/offline của người dùng
- **Hashtags**: Tìm kiếm bài viết theo chủ đề
- **Social Interactions**: Thích, bình luận, chia sẻ bài viết

## 🚀 Công Nghệ Sử Dụng

- **Flutter 3.0+**: Framework UI
- **Dart**: Ngôn ngữ lập trình
- **Firebase Realtime Database**: Chat real-time
- **Firebase Authentication**: Xác thực người dùng
- **Cloud Firestore**: Lưu trữ dữ liệu
- **Firebase Storage**: Lưu trữ hình ảnh

## 📱 Giao Diện

### Màn hình chính:
1. **Home** - Trang chủ
2. **Explore** - Khám phá
3. **Chat** - Tin nhắn real-time ⭐
4. **Community** - Cộng đồng
5. **Profile** - Hồ sơ cá nhân

## 🔧 Cấu Hình Firebase

### Bước 1: Tạo Firebase Project
1. Truy cập [Firebase Console](https://console.firebase.google.com)
2. Tạo project mới
3. Thêm ứng dụng Flutter
4. Tải Google Service files (cho Android và iOS)

### Bước 2: Cấu Hình Firestore
1. Tạo Firestore Database (Start in test mode)
2. Tạo Collections:
   - `users` - Lưu thông tin người dùng
   - `chats` - Lưu cuộc trò chuyện
   - `posts` - Lưu bài viết

### Bước 3: Cập Nhật firebase_options.dart
```dart
// lib/firebase_options.dart
static FirebaseOptions get currentPlatform {
  return FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
```

### Bước 4: Cấu Hình Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid == resource.id;
    }
    
    // Chats collection
    match /chats/{chatId}/messages/{document=**} {
      allow read, write: if request.auth != null;
    }
    
    match /chats/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Posts collection
    match /posts/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 📦 Cài Đặt

### Yêu cầu:
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android API 21+ hoặc iOS 11.0+

### Hướng dẫn:

```bash
# Clone repository
git clone https://github.com/mylta24it-web/EduSocial.git
cd EduSocial

# Tải dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

## 📂 Cấu Trúc Dự Án

```
lib/
├── main.dart                          # Ứng dụng chính
├── firebase_options.dart              # Cấu hình Firebase
├── models/
│   ├── message_model.dart            # Mô hình tin nhắn
│   └── post_model.dart               # Mô hình bài viết
├── services/
│   ├── auth_service.dart             # Xác thực Firebase
│   └── chat_service.dart             # Dịch vụ chat real-time ⭐
└── screens/
    ├── auth_screen.dart              # Đăng nhập/Đăng ký
    ├── home_screen.dart              # Trang chủ
    ├── feed_screen.dart              # Xã hội
    ├── messages_screen.dart          # Danh sách tin nhắn ⭐
    └── chat_detail_screen.dart       # Chi tiết cuộc chat ⭐
```

## ✨ Tính Năng Real-time Chat

### Gửi tin nhắn:
```dart
await _chatService.sendMessage(
  recipientId: userId,
  content: 'Xin chào!',
);
```

### Nhận tin nhắn:
```dart
StreamBuilder<List<Message>>(
  stream: _chatService.getMessages(userId),
  builder: (context, snapshot) {
    // Hiển thị tin nhắn real-time
  },
)
```

### Lấy danh sách cuộc trò chuyện:
```dart
StreamBuilder<List<Conversation>>(
  stream: _chatService.getConversations(),
  builder: (context, snapshot) {
    // Hiển thị danh sách cuộc chat
  },
)
```

## 🎨 Thiết Kế

- **Màu chủ đạo**: Xanh dương (#5B5EFF)
- **Font**: Roboto
- **Layout**: Material Design 3

## 🔐 Bảo Mật

- ✅ Firebase Authentication
- ✅ Firestore Security Rules
- ✅ Encrypt tin nhắn (tuỳ chọn)
- ✅ Rate limiting

## 📚 Tài Liệu

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)

## 🤝 Đóng Góp

Cảm ơn bạn đã quan tâm! Vui lòng:
1. Fork repository
2. Tạo branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📧 Liên Hệ

Nếu có câu hỏi, vui lòng tạo Issue hoặc liên hệ trực tiếp.

## 📄 License

MIT License - xem file LICENSE để chi tiết
