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

  Future fetchMeetings() async {
    //await getuserinfo();
    //print('Print from fetchMeetings Provider ${userInfo['role']}');
    meetings = await FirebaseFirestore.instance
        .collection('meetings')
        .where('role', isEqualTo: userInfo['role'])
        .snapshots();

    //print('Meeting size : ${meetings.length}');
    notifyListeners();
  }

  Future fetchEvents() async {
    events = await FirebaseFirestore.instance.collection('events').snapshots();
    notifyListeners();
  }

  Future getUpcomingMeetings() async {
    upcoming_meetings = FirebaseFirestore.instance
        .collection('meetings')
        .where('role', isEqualTo: userInfo['role'])
        .where('date', isGreaterThan: today)
        .orderBy('date')
        .snapshots();
    upcoming_meetings.forEach((element) {
      element.docs.forEach((element) {
        print('Upcoming Meeting : ${element.data()}');
      });
    });
  }
}
