import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void display_toast(String message, var color, int orientation) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: (orientation == 0) ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

var links_to_imgs = [
  'https://images.unsplash.com/photo-1513624954087-ca7109c0f710?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
  'https://images.unsplash.com/photo-1608869396716-b3de8bf1e16e?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1049&q=80',
  'https://images.unsplash.com/photo-1535375743084-67f559ec192f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
  'https://images.unsplash.com/photo-1580136579312-94651dfd596d?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1177&q=80',
  'https://images.unsplash.com/photo-1599677081334-abd8d806aeb9?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
  'https://images.unsplash.com/photo-1525242756157-bc22ce1e6cb8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
  'https://images.unsplash.com/photo-1595552301308-ef89473be220?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
];

class carousel_item extends StatelessWidget{
  String link;
  carousel_item(String link) {
    this.link = link;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:2.0,right:2.0,bottom:2.0,top:4.25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        image: DecorationImage(
          image: NetworkImage(link),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget carousel_builder() {
  List<Widget> c_items = [];
  for(int i=0;i<links_to_imgs.length;i++) {
    c_items.add(carousel_item(links_to_imgs[i]));
  }

  return CarouselSlider(
    items: c_items,

    options: CarouselOptions(
      height: 180.0,
      enlargeCenterPage: true,
      autoPlay: true,
      aspectRatio: 16 / 9,
      autoPlayCurve: Curves.fastOutSlowIn,
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      viewportFraction: 0.60,
    ),
  );
}
