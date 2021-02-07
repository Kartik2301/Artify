import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/message_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleapp/Classes/display_message.dart';
import 'package:sampleapp/Utilities/Constants.dart';

class Messages extends StatefulWidget {
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  String content = "";
  final comment_controller = TextEditingController();
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
          title : Text(
            'Messaging',
          ),
          backgroundColor : Colors.blue,
        ),
        body : Column(
          children : <Widget> [
            StreamBuilder<QuerySnapshot>(
              stream : Firestore.instance.collection('messages').snapshots(),
              builder : (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                    child : CircularProgressIndicator(
                      backgroundColor : Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data.documents;
                List<DisplayMessage> all_messages = [];
                for(var message in messages) {
                  MessageClass msg_item = MessageClass(message.data['username'], message.data['uid'], message.data['content'], message.data['user_img_url']);
                  final messageWidget = DisplayMessage(msg_item);
                  all_messages.add(messageWidget);
                }
                return Expanded(
                  child : ListView(
                    children : all_messages,
                  ),
                );
              },
            ),
            Container(
              child : Align(
                alignment: FractionalOffset.bottomCenter,
                child : Row(
                  children : <Widget> [
                    Container(
                      width : MediaQuery.of(context).size.width * 0.8,
                      padding : EdgeInsets.all(16.0),
                      child : TextField(
                        onChanged : (value) {
                          setState(() {
                            content = value;
                          });
                        },
                        decoration : InputDecoration(
                          hintText : 'Add Comment',
                        ),
                        controller : comment_controller,
                      ),
                    ),
                    InkWell(
                      onTap : () {
                        if(content.length > 0) {
                          FocusScope.of(context).unfocus();
                          Firestore.instance.collection('messages').document(DateTime.now().millisecondsSinceEpoch.toString()).setData({
                            'username' : Constants.usr.username,
                            'content' : content,
                            'uid' : Constants.usr.uid,
                            'user_img_url' : Constants.usr.imageUrl,
                          });
                          comment_controller.clear();
                        }
                      },
                      child : Container(
                        child : Text(
                          'POST',
                          style : TextStyle(
                            color : (content.length > 0) ? Colors.blue[900] : Colors.cyan[200],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
