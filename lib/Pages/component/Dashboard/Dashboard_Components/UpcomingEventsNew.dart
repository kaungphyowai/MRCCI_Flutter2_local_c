import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/HomeProvider.dart';
import 'package:mrcci_ec/Pages/component/Dashboard/Dashboard_Components/UpcomingCardForEvent.dart';
import 'package:mrcci_ec/Pages/component/Dashboard/Dashboard_Components/UpcomingCardForMeeting.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:provider/provider.dart';

class UpcomingEventsNew extends StatefulWidget {
  @override
  _UpcomingEventsNewState createState() => _UpcomingEventsNewState();
}

class _UpcomingEventsNewState extends State<UpcomingEventsNew> {
  DateTime today = DateTime.now();

  Stream<QuerySnapshot> upcoming_events;

  @override
  Widget build(BuildContext context) {
    upcoming_events = FirebaseFirestore.instance
        .collection('events')
        .where('dateFlutter', isGreaterThan: today)
        .snapshots();
    // HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    // upcoming_Meetings_Provider = homeProvider.getUpcomingMeeting;
    return StreamBuilder<QuerySnapshot>(
      stream: upcoming_events,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'There is something error in fetching...',
              style: TextStyle(fontSize: 15, color: Colors.red[500]),
            ),
          );
        }

        if (snapshot.data == null) {
          return LoadingIndicator();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            height: 200,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.docs.length == null
                  ? Center(
                      child: Text(
                        'There is no upcoming meetings yet.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  : snapshot.data.docs.map((DocumentSnapshot document) {
                      //print(document.data());
                      // String meetingRole = document.data()['role'];
                      // var userRole = currentUser['role'];
                      // print(userRole);
                      // if (meetingRole == 'all' || meetingRole == userRole) {
                      return UpcomingCardForEvent(
                        cardData: document.data(),
                      );
                      // } else {
                      //   return Container();
                      // }
                    }).toList(),
            ),
          );
        }
      },
    );
  }
}
