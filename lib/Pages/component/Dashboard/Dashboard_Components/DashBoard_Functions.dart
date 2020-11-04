import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> getUpcomingMeetings(
    {@required AsyncSnapshot<QuerySnapshot> snapshot,
    @required var userInfo,
    @required upcomingSevenDays}) {
  List<dynamic> upcomingMeetings = [];
  for (var j = 0; j < snapshot.data.docs.length; j = j + 1) {
    var document = snapshot.data.docs[j];
    var documentInfo = document.data();
    //print(documentInfo);
    String meetingRole = documentInfo['role'];
    //print(userInfo);
    var userRole = userInfo['role'];

    var meetingDate = document.data()['date'];
    if (meetingRole == 'all' || meetingRole == userRole) {
      for (var i = 0; i < upcomingSevenDays.length; i++) {
        if (upcomingSevenDays[i] == meetingDate) {
          // print('match');
          upcomingMeetings.add(document.data());
          break;
        }
      }
    }
  }
  return upcomingMeetings;
}

List<String> get_upcoming_seven_days() {
  List<String> upcomingSevenDays = [];
  var today = new DateTime.now();
  for (int i = 1; i < 8; i++) {
    var iDaysFromNow = today.add(new Duration(days: i));
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(iDaysFromNow);
    upcomingSevenDays.add(formatted);
  }
  return upcomingSevenDays;
}

List<dynamic> getUpcomingEvents(
    {@required AsyncSnapshot<QuerySnapshot> snapshot,
    @required upcomingSevenDays}) {
  List<dynamic> upcomingEvents = [];
  for (var j = 0; j < snapshot.data.docs.length; j = j + 1) {
    var document = snapshot.data.docs[j];
    var documentInfo = document.data();
    var meetingDate = document.data()['date'];

    for (var i = 0; i < upcomingSevenDays.length; i++) {
      if (upcomingSevenDays[i] == meetingDate) {
        //print('match');
        upcomingEvents.add(document.data());
        break;
      }
    }
  }
  return upcomingEvents;
}
