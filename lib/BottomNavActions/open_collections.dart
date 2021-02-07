import 'package:flutter/material.dart';
import 'package:sampleapp/Data/database_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class OpenCollection extends StatefulWidget {
  OpenCollectionState createState() => OpenCollectionState();
}
class OpenCollectionState extends State<OpenCollection> {
  final dbHelper = DatabaseHelper.instance;
  List<String> imgs_links = [];
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print("damp");

    setState(() {
      allRows.forEach((row) => imgs_links.add(row['image']));
    });
  }

  initState() {
    _query();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home : Scaffold(
        appBar : AppBar(
          leading : IconButton(
            icon : Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          title : Text(
            'Your Collection',
          ),
        ),
        body : Container(
          child : ListView.builder(
            itemCount : imgs_links.length,
            itemBuilder : (BuildContext context, int index) {
              Uint8List bytes = base64.decode(imgs_links[index]);
              return Container(
                margin : EdgeInsets.only(top:16.0, left:16.0, right : 16.0),
                padding : EdgeInsets.only(bottom:15.0),
                height : MediaQuery.of(context).size.height * 0.6,
                width : 300,
                child : Image.memory(bytes),
                decoration: BoxDecoration(
                  border: Border(
                   bottom: BorderSide(
                     color: Colors.blue,
                     width: 4.0,
                   ),
                 ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
