import 'package:flutter/material.dart';

class MessageClass {
  String username;
  String uid;
  String content;
  String user_img_url;
  MessageClass(String username, String uid, String content, String user_img_url) {
    this.username = username;
    this.uid = uid;
    this.content = content;
    this.user_img_url = user_img_url;
  }
}
