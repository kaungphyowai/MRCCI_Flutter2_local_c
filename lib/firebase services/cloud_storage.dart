import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {
  Future<String> uploadImage(
      {@required File imageToUpload,
      @required String titleWithBaseName,
      @required String uploadLocation}) async {
    var imageFileName =
        titleWithBaseName + DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('$uploadLocation/$titleWithBaseName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return url;
    }
    return null;
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;
  CloudStorageResult({this.imageUrl, this.imageFileName});
}
