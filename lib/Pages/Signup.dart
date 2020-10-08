import 'dart:io';
import 'Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import '../firebase services/authservices.dart';

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
      phone,
      confirmpassword,
      birthday,
      _uploadedFileURL;
  DateTime date;
  File _image;
  List<String> roles = [
    'Chief Executive Committee',
    'Executive Committee',
    'General Management Team',
  ];
  @override
  Widget build(BuildContext context) {
    Future chooseFile() async {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });
      });
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _image == null
                  ? RaisedButton(
                      onPressed: () {
                        chooseFile();
                      },
                      child: Text('upload photo'),
                    )
                  : Image.file(_image),
              flex: 1,
            ),
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name *',
                        ),
                        validator: (value) {
                          return value.isEmpty
                              ? 'This field is requried'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: email,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'email *',
                        ),
                        validator: (value) {
                          return value.isEmpty
                              ? 'This field is requried'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: password,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'password *',
                        ),
                        validator: (value) {
                          return value.length < 6
                              ? 'This field is requried'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: confirmpassword,
                        onChanged: (value) {
                          confirmpassword = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'confirmed password *',
                        ),
                        validator: (value) {
                          return identical(confirmpassword, password)
                              ? 'This field is requried'
                              : null;
                        },
                      ),
                      TextFormField(
                        initialValue: phone,
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'phone *',
                        ),
                        validator: (value) {
                          return value.isEmpty
                              ? 'This field is requried'
                              : null;
                        },
                      ),
                      DropdownButton(
                        value: role,
                        items: roles
                            .map((item) => DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                  onTap: () {
                                    setState(() {
                                      role = item;
                                    });
                                  },
                                ))
                            .toList(),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      InputDatePickerFormField(
                        firstDate: DateTime.utc(1900, 11, 9),
                        lastDate: DateTime.utc(2100, 11, 9),
                        errorFormatText: 'The date is wrong',
                        fieldHintText: 'Enter Your brith date',
                        onDateSaved: (value) {
                          date = value;
                        },
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (_image != null) {
                              print('Reach');
                              await uploadFile();
                              print(_uploadedFileURL);
                            }
                            await _auth.signUp(email, password, name, phone,
                                role, _uploadedFileURL, date);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          }
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
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
