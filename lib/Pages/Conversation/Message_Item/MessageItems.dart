import 'package:flutter/material.dart';

class OtherUserMessage extends StatelessWidget {
  const OtherUserMessage({
    Key key,
    @required this.data,
    @required this.messagedate,
  }) : super(key: key);

  final data;
  final String messagedate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  data['username'],
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            mainAxisAlignment:
                MainAxisAlignment.start, // aligns the chatitem to right end
          ),
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  data['message'],
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(left: 10.0),
              )
            ],
          ),
          Container(
            child: Text(
              messagedate.toString(),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal),
            ),
            margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }
}

class UserMessage extends StatelessWidget {
  const UserMessage({
    Key key,
    @required this.data,
    @required this.messagedate,
  }) : super(key: key);

  final data;
  final String messagedate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  data['username'],
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            mainAxisAlignment:
                MainAxisAlignment.end, // aligns the chatitem to right end
          ),
          data['photourl'] != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Image.network(data['photourl']),
                      width: 200.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          data['message'] != null
              ? Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        data['message'],
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.0)),
                    )
                  ],
                  mainAxisAlignment:
                      MainAxisAlignment.end, // aligns the chatitem to right end
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  messagedate.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
