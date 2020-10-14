import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Message_Item/ChatItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListWidget extends StatelessWidget {
  final ScrollController listScrollController = new ScrollController();
  var userinfo;
  ChatListWidget(this.userinfo);
  @override
  Widget build(BuildContext context) {
    DocumentReference chat =
        FirebaseFirestore.instance.collection('chats').doc(userinfo['role']);

    // TODO: implement build
    return StreamBuilder(
      stream: chat.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.connectionState == ConnectionState.active) {
          // return RaisedButton(
          //   onPressed: () {
          //     print(snapshot.data.data()['messages'][0]['message']);
          //   },
          // );
          if (snapshot.hasData) {
            var data = snapshot.data.data()['messages'];
            return Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => ChatItem(
                  data: snapshot.data.data()['messages'][index],
                  index: index,
                ),
                itemCount: data.length,
                reverse: false,
                controller: listScrollController,
              ),
            );
          }
        }
      },
    );
  }
}
