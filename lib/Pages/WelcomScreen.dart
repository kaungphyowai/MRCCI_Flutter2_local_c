import 'package:flutter/material.dart';
import 'Login.dart';
import 'Signup.dart';
import 'component/LoginAndSignUpComponent/RoundedButton.dart';

class WelcomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WELCOME TO MRCCI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.05),
                Image.asset(
                  'assets/images/logo.png',
                  scale: 3,
                ),
                SizedBox(height: size.height * 0.05),
                RoundedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  text: "LOGIN",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ),
                    );
                  },
                ),
                RoundedButton(
                  text: "SIGN UP",
                  color: Colors.lightBlue,
                  textColor: Colors.black,
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUp();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
