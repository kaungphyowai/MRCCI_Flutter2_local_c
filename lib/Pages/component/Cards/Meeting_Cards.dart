import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Detail View/meeting_detail.dart';

class Meeting_Card extends StatelessWidget {
  var meeting;
  Meeting_Card({@required this.meeting});

  @override
  Widget build(BuildContext context) {
    Timestamp date = meeting['dateFlutter'];
    var toFormat = DateTime.parse(date.toDate().toString());
    var formattedDate = "${toFormat.day}-${toFormat.month}-${toFormat.year}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingDetailView(
              meeting: meeting,
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
                      child: meeting['photoUrl'] != null
                          ? Image.network(
                              meeting['photoUrl'].toString(),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
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
                        meeting['title'].toString(),
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
                            formattedDate.toString(),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.timer,
                            size: 20.0,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            meeting['time'].toString(),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.people,
                            size: 20.0,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            meeting['role'].toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
