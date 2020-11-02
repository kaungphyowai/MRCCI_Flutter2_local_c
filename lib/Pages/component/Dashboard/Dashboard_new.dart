// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mrcci_ec/constants/loading.dart';

// import 'Dashboard_Components/Currency_Exchange_Rate.dart';

// class DashboardNew extends StatefulWidget {
//   @override
//   _DashboardNewState createState() => _DashboardNewState();
// }

// class _DashboardNewState extends State<DashboardNew> {
//   var currencyData;
//   var rates;
//   bool loading = false;
//   var userInfo;
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//   Future getCurrency() async {
//     try {
//       Response response =
//           await Dio().get('https://forex.cbm.gov.mm/api/latest');
//       currencyData = response.data;
//       rates = currencyData['rates'];
//     } catch (e) {
//       print(e.message);
//     }
//   }

//   Future getuserinfo() async {
//     final uid = firebaseAuth.currentUser.uid;
//     print(uid);
//     DocumentSnapshot user = await FirebaseFirestore.instance
//         .collection('userProfiles')
//         .doc(uid)
//         .get();

//     setState(() {
//       userInfo = user.data();
//     });
//     print('userInfo ${userInfo}');
//     return userInfo;
//   }

//   @override
//   Widget build(BuildContext context) {
//     getuserinfo();
//     return ListView(
//       children: [
//         FutureBuilder(
//           future: getCurrency(),
//           builder: (context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: Text('Currency'),
//               );
//             } else {
//               return Center(
//                 child: Text('Currency'),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
