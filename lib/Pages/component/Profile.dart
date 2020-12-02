import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase services/firestore_service.dart';
import '../../firebase services/authservices.dart';
import '../Home.dart';
import '../HomeProvider.dart';
import '../Login.dart';

class Profile extends StatefulWidget {
  static const String id = "profile";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream<QuerySnapshot> same_role_users;

  FirestoreService firestoreService = FirestoreService();
  Auth _auth = Auth();
  var userinfo;
  bool loading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future getuserinfo() async {
    final uid = firebaseAuth.currentUser.uid;
    userinfo = await firestoreService.getCurrentUserInfo(uid);
    //print(userinfo.data());
    userinfo = userinfo.data();
    //print(userinfo);
    return userinfo;
  }

  String decodeUserRole(String userRole) {
    if (userRole == "cec") {
      return "Chief Exclusive Committee";
    } else if (userRole == "ec") {
      return "Exclusive Committee";
    } else {
      return "General Management Team";
    }
  }

  Widget SameRoleUserListView(Stream<QuerySnapshot> same_role_users) {
    return StreamBuilder<QuerySnapshot>(
      stream: same_role_users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Container(
            child: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
        if (snapshot.data == null) {
          return LoadingIndicator();
        }

        if (snapshot.hasData && snapshot.data != null) {
          List<String> userNames = [];
          List<String> phoneNumbers = [];
          List<String> roles = [];
          List<String> photo = [];

          final users = snapshot.data.docs.reversed;
          List<QueryDocumentSnapshot> userList = [];
          for (var user in users) {
            userList.add(user);
            userList.sort((a, b) {
              return a.data()["username"].compareTo(b.data()["username"]);
            });
          }

          for (var user in userList) {
            userNames.add(user.data()["username"]);
            phoneNumbers.add(user.data()["phone"]);
            roles.add(user.data()["role"]);
            photo.add(user.data()["photourl"]);
          }

          return Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            color: Colors.grey[300],
            padding: EdgeInsets.all(10.0),
            //height: 200,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40.0,
                          width: 40.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: photo[index] != null
                                  ? NetworkImage(
                                      photo[index],
                                    )
                                  : AssetImage(
                                      'assets/images/10.jpg',
                                    ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: SameRoleUsersDataDisplayer(
                              maxLines: 1, data: userNames[index]),
                        ),
                        // Expanded(
                        //   child: SameRoleUsersDataDisplayer(
                        //       maxLines: 3, data: decodeUserRole(roles[index])),
                        // ),
                        Expanded(
                          child: SameRoleUsersDataDisplayer(
                              maxLines: 1, data: phoneNumbers[index]),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          iconSize: 20.0,
                          splashRadius: 15.0,
                          onPressed: () {
                            launch(('tel://${phoneNumbers[index]}'));
                          },
                        ),
                      ],
                    ),
                    BaseLine(
                      lineColor: Colors.lightBlueAccent,
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //To Use Getter methods from HomeProvider //FYI for future developments
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    same_role_users = homeProvider.getSameRoleUsers;

    return SingleChildScrollView(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: getuserinfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
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
                            backgroundImage: userinfo['photourl'] != null
                                ? Image.network(
                                    userinfo['photourl'],
                                    fit: BoxFit.contain,
                                  )
                                : AssetImage('assets/images/10.jpg'),
                            radius: 50.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 1.5,
                          top: 20.0,
                          right: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: Colors.lightBlueAccent,
                      ),
                      padding: EdgeInsets.all(10.0),
                      //alignment: Alignment(0.8, 5.5),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.logout,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          await firebaseAuth.signOut();
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            //Initially, Card was used
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                                top: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text(
                              "Role : " + decodeUserRole(userinfo['role']),
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Phone Number : " + userinfo['phone'],
                              style: TextStyle(
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        IconButton(
                          splashRadius: 15.0,
                          iconSize: 20.0,
                          icon: Icon(
                            Icons.phone,
                          ),
                          onPressed: () {
                            print("This should go to dialing");
                            launch(('tel://${userinfo['phone']}'));
                          },
                        ),
                      ],
                    ),
                    BaseLine(
                      lineColor: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Other " + decodeUserRole(userinfo["role"]),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    BaseLine(
                      lineColor: Colors.lightBlueAccent,
                    ),
                    SameRoleUserListView(same_role_users),
                    SizedBox(
                      height: 10.0,
                    ),
                    BaseLine(lineColor: Colors.grey),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Contact Us : ",
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          iconSize: 20.0,
                          splashRadius: 15.0,
                          onPressed: () {
                            print("Dial phone number");
                          },
                        )
                      ],
                    ),
                    BaseLine(lineColor: Colors.grey),
                  ],
                );
              } else {
                return LoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

class BaseLine extends StatelessWidget {
  final Color lineColor;

  BaseLine({this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      width: MediaQuery.of(context).size.width,
      color: lineColor,
    );
  }
}

class SameRoleUsersDataDisplayer extends StatelessWidget {
  final String data;
  final int maxLines;

  SameRoleUsersDataDisplayer({@required this.data, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        data,
        maxLines: maxLines,
        style: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
