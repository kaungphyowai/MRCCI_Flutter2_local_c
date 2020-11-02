import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mrcci_ec/constants/loading.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../firebase services/firestore_service.dart';
import '../../firebase services/firestore_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var currencyData;
  var rates;
  bool loading = false;
  var currentUser;
  FirestoreService firestoreService = FirestoreService();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future getCurrency() async {
    try {
      Response response =
          await Dio().get('https://forex.cbm.gov.mm/api/latest');
      currencyData = response.data;
      rates = currencyData['rates'];
    } catch (e) {
      print(e.message);
    }
  }

  Future getCurrentUser() async {
    try {
      var user =
          await firestoreService.getCurrentUserInfo(auth.currentUser.uid);
      setState(() {
        currentUser = user.data();
      });
      print(currentUser);
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    //getCurrency();
    getCurrentUser();
    return Container(
      child: FutureBuilder(
        future: getCurrency(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0, // soften the shadow
                              spreadRadius: 1.0, //extend the shadow
                            )
                          ],
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.green],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Today Currency Exchange Rate',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '🇺🇸 1 USD  =  🇲🇲  ${rates['USD']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '🇪🇺 1 EUR  =  🇲🇲  ${rates['EUR']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '🇦🇺 1 AUD  =  🇲🇲  ${rates['AUD']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '🇸🇬 1 SGD  =  🇲🇲  ${rates['SGD']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '🇭🇰 1 HKD  =  🇲🇲  ${rates['HKD']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '🇮🇳 1 INR  =  🇲🇲  ${rates['INR']} MMK',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Central Bank of Myanmar',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0, // soften the shadow
                                spreadRadius: 1.0, //extend the shadow
                              )
                            ],
                            gradient: LinearGradient(
                                colors: [Colors.green, Colors.blue],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 20.0, height: 100.0),
                            Text(
                              "What",
                              style: TextStyle(fontSize: 43.0),
                            ),
                            SizedBox(width: 20.0, height: 100.0),
                            RotateAnimatedTextKit(
                                repeatForever: true,
                                onTap: () {
                                  print("Tap Event");
                                },
                                text: ["to Show?", "to Do?", "to be done?"],
                                textStyle: TextStyle(
                                  fontSize: 40.0,
                                ),
                                textAlign: TextAlign.center),
                          ],
                        )),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
