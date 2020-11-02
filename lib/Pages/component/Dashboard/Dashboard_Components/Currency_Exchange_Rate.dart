import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Currency_Exchange_Rate extends StatelessWidget {
  const Currency_Exchange_Rate({
    @required this.rates,
  });

  final rates;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '🇪🇺 1 EUR  =  🇲🇲  ${rates['EUR']} MMK',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '🇦🇺 1 AUD  =  🇲🇲  ${rates['AUD']} MMK',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '🇸🇬 1 SGD  =  🇲🇲  ${rates['SGD']} MMK',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '🇭🇰 1 HKD  =  🇲🇲  ${rates['HKD']} MMK',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '🇮🇳 1 INR  =  🇲🇲  ${rates['INR']} MMK',
                style: TextStyle(fontSize: 20, color: Colors.white),
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
    );
  }
}

class Upcoming_Event_Card extends StatelessWidget {
  const Upcoming_Event_Card({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
