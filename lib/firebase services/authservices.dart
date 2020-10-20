import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future login(email, password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      }
    }
  }

  Future signout() async {
    _auth.signOut();
  }

  String getuid() {
    String uid = _auth.currentUser.uid;
    return uid;
  }

  Future signUp(
      email, password, username, phone, chooserole, photourl, brithday) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        var uid = _auth.currentUser.uid;
        CollectionReference users = await firestore.collection('userProfiles');
        print(photourl);
        users
            .doc(uid)
            .set({
              'username': username,
              'phone': phone,
              'role': chooserole,
              'birthday': brithday,
              'photourl': photourl,
            })
            .then((value) => print('User added'))
            .catchError((error) => print("Failed to add user: $error"));
        _auth.signOut();
      }
    } catch (e) {
      print(e);
    }
  }
  // Future signIn(String email, String pass) async {
  //   load = true;
  //   var result = await _authenticationService.loginWithEmail(
  //       email: email, password: pass);
  //   load = false;
  //   if (result is bool) {
  //     if (result) {
  //       print('login successful');
  //     } else {
  //       print(result);
  //     }
  //   } else {
  //     print(result);
  //   }
  // }
}
