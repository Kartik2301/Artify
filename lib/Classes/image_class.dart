import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:sampleapp/Classes/comments.dart';

class ImgClass {
  String title;
  String username;
  String uid;
  String imageUrl;
  int likes;
  String path;
  List<String> comments;
  ImgClass(String title, String username, String uid, String imageUrl, int likes, String path, List<String> comments) {
    this.title = title;
    this.username = username;
    this.uid = uid;
    this.imageUrl = imageUrl;
    this.likes = likes;
    this.path = path;
    this.comments = comments;
  }
}
