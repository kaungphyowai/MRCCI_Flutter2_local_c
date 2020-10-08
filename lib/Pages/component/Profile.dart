import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase services/firestore_service.dart';
import '../../firebase services/authservices.dart';
import '../Home.dart';
import '../Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirestoreService firestoreService = FirestoreService();
  Auth _auth = Auth();
  var userinfo;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future getuserinfo() async {
    final uid = firebaseAuth.currentUser.uid;
    userinfo = await firestoreService.getCurrentUserInfo(uid);
    print('Profile : ${userinfo.data()}');
    //userinfo = userinfo.data();
    //print(userinfo);
    return userinfo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: getuserinfo(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            } else {
              return Column(
                children: [
                  CircleAvatar(
                    child: Image.network(userinfo['photourl']),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(userinfo['username']),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(userinfo['phone']),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text(userinfo['role']),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        Container(
          child: MaterialButton(
            color: Colors.redAccent[600],
            textColor: Colors.black,
            child: Text('Sign Out'),
            elevation: 10.0,
            onPressed: () {
              _auth.signout();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ),
        ),
      ],
    );
  }
}
