import 'package:flutter/material.dart';
import 'package:sampleapp/Classes/image_class.dart';
import 'package:sampleapp/Classes/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleapp/Utilities/Constants.dart';
import 'package:intl/intl.dart';
import 'package:image_ink_well/image_ink_well.dart';

class DetailImage extends StatefulWidget {
  ImgClass image;
  DetailImage({Key key, @required this.image}) : super(key: key);
  DetailImageState createState() => DetailImageState();
}

class DetailImageState extends State<DetailImage> {
  String content = "";
  bool flag = true;
  bool show_indicator = true;
  final comment_controller = TextEditingController();
  List<Comment> all_comments = [];

  void get_all_comments() async {
    for(int i=0;i<widget.image.comments.length;i++) {
      var doc_ref = await Firestore.instance.collection('comment').document(widget.image.comments[i]).get();
      all_comments.insert(0,Comment(doc_ref.data['content'], doc_ref.data['user_created'], doc_ref.data['time_created']));
    }
    setState(() {
      show_indicator = false;
    });
  }

  void add_comment() async {
    int tm_created = DateTime.now().millisecondsSinceEpoch;
    String time_created = tm_created.toString();
    bool show_indicator = false;
    String comment_path = time_created + "" + Constants.usr.uid + "" +  widget.image.path;
    Firestore.instance.collection('comment').document(comment_path).setData({
      'content' : content,
      'user_created' : Constants.usr.username,
      'time_created' : tm_created,
    });
    var doc_ref = await Firestore.instance.collection('all_images').document(widget.image.path).get();
    List<String> _comments = [];
    for(int i=0;i<doc_ref.data['comments'].length;i++) {
      _comments.add(doc_ref.data['comments'][i]);
    }

    _comments.add(comment_path);
    Firestore.instance.collection('all_images').document(widget.image.path).updateData({
       'comments' : _comments,
    });

    setState(() {
      all_comments.insert(0,Comment(content, Constants.usr.username, tm_created));
    });
  }


initState() {
  get_all_comments();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home : Scaffold(
        body : SafeArea(
          child : Column(
            crossAxisAlignment : CrossAxisAlignment.stretch,
            children : <Widget> [
              (flag == true) ? Container(
                height : MediaQuery.of(context).size.height * 0.4,
                child : RoundedRectangleImageInkWell(
                  onPressed : () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                  image: NetworkImage(
                    widget.image.imageUrl,
                  ),
                  splashColor: Colors.white60,
                  borderRadius : BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
              ):
              SafeArea(
                child : Container(
                  margin : EdgeInsets.only(bottom : 12.0,),
                  child : Row(
                    crossAxisAlignment : CrossAxisAlignment.center,
                    children : <Widget> [
                      IconButton(
                        icon : Icon(
                          Icons.arrow_circle_down_rounded,
                          size : 50.0,
                        ),
                        onPressed : () {
                          setState(() {
                            flag = !flag;
                          });
                        }
                      ),
                    ],
                  ),
                ),
              ),
              (all_comments.length == 0) ?
              (show_indicator == true) ? Container(
                margin : EdgeInsets.only(top : 10.0),
                child : Center(
                  child : CircularProgressIndicator(
                    backgroundColor : Colors.lightBlueAccent,
                  ),
                ),
              ) :
              Container(
                margin : EdgeInsets.only(top : 15.0, left : 15.0),
                child : Text(
                  'Be the first to Comment',
                   style : TextStyle(
                     fontFamily : 'UbuntuRegular',
                     fontSize : 16.0,
                   ),
                 ),
               ) :
              SizedBox(height : 3.0,),
               Expanded(
                child : ListView.builder(
                  itemCount : all_comments.length,
                  itemBuilder : (BuildContext context, int index) {
                    return Container(
                      child : Container(
                        child : Container(
                          padding : EdgeInsets.only(left : 16.0, right : 16.0, top : 16.0, bottom : 8.0),
                          child : Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children : <Widget> [
                              Row(
                                mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                children : <Widget> [
                                  Text(
                                    all_comments[index].user_created,
                                    style : TextStyle(
                                      fontFamily : 'Ubuntu',
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat('dd-MM-yyyy (hh:mm a)').format(DateTime.fromMillisecondsSinceEpoch(all_comments[index].time_created))}',
                                    style : TextStyle(
                                      fontFamily : 'Ubuntu',
                                      color : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height : 3.0,
                              ),
                              Text(
                                all_comments[index].content,
                                style : TextStyle(
                                  fontSize : 17,
                                  fontFamily : 'Lato',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
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
                            add_comment();
                            FocusScope.of(context).unfocus();
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
      ),
    );
  }
}
