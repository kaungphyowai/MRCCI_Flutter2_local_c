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
        print('builder');
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data.snapshot.value != null) {
          var data = snapshot.data.snapshot.value;
          int datalength = data.length;
          print('Widget rebuild');
          print(snapshot.data.snapshot.value[0]);
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
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
