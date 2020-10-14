import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';
import 'Login.dart';
import 'component/constant.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  checkTheUserLogin() async {
    final _auth = FirebaseAuth.instance;
    User currentUser = await _auth.currentUser;
    if (currentUser != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Home(
                    currentUser: currentUser,
                  )));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((timeStamp) => checkTheUserLogin());
    FirebaseAuth.instance.authStateChanges().listen((firebaseuser) {
      //print(firebaseuser.uid);
      if (firebaseuser == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Login()),
            (Route<dynamic> rr) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => Home(
                      currentUser: firebaseuser,
                      userId: firebaseuser.uid,
                    )),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DoubleBounceLoading,
      ),
    );
  }
}
