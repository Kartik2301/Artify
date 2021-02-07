import 'package:flutter/material.dart';
import 'package:sampleapp/BottomNavActions/profile.dart';
import 'package:sampleapp/BottomNavActions/add_image.dart';
import 'package:sampleapp/BottomNavActions/home_page.dart';
import 'package:sampleapp/Utilities/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;

class TransitionScreen extends StatefulWidget {
  TransitionScreenState createState() => TransitionScreenState();
}

class TransitionScreenState extends State<TransitionScreen> {
  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_added_user', true);
  }

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool CheckValue = preferences.containsKey('user_added_user');

    String username = user.displayName;
    String email = user.email;
    int followers = 0;
    int following = 0;
    String url = user.photoUrl;
    String uid = user.uid;
    List<String> imgs = [];
    User createUser = User(username,email,followers,following,url,uid,imgs);

    if(CheckValue == false) {
      List<String> keyWords = [];
      for(int i=0;i<username.length;i++) {
        keyWords.add(username.substring(0,i+1));
      }
      _firestore.collection('users').document(Constants.usr.uid).setData({
        'username' : username,
        'email' : email,
        'followers' : followers,
        'following' : following,
        'url' : url,
        'uid' : uid,
        'imgs' : imgs,
        'searchKeywords' : keyWords,
      });
      addBoolToSF();
      Constants.usr = createUser;
    } else {
      var document = await Firestore.instance.collection('users').document(uid).get();
      List<String> links_to_imgs = [];
      for(int i=0;i<document.data['imgs'].length;i++) {
        links_to_imgs.add(document.data['imgs'][i].toString());
      }
      Constants.usr = User(username,email,document.data['followers'],document.data['following'],document.data['url'],uid,links_to_imgs);
      print(document.data);
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int selected_index) {
    setState(() {
      _selectedIndex = selected_index;
    });
  }

  Widget Choose_screen(int index) {
    switch(index) {
      case 0 : return HomePage();
      case 1 : return AddImage();
      case 2 : return Profile();
    }
  }

  initState() {
    inputData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Choose_screen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor : Colors.blue,
        unselectedItemColor : Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text('HOME'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_a_photo,
          ),
            title: Text('ADD'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text('PROFILE'),
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        elevation: 5,
        onTap: _onItemTapped,
      ),
    );
  }
}
