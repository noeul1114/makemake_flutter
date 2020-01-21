import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import 'dart:convert' show utf8;
import 'dart:convert';
import 'dart:async';

class CompanyInfo extends StatefulWidget {
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class CompanyDataXbrl {
  int companyId;
  int quarterModel, yearModel;
  int sales, operatingRevenue, netIncome;
  int asset, capital, liabilities;
  bool verified;

  CompanyDataXbrl(
      this.companyId,
      this.quarterModel,
      this.yearModel,
      this.sales,
      this.operatingRevenue,
      this.netIncome,
      this.asset,
      this.capital,
      this.liabilities,
      this.verified);

  CompanyDataXbrl.fromJson(Map<String, dynamic> json)
      : quarterModel = json['quarter_model'],
        yearModel = json['year_model'],
        sales = json['sales'],
        operatingRevenue = json['operating_revenue'],
        netIncome = json['net_Income'],
        asset = json['asset'],
        capital = json['capital'],
        liabilities = json['liabilities'],
        verified = json['verified'];

  Text returningTextWidget() => Text("${this.quarterModel}");
}

class _CompanyInfoState extends State<CompanyInfo> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            bottom: true,
            top: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: http
                    .get('http://10.0.2.2:8000/info/chart/000020?format=json'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var temp = utf8.decode(snapshot.data.bodyBytes);

                    var tempList = json.decode(temp)['company_info'];

                    print(temp);
                    print(tempList.length);

                    List<CompanyDataXbrl> infoList = List<CompanyDataXbrl>();

                    for (int i = 0; i < tempList.length; i++) {
                      infoList.add(CompanyDataXbrl.fromJson(tempList[i]));
                    }

                    return ListView.builder(
                        itemCount: tempList.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Card(
                                child: SizedBox(
                                  height: 50,
                                    child: Center(child: Text("${infoList[index].asset}")))),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )));
  }
}
