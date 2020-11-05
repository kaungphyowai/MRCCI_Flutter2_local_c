import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrcci_ec/constants/loading.dart';

class CurrencyCalculator extends StatefulWidget {
  @override
  _CurrencyCalculatorState createState() => _CurrencyCalculatorState();
}

class _CurrencyCalculatorState extends State<CurrencyCalculator> {
  var currencyData;
  var rates;
  bool loading = false;
  DateTime today = DateTime.now();
  List<String> currencyRates = ['USD', 'SGD', 'EUR', 'CNY'];
  String selectedRate = 'USD';
  int inputValue;
  String outputValue = '0';

  void calculateRate(int currency) {
    // print('$selectedRate $currency');
    //print(rates['USD']);
    double rate =
        double.parse(rates[selectedRate].replaceAll(new RegExp(r'[,]'), ''));
    //print(rate);
    double cal = rate * currency;
    setState(() {
      outputValue = cal.toStringAsFixed(2);
    });
  }

  Future<dynamic> getCurrency() async {
    try {
      Response response =
          await Dio().get('https://forex.cbm.gov.mm/api/latest');
      currencyData = response.data;

      rates = currencyData['rates'];
      return rates;
    } catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    inputValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = today.day.toString() +
        "/" +
        today.month.toString() +
        "/" +
        today.year.toString();
    return FutureBuilder(
        future: getCurrency(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Today Currency Exchange Rates',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(
                          'Central Bank of Myanmar - Official\nDate: ${todayDate}'),
                      leading: Icon(
                        Icons.attach_money,
                        color: Colors.blue[500],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '1 USD = ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rates['USD']}',
                                    style: TextStyle(color: Colors.blue[600]),
                                  ),
                                  TextSpan(
                                    text: ' MMK',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '1 SGD = ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rates['SGD']}',
                                    style: TextStyle(color: Colors.blue[600]),
                                  ),
                                  TextSpan(
                                    text: ' MMK',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '1 CNY = ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rates['CNY']}',
                                    style: TextStyle(color: Colors.blue[600]),
                                  ),
                                  TextSpan(
                                    text: ' MMK',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '1 EUR = ',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rates['EUR']}',
                                    style: TextStyle(color: Colors.blue[600]),
                                  ),
                                  TextSpan(
                                    text: ' MMK',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton(
                            hint: Text('Select one'),
                            icon: Icon(Icons.import_export),
                            value: selectedRate,
                            items: currencyRates
                                .map((item) => DropdownMenuItem(
                                      child: Text(item),
                                      value: item,
                                      onTap: () {
                                        setState(() {
                                          selectedRate = item;
                                        });
                                      },
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRate = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(Icons.clear),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Enter a value'),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                calculateRate(int.parse(value));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$outputValue mmk',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.blue),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Today Currency Exchange Rates',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                        'Central Bank of Myanmar - Official\nDate: ${todayDate}'),
                    leading: Icon(
                      Icons.attach_money,
                      color: Colors.blue[500],
                    ),
                  ),
                  Divider(),
                  Center(
                    child: LoadingIndicator(),
                  )
                ],
              ),
            );
          }
        });
  }
}
