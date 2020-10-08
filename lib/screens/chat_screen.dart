import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_test/components/message_stream.dart';
import 'package:message_test/screens/imageScreen.dart';
import 'package:message_test/screens/welcome_screen.dart';
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

User logginedinuser;
final _store = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class _ChatScreenState extends State<ChatScreen> {
  File image;
  File video;
  String imageUrl, fileurl;
  final picker = ImagePicker();
  String messageSend;
  final textcontroller = TextEditingController();
  File file;
  bool pageLoad = false;

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    image = File(pickedFile.path);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageScreen(
            image: image,
            type: 1,
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logginedinuser = user;
        print(logginedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                //Implement logout functionality
                _auth.signOut();
                imageUrl = await Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: pageLoad
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                    Text('Uploading Document'),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessageStream(
                    loggedinuser: logginedinuser,
                  ),
                  Container(
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textcontroller,
                            onChanged: (value) {
                              messageSend = value;
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            }),
                        IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            }),
                        FlatButton(
                          onPressed: () {
                            textcontroller.clear();
                            if (messageSend != null) {
                              _store.collection('messages').add({
                                'sender': logginedinuser.email,
                                'text': messageSend,
                                'messageTime': DateTime.now(),
                                'isImage': 0,
                              });
                            }
                          },
                          child: Text(
                            'Send',
                            style: kSendButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
