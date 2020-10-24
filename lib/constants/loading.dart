import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.loadingText});
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
        children: [
          SpinKitDoubleBounce(
            color: Colors.blueAccent,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Text(
              loadingText,
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          )
        ],
      )),
    );
  }
}
