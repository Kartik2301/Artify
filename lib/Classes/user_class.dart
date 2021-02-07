import 'package:flutter/material.dart';

class User {
  String username;
  String emailId;
  int followers;
  int following;
  String imageUrl;
  String uid;
  List<String> images_added;
  User(String username, String emailId, int followers, int following, String imageUrl, String uid, List<String> images_added) {
    this.username = username;
    this.emailId = emailId;
    this.followers = followers;
    this.following = following;
    this.imageUrl = imageUrl;
    this.uid = uid;
    this.images_added = images_added;
  }
}
