import 'package:firebase_auth/firebase_auth.dart';
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
      return e.message;
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
        users.doc(uid).set({
          'username': username,
          'phone': phone,
          'role': chooserole,
          'birthday': brithday,
          'photourl': photourl,
        }).then((value) {
          print('user added');
          _auth.signOut();
          return true;
        }).catchError((error) {
          print(error.message);
          return error.message;
        });
      } else {
        return result;
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut() {
    _auth.signOut();
  }

  Future getuserinfo() async {
    var userinfo;
    // final uid = firebaseAuth.currentUser.uid;
    // userinfo = await firestoreService.getCurrentUserInfo(uid);
    // userinfo = userinfo.data().length;
    // //print(userinfo);
    // return uid;
    final uid = _auth.currentUser.uid;
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(uid)
        .get();
    userinfo = user.data();
    print(userinfo['role']);
    return userinfo;
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
