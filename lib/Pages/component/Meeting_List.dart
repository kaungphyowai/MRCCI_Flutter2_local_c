import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/meeting_detail.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:mrcci_ec/constants/shared_values.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import '../../firebase services/authservices.dart';
import 'Cards/Meeting_Cards.dart';

class MeetingList extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    CollectionReference meetings =
        FirebaseFirestore.instance.collection('meetings');
    return FutureBuilder(
      future: getuserinfo(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else {
          return StreamBuilder<QuerySnapshot>(
            stream: meetings.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingIndicator();
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  String meetingRole = document.data()['role'];
                  var userRole = userInfo['role'];
                  print(userRole);
                  if (meetingRole == 'all' || meetingRole == userRole) {
                    return Meeting_Card(
                      meeting: document.data(),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              );
            },
          );
        }
      },
    );
  }
}

// document.data()['photoUrl'] != null
//                                 ? Image.network(
//                                     document.data()['photoUrl'],
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Image.asset('assets/images/meeting.jpeg'),
