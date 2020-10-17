import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrcci_ec/models/meetings.dart';
import 'package:path/path.dart';
import 'package:mrcci_ec/models/user.dart';
import 'authservices.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreService {
  final String uid;
  FirestoreService({this.uid});
  Auth _auth = Auth();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userProfiles');
  final CollectionReference meetingCollection =
      FirebaseFirestore.instance.collection('meetings');
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future<Stream> getMeetings() async {
    try {
      Stream meetings = await meetingCollection.snapshots();
      return meetings;
    } catch (e) {
      return e.message;
    }
  }

  Future<Stream> getMeetingsWithRole(String role) async {
    try {
      Stream meetings =
          await meetingCollection.where('role', isEqualTo: role).snapshots();
      return meetings;
    } catch (e) {
      return e.message;
    }
  }

  Future getSingleMeeting(String meetingID) async {
    try {
      var singleMeeting = await meetingCollection.doc(meetingID).get();
      return Meeting.fromData(singleMeeting.data());
    } catch (e) {
      return e.message;
    }
  }

  Future getCurrentUserInfo(String id) async {
    try {
      var currentUser = await userCollection.doc(id).get();
      return currentUser;
    } catch (e) {
      return e.message;
    }
  }

  void saveMessage({
    @required var userinfo,
    @required String message,
    @required int time,
    @required String role,
    @required String photourl,
    @required String attachmenturl,
    @required String attachmentname,
    @required String videourl,
  }) async {
    try {
      if (message != null ||
          photourl != null ||
          attachmenturl != null ||
          videourl != null) {
        var uid = _auth.getuid();
        DocumentReference _userchats = chatCollection.doc(role);
        _userchats.update({
          "messages": FieldValue.arrayUnion([
            {
              'username': userinfo['username'],
              'message': message,
              'time': time,
              'uid': uid,
              'photourl': photourl,
              'attachment': {
                'attachmenturl': attachmenturl,
                'attachmentname': attachmentname,
              },
              'videourl': videourl
            }
          ])
        });
      }
    } catch (e) {
      return e.messages;
    }
  }
}

//     String downloadURL = await firebase_storage.FirebaseStorage.instance
// .ref().
// .getDownloadURL();
