import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  var currencyData;
  var rates;
  DateTime today = DateTime.now();

  dynamic get getRates => rates;

  var userInfo;
  Map<String, dynamic> get getcurrentUserInfo => userInfo;

  String uid;
  String get userID => uid;

  Stream<QuerySnapshot> upcoming_meetings;
  Stream<QuerySnapshot> get getUpcomingMeeting => upcoming_meetings;

  Stream<QuerySnapshot> meetings;
  Stream<QuerySnapshot> get getMeetings => meetings;

  Stream<QuerySnapshot> events;
  Stream<QuerySnapshot> get getEvents => events;

  Stream<QuerySnapshot> sameRoleUsers;
  Stream<QuerySnapshot> get getSameRoleUsers => sameRoleUsers;

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

  Future getCurrency() async {
    try {
      Response response =
          await Dio().get('https://forex.cbm.gov.mm/api/latest');
      currencyData = response.data;
      rates = currencyData['rates'];
    } catch (e) {
      print(e.message);
    }
  }

  //To provide the users with the same role as the current users in a listView
  Future fetchSameRoleUsers() async {
    //print("Fetch Same Role User");
    sameRoleUsers = await FirebaseFirestore.instance
        .collection('userProfiles')
        .where('role', isEqualTo: userInfo['role'])
        //.orderBy("username")
        //.orderBy("username", descending: true)
        .snapshots();

    notifyListeners();
  }

  Future fetchMeetings() async {
    //await getuserinfo();
    //print('Print from fetchMeetings Provider ${userInfo['role']}');
    meetings = await FirebaseFirestore.instance
        .collection('meetings')
        .where('role', whereIn: [userInfo['role'], "all"]).snapshots();
    //print('Meeting size : ${meetings.length}');
    notifyListeners();
  }

  Future fetchEvents() async {
    events = await FirebaseFirestore.instance.collection('events').snapshots();
    notifyListeners();
  }

  Future getUpcomingMeetings() async {
    //String userRole = userInfo['role'];
    upcoming_meetings = FirebaseFirestore.instance
        .collection('meetings')
        .where('date', isGreaterThan: today)
        .snapshots();
    notifyListeners();
    // upcoming_meetings.forEach((element) {
    //   element.docs.forEach((element) {
    //     print(element.data());
    //   });
    // });
  }
}
