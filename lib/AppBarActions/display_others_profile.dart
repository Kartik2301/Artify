import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/user_class.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:sampleapp/Utilities/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var user_global;

class DispOtherProfile extends StatefulWidget {
  final User user;
  DispOtherProfile({Key key, @required this.user}) : super(key: key);
  DispOtherProfileState createState() => DispOtherProfileState();
}

class DispOtherProfileState extends State<DispOtherProfile> {
  void add_follower() async {
    var doc_ref = await Firestore.instance.collection("users").document(Constants.usr.uid).get();
    int followers = doc_ref.data['followers'] + 1;
    Firestore.instance.collection("users").document(Constants.usr.uid).updateData({
      'followers' : followers,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home : Scaffold(
        appBar : AppBar(
          leading : IconButton(
            icon : Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          title : Text(widget.user.username),
        ),
        body : Column(
          children : <Widget> [
            SafeArea(
              child : Container(
                padding : EdgeInsets.all(12.0),
                color: Color(0xFF323A6E),
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                  children : <Widget> [
                    CircleAvatar(
                      radius : 50.0,
                      backgroundImage: NetworkImage(widget.user.imageUrl),
                    ),
                    Column(
                      children : <Widget> [
                        InkWell(
                          onTap : () {},
                          child : Container(
                            child : FlatButton(
                              onPressed : () {
                                add_follower();
                                print("followed");
                                setState(() {
                                  widget.user.followers++;
                                });
                              },
                              child : Text(
                                'Follow',
                                style : TextStyle(
                                  color : Colors.white,
                                ),
                              ),
                              color : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height:21,
            ),
            Row(
              mainAxisAlignment : MainAxisAlignment.spaceEvenly,
              children : <Widget> [
                Text(
                  'Images added\n${widget.user.images_added.length}',
                 textAlign:TextAlign.center,
                 style : TextStyle(
                   fontFamily : 'UbuntuRegular',
                   fontSize:15.0,
                 ),
               ),
                Text(
                  'Followers\n${widget.user.followers}',
                 textAlign:TextAlign.center,
                 style : TextStyle(
                   fontFamily : 'UbuntuRegular',
                   fontSize:15.0,
                 ),
               ),
                Text(
                  'Following\n${widget.user.following}',
                   textAlign:TextAlign.center,
                   style : TextStyle(
                     fontFamily : 'UbuntuRegular',
                     fontSize:15.0,
                   ),
                 ),
              ],
            ),
            SizedBox(
              height : 15.0,
            ),
            Text(
              'Images Added by ${widget.user.username}',
              style : TextStyle(
                fontFamily : 'Pacifico',
                fontSize : 18,
                color : Color(0xFF03A69A),
              ),
            ),
            SizedBox(
              height : 8,
            ),
            Expanded(
              child: Container(
                child : GridView.count(
                  crossAxisCount : 3,
                  shrinkWrap: true,
                  children : List.generate(widget.user.images_added.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: RoundedRectangleImageInkWell(
                        onPressed : () {
                        },
                        image: NetworkImage(widget.user.images_added[index]),
                        splashColor: Colors.white60,
                        borderRadius : BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
