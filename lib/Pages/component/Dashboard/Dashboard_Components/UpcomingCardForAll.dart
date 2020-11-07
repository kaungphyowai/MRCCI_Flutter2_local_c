import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/event_detail.dart';
import 'package:mrcci_ec/Pages/component/Detail%20View/meeting_detail.dart';

class UpcomingCard extends StatelessWidget {
  var cardData;
  UpcomingCard({this.cardData});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //go to meeting detail card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeetingDetailView(
                meeting: cardData,
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
                      ? Image.asset('assets/images/meeting.jpeg')
                      : NetworkImage(cardData['photoUrl'].toString()),
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Meetings',
                  style: TextStyle(fontSize: 15.0),
                ),
                Text(
                  'Date',
                  style: TextStyle(fontSize: 15.0),
                )
              ],
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
