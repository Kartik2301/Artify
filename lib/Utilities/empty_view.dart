import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor : Color(0xFF51c2d5),
        body : Column(
          mainAxisAlignment : MainAxisAlignment.center,
          crossAxisAlignment : CrossAxisAlignment.center,
          children : <Widget> [
            Container(
              width: double.infinity,
              height : 200,
              child:Image(
                image : AssetImage(
                  'images/img_413460.png'
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              child:Text(
                'No Internet Connection found',
                style : TextStyle(
                  color : Colors.red,
                  fontSize : 20.0,
                ),
              ),
            ),
          ],
        ),
      );
  }
}
