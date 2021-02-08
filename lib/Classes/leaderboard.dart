import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:sampleapp/Classes/display_profile.dart';
import 'package:sampleapp/Classes/display_element_leaderboard.dart';

class Leaderboard extends StatefulWidget {
  LeaderboardState createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  List<User> users = [];
  void getUsers() async {
    await for(var snapshot in Firestore.instance.collection('users').snapshots()) {
      for(var user in snapshot.documents) {
        List<String> links_to_imgs = [];
        for(int i=0;i<user.data['imgs'].length;i++) {
          links_to_imgs.add(user.data['imgs'][i].toString());
        }
        User new_user = User(
         user.data['username'],
         user.data['email'],
         user.data['followers'],
         user.data['following'],
         user.data['url'],
         user.data['uid'],
         links_to_imgs
       );
       users.add(new_user);
      }
      setState(() {});
    }
  }

  initState() {
    getUsers();
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
            'Leaderboard',
          ),
          backgroundColor : Colors.blue,
        ),
        body : Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/backgrond.jpg"),
            fit: BoxFit.cover,
            ),
          ),
          child : Container(
            margin : EdgeInsets.only(top : 10.0),
            child : ListView.builder(
              itemCount : users.length,
              itemBuilder : (BuildContext context, int index) {
                return Container(
                  child : DispElement(users[index], index),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
