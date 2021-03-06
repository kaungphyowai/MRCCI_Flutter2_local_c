import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Message_Item/ChatItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatListWidget extends StatelessWidget {
  final ScrollController listScrollController = new ScrollController();
  var userinfo;
  ChatListWidget(this.userinfo);
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.reference();

    // TODO: implement build
    return StreamBuilder(
      stream: ref.child(userinfo['role']).onValue,
      builder: (context, snapshot) {
        //print("Snapshot data : " + snapshot.data.toString());

        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data.snapshot.value != null) {
          var data = snapshot.data.snapshot.value;
          int datalength = data.length;
          return Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => ChatItem(
                data: snapshot.data.snapshot.value[index],
                index: index,
              ),
              itemCount: data.length,
              reverse: false,
              controller: listScrollController,
            ),
          );
        } else if (snapshot.data == null) {
          return Center(
            child: Text(
              "Start Conversation",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
