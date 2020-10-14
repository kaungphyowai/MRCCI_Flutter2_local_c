import 'package:flutter/material.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import 'package:path/path.dart';
import '../../firebase services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../firebase services/cloud_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InputWidget extends StatefulWidget {
  var userinfo;
  InputWidget(this.userinfo);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController textEditingController =
      new TextEditingController();
  String _message;
  TextEditingController _controller;
  File _image;
  String imageurl;
  bool imageStillUploading = false;
  final picker = ImagePicker();
  CloudStorageService cloudstorage = CloudStorageService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TextEditingController(text: _message);
  }

  Future<void> _getImageAndUpload() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    imageStillUploading = true;
    imageurl = await cloudstorage.uploadImage(
        imageToUpload: _image,
        titleWithBaseName: basename(_image.path),
        uploadLocation: 'chatfiles');
    imageStillUploading = false;
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                color: Colors.grey,
              ),
            ),
            color: Colors.white,
          ),
          IconButton(
              icon: Icon(Icons.image),
              onPressed: () async {
                await _getImageAndUpload();
              }),

          Flexible(
            child: Container(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),

          // Send Message Button
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  if (imageStillUploading) {
                    return Fluttertoast.showToast(
                        msg: 'Image is still uploading');
                  } else {
                    firestoreService.saveMessage(
                      userinfo: widget.userinfo,
                      time: DateTime.now().millisecondsSinceEpoch.round(),
                      message: _message,
                      role: widget.userinfo['role'],
                      photourl: imageurl,
                    );
                  }

                  imageurl = null;
                  setState(() {
                    _message = null;
                    textEditingController.clear();
                  });
                },
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
}
