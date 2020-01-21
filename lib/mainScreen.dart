import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import 'dart:convert' show utf8;
import 'dart:convert';
import 'dart:async';

import 'companyInfo.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class CompanyBase {
  String companyName, code, country, market;
  int status;

  CompanyBase(
      this.companyName, this.code, this.country, this.market, this.status);

  CompanyBase.fromJson(Map<String, dynamic> json)
      : companyName = json["company_name"],
        code = json["code"],
        country = json["country"],
        market = json["market"],
        status = json['status'];
}

var companyChart = (snapshot) => new Padding(
      padding: EdgeInsets.all(5.0),
      child: Text("testing ${snapshot.data[0].quarterModel}"),
    );


class _MainScreenState extends State<MainScreen> {
  int _companyBasePage = 1;

  void _prevButtonPressed () {
    setState(() {
      print(_companyBasePage);
      if (_companyBasePage >= 2){
        _companyBasePage -= 1;
      }
    });
  }

  void _nextButtonPressed () {
    setState(() {
      print(_companyBasePage);
      _companyBasePage += 1;
    });
  }

  void _companyInfoPage () {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CompanyInfo(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height-82,
                  child: FutureBuilder(
                    future: http.get(
//                  'http://10.0.2.2:8000/info/chart/000020?format=json'),
                        'http://10.0.2.2:8000/companys/'+_companyBasePage.toString()+'?format=json'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var temp = utf8.decode(snapshot.data.bodyBytes);

                        List<dynamic> companyDataList = new List<dynamic>();

                        var tempList =
                            json.decode(temp)['company_list'];

                        for (int i = 0; i < tempList.length; i++) {
                          companyDataList.add(CompanyBase.fromJson(tempList[i]));
                        }
                        return ListView.builder(
                            itemCount: tempList.length,
                            itemBuilder: (context, index) => FlatButton(
                              onPressed: _companyInfoPage,
                              child: Column(
                                children: <Widget>[
                                  Card(
                                      child: SizedBox(
                                        height: 50,
                                        child: Row(
                                          children: <Widget>[
                                            Opacity(
                                              opacity: 0.0,
                                              child: SizedBox(
                                                width: 30,
                                              ),
                                            ),
                                            Icon(
                                              Icons.add_circle_outline,
                                              size: 24.0,
                                              color: Colors.redAccent,
                                            ),
                                            Opacity(
                                              opacity: 0.0,
                                              child: SizedBox(
                                                width: 30,
                                              ),
                                            ),
                                            Text("${companyDataList[index].companyName}"),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ));
//                      return Text("${json.decode(snapshot.data.body)['company_info'][0]['quarter_model']}");
                      } else {
                        return SizedBox(
                          width: 10.0,
                          height: 10.0,
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: Card(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              onPressed: _prevButtonPressed,
                              child: Text("Prev"),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            FlatButton(
                              onPressed: _nextButtonPressed,
                              child: Text("Next"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
          r: color.red,
          g: color.green,
          b: color.blue,
          a: color.alpha,
        );
}

var data = [
  new ClicksPerYear('2016', 12, Colors.red),
  new ClicksPerYear('2017', 42, Colors.yellow),
  new ClicksPerYear('2018', 50, Colors.green),
];

var series = [
  new charts.Series(
    id: 'Clicks',
    domainFn: (ClicksPerYear clickData, _) => clickData.year,
    measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
    colorFn: (ClicksPerYear clickData, _) => clickData.color,
    data: data,
  )
];

var chart = new charts.BarChart(
  series,
  animate: true,
);

var chartWidget = new Padding(
    padding: new EdgeInsets.all(32.0),
    child: new SizedBox(
      height: 200.0,
      child: chart,
    ));
