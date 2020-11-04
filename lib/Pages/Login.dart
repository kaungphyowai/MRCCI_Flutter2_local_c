import 'dart:io';
import 'component/LoginAndSignUpComponent/RoundedInputField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrcci_ec/Pages/Home.dart';
import 'Auth.dart';
import 'package:mrcci_ec/constants/loading.dart';
import '../firebase services/authservices.dart';
import 'Signup.dart';
import 'component/LoginAndSignUpComponent/RoundedButton.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool _obscureText = true;
  String email, password;

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Auth auth = Auth();

    return loading
        ? LoadingIndicator()
        : Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          hintText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.blue[400],
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            email = newValue;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordStatus,
                            color: Colors.blue[400],
                          ),
                        ),
                        obscureText: _obscureText,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            password = newValue;
                          });
                        },
                      ),
                    ),
                    RoundedButton(
                      text: "Log In",
                      color: Colors.lightBlue,
                      textColor: Colors.black,
                      press: () async {
                        setState(() {
                          loading = true;
                        });

                        var result = await auth.login(email, password);
                        if (result != null) {
                          setState(() {
                            loading = false;
                          });
                          if (result.runtimeType == String) {
                            return Fluttertoast.showToast(msg: 'Return error');
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthPage()));
                          }
                        } else {
                          setState(() {
                            loading = false;
                          });

                          return Fluttertoast.showToast(
                              msg:
                                  'Login Unsuccesfull. Check your internet connection');
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
