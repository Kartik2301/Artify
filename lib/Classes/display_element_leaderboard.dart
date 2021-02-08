import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/display_profile.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:sampleapp/Classes/element.dart';

class DispElement extends StatelessWidget {
  User user;
  int index;
  DispElement(User user, int index) {
    this.user = user;
    this.index = index;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Row(
        children : <Widget> [
          SizedBox(
            width : 10.0,
          ),
          Text(
            '${index+1}.',
            style : TextStyle(
              fontFamily : 'UbuntuRegular',
              fontSize : 18.0,
            ),
          ),
          Expanded(
            child : Element_item(user,true),
          ),
        ],
      ),
    );
  }
}
