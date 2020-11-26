import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/event_detail.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/meeting_detail.dart';

class UpcomingCardForEvent extends StatelessWidget {
  var cardData;
  UpcomingCardForEvent({this.cardData});

  @override
  Widget build(BuildContext context) {
    // var date = DateTime.fromMillisecondsSinceEpoch(cardData['date'] * 1000);\
    Timestamp date = cardData['dateFlutter'];
    var toFormat = DateTime.parse(date.toDate().toString());
    var formattedDate = "${toFormat.day}-${toFormat.month}-${toFormat.year}";

    return GestureDetector(
        onTap: () {
          //go to meeting detail card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailView(
                event: cardData,
              ),
            ),
          );
        },
        child: new Card(
          elevation: 10.0,
          child: new Container(
            width: 300,
            decoration: new BoxDecoration(
              color: Colors.grey,
              image: new DecorationImage(
                  image: cardData['photoUrl'] == null
                      ? AssetImage('assets/images/meeting.jpeg')
                      : NetworkImage(cardData['photoUrl'].toString()),
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardData['title'],
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  ),
                  Text(
                    formattedDate.toString(),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

// RichText(
//               text: TextSpan(
//                 text: cardData['title\n'],
//                 style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: cardData['date'],
//                     style: TextStyle(color: Colors.blue[600]),
//                   ),
//                 ],
//               ),
//             ),

// Card(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         margin: EdgeInsets.symmetric(vertical: 5.0),
//         shadowColor: Colors.black,
//         elevation: 8.0,
//         semanticContainer: true,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: cardData['photoUrl'] == null
//             ? Image.asset('assets/images/meeting.jpeg')
//             : Image.network(
//                 cardData['photoUrl'].toString(),
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes
//                           : null,
//                     ),
//                   );
//                 },
//                 fit: BoxFit.cover,
//               ),
//       ),
