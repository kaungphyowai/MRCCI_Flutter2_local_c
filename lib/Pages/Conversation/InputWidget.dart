import 'package:flutter/material.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import 'package:path/path.dart';
import '../../firebase services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../firebase services/cloud_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

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
  File _attachmentFile;
  String imageurl;
  String videourl;
  String attachmenturl;
  bool imageStillUploading = false;
  bool videoStillUploading = false;
  bool attachmentStillUploading = false;
  final imagePicker = ImagePicker();
  CloudStorageService cloudstorage = CloudStorageService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TextEditingController(text: _message);
  }

  Future<void> _getImageAndUpload() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    imageStillUploading = true;
    imageurl = await cloudstorage.uploadFile(
        fileToUpload: _image,
        titleWithBaseName: basename(_image.path),
        uploadLocation: 'chatimages');
    imageStillUploading = false;
  }

  Future<void> _getVideoAndUpload() async {
    File _videoFile;
    String titlewithbaseName;
    final pickedvideoFile = await imagePicker.getVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
    setState(() {
      if (pickedvideoFile != null) {
        _videoFile = File(pickedvideoFile.path);

        //change the extension of the file
        List<String> stringList = basename(pickedvideoFile.path).split('.');
        stringList[1] = 'mp4';
        titlewithbaseName = stringList.join('.');
      } else {
        print('No video selected.');
      }
    });
    videoStillUploading = true;
    videourl = await cloudstorage.uploadFile(
        fileToUpload: _videoFile,
        titleWithBaseName: titlewithbaseName,
        uploadLocation: 'chatvideos');
    videoStillUploading = false;
    print(videourl);
  }

  Future<void> _getAttachmentAndUpload() async {
    print('hello');
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    setState(() {
      if (result != null) {
        _attachmentFile = File(result.files.single.path);
      } else {
        print('No attachment selected');
      }
    });
    attachmentStillUploading = true;
    attachmenturl = await cloudstorage.uploadFile(
        fileToUpload: _attachmentFile,
        titleWithBaseName: basename(_attachmentFile.path),
        uploadLocation: 'chatfiles');
    attachmentStillUploading = false;
    print(attachmenturl);
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
                onPressed: () {
                  _getAttachmentAndUpload();
                },
                icon: new Icon(Icons.attach_file),
                color: Colors.grey,
              ),
            ),
            color: Colors.white,
          ),
          //video Still need to develops

          // IconButton(
          //   icon: Icon(Icons.video_library),
          //   onPressed: () {
          //     _getVideoAndUpload();
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              _getImageAndUpload();
            },
          ),

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
                  if (imageStillUploading ||
                      attachmentStillUploading ||
                      videoStillUploading) {
                    return Fluttertoast.showToast(
                        msg: 'File is still uploading');
                  } else {
                    firestoreService.saveMessage(
                      userinfo: widget.userinfo,
                      time: DateTime.now().millisecondsSinceEpoch.round(),
                      message: _message,
                      role: widget.userinfo['role'],
                      photourl: imageurl,
                      attachmenturl: attachmenturl,
                      attachmentname: attachmenturl != null
                          ? basename(_attachmentFile.path)
                          : null,
                      videourl: videourl,
                    );
                  }

                  setState(() {
                    attachmenturl = null;
                    imageurl = null;
                    _message = null;
                    videourl = null;
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
