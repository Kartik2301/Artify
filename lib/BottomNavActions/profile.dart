import 'package:flutter/material.dart';
import 'package:sampleapp/Utilities/utility_functions.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:sampleapp/Utilities/Constants.dart';
import 'package:sampleapp/Auth/auth.dart';
import 'package:sampleapp/Auth/log_in.dart';
import 'package:sampleapp/BottomNavActions/open_collections.dart';

class Profile extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home : Scaffold(
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
                      backgroundImage: NetworkImage(Constants.usr.imageUrl),
                    ),
                    Column(
                      children : <Widget> [
                        Text(
                          'Hey, ${Constants.usr.username}!!',
                          style : TextStyle(
                            fontSize : 19,
                            color:Colors.white,
                            fontFamily : 'Ubuntu',
                          ),
                        ),
                        SizedBox(
                          height : 8.5,
                        ),
                        Row(
                          mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                          children : <Widget> [
                            InkWell(
                              onTap : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder : (context) => OpenCollection()),
                                );
                              },
                              child : Icon(
                                Icons.collections,
                                color : Color(0xFFf7f7f7),
                                size : 29.5,
                              ),
                            ),
                            SizedBox(
                              width : 30.0,
                            ),
                            InkWell(
                              onTap : () {
                                signOutGoogle();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  return LoginPage();
                                }), ModalRoute.withName('/'));
                              },
                              child : Icon(
                                Icons.logout,
                                color : Colors.redAccent[400],
                                size : 29.5,
                              ),
                            ),
                          ],
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
                  'Images added\n${Constants.usr.images_added.length}',
                 textAlign:TextAlign.center,
                 style : TextStyle(
                   fontFamily : 'UbuntuRegular',
                   fontSize:15.0,
                 ),
               ),
                Text(
                  'Followers\n${Constants.usr.followers}',
                 textAlign:TextAlign.center,
                 style : TextStyle(
                   fontFamily : 'UbuntuRegular',
                   fontSize:15.0,
                 ),
               ),
                Text(
                  'Following\n${Constants.usr.following}',
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
              'Images Added by You',
              style : TextStyle(
                fontFamily : 'Pacifico',
                fontSize : 18,
                color : Color(0xFF03A69A),
              ),
            ),
            Expanded(
              child: Container(
                child : GridView.count(
                  crossAxisCount : 3,
                  shrinkWrap: true,
                  children : List.generate(Constants.usr.images_added.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: RoundedRectangleImageInkWell(
                        onPressed : () {
                        },
                        image: NetworkImage(Constants.usr.images_added[index]),
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
