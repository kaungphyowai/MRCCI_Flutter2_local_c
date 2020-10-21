import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChatListWidget.dart';
import 'InputWidget.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
  var userinfo;
  Conversation(this.userinfo);
}

class _ConversationState extends State<Conversation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userinfo['role']);
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('There is No internet'),
          );
        }
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '${widget.userinfo['role']} chat room',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      ChatListWidget(widget.userinfo),
                      InputWidget(widget.userinfo),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
