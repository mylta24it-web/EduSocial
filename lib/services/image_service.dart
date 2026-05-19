import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // Chọn ảnh từ gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      throw 'Lỗi chọn ảnh: $e';
    }
  }

  // Chụp ảnh từ camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      throw 'Lỗi chụp ảnh: $e';
    }
  }

  // Upload ảnh lên Firebase Storage
  Future<String> uploadImage({
    required XFile image,
    required String folder,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}';
      final reference = _storage.ref('$folder/$fileName');

      final uploadTask = reference.putFile(File(image.path));
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Upload ảnh thất bại: $e';
    }
  }

  // Xóa ảnh từ Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final reference = _storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      throw 'Xóa ảnh thất bại: $e';
    }
  }

  // Compress & upload
  Future<String> uploadImageOptimized({
    required XFile image,
    required String folder,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}';
      final reference = _storage.ref('$folder/$fileName');

      final file = File(image.path);
      final uploadTask = reference.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploaded_at': DateTime.now().toString(),
          },
        ),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Upload ảnh tối ưu thất bại: $e';
    }
  }
}
