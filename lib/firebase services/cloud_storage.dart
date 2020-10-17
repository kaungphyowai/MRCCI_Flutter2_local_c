import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {
  Future<String> uploadFile(
      {@required File fileToUpload,
      @required String titleWithBaseName,
      @required String uploadLocation}) async {
    StorageUploadTask uploadTask;
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('$uploadLocation/$titleWithBaseName');
    //if condition is added cause of the Image_Picker Plugin error(Error: The plugin picked the video but the extension of the file is jpg format. So Needed to convert to the mp4 format)
    if (titleWithBaseName.contains('mp4')) {
      StorageMetadata metadata = StorageMetadata(contentType: 'mp4');
      uploadTask = firebaseStorageRef.putFile(fileToUpload, metadata);
    } else {
      uploadTask = firebaseStorageRef.putFile(fileToUpload);
    }

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return url;
    }
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;
  CloudStorageResult({this.imageUrl, this.imageFileName});
}
