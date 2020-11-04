import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  var userInfo;
  Map<String, dynamic> get getcurrentUserInfo => userInfo;

  String uid;
  String get userID => uid;

  CollectionReference meetings;
  CollectionReference get getMeetings => meetings;

  CollectionReference events;
  CollectionReference get getEvents => events;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future getuserinfo() async {
    // final uid = firebaseAuth.currentUser.uid;
    // userinfo = await firestoreService.getCurrentUserInfo(uid);
    // userinfo = userinfo.data().length;
    // //print(userinfo);
    // return uid;
    uid = firebaseAuth.currentUser.uid;
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(uid)
        .get();
    userInfo = user.data();

    notifyListeners();
  }

  Future fetchMeetings() async {
    meetings = await FirebaseFirestore.instance.collection('meetings');
    notifyListeners();
  }

  Future fetchEvents() async {
    events = await FirebaseFirestore.instance.collection('events');
    notifyListeners();
  }
}
