import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleapp/Classes/display_profile.dart';
import 'package:sampleapp/Classes/user_class.dart';

class SearchRoute extends StatefulWidget {
  SearchRouteState createState() => SearchRouteState();
}

class SearchRouteState extends State<SearchRoute> {
  String query = "";
  final _firestore = Firestore.instance;

  void load_users() async {
    await for(var snapshot in _firestore.collection('users').where("searchKeywords", arrayContains: query).snapshots()) {
      for (var user in snapshot.documents) {
        print(user.data);
      }
    }
  }

  initState() {
    load_users();
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
            'Search',
          ),
          backgroundColor : Colors.blue,
        ),
        body : Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/download.jpg"),
            fit: BoxFit.cover,
            ),
          ),
          child : Column(
            children : <Widget> [
              SizedBox(
                height : 8.0,
              ),
              Container(
                padding : EdgeInsets.all(7.0),
                child : TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    fillColor: Colors.grey[200],
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontFamily : 'UbuntuRegular',
                    ),
                  ),
                  onChanged : (value) {
                    setState(() {
                      query = value.toLowerCase();
                      load_users();
                    });
                  },
                ),
              ),
              SizedBox(
                height : 5.0,
              ),
              StreamBuilder(
                stream : _firestore.collection('users').where("searchKeywords", arrayContains : query).snapshots(),
                builder : (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Center(
                      child : CircularProgressIndicator(
                        backgroundColor : Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final users = snapshot.data.documents;
                  List<DisplayProfile> userList = [];
                  for (var user in users) {
                    List<String> links_to_imgs = [];
                    for(int i=0;i<user.data['imgs'].length;i++) {
                      links_to_imgs.add(user.data['imgs'][i].toString());
                    }
                    User usr = User(
                      user.data['username'],
                      user.data['email'],
                      user.data['followers'],
                      user.data['following'],
                      user.data['url'],
                      user.data['uid'],
                      links_to_imgs,
                    );
                    final profileWidget = DisplayProfile(usr);
                    userList.add(profileWidget);
                  }
                  return Expanded(
                    child : ListView(
                      children : userList,
                    ),
                  );
                },
              ),
            ]
          ),
        ),

      ),
    );
  }
}
