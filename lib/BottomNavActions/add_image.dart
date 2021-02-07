import 'package:flutter/material.dart';
import 'dart:io'; // Carousel
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sampleapp/Utilities/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleapp/Utilities/utility_functions.dart';

class AddImage extends StatefulWidget {
  AddImageState createState() => AddImageState();
}

class AddImageState extends State<AddImage> {
  File _image;
  bool flag = false;
  String _uploadedFileURL = "https://tourhalt.com/images/no_image.jpg";
  String title = "";
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source : ImageSource.camera,
      imageQuality : 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
      source : ImageSource.gallery,
      imageQuality : 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future uploadFile() async {
    setState(() {
      flag = true;
    });
    String path = Constants.usr.uid + "" + DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().
    child('all_images/${path}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        Firestore.instance.collection('all_images').document(path).setData({
          'title' : title,
          'imageUrl' : _uploadedFileURL,
          'likes' : 0,
          'user' : Constants.usr.username,
          'uid' : Constants.usr.uid,
          'path' : path,
          'comments' : [],
        });
        List<String> lst = Constants.usr.images_added;
        lst.add(_uploadedFileURL);

        Firestore.instance.collection("users").document(Constants.usr.uid).updateData({
          'imgs' : lst,
        });

        flag = false;
        _image = null;
        display_toast("Image Sucessfully Uploaded", Colors.green ,0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title : Text(
          'New Post',
          style : TextStyle(
            fontFamily : 'Ubuntu',
          ),
        ),
      ),
      body: (flag == true) ? Container(
        child : Center(
          child : CircularProgressIndicator(
            backgroundColor : Colors.lightBlueAccent,
          ),
        ),
      )
      : GestureDetector(
        onTap: () => {
          FocusScope.of(context).unfocus(),
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Container(),
                ),
                SizedBox(
                  height : 40.0,
                ),
                Container(
                  margin: EdgeInsets.only(left:16, right:16, top:40.0),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      fillColor: Colors.grey[200],
                      hintText: 'Add Title',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily : 'UbuntuRegular',
                      ),
                    ),

                    onChanged: (value){
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                ),
              SizedBox(
                height : 25.0,
              ),
              (title.length > 0 && _image != null) ?
                RaisedButton(
                  child : Text('Post'),
                  onPressed : () {
                    uploadFile();
                  },
                  color : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
                :
                Container(),
                SizedBox(
                  height : 25.0,
                ),
              (_image == null) ?
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffFDCF09),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                )
                :
                Image.file(
                  _image,
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
