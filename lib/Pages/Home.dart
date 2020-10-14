import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/component/Dashboard.dart';
import 'package:mrcci_ec/Pages/component/EventList.dart';
import 'package:mrcci_ec/Pages/component/Profile.dart';
import 'package:mrcci_ec/Pages/component/Meeting_List.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import 'package:mrcci_ec/models/user.dart';
import '../constants/shared_values.dart';
import 'component/Chat.dart';
import '../firebase services/authservices.dart';
import 'Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  User currentUser;
  String userId;
  Home({this.currentUser, this.userId});
}

class _HomeState extends State<Home> {
  CurrentUser userInfo;
  DocumentSnapshot doc;
  int _selectedIndex = 0;
  FirestoreService _firestoreService = FirestoreService();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    MeetingList(),
    EventList(),
    Chat(),
    Profile(),
  ];

  static const List<Widget> _appBarText = <Widget>[
    Text(
      'Dashboard',
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 26,
      ),
    ),
    Text(
      'Meetings',
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 26,
      ),
    ),
    Text(
      'Events',
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26),
    ),
    Text(
      'Chat',
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26),
    ),
    Text(
      'Profile',
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 26),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setCurrentUserID(widget.currentUser.uid);

    //setCurrentUserData(doc.data());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _appBarText.elementAt(_selectedIndex)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.maxFinite,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Meetings'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day),
              title: Text('Events'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('Chat'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              backgroundColor: Colors.black),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[200],
        onTap: _onItemTapped,
        elevation: 8.0,
        backgroundColor: Colors.black,
      ),
    );
  }
}
