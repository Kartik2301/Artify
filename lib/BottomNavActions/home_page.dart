import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleapp/Utilities/utility_functions.dart';
import 'package:sampleapp/AppBarActions/search_imgs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sampleapp/Classes/image_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sampleapp/Data/database_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:sampleapp/Data/database_helper.dart';
import 'package:share/share.dart';
import 'package:sampleapp/Classes/detail_img.dart';
import 'package:sampleapp/Classes/comments.dart';
import 'package:sampleapp/AppBarActions/message.dart';
import 'package:sampleapp/Classes/leaderboard.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool darkMode = false;
  String _base64;
  final _firestore = Firestore.instance;
  bool display_top_images = false;
  List<ImgClass> images = [];
  final dbHelper = DatabaseHelper.instance;
  bool topButtons = false;

  void getData() async {
    await for(var snapshot in _firestore.collection('all_images').snapshots()) {
      for(var img in snapshot.documents) {
        List<String> comments = [];
        for(int i=0;i<img.data['comments'].length;i++) {
          comments.add(img.data['comments'][i]);
        }
        ImgClass img_class = ImgClass(img.data['title'],img.data['user'],img.data['uid'],img.data['imageUrl'],img.data['likes'], img.data['path'], comments);
        images.insert(0,img_class);
      }
    }
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("themeMode");
  }

  addBoolToSF(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeMode', flag);
  }

  Future<bool> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('themeMode');
    });
  }

  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool find = prefs.containsKey('themeMode');
    if(find) {
      getBoolValue();
    } else {
      addBoolToSF(darkMode);
    }
  }

  initState() {
    getTheme();
    getData();
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnImage : _base64,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void inc_and_update(int index) async {
    var doc_ref = await Firestore.instance.collection('all_images').document(images[index].path).get();
    int like_count = doc_ref.data['likes'];
    like_count += 1;
    Firestore.instance.collection('all_images').document(images[index].path).updateData({
      'likes' : like_count,
    });
  }

 int columns = 1;
 Future<void> _showMyDialog(int index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          images[index].title,
        ),
        elevation : 120.0,
        backgroundColor : Color(0xFFFFFFFF),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Likes :- ${images[index].likes}',
                style : TextStyle(
                  fontFamily : 'UbuntuRegular',
                  color : Colors.pink,
                  fontSize : 16,
                ),
              ),
              SizedBox(
                height : 5,
              ),
              Text(
                'Posted by ${images[index].username}',
                style : TextStyle(
                  color : Color(0xFF039be5),
                  fontSize : 16,
                ),
              ),
              SizedBox(
                height : 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(images[index].imageUrl),
                        fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite_border_sharp ,
              color: Colors.pink,
              size: 32.0,
            ),
            onPressed: () {
              inc_and_update(index);
              display_toast("Likes +1", Colors.pink,0);
            },
          ),
          SizedBox(
            width:8.0,
          ),
          IconButton(
            icon: Icon(
              Icons.add_comment_rounded,
              color: Colors.pink,
              size: 32.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder : (context) => DetailImage(
                  image : images[index],
                )),
              );
            },
          ),
          SizedBox(
            width:8.0,
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border_outlined ,
              color: Colors.pink,
              size: 32.0,
            ),
            onPressed: () {
              (() async {
                http.Response response = await http.get(
                  images[index].imageUrl,
                );
                if (mounted) {
                  setState(() {
                    _base64 = base64.encode(response.bodyBytes);
                    print("Here we go" + _base64);
                   _insert();
                  });
                }
              })();
              display_toast("Image Added to your Collection", Colors.black,1);
            },
          ),
          SizedBox(
            width:8.0,
          ),
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: Colors.pink,
              size: 32.0,
            ),
            onPressed: () {
              Share.share('Hey, check out this image from Artify, ${images[index].imageUrl}');
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      theme : (darkMode == true) ? ThemeData.dark() : ThemeData.light(),
      home : Scaffold(
        appBar : AppBar(
          backgroundColor : Colors.blue,
          leading : IconButton(
            icon: Icon(Icons.api_rounded),
            onPressed : () {
              setState(() {
                topButtons = !topButtons;
              });
            }
          ),
          title : Text(
            'Artify',
            style : TextStyle(
              fontFamily : 'Ubuntu',
            ),
          ),
          actions : <Widget> [
            Padding(
              padding : EdgeInsets.only(right : 20.0),
              child : GestureDetector(
                onTap : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder : (context) => SearchRoute()),
                  );
                },
                child : Icon(
                  Icons.search,
                  size : 26.0,
                ),
              ),
            ),

            Padding(
              padding : EdgeInsets.only(right : 20.0),
              child : GestureDetector(
                onTap : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder : (context) => Messages()),
                  );
                },
                child: Icon(
                  Icons.message_outlined,
                ),
              ),
            ),
            Padding(
              padding : EdgeInsets.only(right : 20.0),
              child : GestureDetector(
                onTap : () {
                  setState((){
                    darkMode = !darkMode;
                    addBoolToSF(darkMode);
                  });
                },
                child: Icon(
                  Icons.nights_stay,
                  color : (darkMode == true) ? Colors.black : Colors.white,
                ),
              ),
            ),
            Padding(
              padding : EdgeInsets.only(right : 20.0),
              child : GestureDetector(
                onTap : () {
                  setState((){
                    columns = 1 - columns;
                  });
                },
                child: (columns == 1) ? Icon(
                  Icons.grid_off_rounded,
                ) :
                Icon(
                  Icons.grid_on_rounded,
                ),
              ),
            ),
          ],
        ),
        body : Container(
          margin : EdgeInsets.only(top:6.0),
          child : Column(
            children : <Widget> [
              (topButtons == true) ? Row(
                mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                children : <Widget> [
                  FlatButton(
                    onPressed : () {
                      setState(() {
                        display_top_images = !display_top_images;
                      });
                    },
                    child : Text('Top Images'),
                    color : (display_top_images == true) ? Colors.greenAccent : Colors.grey[300],
                  ),
                  FlatButton(
                      onPressed : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder : (context) => Leaderboard()),
                        );
                      },
                      child : Text('Leaderboard'),
                      color : Colors.grey[300],
                  ),
                  SizedBox(
                    height : 15,
                  ),
                ],
              ) : Container(),
              (display_top_images == true) ? carousel_builder() : Container(),
              (display_top_images == true) ? SizedBox(height : 10.0,) : Container(),
              Expanded(
                child : GridView.count(
                  crossAxisCount : columns + 1,
                  shrinkWrap: true,
                  children : List.generate(images.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RoundedRectangleImageInkWell(
                        onPressed : () {
                          _showMyDialog(index);
                        },
                        image: NetworkImage(images[index].imageUrl),
                        splashColor: Colors.white60,
                        borderRadius : BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
