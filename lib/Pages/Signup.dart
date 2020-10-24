import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrcci_ec/Pages/component/LoginAndSignUpComponent/RoundedButton.dart';
import 'package:mrcci_ec/constants/loading.dart';

import 'Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import '../firebase services/authservices.dart';
import 'component/constant.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Auth _auth = Auth();
  String name,
      email,
      password,
      role,
      chooserole,
      phone,
      confirmpassword,
      birthday,
      _uploadedFileURL;
  DateTime date = DateTime.now();
  File _image;
  String _imagePath;
  bool load = false;
  String _dateString = DateTime.now().toLocal().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    Future chooseFile() async {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        print(image.absolute.path);

        setState(() {
          _image = image;
          _imagePath = image.absolute.path;
        });
      });
    }

    Future _imgFromCamera() async {
      await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50)
          .then((image) => setState(() {
                _image = image;
              }));
    }

    Future _imgFromGallery() async {
      await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50)
          .then((image) => setState(() {
                _image = image;
              }));
    }

    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Future _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != date) {
        print(picked.toLocal());
        setState(() {
          date = picked;
          _dateString = picked.toLocal().toString().split(' ')[0];
        });
      } else {
        print('date picker error');
      }
    }

    Future uploadFile() async {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('/userProfiles/${Path.basename(_image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          print(_uploadedFileURL);
        });
      });
    }

    final _formKey = GlobalKey<FormState>();
    return load == true
        ? LoadingIndicator()
        : Scaffold(
            body: Form(
              key: _formKey,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              onPressed: () {
                                _showPicker(context);
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              radius: 55,
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        _image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                            ),
                          ),
                    Expanded(
                      flex: 5,
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextFormField(
                                    initialValue: name,
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Name *',
                                    ),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'This field is requried'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextFormField(
                                    initialValue: email,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Email *',
                                    ),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'This field is requried'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextFormField(
                                    initialValue: password,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Password *',
                                    ),
                                    validator: (value) {
                                      return value.length < 6
                                          ? 'This field is requried'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextFormField(
                                    initialValue: confirmpassword,
                                    onChanged: (value) {
                                      confirmpassword = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Confirmed Password *',
                                    ),
                                    validator: (value) {
                                      return identical(
                                              confirmpassword, password)
                                          ? 'This field is requried'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: TextFormField(
                                    initialValue: phone,
                                    onChanged: (value) {
                                      phone = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      labelText: 'Phone *',
                                    ),
                                    validator: (value) {
                                      return value.isEmpty
                                          ? 'This field is requried'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Select Role'),
                                    DropdownButton(
                                      hint: Text('Chief Committee Executive'),
                                      icon: Icon(Icons.person),
                                      value: role,
                                      items: roles
                                          .map((item) => DropdownMenuItem(
                                                child: Text(item),
                                                value: item,
                                                onTap: () {
                                                  setState(() {
                                                    role = item;
                                                    if (role == roles[0]) {
                                                      chooserole = "cec";
                                                    } else if (role ==
                                                        role[1]) {
                                                      chooserole = "ec";
                                                    } else if (role ==
                                                        role[2]) {
                                                      chooserole = 'gmt';
                                                    }
                                                  });
                                                },
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        print(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RaisedButton(
                                        onPressed: () => _selectDate(context),
                                        child: Text(
                                          'Select Date of Birth',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        color: Colors.blueAccent,
                                      ),
                                      Text(
                                        'Selected DOB: $_dateString',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                              RoundedButton(
                                color: Colors.blue,
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    setState(() {
                                      load = true;
                                    });
                                    if (_image != null) {
                                      print('Reach');
                                      await uploadFile();
                                      print(_uploadedFileURL);
                                    }
                                    var result = await _auth.signUp(
                                        email,
                                        password,
                                        name,
                                        phone,
                                        chooserole,
                                        _uploadedFileURL,
                                        date);
                                    if (result != null) {
                                      setState(() {
                                        load = false;
                                      });
                                      if (result == true) {
                                        return Fluttertoast.showToast(
                                            msg: "successfully created user");
                                      } else {
                                        return Fluttertoast.showToast(
                                            msg: result.message);
                                      }
                                    }

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  }
                                },
                                text: 'Sign Up',
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

// Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             decoration:
//                 InputDecoration(border: InputBorder.none, hintText: 'Email '),
//             onChanged: (value) {
//               email = value;
//             },
//           ),
//           TextField(
//             decoration: InputDecoration(
//                 border: InputBorder.none, hintText: 'Password '),
//             onChanged: (value) {
//               password = value;
//             },
//           ),
//           DropdownButton(
//               value: role,
//               items: roles
//                   .map((item) => DropdownMenuItem(
//                         child: Text(item),
//                         value: item,
//                         onTap: () {
//                           setState(() {
//                             role = item;
//                           });
//                         },
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 print(value);
//               }),
//           RaisedButton(
//             onPressed: () {},
//           )
//         ],
//       ),
