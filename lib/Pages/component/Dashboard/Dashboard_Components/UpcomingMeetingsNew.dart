import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/HomeProvider.dart';
import 'package:mrcci_ec/Pages/component/Dashboard/Dashboard_Components/UpcomingCardForAll.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:provider/provider.dart';

class UpcomingMeetingsNew extends StatefulWidget {
  @override
  _UpcomingMeetingsNewState createState() => _UpcomingMeetingsNewState();
}

class _UpcomingMeetingsNewState extends State<UpcomingMeetingsNew> {
  Stream<QuerySnapshot> upcoming_Meetings_Provider;
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    upcoming_Meetings_Provider = homeProvider.getUpcomingMeeting;
    return StreamBuilder<QuerySnapshot>(
      stream: upcoming_Meetings_Provider,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
              child: Text(
            'There is no Internet Connection',
            style: TextStyle(fontSize: 15, color: Colors.red[500]),
          ));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'There is something error in fetching...',
              style: TextStyle(fontSize: 15, color: Colors.red[500]),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }

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
                    return UpcomingCard(
                      cardData: document.data(),
                    );
                    // } else {
                    //   return Container();
                    // }
                  }).toList(),
          ),
        );
      },
    );
  }
}
