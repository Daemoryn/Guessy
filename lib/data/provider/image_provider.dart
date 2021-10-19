import 'dart:io';
import 'package:path/path.dart';
import 'package:guessy/data/repositories/storage_firebase.dart';

class ImageFirebaseProvider{
  var _firebaseStorageRepository = new StorageFirebase();

  Future<String> getImageFromPath(String path){
    return _firebaseStorageRepository.getImageFromStorage(path).getDownloadURL();
  }

  Future<void> uploadImage(File image)async{
    try{
      await _firebaseStorageRepository.uploadImage(basename(image.path), image);
    } catch (e){
      // print(e.toString());
    }
  }
}