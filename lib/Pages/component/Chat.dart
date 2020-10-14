import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/Conversation/Conversation.dart';
import 'package:mrcci_ec/constants/loading.dart';
import '../../firebase services/firestore_service.dart';
import '../../firebase services/authservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Conversation/Conversation.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FirestoreService firestoreService = FirestoreService();
  Auth _auth = Auth();
  var uid;
  var userinfo;
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
    userinfo = user.data();
    print(userinfo['role']);
    return userinfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getuserinfo(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else {
            return RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Conversation(userinfo)));
              },
              child: Text('Go to the ${userinfo['role']} chat'),
            );
          }
        });
  }
}
