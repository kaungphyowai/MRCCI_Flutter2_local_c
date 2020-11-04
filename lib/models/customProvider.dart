import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mrcci_ec/firebase%20services/authservices.dart';

class Data_for_app extends ChangeNotifier {
  var userInfo;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future getuserinfo() async {
    // final uid = firebaseAuth.currentUser.uid;
    // userinfo = await firestoreService.getCurrentUserInfo(uid);
    // userinfo = userinfo.data().length;
    // //print(userinfo);
    // return uid;
    final uid = firebaseAuth.currentUser.uid;
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(uid)
        .get();
    userInfo = user.data();
    return userInfo;
  }
}
