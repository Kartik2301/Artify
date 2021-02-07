import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:io';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:sampleapp/Utilities/empty_view.dart';
import 'package:sampleapp/Utilities/transition_screen.dart';
import 'package:sampleapp/Auth/log_in.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isInternetOn = true;
  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() async {
      });
    }
  }

  void initState() {
    super.initState();
    GetConnect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home : (isInternetOn == true) ? LoginPage() : EmptyView(),
    );
  }
}
