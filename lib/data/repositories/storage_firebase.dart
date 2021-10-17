import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageFirebase {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Reference getImageFromStorage(String path) {
    return _storage.ref(path);
  }

  Future<void> uploadImage(String imageName,File image)async {
    await _storage.ref(imageName).putFile(image);
  }
}