import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mrcci_ec/Pages/NewHome.dart';
import 'Home.dart';
import 'component/constant.dart';
import 'WelcomScreen.dart';

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
          MaterialPageRoute(builder: (BuildContext context) => WelcomScreen()));
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WelcomScreen();
            },
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NewHomeWithProvider();
            },
          ),
        );
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
