import 'package:flutter/material.dart';
import 'package:sampleapp/BottomNavActions/profile.dart';
import 'package:sampleapp/BottomNavActions/add_image.dart';
import 'package:sampleapp/BottomNavActions/home_page.dart';
import 'package:sampleapp/Utilities/transition_screen.dart';
import 'package:sampleapp/Auth/auth.dart';
import 'package:sampleapp/Utilities/utility_functions.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Container(
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("images/milky_way.jpg"),
             fit: BoxFit.cover,
            ),
          ),
         child: Center(
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Text(
                 'Artify',
                 style : TextStyle(
                   fontFamily : 'Pacifico',
                   color : Colors.white,
                   fontSize : 40.0,
                 ),
               ),
               SizedBox(height: 50),
               Row(
                 mainAxisAlignment : MainAxisAlignment.center,
                 children : <Widget> [
                   _signInButton(),
                   _signInButtonEmail(),
                   _signInButtonFacebook(),
                 ],
               ),
             ],
           ),
         ),
       ),
     );
   }

   Widget _signInButton() {
     return OutlineButton(
       splashColor: Colors.grey,
       onPressed: () {
         signInWithGoogle().whenComplete(() {
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) {
                 return TransitionScreen();
               },
             ),
           );
         });
       },
       child: Padding(
         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
         child: Row(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Image(image: AssetImage("images/google_logo.png"), height: 44.0),
             Padding(
               padding: const EdgeInsets.only(left: 10),
             )
           ],
         ),
       ),
     );
   }

   Widget _signInButtonEmail() {
     return OutlineButton(
       splashColor: Colors.grey,
       onPressed: () {
         signInWithGoogle().whenComplete(() {
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) {
                 return TransitionScreen();
               },
             ),
           );
         });
       },
       child: Padding(
         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
         child: Row(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Image(image: AssetImage("images/gmail.png"), height: 40.0),
             Padding(
               padding: const EdgeInsets.only(left: 10),
             )
           ],
         ),
       ),
     );
   }

   Widget _signInButtonFacebook() {
     return OutlineButton(
       splashColor: Colors.grey,
       onPressed: () {
         signInWithGoogle().whenComplete(() {
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) {
                 return TransitionScreen();
               },
             ),
           );
         });
       },
       child: Padding(
         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
         child: Row(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Image(image: AssetImage("images/facebook.png"), height: 44.0),
             Padding(
               padding: const EdgeInsets.only(left: 10),
             )
           ],
         ),
       ),
     );
   }
}
