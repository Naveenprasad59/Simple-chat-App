import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageScreen extends StatefulWidget {
  static const String id = "images_screen";
  ImageScreen({this.image, this.type});
  final File image;
  final int type;

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  User logginedinuser;
  final _store = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String fileUrl;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        logginedinuser = user;
        print(logginedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  var enabled = true;
  @override
  Widget build(BuildContext context) {
    var onPress;
    if (enabled) {
      onPress = () async {
        setState(() {
          enabled = false;
          isLoading = true;
        });
        print("URL--------------------" + await uploadFile());
        uploadURL(widget.type);
        Navigator.pop(context, fileUrl);
      };
    }
    return Scaffold(
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Center(
            child: Image.file(
              widget.image,
              height: 600,
              width: double.infinity,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPress,
        child: Icon(Icons.send),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  Future<String> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Chat Images').child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(widget.image);
    fileUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return fileUrl;
    //  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  }

  void uploadURL(int type) {
    _store.collection('messages').add({
      'sender': logginedinuser.email,
      'text': fileUrl,
      'messageTime': DateTime.now(),
      'isImage': type,
    });
    print("SUCCESS");
  }
}
