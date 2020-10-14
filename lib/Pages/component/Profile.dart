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
    print(userinfo.data());
    userinfo = userinfo.data();
    //print(userinfo);
    return userinfo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getuserinfo(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            } else {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/10.jpg'),
                            fit: BoxFit.fill)),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        alignment: Alignment(0.0, 2.5),
                        child: CircleAvatar(
                          backgroundImage: userinfo['photurl'] != null
                              ? NetworkImage(userinfo['photourl'])
                              : AssetImage('assets/images/10.jpg'),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    userinfo['username'],
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.blueGrey,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userinfo['phone'],
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      elevation: 2.0,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          child: Text(
                            userinfo['role'],
                            style: TextStyle(
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300),
                          ))),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.pink, Colors.redAccent]),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 40.0,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Contact me",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
