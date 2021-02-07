import 'package:flutter/material.dart';
import 'dart:core';

class Comment {
  String content;
  String user_created;
  int time_created;
  Comment(String content, String user_created, int time_created) {
    this.content = content;
    this.user_created = user_created;
    this.time_created = time_created;
  }
}
