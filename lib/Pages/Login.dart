import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mrcci_ec/Pages/Home.dart';
import 'package:mrcci_ec/constants/loading.dart';
import '../firebase services/authservices.dart';
import 'Signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    String email, password;
    return loading
        ? LoadingIndicator()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Email '),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Password '),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    onPressed: () async {
                      var result = await auth.login(email.trim(), password);
                      if (result != null) {
                        if (result == 1) {
                          return Fluttertoast.showToast(
                              msg: 'Email or Password are incorrect');
                        } else if (result == 2) {
                          return Fluttertoast.showToast(
                              msg: 'Email or Password are incorrect');
                        } else {
                          setState(() {
                            loading = false;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          });
                        }
                      } else {
                        setState(() {
                          loading = false;
                        });
                        print('login unsucessful');
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text("Go to SignUp"),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
