import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:sampleapp/AppBarActions/display_others_profile.dart';
import 'package:sampleapp/Classes/element.dart';

class DisplayProfile extends StatelessWidget {
  User user;
  DisplayProfile(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Element_item(user,false);
  }
}
