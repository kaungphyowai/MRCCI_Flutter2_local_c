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

  @override
  Widget build(BuildContext context) {
    //To Use Getter methods from HomeProvider //FYI for future developments
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    same_role_users = homeProvider.getSameRoleUsers;

    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: getuserinfo(),
            builder: (context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
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
                    SizedBox(
                      height: 80,
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
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
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
                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.lightBlueAccent,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: same_role_users,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text("Something went wrong"),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        if (snapshot.data == null) {
                          return Text(snapshot.toString());
                        }

                        if (snapshot.hasData) {
                          List<String> userNames = [];
                          List<String> phoneNumbers = [];
                          List<String> roles = [];
                          List<String> photo = [];

                          final users = snapshot.data.docs.reversed;

                          for (var user in users) {
                            userNames.add(user.data()["username"]);
                            phoneNumbers.add(user.data()["phone"]);
                            roles.add(user.data()["role"]);
                            photo.add(user.data()["photourl"]);
                          }

                          return Container(
                            height: 150,
                            child: ListView.builder(
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
                                          child: Container(
                                            child: Text(
                                              userNames[index],
                                              //textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              decodeUserRole(roles[index]),
                                              //textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              phoneNumbers[index],
                                              //textAlign: TextAlign.center,
                                              style: TextStyle(
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
                                            launch(
                                                ('tel://${phoneNumbers[index]}'));
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 1.0,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
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
                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ],
                );
              } else {
                return LoadingIndicator();
              }
            },
          ),
          Container(
            child: MaterialButton(
              color: Colors.redAccent[600],
              textColor: Colors.black,
              child: Text(
                'Sign Out',
                textAlign: TextAlign.start,
              ),
              elevation: 10.0,
              onPressed: () async {
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
        ],
      ),
    );
  }
}

// return
