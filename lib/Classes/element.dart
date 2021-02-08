import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:sampleapp/AppBarActions/display_others_profile.dart';

class Element_item extends StatelessWidget {
  User user;
  bool showPoints;
  Element_item(User user, bool showPoints) {
    this.user = user;
    this.showPoints = showPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child : InkWell(
        onTap : () {
          Navigator.push(
            context,
            MaterialPageRoute(builder : (context) => DispOtherProfile(user : user)),
          );
        },
        child : Container(
          padding : EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom:0.0),
            child : Row(
              children : <Widget> [
                Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width * 0.225,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.056, right: MediaQuery.of(context).size.width * 0.08, bottom:10.0,),
                  child: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(user.imageUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontFamily : 'UbuntuRegular',
                      ),
                    ),
                    Text(
                      user.emailId,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontFamily : 'sans-serif',
                        fontStyle : FontStyle.italic,
                      ),
                    ),
                    (showPoints == true) ? Text(
                      '${user.images_added.length*10} Points',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.5,
                        fontFamily : 'Ubuntu',
                        fontStyle : FontStyle.italic,
                      ),
                    ) : Container(),
                  ],
                ),
              ],
            ),
        ),
      )
    );
  }
}
