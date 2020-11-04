import 'package:flutter/material.dart';
import 'package:mrcci_ec/Pages/Home.dart';
import 'package:provider/provider.dart';
import 'HomeProvider.dart';

class NewHomeWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      lazy: false,
      create: (context) => HomeProvider(),
      child: Home(),
    );
  }
}
