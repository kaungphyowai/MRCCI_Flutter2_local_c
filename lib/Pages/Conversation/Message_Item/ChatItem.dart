import 'package:flutter/material.dart';
import '../../../firebase services/authservices.dart';
import 'package:intl/intl.dart';
import 'MessageItems.dart';

class ChatItem extends StatelessWidget {
  Auth _auth = Auth();
  var index;
  var data;

  ChatItem({this.index, this.data});
  @override
  Widget build(BuildContext context) {
    var uid = _auth.getuid();
    var messagedate = DateFormat().add_yMd().add_Hm().format(
        DateTime.fromMillisecondsSinceEpoch(data['time'], isUtc: true)
            .toLocal());
    if (data['uid'] == uid) {
      return UserMessage(data: data, messagedate: messagedate);
    } else {
      return OtherUserMessage(data: data, messagedate: messagedate);
    }
  }
}
