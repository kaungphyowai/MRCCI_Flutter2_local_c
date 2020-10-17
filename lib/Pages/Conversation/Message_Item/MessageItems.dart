import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class OtherUserMessage extends StatefulWidget {
  const OtherUserMessage({
    Key key,
    @required this.data,
    @required this.messagedate,
  }) : super(key: key);

  final data;
  final String messagedate;

  @override
  _OtherUserMessageState createState() => _OtherUserMessageState();
}

class _OtherUserMessageState extends State<OtherUserMessage> {
  VideoPlayerController _videocontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data['videourl'] != null) {
      _videocontroller = VideoPlayerController.network(widget.data['videourl'])
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });

      _videocontroller.setLooping(true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  widget.data['username'],
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            mainAxisAlignment:
                MainAxisAlignment.start, // aligns the chatitem to right end
          ),
          widget.data['photourl'] != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.network(widget.data['photourl']),
                      width: 200.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          widget.data['videourl'] != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Stack(
                        children: [
                          _videocontroller.value.initialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videocontroller.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_videocontroller),
                                      Center(
                                        child: IconButton(
                                          icon: Icon(
                                            _videocontroller.value.isPlaying
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_filled,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _videocontroller.value.isPlaying
                                                  ? _videocontroller.pause()
                                                  : _videocontroller.play();
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          widget.data['message'] != null
              ? Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.data['message'],
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment
                      .start, // aligns the chatitem to right end
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  widget.messagedate.toString(),
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

class UserMessage extends StatefulWidget {
  const UserMessage({
    Key key,
    @required this.data,
    @required this.messagedate,
  }) : super(key: key);

  final data;
  final String messagedate;

  @override
  _UserMessageState createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  VideoPlayerController _videocontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data['videourl'] != null) {
      _videocontroller = VideoPlayerController.network(widget.data['videourl'])
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });

      _videocontroller.setLooping(true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  widget.data['username'],
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            mainAxisAlignment:
                MainAxisAlignment.end, // aligns the chatitem to right end
          ),
          widget.data['photourl'] != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Image.network(widget.data['photourl']),
                      width: 200.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          widget.data['videourl'] != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Stack(
                        children: [
                          _videocontroller.value.initialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videocontroller.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_videocontroller),
                                      Center(
                                        child: IconButton(
                                          icon: Icon(
                                            _videocontroller.value.isPlaying
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_filled,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _videocontroller.value.isPlaying
                                                  ? _videocontroller.pause()
                                                  : _videocontroller.play();
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          widget.data['message'] != null
              ? Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.data['message'],
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
              : Container(
                  width: 0,
                  height: 0,
                ),
          widget.data['attachment']['attachmentname'] != null
              ? Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        launch(widget.data['attachment']['attachmenturl']);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              color: Colors.white,
                            ),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: widget.data['attachment']
                                      ['attachmentname'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ],
                  mainAxisAlignment:
                      MainAxisAlignment.end, // aligns the chatitem to right end
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  widget.messagedate.toString(),
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
