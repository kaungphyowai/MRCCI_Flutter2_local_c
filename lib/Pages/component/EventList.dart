import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mrcci_ec/Pages/HomeProvider.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/event_detail.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/meeting_detail.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:mrcci_ec/constants/shared_values.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import 'package:provider/provider.dart';

class EventList extends StatelessWidget {
  Stream<QuerySnapshot> events_Provider;
  Map<String, dynamic> currentUser;
  @override
  Widget build(BuildContext context) {
    // CollectionReference events =
    //     FirebaseFirestore.instance.collection('events');

    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    events_Provider = homeProvider.getEvents;
    currentUser = homeProvider.getcurrentUserInfo;

    return StreamBuilder<QuerySnapshot>(
      stream: events_Provider,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }

        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(
              'Connect to the Internet',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailView(
                      event: document,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    shadowColor: Colors.black,
                    elevation: 8.0,
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 16.0 / 8.0,
                              child: document.data()['photoUrl'] != null
                                  ? Image.network(
                                      document.data()['photoUrl'].toString(),
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset('assets/images/meeting.jpeg'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.data()['title'].toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20.0,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    document.data()['date'].toString(),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.timer,
                                    size: 20.0,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    document.data()['time'].toString(),
                                  ),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
